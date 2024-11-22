#!/bin/bash

# Youtube Video Downloader Installer

# Check for Python installation
if ! command -v python3 &>/dev/null; then
    echo "Python3 is not installed. Please install Python3 and rerun this script."
    exit 1
fi

# Check for pip installation
if ! command -v pip3 &>/dev/null; then
    echo "pip3 is not installed. Installing pip3..."
    sudo apt update && sudo apt install -y python3-pip || {
        echo "Failed to install pip3. Exiting."
        exit 1
    }
fi

# Install pytube
echo "Installing required libraries..."
pip3 install --upgrade pytube || {
    echo "Failed to install pytube. Exiting."
    exit 1
}

# Create the Python downloader script
DOWNLOADER_SCRIPT="youtube_downloader.py"

echo "Creating the Python downloader script: $DOWNLOADER_SCRIPT"

cat <<EOF >$DOWNLOADER_SCRIPT
import os
from pytube import YouTube

def download_video(url):
    try:
        yt = YouTube(url)
        print(f"Downloading: {yt.title}")
        
        # Get the highest quality stream
        video_stream = yt.streams.filter(progressive=True, file_extension="mp4").order_by("resolution").desc().first()
        if not video_stream:
            print("Error: No suitable video stream found!")
            return
        
        video_stream.download()
        print(f"Downloaded: {yt.title} in highest quality.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    url = input("Enter the YouTube video URL: ")
    if url:
        download_video(url)
    else:
        print("Invalid URL. Exiting.")
EOF

# Make the Python script executable
chmod +x $DOWNLOADER_SCRIPT

echo "Setup complete. Run the downloader with: python3 $DOWNLOADER_SCRIPT"
