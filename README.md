# Pre-Release Capture Movie Maker # 

# What is Pre-Release Capture?
Nikon's Pre-Release Capture feature allows the camera to start capturing images before the shutter button is fully pressed. This feature is particularly useful in situations where timing is critical, such as sports or wildlife photography, where capturing the exact moment can be challenging. You are only allowed to shoot in JPEG (yet), because it will buffer a lot images in memory. Once you fully press the shutter button it will write all buffered images to the memory card.
 
# What is (P)re-(R)elease (C)apture (M)ovie (M)aker?
PRCMM is a powershell script created for Nikon's "Pre-Release Capture" feature.
It sorts images from a source folder into series based on the JPEG timestamp and merges them into a h264 movie file.
No images will be moved or deleted. They will only get copied and renamed within the series folder.

# Prerequisites 
- PowerShell for Windows 10/11
- ffmpeg (https://www.ffmpeg.org/download.html#build-windows)

# Installation
1. Create a folder e.g. D:\PreReleaseCaptureMM
2. Download and copy the script into D:\PreReleaseCaptureMM
2. Download and extract latest ffmpeg to D:\PreReleaseCaptureMM (ffmpeg.exe needs to be within the subdirectory ffmpeg\bin)
3. Start the script and enter the source path of the images
4. Let it cook...
5. Detected series (burst shots) will be save under .\Series
5. Stiched videos will be saved under .\StichedVideos

PS: Series are named after the timestamp of the first image

PPS: Minimun amount of images is the set output framerate

PPPS: Cooking can take a while
