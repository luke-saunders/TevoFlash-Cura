write-host " 

 ___                            _     ____       _       _            
|_ _|_ __ ___  _ __   ___  _ __| |_  |  _ \ _ __(_)_ __ | |_ ___ _ __ 
 | || '_ `` _ \| '_ \ / _ \| '__| __| | |_) | '__| | '_ \| __/ _ \ '__|
 | || | | | | | |_) | (_) | |  | |_  |  __/| |  | | | | | ||  __/ |   
|___|_| |_| |_| .__/ \___/|_|   \__| |_|   |_|  |_|_| |_|\__\___|_|   
              |_|                                                     
"
# Find Cura in the default location
$FindCuraPath = Resolve-Path -Path "C:\Program Files\Ultimaker Cura *"

while(-not( Test-Path -Path ( "$FindCuraPath\Cura.exe" ))) {

    Write-Host -f yellow "Couldn't find Cura in path ($FindCuraPath)`n"
    $FindCuraPath = Read-Host -Prompt "Enter full-path to Cura"

}

Write-Host "Found Cura path: $FindCuraPath `n"

try {

    Copy-Item -Path ".\tevo_flash_definition\*" -Destination $FindCuraPath -Force -Recurse -ErrorAction stop
    Write-Host -f green "Complete. `n"
    Write-Host -f green "NOTE: If you already have a Tevo Flash printer installed, remove and add printer to reload the definition. `n`n"

} catch {

    Write-Host -f reg "ERROR: Failed to copy files.  You may need to run this script with elevated permissions (Run as Administrator). `n`n"

}
