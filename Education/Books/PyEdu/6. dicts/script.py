#!/usr/bin/env python3
#import keyboard

# import curses
# import os

# def main(win):
#     win.nodelay(True)
#     key=""
#     win.clear()
#     win.addstr("key:")
#     while 1:
#         try:
#             key = win.getkey()
#             win.clear()
#             win.addstr("key:")
#             win.addstr(str(key))
#             if key == os.linesep:
#                 break
#         except Exception as err:
#             pass
    
# curses.wrapper(main)

#print(123)
import sys,tty,os,termios

f = open("log.txt", "w")

def getkey():
    old_settings = termios.tcgetattr(sys.stdin)
    tty.setcbreak(sys.stdin.fileno())
    try:
        while True:
            b = os.read(sys.stdin.fileno(), 3).decode()
            if len(b) == 3:
                k = ord(b[2])
            else:
                k = ord(b)
            key_mapping = {
                127: 'backspace',
                10: 'return',
                32: 'space',
                9: 'tab',
                27: 'esc',
                65: 'up',
                66: 'down',
                67: 'right',
                68: 'left'
            }
            return key_mapping.get(k, chr(k))
    finally:
        termios.tcsetattr(sys.stdin, termios.TCSADRAIN, old_settings)
try:
    while True:
        k = getkey()
        if k == 'esc':
            quit()
        else:
            f.write(k)
except (KeyboardInterrupt, SystemExit):
    os.system('stty sane')
    print('stopping.')