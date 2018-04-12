#!/usr/bin/env python
import asyncio
import json
import slacker
import sys
import websockets

messages = asyncio.queues.Queue()

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
    users = {}  # Cache user information
    async with websockets.connect(url) as websocket:
        async for message in websocket:
            event = json.loads(message)

            # Filter out irrelevant messages
            print("INFO:", event['type'], event.get('subtype', '-'), event.get('text', '-'))
            if event['type'] != 'message':
                continue
            elif 'subtype' in event and event['subtype'] not in ('file_comment', 'message_replied'):
                continue

            # Fetch user information
            user_id = event['user']
            user = users.get(user_id)
            if not user:
                response = slack.users.info(user=user_id)
                user = response.body['user']
                users[user_id] = user

            # Put message
            print("INFO: Queue size ", messages.qsize())
            await messages.put('{} (@{})'.format(event['text'], user['name']))
            print("INFO: Queue size ", messages.qsize())

async def local_client(url):
    async with websockets.connect(url) as websocket:
        while True:
            message = await messages.get()
            print("INFO: Message ", message)
            await websocket.send(message)

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
