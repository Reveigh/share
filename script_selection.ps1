# Define the GitHub repository URL
$repoUrl = "https://api.github.com/repos/Reveigh/share/contents"

# Use the GitHub API to fetch the list of files in the repository
$response = Invoke-RestMethod -Uri $repoUrl

# Check if the response is an array of files
if ($response -is [array]) {
    # Display the list of .ps1 files and their download URLs
    Write-Host "PowerShell (.ps1) files in the GitHub repository:"
    
    $fileOptions = @{}
    $fileCount = 0
    
    for ($i = 0; $i -lt $response.Count; $i++) {
        $file = $response[$i]
        $fileName = $file.name
        $fileUrl = $file.download_url
        
        # Check if the file has a .ps1 extension
        if ($fileName -match '\.ps1$') {
            $fileOptions["$fileCount"] = $fileUrl
            Write-Host "$($fileCount): $fileName"
            $fileCount++
        }
    }

    if ($fileCount -eq 0) {
        Write-Host "No .ps1 files found in the repository."
    } else {
        # Prompt the user to select a .ps1 file
        $selection = Read-Host "Enter the number of the .ps1 file you want to run (e.g., 0, 1, 2, ...)"
        
        if ($fileOptions.ContainsKey($selection)) {
            # Download and execute the selected .ps1 file
            $selectedFileUrl = $fileOptions[$selection]
            $scriptContent = Invoke-RestMethod -Uri $selectedFileUrl
            Invoke-Expression $scriptContent
        } else {
            Write-Host "Invalid selection. Please enter a valid file number."
        }
    }
} else {
    Write-Host "Unable to fetch the list of files from the GitHub repository."
}
