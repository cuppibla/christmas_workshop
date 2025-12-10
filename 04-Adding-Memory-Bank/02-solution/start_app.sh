#!/bin/bash

# Define the root directory of the solution
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to kill processes when script exits
cleanup() {
    echo ""
    echo "🛑 Stopping processes..."
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID
    fi
    if [ ! -z "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID
    fi
    exit
}

# Trap SIGINT (Ctrl+C)
trap cleanup SIGINT

echo "� Checking Backend Dependencies..."
cd "$PROJECT_ROOT/backend"
uv sync

echo "🚀 Starting Backend..."
uv run python main.py &
BACKEND_PID=$!
echo "✅ Backend started with PID $BACKEND_PID"

echo "� Checking Frontend Dependencies..."
cd "$PROJECT_ROOT/frontend"
npm install

echo "🚀 Starting Frontend..."
npm run dev -- --host &
FRONTEND_PID=$!
echo "✅ Frontend started with PID $FRONTEND_PID"

echo "💡 App is running! Press Ctrl+C to stop both servers."

# Wait for processes
wait
