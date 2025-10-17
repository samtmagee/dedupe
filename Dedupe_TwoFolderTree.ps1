$dir1 = "$env:USERPROFILE\github\dedupe\Test Data\Duplicates in two folders\Test data\Folder 1"
$dir2 = "$env:USERPROFILE\github\dedupe\Test Data\Duplicates in two folders\Test data\Folder 2"

# Get a list of files in the first directory
$files1 = Get-ChildItem -Path $dir1 -Recurse -File

# Get a list of files in the second directory
$files2 = Get-ChildItem -Path $dir2 -Recurse -File

# Loop through the list of files in the first directory
foreach ($file1 in $files1) {
    # Calculate the hash of the file
    $hash = (Get-FileHash $file1.'FullName').Hash

    # Loop through the list of files in the second directory
    foreach ($file2 in $files2) {
        # Check if the hash of the file in the second directory matches the hash of the file in the first directory
        if ((Get-FileHash $file2.'FullName').Hash -eq $hash) {
            # If the hashes match, display the name of the duplicate file
            Write-Host "Duplicate file: $($file2.'FullName')"
        }
    }
}