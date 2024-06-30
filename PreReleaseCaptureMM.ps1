# Set the path to FFmpeg relative to the script directory
$ffmpegPath = Join-Path -Path $PSScriptRoot -ChildPath "ffmpeg\bin\ffmpeg.exe"

# Use the directory where the script is executed as the working directory
$workingDirectory = $PSScriptRoot

# Prompt for the source folder
$sourceFolder = Read-Host -Prompt "Please enter the path to the source folder with the images"

# Validate the source folder
if (-not (Test-Path -Path $sourceFolder)) {
    Write-Output "The specified source folder does not exist. Exiting script."
    exit
}

# Output folder for the series of images (inside the working directory)
$outputFolder = Join-Path -Path $workingDirectory -ChildPath "Series"

# Output folder for the videos (in the root of the working directory)
$videoOutputFolder = Join-Path -Path $workingDirectory -ChildPath "StichedVideos"

# Frame rate for the videos (adjustable)
$outputFrameRate = 30  # Example: You can adjust the desired frame rate here

# Ensure the output folders exist or create them
if (-not (Test-Path -Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}
if (-not (Test-Path -Path $videoOutputFolder)) {
    New-Item -ItemType Directory -Path $videoOutputFolder | Out-Null
}

# Get all images in the source folder (recursively) and sort them into series
$images = Get-ChildItem -Path $sourceFolder -Filter *.jpg -Recurse | Sort-Object LastWriteTime

# Initialize variables for the series
$lastTimestamp = $null
$serieImages = @()

# Function to process a series of images and create a video
function Process-Series {
    param (
        [array]$images,
        [datetime]$lastTimestamp
    )

    # Ensure there are enough images to create a video
    if ($images.Count -lt $outputFrameRate) {
        Write-Output "Skipping series at $($lastTimestamp.ToString("yyyyMMdd_HHmmss")) due to insufficient images."
        return
    }

    # Create a new folder for the series
    $serieFolderName = $lastTimestamp.ToString("yyyyMMdd_HHmmss")
    $serieFolderPath = Join-Path -Path $outputFolder -ChildPath $serieFolderName
    New-Item -ItemType Directory -Path $serieFolderPath -ErrorAction SilentlyContinue | Out-Null

    # Create file list for the video
    $listFile = Join-Path -Path $videoOutputFolder -ChildPath "$serieFolderName`_list.txt"
    if (Test-Path -Path $listFile) {
        Remove-Item -Path $listFile -Force
    }

    $counter = 0
    foreach ($img in $images) {
        $newFileName = "img_{0:D5}.jpg" -f $counter
        $destinationPath = Join-Path -Path $serieFolderPath -ChildPath $newFileName
        Copy-Item -Path $img.FullName -Destination $destinationPath
        Add-Content -Path $listFile -Value ("file '$($destinationPath)'")
        $counter++
    }

    # Concatenate images of the current series into a video using FFmpeg
    $outputVideoPath = Join-Path -Path $videoOutputFolder -ChildPath "$serieFolderName.mp4"
    & $ffmpegPath -y -f concat -safe 0 -i $listFile -r $outputFrameRate -c:v libx264 -pix_fmt yuv420p $outputVideoPath

    Write-Output "Video created: $outputVideoPath"
}

# Initialize progress bar
$totalImages = $images.Count
$currentImageIndex = 0
$progressIncrement = [math]::Round(100 / $totalImages, 2)

# Loop through all images
foreach ($image in $images) {
    $timestamp = $image.LastWriteTime

    # Update progress bar
    $currentProgress = [math]::Round(($currentImageIndex / $totalImages) * 100, 2)
    Write-Progress -Activity "Cooking" -Status "$currentProgress% complete" -PercentComplete $currentProgress

    # If last timestamp is set and time difference is greater than 2 seconds
    if ($lastTimestamp -ne $null -and ($timestamp - $lastTimestamp).TotalSeconds -gt 2) {
        Process-Series -images $serieImages -lastTimestamp $lastTimestamp

        # Reset series for the next series
        $serieImages = @()
    }

    # Add image to the current series
    $serieImages += $image
    $lastTimestamp = $timestamp

    # Increment current image index for progress tracking
    $currentImageIndex++
}

# Process the last series if it exists
if ($serieImages.Count -gt 0) {
    Process-Series -images $serieImages -lastTimestamp $lastTimestamp
}

# Final progress update
Write-Progress -Activity "Cooking" -Status "100% complete" -PercentComplete 100

Write-Output "All series grouped and videos created."
