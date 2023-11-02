# Define the URL of the executable file
$url = 'https://github.com/Reveigh/share/raw/main/SentinelOneInstaller_windows_64bit_v23_2_3_358.exe'

# Define the local path where you want to save the executable
$outputPath = 'C:\SentinelOneInstaller.exe'

# Check if the file already exists in the output path
if (-not (Test-Path $outputPath)) {
    # File doesn't exist, so download it
    Write-Host "Downloading the executable..."
    Invoke-WebRequest -Uri $url -OutFile $outputPath

    # Check if the download was successful
    if (Test-Path $outputPath) {
        Write-Host "Download completed. Starting the installation..."
    } else {
        Write-Host "Download failed. The executable file was not saved."
        exit
    }
} else {
    Write-Host "The file already exists in the output path."
}

# Prompt the user to enter the token code
$tokenCode = Read-Host "Enter the token code"

# Run the downloaded executable with arguments and token code
Start-Process -FilePath $outputPath -ArgumentList "/c", "/t", $tokenCode

Write-Host "Installation completed."
