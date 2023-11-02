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

    # Create a background job to run the executable with arguments
    $job = Start-Job -ScriptBlock {
        param (
            $outputPath,
            $tokenCode
        )
        $process = Start-Process -FilePath $outputPath -ArgumentList '-q ', '-t ', $tokenCode
        $process.ExitCode
    } -ArgumentList $outputPath, $tokenCode

    # Wait for the job to complete
    Wait-Job $job

    # Check if the job completed successfully
    if ($job.State -eq 'Completed') {
        $exitCode = Receive-Job $job
        if ($exitCode -eq 0) {
            Write-Host "Installation completed successfully."
        } else {
            Write-Host "Installation failed. Exit code: $exitCode"
        }
    } else {
        Write-Host "Installation job failed or was terminated abnormally."
    }

    # Remove the completed job
    Remove-Job $job
} else {
    Write-Host "Download failed. The executable file was not saved."
}
