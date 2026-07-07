#!/bin/bash

# Check if the lineage directory exists; create it if it doesn't
if [ ! -d "lineage" ]; then
    mkdir -p lineage
fi

# Step 1: Setup Dump

echo "Cloning DumprX..."
if [ -d "lineage/DumprX" ]; then
    echo "DumprX already exists, updating..."
    cd lineage/DumprX
    git pull
else
    git clone https://github.com/DumprX/DumprX.git lineage/DumprX
    cd lineage/DumprX
fi

# Step 2: Download MIUI Firmware

FIRMWARE_URL="https://bn.d.miui.com/OS3.0.301.0.WNPMIXM/peridot_global_images_OS3.0.301.0.WNPMIXM_20260430.0000.00_16.0_global_2f177c3d4e.tgz"
FIRMWARE_FILE="peridot_global_images_OS3.0.301.0.WNPMIXM_20260430.0000.00_16.0_global_2f177c3d4e.tgz"

echo "Downloading MIUI firmware..."
if [ -f "$FIRMWARE_FILE" ]; then
    echo "Firmware file already exists. Checking file size..."

    # Get the size of the existing file
    existing_size=$(stat -c%s "$FIRMWARE_FILE")

    # Get the size of the file on the server
    remote_size=$(curl -sI "$FIRMWARE_URL" | grep -i Content-Length | awk '{print $2}' | tr -d '\r')

    if [ "$existing_size" -eq "$remote_size" ]; then
        echo "Firmware file is up-to-date. Skipping download."
    else
        echo "Firmware file size does not match. Redownloading..."
        wget "$FIRMWARE_URL"
    fi
else
    wget "$FIRMWARE_URL"
fi

# Step 3: Run setup and dumper scripts

echo "Running setup.sh..."
bash setup.sh

echo "Running dumper.sh..."
bash dumper.sh "$FIRMWARE_FILE"

echo "Firmware download and dump completed successfully!"

