# Define the URL of the executable file
$url = 'https://github.com/Reveigh/share/raw/main/SentinelOneInstaller_windows_64bit_v23_2_3_358.exe'

# Define the local path where you want to save the executable
$outputPath = 'C:\SentinelOneInstaller.exe'

# Prompt the user to enter the token code
$tokenCode = Read-Host "Enter the token code"

# Check if the file already exists
if (Test-Path $outputPath) {
    Write-Host "The executable file already exists at $outputPath. Starting the installation..."

    # Create a background job to run the executable with arguments
    $job = Start-Job -ScriptBlock {
        param (
            $outputPath,
            $tokenCode
        )
        & $outputPath -t -q $tokenCode
    } -ArgumentList $outputPath, $tokenCode

    # Wait for the job to complete
    Wait-Job $job

    # Remove the completed job
    Remove-Job $job
} else {
    Write-Host "The executable file does not exist at $outputPath. Downloading and starting the installation..."

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
            & $outputPath -q -t $tokenCode
        } -ArgumentList $outputPath, $tokenCode

        # Wait for the job to complete
        Wait-Job $job

        # Remove the completed job
        Remove-Job $job
    } else {
        Write-Host "Download failed. The executable file was not saved."
    }
}
