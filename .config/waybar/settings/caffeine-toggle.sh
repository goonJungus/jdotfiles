#!/bin/bash
# j: caffeine toggle - blocks idle/sleep and pauses hypridle while on
if pgrep -f "systemd-inhibit.*[C]affeine" > /dev/null; then
  pkill -f "systemd-inhibit.*[C]affeine"
  systemctl --user start hypridle
else
  setsid systemd-inhibit --what=idle:sleep --mode=block --who=Caffeine --why="Caffeine toggle" sleep infinity > /dev/null 2>&1 &
  systemctl --user stop hypridle
fi
