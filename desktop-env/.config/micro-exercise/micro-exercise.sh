#!/bin/bash
#
# micro-exercise.sh — reminds you to do a micro exercise every ~15 min.
# Only fires when the laptop is active (not idle / sleeping).
#
# Uses Python + XScreenSaver to detect idle time. No extra dependencies.

# ---------- idle detection (XScreenSaver via Python ctypes) ----------
idle_ms=$(python3 -c "
import ctypes, struct

libX11 = ctypes.cdll.LoadLibrary('libX11.so.6')
libXss = ctypes.cdll.LoadLibrary('libXss.so.1')

libX11.XOpenDisplay.restype = ctypes.c_void_p
libX11.XOpenDisplay.argtypes = [ctypes.c_char_p]
libX11.XDefaultRootWindow.restype = ctypes.c_ulong
libX11.XDefaultRootWindow.argtypes = [ctypes.c_void_p]
libX11.XFree.restype = ctypes.c_int
libX11.XFree.argtypes = [ctypes.c_void_p]
libX11.XCloseDisplay.restype = None
libX11.XCloseDisplay.argtypes = [ctypes.c_void_p]

libXss.XScreenSaverQueryExtension.restype = ctypes.c_int
libXss.XScreenSaverQueryExtension.argtypes = [ctypes.c_void_p, ctypes.POINTER(ctypes.c_int), ctypes.POINTER(ctypes.c_int)]
libXss.XScreenSaverAllocInfo.restype = ctypes.c_void_p
libXss.XScreenSaverQueryInfo.restype = None
libXss.XScreenSaverQueryInfo.argtypes = [ctypes.c_void_p, ctypes.c_ulong, ctypes.c_void_p]

display = libX11.XOpenDisplay(None)
if not display:
    print(999999999)
    exit()

event_base = ctypes.c_int()
error_base = ctypes.c_int()
if not libXss.XScreenSaverQueryExtension(display, ctypes.byref(event_base), ctypes.byref(error_base)):
    libX11.XCloseDisplay(display)
    print(0)
    exit()

info_ptr = libXss.XScreenSaverAllocInfo()
root = libX11.XDefaultRootWindow(display)
libXss.XScreenSaverQueryInfo(display, root, info_ptr)

# XScreenSaverInfo on amd64: idle is c_ulong at offset 24
buf = (ctypes.c_char * 8).from_address(info_ptr + 24)
idle = struct.unpack('Q', buf.raw)[0]

libX11.XFree(info_ptr)
libX11.XCloseDisplay(display)
print(idle)
")

# ---------- guard: only notify if user has been active recently ----------
IDLE_THRESHOLD_MS=600000   # 10 minutes — longer than this means away/sleeping

if [ "$idle_ms" -gt "$IDLE_THRESHOLD_MS" ] 2>/dev/null; then
    exit 0
fi

# ---------- exercise list (standing-desk friendly) ----------
exercises=(
    "10 push-ups against the desk"
    "20 calf raises"
    "15 squats"
    "Neck rolls — 5 each direction"
    "Shoulder shrugs — 10 reps"
    "Standing quad stretch — 20s each leg"
    "10 desk dips (tricep dips)"
    "March in place — 30 seconds"
    "Hip circles — 10 each direction"
    "Ankle rotations — 10 each foot"
    "Standing hamstring stretch — 20s each leg"
    "10 lunges (alternating legs)"
    "Shoulder blade squeezes — 10 reps"
    "Torso twists — 10 each side"
    "Wrist and finger stretches — 30s"
    "Balancing on one leg — 30s each"
    "Side bends — 10 each side"
    "Wall push-ups — 10 reps"
    "High knees — 30 seconds"
    "Seated spinal twist — 20s each side"
)

idx=$(( RANDOM % ${#exercises[@]} ))
exercise="${exercises[$idx]}"

notify-send \
    -u normal \
    -t 10000 \
    "Micro Exercise Break" \
    "$exercise" \
    --icon=face-wink
