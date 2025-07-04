#!/bin/bash

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

### === Backend === ###
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

### === Frontend === ###
echo $UI_SEP
echo "PREPARING FRONTEND"
echo $UI_SEP
echo "[ ➡️ ]: Navigating to 'frontend'..."
cd ..
cd "$FRONTEND_DIR" || { echo "[ ❌ ]: Could not find the directory '$FRONTEND_DIR'"; exit 1; }
if [ ! -d "node_modules" ]; then
  echo "[ 📦 ]: Installing npm dependencies..."
  npm install
#   python3 -m venv venv
else
  echo "[ ✅ ]: The folder 'node_modules' already exists. Skipping installation..."
  echo "[ ⚠️ ]: If some error occurs, run 'cd frontend/theme-creator && npm install'..."
fi
echo ""

### === Servers === ###
echo $UI_SEP
echo "SERVERS"
echo $UI_SEP

# Asks if the user wants to start the frontend server
read -p "[ 🚀 ]: Would you like to start the FRONTEND server? (y/N): " answer

if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo "[ ▶️ ]: Starting server using 'ng serve'..."

    if [[ "$OS_TYPE" == "Darwin" ]]; then
        # macOS
        echo "[ 🖥️ ]: macOS detected. Running server in a new tab..."

        osascript <<EOF
tell application "Terminal"
    do script "cd $FRONTEND_DIR; ng serve"
end tell
EOF

    elif [[ "$OS_TYPE" == "Linux" ]]; then
        # Linux
        echo "[ 🖥️ ]: Linux detected. Running server in a new tab..."

        gnome-terminal --tab -- bash -c "\
            echo \"$UI_SEP\" && \
            echo 'Running Angular Server: ['$USERNAME_FORMATTED']' && \
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
  if [[ "$OS_TYPE" == "Darwin" ]]; then
        # macOS
        echo "[ 🖥️ ]: macOS detected. Running server in a new tab..."

        osascript <<EOF
tell application "Terminal"
    do script "echo $UI_SEP && echo ' Running Python Server: [$USERNAME_FORMATTED]' && echo $UI_SEP && cd .. && cd .. && cd $BACKEND_DIR && python3 app.py"
end tell
EOF

    elif [[ "$OS_TYPE" == "Linux" ]]; then
        # Linux
        echo "[ 🖥️ ]: Linux detected. Running server in a new tab..."

        gnome-terminal --tab -- bash -c "\
            echo \"$UI_SEP\" && \
            echo 'Running Python Server: ['$USERNAME_FORMATTED']' && \
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
