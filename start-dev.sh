#!/bin/bash

### ======================================== Variables ======================================== ###
# Path to backend
BACKEND_DIR="backend"
# Path to frontend
FRONTEND_DIR="frontend/theme-creator/"
# Detects the running OS
OS_TYPE=$(uname)
# Get the name of the logged user
USERNAME="$USER"
USERNAME_FORMATTED="$(echo "${USERNAME:0:1}" | tr '[:lower:]' '[:upper:]')$(echo "${USERNAME:1}" | tr '[:upper:]' '[:lower:]')"
UI_SEP="========================================"
# Get the absolute path of the current directory
BASE_DIR=$(pwd)

if [ ! -d "$BASE_DIR/$BACKEND_DIR" ] || [ ! -d "$BASE_DIR/$FRONTEND_DIR" ]; then
  echo "[ ❌ ]: Required directories '$BACKEND_DIR' or '$FRONTEND_DIR' not found in $BASE_DIR"
  exit 1
fi

### ======================================== Backend Config ======================================== ###
echo $UI_SEP
echo "PREPARING BACKEND"
echo $UI_SEP
echo "[ ➡️ ]: Navigating to 'backend'..."
cd "$BACKEND_DIR" || { echo "[ ❌ ]: Could not find the directory '$BACKEND_DIR'"; exit 1; }

if [ ! -d "venv" ]; then
  echo "[ 🐍 ]: Creating virtual environment..."
  python3 -m venv venv
else
  echo "[ ✅ ]: Virtual environment already exists. Skipping creation..."
fi

echo "[ ✅ ]: Activating virtual environment..."
source venv/bin/activate

echo "[ 📦 ]: Installing dependencies using pip..."
pip install -r requirements.txt

echo "[ ✅ ]: You're all set! Environment is ready and dependencies are installed!"
echo ""

### ======================================== Frontend Config ======================================== ###
echo $UI_SEP
echo "PREPARING FRONTEND"
echo $UI_SEP
echo "[ ➡️ ]: Navigating to 'frontend'..."
cd ..
cd "$FRONTEND_DIR" || { echo "[ ❌ ]: Could not find the directory '$FRONTEND_DIR'"; exit 1; }
if [ ! -d "node_modules" ]; then
  echo "[ 📦 ]: Installing npm dependencies..."
  npm install
else
  echo "[ ✅ ]: The folder 'node_modules' already exists. Skipping installation..."
  echo "[ ⚠️ ]: If some error occurs, run 'cd frontend/theme-creator && npm install'..."
fi
echo ""

### ======================================== Servers Config ======================================== ###
echo $UI_SEP
echo "SERVERS"
echo $UI_SEP

# Asks if the user wants to start the frontend server
read -p "[ 🚀 ]: Would you like to start the FRONTEND server? (y/N): " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  echo "[ ▶️ ]: Starting server using 'ng serve'..."

  # macOS
  if [[ "$OS_TYPE" == "Darwin" ]]; then
    DATE_HOUR=$(date +"%Y-%m-%d %H:%M:%S")
      echo "[ 🖥️ ]: macOS detected. Running server in a new tab..."
      osascript <<EOF
tell application "Terminal"
  do script "/bin/bash -c 'clear; echo \"$UI_SEP\"; echo \"Running Angular Server: [$USERNAME_FORMATTED]\"; echo $DATE_HOUR; echo \"$UI_SEP\"; cd \"$BASE_DIR/$FRONTEND_DIR\"; ng serve'"
end tell
EOF

  # Linux
  elif [[ "$OS_TYPE" == "Linux" ]]; then
    DATE_HOUR=$(date +"%Y-%m-%d %H:%M:%S")
      echo "[ 🖥️ ]: Linux detected. Running server in a new tab..."
      gnome-terminal --tab -- bash -c "\
        echo \"$UI_SEP\" && \
        echo 'Running Angular Server: ['$USERNAME_FORMATTED']' && \
        echo $DATE_HOUR
        echo \"$UI_SEP\" && \
        cd ../.. && \
        cd \"$FRONTEND_DIR\" && \
        ng serve && \
        exec bash"
  else
    echo "[ ❌ ]: This operating system is not supported. Please, run the server manually."
  fi
else
  echo "[ ⏹️ ]: Server not started."
fi

# Asks if the user wants to start the backend server
read -p "[ 🚀 ]: Would you like to start the BACKEND server? (y/N): " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  echo "[ ▶️ ]: Starting server using 'app.py'..."
  # macOS
  if [[ "$OS_TYPE" == "Darwin" ]]; then
    DATE_HOUR=$(date +"%Y-%m-%d %H:%M:%S")
      echo "[ 🖥️ ]: macOS detected. Running server in a new tab..."
      echo "[ ✅ ]: Activating virtual environment..."
      osascript <<EOF
tell application "Terminal"
  do script "/bin/bash -c 'clear; echo \"$UI_SEP\"; echo \"Running Python Server: [$USERNAME_FORMATTED]\"; echo $DATE_HOUR; echo \"$UI_SEP\"; cd \"$BASE_DIR/$BACKEND_DIR\"; source venv/bin/activate; python3 app.py'"
end tell
EOF

  elif [[ "$OS_TYPE" == "Linux" ]]; then
    DATE_HOUR=$(date +"%Y-%m-%d %H:%M:%S")
      # Linux
      echo "[ 🖥️ ]: Linux detected. Running server in a new tab..."
      gnome-terminal --tab -- bash -c "\
        echo \"$UI_SEP\" && \
        echo 'Running Python Server: ['$USERNAME_FORMATTED']' && \
        echo $DATE_HOUR
        echo \"$UI_SEP\" && \
        cd ../.. && \
        cd \"$BACKEND_DIR\" && \
        python3 app.py && \
        exec bash"
  else
    echo "[ ❌ ]: This operating system is not supported. Please, run the server manually."
  fi
else
echo "[ ⏹️ ]: Server not started."
fi
