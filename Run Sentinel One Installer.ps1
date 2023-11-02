# Define the arguments to pass to the executable
$arguments = '-q -t '

# Prompt the user to enter the token code
$tokenCode = Read-Host "Enter the token code"

# Download the executable from the GitHub repository to the specified local path
Invoke-WebRequest -Uri $url -OutFile $outputPath

# Wait
    $process.WaitForExit()
    Write-Host "Installation completed successfully."
