# Pre Release Capture Movie Maker # 

This is a powershell script created for Nikon's "Pre Release Capture" feature.
It sorts images into series based on the timestamp and merges them into a h264 movie file.
No images are moved or deleted, only copied and renamed within the series folder.

1. Create a folder e.g. D:\PreReleaseShutterMM
2. Download and copy the script into D:\PreReleaseShutterMM
2. Download and extract latest ffmpeg to D:\PreReleaseShutterMM (ffmpeg.exe needs to be within the subdirectory ffmpeg\bin)
3. Start the script and enter the images source path
4. Let it cook...
5. Detected series will be save under .\Series
5. Stiched videos will be saved under .\StichedVideos

PS: Series are named after the timestamp of the first image
PSS: Minimun amount of images is the set output framerate
PPS: Cooking can take a while