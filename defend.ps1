function installGPG {
    choco install gpg4win -y
}

function setupGPG {
    & 'C:\Program Files (x86)\GnuPG\bin\gpg.exe' --generate-key
    & 'C:\Program Files (x86)\GnuPG\bin\gpg.exe' --help
}


function backup {
    $sourceFolder = "source"
    $backupFolder = "backup"

    # Check if the backup folder exists, if not, create it
    if (-not (Test-Path $backupFolder)) {
        New-Item -ItemType Directory -Path $backupFolder | Out-Null
    }

    # Get all files in the source folder and encrypt them
    Get-ChildItem -Path $sourceFolder | ForEach-Object {
        $outputFileName = Join-Path -Path $backupFolder -ChildPath $_.Name + ".gpg"
        & 'C:\Program Files (x86)\GnuPG\bin\gpg.exe' --output $outputFileName --encrypt --recipient boe.albina@cqu.edu.au $_.FullName
    }
}

function restore {
    $backupFolder = "backup"
    $restoredFolder = "restored"
    
    if (-not (Test-Path $restoredFolder)) {
        New-Item -ItemType Directory -Path $restoredFolder | Out-Null
    }

    Get-ChildItem -Path $backupFolder | ForEach-Object {
        $outputFileName = Join-Path -Path $restoredFolder -ChildPath $_.Name.Replace('.gpg', '')
        & 'C:\Program Files (x86)\GnuPG\bin\gpg.exe' --output $outputFileName --decrypt $_.FullName
    }
}

if ($args[0] -eq "installGPG") {
    installGPG
}
elseif ($args[0] -eq "setupGPG") {
    setupGPG
}
elseif ($args[0] -eq "backup") {
    backup
}
elseif ($args[0] -eq "restore") {
    restore
}
else {
    Write-Output "Invalid argument. Accepted arguments: installGPG, setupGPG, backup, restore"
}
