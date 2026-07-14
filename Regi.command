#!/bin/bash
# Regi launcher — double-click in Finder to run the app with saving enabled.
# Starts a tiny local web server (so localStorage persistence works) and opens
# your browser. Leave the Terminal window open while you use Regi; closing it
# (or pressing Ctrl+C) stops the server.

cd "$(dirname "$0")" || exit 1

# Pick a Python interpreter.
if command -v python3 >/dev/null 2>&1; then
  PY=python3
elif command -v python >/dev/null 2>&1; then
  PY=python
else
  echo "Regi needs Python to run the local server, but none was found."
  echo "Install Python 3 from https://www.python.org/downloads/ and try again."
  echo "Press any key to close."
  read -r -n 1
  exit 1
fi

# Find a free port starting at 8731.
PORT=8731
while lsof -i ":$PORT" >/dev/null 2>&1; do
  PORT=$((PORT + 1))
done

echo "Starting Regi on http://localhost:$PORT/ ..."
"$PY" -m http.server "$PORT" >/dev/null 2>&1 &
SERVER_PID=$!

# Stop the server whenever this script exits.
trap 'kill "$SERVER_PID" 2>/dev/null' EXIT

sleep 1
open "http://localhost:$PORT/index.html"

echo ""
echo "Regi is running. Your protocols and run log will be saved."
echo "Keep this window open while you use the app."
echo "To stop: close this window or press Ctrl+C."

wait "$SERVER_PID"
