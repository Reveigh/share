$strFilename = "$(Get-Date -f yyyy-MMM-dd-HHmmss)-Domain-AdminPWData.csv"

Get-ADGroupMember -Identity "Administrators" -Recursive | Get-ADUser -Properties pwdLastSet | Select-Object @{Name='Group';Expression={'Administrators'}},DistinguishedName,sAMAccountName,GivenName,Surname,Name,Enabled,@{Name="PwdLastSet";Expression={[datetime]::FromFileTimeUTC($_.pwdLastSet)}} | Export-Csv $strFilename
Get-ADGroupMember -Identity "Domain Admins" -Recursive | Get-ADUser -Properties pwdLastSet | Select-Object @{Name='Group';Expression={'Domain Admins'}},DistinguishedName,sAMAccountName,GivenName,Surname,Name,Enabled,@{Name="PwdLastSet";Expression={[datetime]::FromFileTimeUTC($_.pwdLastSet)}} | Export-Csv $strFilename -Append
Get-ADGroupMember -Identity "Enterprise Admins" -Recursive | Get-ADUser -Properties pwdLastSet | Select-Object @{Name='Group';Expression={'Enterprise Admins'}},DistinguishedName,sAMAccountName,GivenName,Surname,Name,Enabled,@{Name="PwdLastSet";Expression={[datetime]::FromFileTimeUTC($_.pwdLastSet)}} | Export-Csv $strFilename  -Append
Get-ADGroupMember -Identity "Schema Admins" -Recursive | Get-ADUser -Properties pwdLastSet | Select-Object @{Name='Group';Expression={'Schema Admins'}},DistinguishedName,sAMAccountName,GivenName,Surname,Name,Enabled,@{Name="PwdLastSet";Expression={[datetime]::FromFileTimeUTC($_.pwdLastSet)}} | Export-Csv $strFilename -Append

$boolFormatDates = $True

$strFilename = "$(Get-Date -f yyyy-MMM-dd-HHmmss)-Domain-AllUserPwdInfo.csv"

If ($boolFormatDates)
{
    Get-ADUser -Filter * -Properties DistinguishedName,sAMAccountName,GivenName,Surname,Name,Enabled,whenCreated,LastLogonTimestamp,PwdLastSet,userAccountControl,msDS-UserPasswordExpiryTimeComputed,PasswordNeverExpires | Select-Object DistinguishedName,sAMAccountName,GivenName,Surname,Name,Enabled,PasswordNeverExpires,@{Name="PasswordNotRequired";Expression={[bool]($_.userAccountControl -band 32)}},@{Name="ReversibleEncryption";Expression={[bool]($_.userAccountControl -band 128)}},whenCreated,@{Name="PwdLastSet";Expression={[datetime]::FromFileTimeUTC($_.pwdLastSet)}},@{Name="PwdExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}},@{Name="lastLogonTimestamp";Expression={[datetime]::FromFileTimeUTC($_.lastLogonTimestamp)}} | Export-Csv -Path $strFilename -Delimiter ";" -NoTypeInformation
}
Else
{
    Get-ADUser -Filter * -Properties DistinguishedName,sAMAccountName,GivenName,Surname,Name,Enabled,whenCreated,LastLogonTimestamp,PwdLastSet,userAccountControl,msDS-UserPasswordExpiryTimeComputed,PasswordNeverExpires | Select-Object DistinguishedName,sAMAccountName,GivenName,Surname,Name,Enabled,PasswordNeverExpires,@{Name="PasswordNotRequired";Expression={[bool]($_.userAccountControl -band 32)}},@{Name="ReversibleEncryption";Expression={[bool]($_.userAccountControl -band 128)}},whenCreated,pwdLastSet,msDS-UserPasswordExpiryTimeComputed,lastLogonTimestamp | Export-Csv -Path $strFilename -Delimiter ";" -NoTypeInformation
}

$GPOs = Get-GPO -All
$results = @()
foreach ($GPO in $GPOs) {

    $settings = Get-GPOReport -Guid $GPO.Id -ReportType xml | Select-String "<Setting"

    $obj = New-Object -TypeName PSObject -Property @{
        "Name" = $GPO.DisplayName
        "CreationTime" = $GPO.CreationTime
        "ModificationTime" = $GPO.ModificationTime
    }

    $results += $obj
}

$results | Export-Csv -Path "$($PWD.Path)\$(Get-Date -f yyyy-MMM-dd-HHmmss)-Domain-GPOs.csv" -NoTypeInformation

$exportPath = "$($PWD.Path)\$(Get-Date -f yyyy-MMM-dd-HHmmss)-Domain-GPOSettings.html"
Get-GPOReport -All -ReportType HTML -Path $exportPath 

$sysvolPath = "\\$((Get-WmiObject Win32_ComputerSystem).Domain)\SYSVOL"
$fileList = Get-ChildItem -Path $sysvolPath -Recurse -File
$fileInfo = @()

foreach ($file in $fileList) {
    $fileInfo += [PSCustomObject]@{
        Name = $file.Name
        Path = $file.FullName
        ModifyDate = $file.LastWriteTime
    }
}

$fileInfo | Export-Csv -Path ".\$(Get-Date -f yyyy-MMM-dd-HHmmss)-Domain-SYSVOLContents.csv" -NoTypeInformation

$days = 180
$now = Get-Date
$180daysago = $now.AddDays(-$days)
$computers = Get-ADComputer -Filter { LastLogonTimestamp -gt $180daysago } -Properties Name,DNSHostName,OperatingSystem,OperatingSystemVersion,CanonicalName
$computers | Select-Object Name,DNSHostName,OperatingSystem,OperatingSystemVersion,CanonicalName | Export-Csv -Path ".\$(Get-Date -f yyyy-MMM-dd-HHmmss)-DomainComputers-180days.csv" -NoTypeInformation