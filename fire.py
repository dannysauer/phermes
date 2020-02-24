#!/usr/bin/env python3

# Simple test for NeoPixels on Raspberry Pi
import time
import board
import neopixel
import random
import threading


# NeoPixels must be connected to D10, D12, D18 or D21 to work.
pixel_pin = board.D12

# The number of NeoPixels
num_pixels = 5

# The order of the pixel colors - RGB or GRB.
# For RGBW NeoPixels, simply change the ORDER to RGBW or GRBW.
ORDER = neopixel.RGB

pixels = neopixel.NeoPixel(
        pixel_pin,
        num_pixels,
        brightness=0.2,
        auto_write=True,
        pixel_order=ORDER)

def burn(p, i):
    r = 255
    g = 0
    b = 0
    gs      = (0,64,100,220)
    weights = (4, 2,  1,  1)
    if i > 2:
        gs = gs[0:len(gs)-1]  # note: slice format [element:count:increment]
    while True:
        g = (random.choices(gs, weights=weights[0:len(gs)], k=1))[0]
        if g == 0:
            time.sleep(.25)
        current = p[i][1]
        while (current <= g):
            p[i] = (r, current, b)
            current += 1
            time.sleep(.0005)
        while (g > gs[0]):
            p[i] = (r, g, b)
            g -= 1
            if g <= gs[1]:
                time.sleep(.01)
            else:
                time.sleep(.0005)
        p[i] = (r, gs[0], b) # end on red

for i in range(0, num_pixels):
    t = threading.Thread(
            target=burn,
            args=(pixels, int(i)),
            name=i,
            daemon=True,
            )
    t.start()

for t in threading.enumerate():
    if t != threading.main_thread():
        t.join()
