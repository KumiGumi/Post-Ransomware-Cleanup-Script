$ransomExtensions = @(".yytw", ".yyza") # Adjust as needed
$recoveryFolder = "C:\RecoveryFolder" # Adjust as need
$searchPath = "."  # Adjust as needed (. is current and all subfolders)


if (-not (Test-Path $recoveryFolder)) {
    New-Item -ItemType Directory -Path $recoveryFolder
}

foreach ($extension in $ransomExtensions) {
    Get-ChildItem -Path $searchPath -Recurse | Where-Object { $_.Extension -eq $extension} | ForEach-Object {
        $originalPath = Split-Path $_.FullName -Parent
            # Write-Host "Original Path: $originalPath" ; #Debugging Path
            # Write-Host "Search Path: $searchPath" ; #Debugging Path
        $relativePath = $originalPath -replace [regex]::Escape($searchPath), ''
            # Write-Host "Relative Path: $relativePath" ; #Debugging Path
        
        $newFolderPath = Join-Path $recoveryFolder ($originalPath.replace(":", " "))
        
        Write-Host "New Folder Path: $newFolderPath" ; #Debugging Path
        
        if (-not (Test-Path $newFolderPath)) {
            New-Item -ItemType Directory -Path $newFolderPath
            }
        
        
        $destPath = Join-Path $newFolderPath $_.Name
        
        
        if (Test-Path $destPath) {
            Write-Host "File exists in recovery: $($_.Name)"
            # Rename or skip
            continue
        }

        try {
            Move-Item $_.FullName -Destination $destPath
            Write-Host "Moved: $($_.FullName) to $destPath"
        } catch {
            Write-Host "Error moving: $($_.FullName)"
        }
    }
}
