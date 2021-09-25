#!/bin/bash

# launch and kill

TERMINAL="iTerm2"
CHROMIUM="Google Chrome"
PORT=8888
PROFILE=40

lak () {
  ttyd --port $PORT bash &>/dev/null & \
  open -a "$CHROMIUM" \
  --args --profile-directory="Profile $PROFILE" "http://localhost:$PORT" && \
  killall $TERMINAL
}

lak
