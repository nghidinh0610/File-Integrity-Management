<h1> File-Integrity-Monitoring </h1>  

<h2>Description</h2>
Project consist of a powershell script that will alert everytime there are any change in files, adding any files and deleting anyfile base on a baseline file that can also be modify through the script. The purpose of this script is to maintain integrity, one of the CIA triad in security, when data is at rest. This is going to be extremely useful when someone inside the organization or someone try to remote access to your system gained access to your private data and try to change it up. Also, this script included using hashing algorythm 256 to secure the stored file

<h2>Language and Utilities Used</h2>

- <b>Windows PowerShell</b>

<h2>Program walk-through</h2>

<h3>Step 1: Plannning</h3>
<b>The script have to satisfy all the following requirements:</b> <br/>

🔲 Show 2 options: assign new baseline or check folder integrity. The first option is for when you want to change your data intentionally, when the second option is used when you to make sure it has not been changed <br/>

🔲 When a new base line is establish, delete all the previous baseline to avoid overlaping <br/>

🔲 The script have to alert everytime a file is modify, a file is added or a file is deleted <br/>

🔲 Check and alert every second  <br/>

🔲 Hasing all contents inside all files <br/>

<h3>Step 2: Interface</h3>
<b>The script will include these text as what will be show in each specific scenario</b> <br>

- <b>Start up:</b> What would you like to do? | A) Collect new Baseline? | B) Begin monitoring files with save baseline? | Please enter A or B <br>

- <b>After choosing A:</b> Calculated Hashes, made new baseline.txt <br>

- <b>After choosing B:</b> *File*  has been created | *File* has changed!!! | *File* has been deleted! | Show nothing when nothing happen

<h3>Step 3: Script</h3>

Here comes the fun part: <br>

1) Create start up interfaces and create options:
```objc
Write-host ""
Write-host "What would you like to do?"
write-host ""
Write-host "    A) Collect new baseline?"
Write-host "    B) Begin monitoring files with save Baseline?"
Write-host ""

$response = Read-host -Prompt "Please enter 'A' or 'B'"
Write-host ""
```
2) Create a hashing function and store in variable $filehash:
```objc
Function Calculate-File-Hash($filepath) 
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA256
    return $filehash
```
3) Create a new baseline. Also create a statement that will delete the old baseline when a new baseline is created:
```objc
Function Erase-Baseline-If_Already-Exist 
    $baselineExist = Test-Path -Path .\baseline.txt

    if ($baselineExist)
        #Delete it
        Remove-item -Path .\baseline.txt

```
4) Create statement when the option is A, capitalize it and create a new baseline, with file paths + the hashed content, separate by a "|":
```objc
if ($response -eq "A".ToUpper()) 
    
    Erase-Baseline-If_Already-Exist   
   
    Write-host "Calculated Hashes, made new baseline.txt" -ForegroundColor Cyan
    
    $files = Get-ChildItem -Path .\Files
    
    foreach ($f in $files) 
        $hash = Calculate-File-Hash $f.FullName
        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
```
5) Create a statement when the option is B and create a dictionary to later on, use that for monitoring. Get content from baseline file and start continuously monitoring every second
```objc
elseif ($response -eq "B".ToUpper()) 
    
    $fileHashDictionary = @{}

    $filePathsAndHashes = Get-Content -Path.\baseline.txt

    foreach ($f in $filePathsAndHashes) 
        $fileHashDictionary.add($f.Split("|")[0],$f.Split("|")[1])
    

    while($true) 
        Start-Sleep -Seconds 1

        $files = Get-ChildItem -Path .\Files

        foreach ($f in $files) 
                    $hash = Calculate-File-Hash $f.FullName
                    #"$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
```
6) When a new file is created, send an alert/second until it's back to normal
```objc
if ($fileHashDictionary[$hash.Path] -eq $null) 
                #A new file has been created
                Write-Host "$($hash.path) has been created" -ForegroundColor Green
```
7) When an existing file is modified, send an alert/second until it's back to normal
```objc
else 
     if ($fileHashDictionary[$hash.Path] -eq $hash.Hash)              
    else 
        Write-Host "$($hash.Path) has changed!!!" -ForegroundColor Yellow
```
8) When an existing file is deleted, send an alert/second until it's back to normal
```objc
 foreach ($key in $fileHashDictionary.Keys) 
                $baselineFileStillExists = Test-Path -Path $key
                if (-not $baselineFileStillExists)
                    # One of the baseline files must have been deleted, notify the user
                    Write-Host "$($key) has been deleted!" -ForegroundColor Red
```
