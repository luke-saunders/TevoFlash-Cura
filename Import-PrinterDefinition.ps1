param(
    [string] $CuraPath = ""
)

try
{
    # Check RunAsAdministrator
    $CP = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if ($CP -ne $true)
    {
        Write-Host "`n`nERROR: This script requires elevated permissions.  Please use 'run as administrator'.`n`n" -ForegroundColor Red
        exit(1)
    }

    @" 
`n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  _____                 _____ _           _     
 |_   _|____   _____   |  ___| | __ _ ___| |__  
   | |/ _ \ \ / / _ \  | |_  | |/ _`` / __| '_ \ 
   | |  __/\ V / (_) | |  _| | | (_| \__ \ | | |
   |_|\___| \_/ \___/  |_|   |_|\__,_|___/_| |_|

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`n
"@ | Write-Host -ForegroundColor Green

    # Attempt to find the Cura installation folder
    if ($CuraPath -eq "")
    {
        $FindCuraPath = (Resolve-Path -Path "C:\Program Files*\Ultimaker Cura*" | Sort-Object Path -Descending)
        switch ($FindCuraPath.Path.Count)
        {
            1 { $CuraPath = $FindCuraPath[0].Path } 
            0 { $CuraPath = Read-Host -Prompt "`nCura Installation Folder" } 
            default
            {
                Write-Host "Multiple Cura folders found:" -ForegroundColor Yellow
                Write-Output $FindCuraPath.Path
                $CuraPath = Read-Host -Prompt "`nCura Installation Folder"
                Write-Host ""
            }
        }
    }

    while (-not( Test-Path -Path ( "$CuraPath\share\cura\" )))
    {
        Write-Host -f red "`nFolder not found. Please check the Cura installation path."
        $CuraPath = Read-Host -Prompt "Cura Installation Path"
        Write-Host ""
    }

    Write-Host "Cura Folder: $CuraPath`n"

    # Find Cura version from folder name
    $CuraPath -match '(Ultimaker Cura )([0-9]+)(.*)' | Out-Null
    $CuraVersion = $Matches[2]

    # Remove any existing Tevo_Flash files
    Remove-Item -Path "$CuraPath\share\cura\" -Include "Tevo_Flash*" -Recurse -Confirm:$false

    # Version Specific Actions
    switch ($CuraVersion)
    {
        4 { Copy-Item -Path ".\tevo_flash\*" -Destination $CuraPath -Force -Recurse -ErrorAction Stop }
        5 { Copy-Item -Path ".\tevo_flash\*" -Destination $CuraPath\share\cura -Force -Recurse -ErrorAction Stop }
        default
        {
            Write-Host "WARNING: Untested Cura version" -ForegroundColor Yellow
            if ((Read-Host -Prompt "Would you like to proceed? [y/n]").ToLower() -ne 'y') { exit(1) }
            Copy-Item -Path ".\tevo_flash\*" -Destination $CuraPath\share\cura -Force -Recurse -ErrorAction Stop
        }
    }

    Write-Host "NOTE: If you're reinstalling the driver, remember to remove & add the printer in Cura the reload the definition.`n"

    Write-Host -f green "~~~~~ DONE ~~~~~`n`n"
    Pause
} 
catch 
{
    $_
    Pause
}

