#!/usr/bin/env python
# coding=UTF-8

import os
import math
import subprocess

if os.uname()[0] == 'Darwin':
  p = subprocess.Popen(["ioreg", "-rc", "AppleSmartBattery"], stdout=subprocess.PIPE)
  output = p.communicate()[0]
  
  o_max = [l for l in output.splitlines() if 'MaxCapacity' in l][0]
  o_cur = [l for l in output.splitlines() if 'CurrentCapacity' in l][0]
  
  b_max = float(o_max.rpartition('=')[-1].strip())
  b_cur = float(o_cur.rpartition('=')[-1].strip())
# If we're not on Darwin, we bail out. We can't know the battery charge
else:
  exit(0)
  
charge = b_cur / b_max
charge_threshold = int(math.ceil(10 * charge))

# Output

total_slots, slots = 10, []
filled = int(math.ceil(charge_threshold * (total_slots / 10.0))) * u'▸'
empty = (total_slots - len(filled)) * u'▹'

out = (filled + empty).encode('utf-8')
import sys

color_green = '%{\033[32m%}'
color_yellow = '%{\033[1;33m%}'
color_red = '%{\033[31m%}'
color_reset = '%{\033[00m%}'
color_out = (
    color_green if len(filled) > 6
    else color_yellow if len(filled) > 4
    else color_red
)

out = color_out + out + color_reset
sys.stdout.write(out)
