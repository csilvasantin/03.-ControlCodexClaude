#!/usr/bin/env python3
"""Generate and play a 56k modem handshake sound (BBS era)."""
import struct, wave, math, subprocess, os, sys

sr = 44100
dur = 5
frames = sr * dur
wav_path = "/tmp/modem-handshake.wav"

w = wave.open(wav_path, "w")
w.setnchannels(1)
w.setsampwidth(2)
w.setframerate(sr)
data = b""

for i in range(frames):
    t = i / sr

    if t < 0.8:
        # Dial tone (350+440 Hz DTMF)
        sample = int(8000 * (math.sin(2*math.pi*350*t) + math.sin(2*math.pi*440*t)))
    elif t < 1.2:
        # Ring / carrier detect (2100 Hz CED tone)
        sample = int(14000 * math.sin(2*math.pi*2100*t))
    elif t < 2.0:
        # V.32 handshake — alternating 1200/2400Hz
        freq = 1200 + 1200 * (0.5 + 0.5 * math.sin(2*math.pi*25*t))
        sample = int(12000 * math.sin(2*math.pi*freq*t))
    elif t < 3.0:
        # Scrambled negotiation — rapid frequency sweeps
        freq = 300 + 2100 * abs(math.sin(2*math.pi*60*t))
        noise = 3000 * math.sin(2*math.pi*(800+400*math.sin(2*math.pi*15*t))*t)
        sample = int(10000 * math.sin(2*math.pi*freq*t) + noise)
    elif t < 4.0:
        # V.34 training — chirps and warbles
        freq = 600 + 1800 * (0.5 + 0.5 * math.sin(2*math.pi*40*t))
        amp = 8000 + 4000 * math.sin(2*math.pi*3*t)
        sample = int(amp * math.sin(2*math.pi*freq*t))
    else:
        # Final sync — settling carrier at 1800Hz fading out
        fade = max(0, 1.0 - (t - 4.0) * 1.0)
        sample = int(12000 * fade * math.sin(2*math.pi*1800*t))

    sample = max(-32768, min(32767, sample))
    data += struct.pack("<h", sample)

w.writeframes(data)
w.close()

# Play it
subprocess.Popen(["afplay", wav_path], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
