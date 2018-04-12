#!/usr/bin/env python
import asyncio
import slacker
import sys
import websockets

async def main(url):
    async with websockets.connect(url) as websocket:
        await websocket.send("I can eat glass! Oof!")

def show_help():
    print("""
    Usage: server.py ( ws:// url | local port )
    """)


if __name__ == '__main__':
    if len(sys.argv) == 1:
        show_help()
        sys.exit()

    url = sys.argv[1]
    if url.isdigit():
        url = 'ws://localhost:' + url

    event_loop = asyncio.get_event_loop()
    event_loop.run_until_complete(main(url))
