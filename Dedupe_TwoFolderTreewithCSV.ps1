# Define folders to compare, folder 1 is the folder we want to prune file from that already exist in folder 2
$folderA = "$env:USERPROFILE\OneDrive\GITHub\Dedupe\Test Data\Duplicates in two folders with csv\Test data\Folder 1"
$folderB = "$env:USERPROFILE\OneDrive\GITHub\Dedupe\Test Data\Duplicates in two folders with csv\Test data\Folder 2"

# Get a list of the files, hash them and store in a CSV file with their algorithm , hash and path
$folderAData = Get-ChildItem -Path $folderA -Recurse | Get-FileHash
$folderBData = Get-ChildItem -Path $folderB -Recurse | Get-FileHash

# Export the CSV files
$folderAData | Export-Csv -Path "$env:USERPROFILE\Dedupe - FolderA.csv" -NoTypeInformation
$folderBData | Export-Csv -Path "$env:USERPROFILE\Dedupe - FolderB.csv" -NoTypeInformation

# Compare the CSV files and return hashes that exist in both CSV files
$comparison = Compare-Object -ReferenceObject $folderAData.'Hash' -DifferenceObject $folderBData.'Hash' -ExcludeDifferent -IncludeEqual

# Show Algorithm, Hash and Path from the comparison that show up in folder 1
$folderBData | Where-Object { $comparison.'InputObject' -contains $_.'Hash' } | Format-Table -AutoSize Algorithm,Hash,Path