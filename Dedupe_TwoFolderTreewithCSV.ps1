# Define folders to compare, folder 1 is the folder we want to prune file from that already exist in folder 2
$folder1 = "$env:USERPROFILE\github\dedupe\Test Data\Duplicates in two folders with csv\Test data\Folder 1"
$folder2 = "$env:USERPROFILE\github\dedupe\Test Data\Duplicates in two folders with csv\Test data\Folder 2"

# Get a list of the files, hash them and store in a CSV file with their algorithm , hash and path
Get-ChildItem -Path $folder1 | Get-FileHash | Export-Csv -Path "$env:USERPROFILE\github\dedupe\Test Data\Duplicates in two folders with csv\folder1.csv" -NoTypeInformation
Get-ChildItem -Path $folder2 | Get-FileHash | Export-Csv -Path "$env:USERPROFILE\github\dedupe\Test Data\Duplicates in two folders with csv\folder2.csv" -NoTypeInformation

# Import the CSV files
$data1 = Import-Csv -Path "$env:USERPROFILE\github\dedupe\Test Data\Duplicates in two folders with csv\folder1.csv"
$data2 = Import-Csv -Path "$env:USERPROFILE\github\dedupe\Test Data\Duplicates in two folders with csv\folder2.csv"

# Compare the CSV files and return hashes that exist in both CSV files
$comparison = Compare-Object -ReferenceObject $data1.'Hash' -DifferenceObject $data2.'Hash' -ExcludeDifferent -IncludeEqual

# Show Algorithm, Hash and Path from the comparison that show up in folder 1
$data1 | Where-Object { $comparison.'InputObject' -contains $_.'Hash' } | Format-Table -AutoSize Algorithm,Hash,Path