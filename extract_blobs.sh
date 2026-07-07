#!/bin/bash

# Check if the lineage directory exists; create it if it doesn't
if [ ! -d "lineage" ]; then
    mkdir -p lineage
fi

# Step 3: Extract Blobs

echo "Checking and cloning or updating Xiaomi peridot device tree..."
if [ -d "lineage/device/xiaomi/peridot" ]; then
    echo "Xiaomi Peridot device tree already exists, updating..."
    cd lineage/device/xiaomi/peridot
    git pull
    cd ../../../..
else
    git clone https://github.com/ryznstk.git -b evo lineage/device/xiaomi/peridot
fi

echo "Running setup-makefiles.sh in the peridot directory..."
cd lineage/device/xiaomi/peridot
bash setup-makefiles.sh

echo "Running extract-files.sh using output from lineage/DumprX..."
bash extract-files.sh ../../../DumprX/out

echo "Blobs extracted successfully!"

