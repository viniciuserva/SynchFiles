param (
    [string]$source,
    [string]$replica,
    [string]$log
)
if (-not (Test-Path $source -PathType Container)) {
    Write-Host "Source folder does not exist."
    exit
}

if (-not (Test-Path $replica -PathType Container)) {
    Write-Host "Replica folder does not exist."
    exit
}

$replicaItems = Get-ChildItem $replica
$sourceItems = Get-ChildItem $source


# File checking loop for deletion
foreach ($replicaFile in $replicaItems) {
    $replicaDir = $replicaFile.FullName
    $sourceDir = Join-Path $source $replicaFile.Name
    if (-not (Test-Path $sourceDir)) {
        $confirmation = Read-Host "The Item '$($replicaFile.Name)' is no longer present in the Source folder, do you wish to delete it? (Y/N)"
        if ($confirmation -eq "Y") {
            Remove-Item $replicaDir -Force
            Add-Content -Path $log -Value "[$(Get-Date)] Item $($replicaFile.Name) deleted."
            Write-Host "Item $($replicaFile.Name) deleted."
        }
    }
}

# File checking loop for copying
foreach ($file in $sourceItems) {
    $sourceDir = $file.FullName
    $replicaDir = Join-Path $replica $file.Name
    if (Test-Path $replicaDir) {
        $sourceLastWriteTime = $file.LastWriteTime
        $replicaLastWriteTime = (Get-Item $replicaDir).LastWriteTime
        if ($sourceLastWriteTime -gt $replicaLastWriteTime) {
            Copy-Item $sourceDir $replicaDir -Force
            Add-Content -Path $log -Value "[$(Get-Date)] Item $($file.Name) copied to replica"
            Write-Host "Item $($file.Name) copied to replica"
        }
    } else {
        Copy-Item $sourceDir $replicaDir
        Add-Content -Path $log -Value "[$(Get-Date)] Item $($file.Name) copied to replica."
        Write-Host "Item $($file.Name) copied to replica."
    }
}

Write-Host "Synch Complete."
