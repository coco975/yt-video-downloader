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
