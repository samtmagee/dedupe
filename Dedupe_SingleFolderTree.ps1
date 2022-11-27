$files = Get-ChildItem -Path "$env:OneDriveConsumer\GitHub\dedupe\Test Data\Duplicates in one folder\Test data" -File -Recurse | Get-FileHash -Algorithm SHA512

$duplicates = @()

foreach ($file in $files) {

    $MyMatches = $null
    $MyMatches = $files | Where-Object { $file.hash -contains $_.hash }
    
    if ($($Mymatches | Measure-Object).Count -gt 1) {

        $Mymatch = $null
        foreach ($Mymatch in $Mymatches) {
            $duplicates += [PSCustomObject]@{
                Path = $Mymatch.'Path'
                Hash = $Mymatch.'Hash'
            }
        }
    }
}

$duplicates | 
Group-Object 'Hash' | 
ForEach-Object { $_.Group | Select-Object 'Path', 'Hash' -First 1 } | Sort-Object Hash | Remove-Item
