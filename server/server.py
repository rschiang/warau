#!/usr/bin/env python
import asyncio
import json
import re
import slacker
import sys
import websockets

MENTION_PATTERN = re.compile(r'<@([A-Z0-9]+)(?:\|([^>]+))?>')
CHANNEL_PATTERN = re.compile(r'<#([A-Z0-9]+)(?:\|([^>]+))?>')

messages = asyncio.queues.Queue()
users = {}

async def main():
    local_url = sys.argv[1]
    if local_url.isdigit():
        local_url = 'ws://localhost:' + local_url

    print("Connecting to Slack.")
    try:
        rtm_response = slack.rtm.connect()
        slack_url = rtm_response.body['url']
    except KeyError:
        print('ERROR: Failed to initiate Slack connection', rtm_response['error'])

    # Create tasks and run them
    slack_task = asyncio.ensure_future(slack_client(slack_url))
    local_task = asyncio.ensure_future(local_client(local_url))
    done, pending = await asyncio.wait([slack_task, local_task], return_when=asyncio.FIRST_COMPLETED)

    # Shut down remaining tasks
    for task in pending:
        task.cancel()

async def slack_client(url):
    async with websockets.connect(url) as websocket:
        async for message in websocket:
            event = json.loads(message)

            # Filter out irrelevant messages
            print("INFO:", event['type'], event.get('subtype', ''), event.get('text', ''))
            if event['type'] != 'message':
                continue
            elif 'subtype' in event and event['subtype'] not in ('file_comment', 'message_replied'):
                continue

            # Fetch user information
            user = get_slack_user(event['user'])

            # Process mentions
            text = event['text']
            text = MENTION_PATTERN.sub(slack_user_repl, text)
            text = CHANNEL_PATTERN.sub(slack_channel_repl, text)

            # Put message
            await messages.put('{} (@{})'.format(text, user['name']))

async def local_client(url):
    async with websockets.connect(url) as websocket:
        while True:
            message = await messages.get()
            await websocket.send(message)

def get_slack_user(user_id):
    if user_id not in users:
        response = slack.users.info(user=user_id)
        user = response.body['user']
        users[user_id] = user
    return users[user_id]

def slack_user_repl(matchobj):
    return '@' + (matchobj[2] or get_slack_user(matchobj[1])['name'])

def slack_channel_repl(matchobj):
    return '#' + (matchobj[2] or slack.channels.info(channel=matchobj[1]).body['name'])

def show_help():
    print("""
    Usage: server.py ( ws:// url | local port )
    """)
    sys.exit()


if __name__ == '__main__':
    if len(sys.argv) == 1:
        show_help()

    try:
        with open('config.json') as f:
            config = json.load(f)
            slack = slacker.Slacker(config['slack_token'])
    except (IOError, json.JSONDecodeError, KeyError):
        print("ERROR: Invalid config file. Refer to config.json.example for usage.")
        raise

    event_loop = asyncio.get_event_loop()
    try:
        event_loop.run_until_complete(main())
    except KeyboardInterrupt:
        sys.exit()
