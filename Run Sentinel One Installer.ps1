# Define the URL of the executable file
$url = 'https://github.com/Reveigh/share/raw/main/SentinelOneInstaller_windows_64bit_v23_2_3_358.exe'

# Define the local path where you want to save the executable
$outputPath = 'C:\SentinelOneInstaller.exe'

# Prompt the user to enter the token code
$tokenCode = Read-Host "Enter the token code"

# Download the executable from the GitHub repository to the specified local path
Invoke-WebRequest -Uri $url -OutFile $outputPath

# Check if the download was successful
if (Test-Path $outputPath) {
    Write-Host "Download completed. Starting the installation..."

    # Run the downloaded executable with arguments and token code
    & $outputPath -q -t $tokenCode

    Write-Host "Installation completed."
} else {
    Write-Host "Download failed. The executable file was not saved."
}
