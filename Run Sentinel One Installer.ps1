# Define the arguments to pass to the executable
$arguments = '-q -t '

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
