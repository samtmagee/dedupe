# Update the two following locations to define the folders to compare,
# folderA is the folder we want to keep the data
# folderB is the folder we want to prune files from that already exist in folderA
$folderA = "$env:USERPROFILE\OneDrive\GITHub\Dedupe\Test Data\Duplicates in two folders with csv\Test data\Folder A"
$folderB = "$env:USERPROFILE\OneDrive\GITHub\Dedupe\Test Data\Duplicates in two folders with csv\Test data\Folder B"

# Get a list of the files, hash them and store in a variable with their algorithm, hash and path
$folderAData = Get-ChildItem -Path $folderA -Recurse -File | Get-FileHash
$folderBData = Get-ChildItem -Path $folderB -Recurse -File | Get-FileHash

# Export data to CSV files (these files are not used in code, just for your reference)
$folderAData | Export-Csv -Path "$env:USERPROFILE\Dedupe - FolderA.csv" -NoTypeInformation
$folderBData | Export-Csv -Path "$env:USERPROFILE\Dedupe - FolderB.csv" -NoTypeInformation

# Compare the CSV files and return hashes that exist in both CSV files
$comparison = Compare-Object -ReferenceObject $folderAData.'Hash' -DifferenceObject $folderBData.'Hash' -ExcludeDifferent -IncludeEqual

# Show Algorithm, Hash and Path from the comparison that show up in folderB
# These are the duplicate files that exist in both folderA and folderB (can be deleted from folderB)
$results = $folderBData | Where-Object { $comparison.'InputObject' -contains $_.'Hash' } | Select-Object 'Algorithm', 'Hash', 'Path'
$results | Format-Table -AutoSize Algorithm,Hash,Path
$results | Export-Csv -Path "$env:USERPROFILE\Dedupe - Results.csv" -NoTypeInformation