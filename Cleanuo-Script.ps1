$ransomExtensions = @(".yytw", ".yyza")
$recoveryFolder = "C:\Recovery"
$searchPath = "C:\Users"  # Adjust as needed
$depth = 2  # Adjust as needed

if (-not (Test-Path $recoveryFolder)) {
    New-Item -ItemType Directory -Path $recoveryFolder
}

foreach ($extension in $ransomExtensions) {
    Get-ChildItem -Path $searchPath -Recurse -Depth $depth | Where-Object { $_.Extension -eq $extension} | ForEach-Object {
        $destPath = Join-Path $recoveryFolder $_.Name
        if (Test-Path $destPath) {
            Write-Host "File exists in recovery: $_.Name"
            # Rename or skip
            continue
        }

        try {
            Move-Item $_.FullName -Destination $recoveryFolder
            Write-Host "Moved: $_.FullName"
        } catch {
            Write-Host "Error moving: $_.FullName"
        }
    }
}
