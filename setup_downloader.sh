#!/bin/bash

# Youtube Video Downloader Installer with Virtual Environment and FFmpeg Check

# Check for Python installation
if ! command -v python3 &>/dev/null; then
    echo "Python3 is not installed. Please install Python3 and rerun this script."
    exit 1
fi

# Check and install FFmpeg
if ! command -v ffmpeg &>/dev/null; then
    echo "FFmpeg is not installed. Installing FFmpeg..."
    sudo apt update && sudo apt install -y ffmpeg || {
        echo "Failed to install FFmpeg. Exiting."
        exit 1
    }
else
    echo "FFmpeg is already installed."
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

# Install yt-dlp in the virtual environment
echo "Installing required libraries in the virtual environment..."
pip install --upgrade pip
pip install yt-dlp || {
    echo "Failed to install yt-dlp. Exiting."
    deactivate
    exit 1
}

# Create the Python downloader script
DOWNLOADER_SCRIPT="youtube_downloader.py"

echo "Creating the Python downloader script: $DOWNLOADER_SCRIPT"

cat <<EOF >$DOWNLOADER_SCRIPT
import yt_dlp

def download_video(url):
    ydl_opts = {
        'format': 'bestvideo+bestaudio/best',  # Best video and audio quality
        'outtmpl': '%(title)s.%(ext)s',       # Save file as video title
    }

    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            ydl.download([url])
            print("Download completed successfully!")
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
