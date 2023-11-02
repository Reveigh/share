# Define the URL of the executable file
$url = 'https://github.com/Reveigh/share/raw/main/SentinelOneInstaller_windows_64bit_v23_2_3_358.exe'

# Define the local path where you want to save the executable
$outputPath = 'C:\SentinelOneInstaller.exe'

# Define the arguments to pass to the executable
$arguments = '-q -t '

# Prompt the user to enter the token code
$tokenCode = Read-Host "Enter the token code"

# Download the executable from the GitHub repository to the specified local path
Invoke-WebRequest -Uri $url -OutFile $outputPath

# Check if the download was successful
if (Test-Path $outputPath) {
    Write-Host "Download completed. Starting the installation..."

    # Create a background job to run the executable
    $job = Start-Job -ScriptBlock {
        param (
            $outputPath,
            $arguments,
            $tokenCode
        )
        & $outputPath $arguments $tokenCode
    } -ArgumentList $outputPath, $arguments, $tokenCode

    # Wait for the job to complete
    Wait-Job $job

    # Check if the job completed successfully
    if ($job.State -eq 'Completed') {
        Write-Host "Installation completed successfully."
    } else {
        Write-Host "Installation failed. The job may have terminated abnormally."
    }

    # Remove the completed job
    Remove-Job $job
} else {
    Write-Host "Download failed. The executable file was not saved."
}
