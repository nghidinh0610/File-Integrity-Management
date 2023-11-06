Write-host ""
Write-host "What would you like to do?"
write-host ""
Write-host "    A) Collect new Baseline?"
Write-host "    B) Begin monitoring files with save Baseline?"
Write-host ""

$response = Read-host -Prompt "Please enter 'A' or 'B'"
Write-host ""

Function Calculate-File-Hash($filepath) {
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA256
    return $filehash 
}

Function Erase-Baseline-If_Already-Exist {
    $baselineExist = Test-Path -Path .\baseline.txt

    if ($baselineExist){
        #Delete it
        Remove-item -Path .\baseline.txt
    }
}

if ($response -eq "A".ToUpper()) {
    #Delete baseline.txt if it already exists
    Erase-Baseline-If_Already-Exist   
   
    # Calculate Hash from the target files and store in baseline.txt
    Write-host "Calculated Hashes, made new baseline.txt" -ForegroundColor Cyan
    
    #Collect all files in the target folder
    $files = Get-ChildItem -Path .\Files
    

    #For each file, calculate the hash and write to baseline.txt
    foreach ($f in $files) {
        $hash = Calculate-File-Hash $f.FullName
        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
   
    }
}
elseif ($response -eq "B".ToUpper()) {
    
    $fileHashDictionary = @{}

    # Load file|hash from baseline.txt and store them in a dictionary
    $filePathsAndHashes = Get-Content -Path.\baseline.txt

    foreach ($f in $filePathsAndHashes) {
        $fileHashDictionary.add($f.Split("|")[0],$f.Split("|")[1])
    }


    # Begin (continuously) monitoring files with save Baseline
    while($true) {
        Start-Sleep -Seconds 1

        $files = Get-ChildItem -Path .\Files

        #For each file, calculate the hash and write to baseline.txt
        foreach ($f in $files) {
            $hash = Calculate-File-Hash $f.FullName
            #"$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
            
            #Notify if a new file has been created
            if ($fileHashDictionary[$hash.Path] -eq $null) {
                #A new file has been created
                Write-Host "$($hash.path) has been created" -ForegroundColor Green
             }
            
             else {

                # Notify if a new file has been changed
                if ($fileHashDictionary[$hash.Path] -eq $hash.Hash) {
                    #The file has not changed
                }
                else {
                    #File has been compromised!, notify the user
                    Write-Host "$($hash.Path) has changed!!!" -ForegroundColor Yellow    
                }       
            }
            
        }

        foreach ($key in $fileHashDictionary.Keys) {
                $baselineFileStillExists = Test-Path -Path $key
                if (-not $baselineFileStillExists){
                    # One of the baseline files must have been deleted, notify the user
                    Write-Host "$($key) has been deleted!" -ForegroundColor Red
                    }
            }

    }
}