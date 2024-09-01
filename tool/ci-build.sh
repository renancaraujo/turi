#!/bin/bash

# Check if the flutter directory exists
if cd flutter; then
    # Pull the latest changes
    git pull
    # Navigate back to the parent directory
    cd ..
else
    # Clone the Flutter repository
    git clone https://github.com/flutter/flutter.git
fi

# List the contents of the current directory
ls

# add flutter alias
export PATH=`pwd`/flutter/bin:$PATH


# Run flutter commands
flutter doctor

flutter build web --wasm --release --no-tree-shake-icons