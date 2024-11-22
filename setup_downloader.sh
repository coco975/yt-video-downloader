#!/bin/bash

# Youtube Video Downloader Installer with Virtual Environment

# Check for Python installation
if ! command -v python3 &>/dev/null; then
    echo "Python3 is not installed. Please install Python3 and rerun this script."
    exit 1
fi

# Create a virtual environment
ENV_DIR="yt_downloader_env"
if [ ! -d "$ENV_DIR" ]; then
    echo "Creating virtual environment..."
    python3 -m venv $ENV_DIR || {
        echo "Failed to create virtual environment. Exiting."
        exit 1
    }
fi

# Activate the virtual environment
source $ENV_DIR/bin/activate

# Install pytube in the virtual environment
echo "Installing required libraries in the virtual environment..."
pip install --upgrade pip
pip install pytube || {
    echo "Failed to install pytube. Exiting."
    deactivate
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

# Deactivate the virtual environment
deactivate

# Make the Python script executable
chmod +x $DOWNLOADER_SCRIPT

echo "Setup complete. Run the downloader with: source $ENV_DIR/bin/activate && python $DOWNLOADER_SCRIPT"
