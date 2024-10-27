import board
import keypad
import digitalio
import time
import usb_hid
from adafruit_hid.keyboard import Keyboard
from adafruit_hid.keycode import Keycode

keyboard = Keyboard(usb_hid.devices)

key_pins = (
    board.GP1,
    board.GP2,
    board.GP3,

    board.GP24,
    board.GP23,
    board.GP22,
)

keys_val = (
    Keycode.A,
    Keycode.ONE,
    Keycode.D,

    Keycode.W,
    Keycode.TWO,
    Keycode.S,
)

keys = keypad.Keys(key_pins, value_when_pressed=False, pull=True)

led = digitalio.DigitalInOut(board.LED)
led.direction = digitalio.Direction.OUTPUT
led.value = True

while True:
    event = keys.events.get()
    if event:
        key_number = event.key_number
        if event.pressed:
            keyboard.press(keys_val[key_number])

        if event.released:
            keyboard.release(keys_val[key_number])
