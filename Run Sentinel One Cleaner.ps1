# Define the URL of the executable file
$url = 'https://github.com/Reveigh/share/raw/main/SentinelOneInstaller_windows_64bit_v23_2_3_358.exe'

# Define the local path where you want to save the executable
$outputPath = 'C:\SentinelOneInstaller.exe'

# Define the arguments to pass to the executable
$arguments = '-c -q -t '
    Write-Host "Use only if re-installing failed"`
# Prompt the user to enter the token code
$tokenCode = Read-Host "Enter the token code"

# Download the executable from the GitHub repository to the specified local path
Invoke-WebRequest -Uri $url -OutFile $outputPath

# Check if the download was successful
if (Test-Path $outputPath) {
    Write-Host "Download completed. Running the executable..."

    # Execute the downloaded executable with the arguments and token code
    $process = Start-Process -FilePath $outputPath -ArgumentList $arguments, $tokenCode -NoNewWindow -PassThru

    # Wait for the executable to finish and show the status
    $process.WaitForExit()


    Write-Host "Installation completed successfully."
   