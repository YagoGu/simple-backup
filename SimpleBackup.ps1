$BackupLocationsFilePath="C:\Users\Administrator\Desktop\Projects\simple-backup\Directories.txt"
$BackupLocations=Get-Content -Path $BackupLocationsFilePath

$StorageLocation="C:\Users\Administrator\Desktop\Backup"
$BackupName="Backup $(Get-Date -Format "yyyy-MM-dd hh-mm")"

foreach($Location in $BackupLocations){
    Write-Output "Backing up $($Location)"
    <#The next part of the scripts mantains the current structure of the folders 
    like if they were copied from the root#>
    $LeadingPath="$($Location.Replace(':',''))"
    if(-not (Test-Path "$StorageLocation\$BackupName\$LeadingPath")){
        New-Item -Path "$StorageLocation\$BackupName\$LeadingPath" -ItemType Directory
    }
    <#it search recursively#>
    Get-ChildItem -Path $Location | Copy-Item -Destination "$StorageLocation\$BackupName\$LeadingPath" -Container -Recurse
}

<#compress it just to make it lighter#>
Compress-Archive -Path "$StorageLocation\$BackupName" -DestinationPath "$StorageLocation\$BackupName.zip" -CompressionLevel Fastest