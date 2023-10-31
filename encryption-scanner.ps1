#New-Item C:\Windows\Temp\encrypted_files.txt | out-null
[System.Collections.ArrayList]$file_array = @()
$drive = (Get-PSDrive).Name -match '^[a-z]$'

foreach ($a in $drive) 
{
gci $a":\" *.extension_here -file -ea silent -recurse | Out-File -FilePath "C:\Windows\Temp\encrypted_files_$a.txt"
$file_array += ,"encrypted_files_$a.txt"
}

foreach ($file in $file_array)
{
	
    $startchar = [math]::min($file.length - 5,$file.length)
    $startchar = [math]::max(0, $startchar)
    $length = [math]::min($file.length, 5)
    $drive_letters = $file.SubString($startchar ,$length)
    $drive_letter = $drive_letters[0]

	if ((Get-Content "C:\Windows\Temp\$file") -eq $Null) 
	{
    	Write-Host $drive_letter "NONENCRYPTED!"
    	# Delete file
    	Remove-Item -Path "C:\Windows\Temp\$file"
	}

	else 
	{
	Write-Host $drive_letter "ENCRYPTED! See C:\Windows\Temp\$file"
	}
}
