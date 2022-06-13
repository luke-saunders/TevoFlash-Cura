param(
    [String] $CuraPath = (Resolve-Path -Path "C:\Program Files\Ultimaker Cura*" | Sort-Object Path -Descending)[0]
)

write-host " 

  _____                 _____ _           _     
 |_   _|____   _____   |  ___| | __ _ ___| |__  
   | |/ _ \ \ / / _ \  | |_  | |/ _`` / __| '_ \ 
   | |  __/\ V / (_) | |  _| | | (_| \__ \ | | |
   |_|\___| \_/ \___/  |_|   |_|\__,_|___/_| |_|

"

while (-not( Test-Path -Path ( "$CuraPath\*Cura.exe" )))
{
    Write-Host -f yellow "Cura exe not found: $CuraPath `n"
    $CuraPath = Read-Host -Prompt "Cura Installation Path"
}

Write-Host "Found Cura path: $CuraPath `n"

try
{
    if ($CuraPath -match "(?<=Ultimaker Cura )(.*?)(?=\.)")
    {
        $CuraVersion = $Matches.0
        
        # TODO: Remove any existing Tevo_Flash files...

        switch ($CuraVersion)
        {
            4 { Copy-Item -Path ".\tevo_flash_definition\*" -Destination $CuraPath -Force -Recurse -ErrorAction stop }
            5 { Copy-Item -Path ".\tevo_flash_definition\*" -Destination $CuraPath\share\cura -Force -Recurse -ErrorAction stop }
            default
            { 
                write-host "Unknown or Incompatible Cura version"
                exit 
            }
        }

        Write-Host -f green "DONE`n"
        Write-Host -f green "NOTE: If you're reinstalling the driver, remember to remove and add printer in Cura the reload the definition. `n`n"

    }
}
catch
{
    Write-Host -f red "ERROR: Failed to copy files.  You may need to run this script with elevated permissions (Run as Administrator). `n`n"
}
