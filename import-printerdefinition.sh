#/bin/bash

if [ "$#" -gt 1 ] || [ "${1}" = "-h" ] || [ "${1}" = "--help" ]; then
    # Display help info
    echo "Usage: $0 [OPTIONS] <path>"
    echo "Options:"
    echo "  -h, --help     Display this help message"
    echo "Arguments:"
    echo "  path           Cura path (e.g. ~/.local/share/cura/5.7)"
    exit 0

elif [ ! -d "${1}/definitions" ] || [ ! -d "${1}/extruders" ] || [ ! -d "${1}/quality" ] ; then
    # Confirm that we have the right folder
    echo -e "Error: Invalid Cura path."
    exit 1
fi

cura_dir=${1}

echo -e "\e[32m
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  _____                 _____ _           _     
 |_   _|____   _____   |  ___| | __ _ ___| |__  
   | |/ _ \ \ / / _ \  | |_  | |/ _\` / __| '_ \ 
   | |  __/\ V / (_) | |  _| | | (_| \__ \ | | |
   |_|\___| \_/ \___/  |_|   |_|\__,_|___/_| |_|

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
\e[0m"

echo -e "Cura Directory: ${cura_dir}\n"

# Delete any existing tevo_flash files and directories
rm -f ${cura_dir}/definitions/tevo_flash*
rm -f ${cura_dir}/extruders/tevo_flash_extruder_*
rm -f ${cura_dir}/meshes/tevo_flash*
rm -rf ${cura_dir}/quality/tevo_flash*

# Version Specific Actions
cp -rv ./tevo_flash/resources/* ${cura_dir}/ 

echo -e "NOTE: If you're reinstalling the driver, remember to remove & add the printer in Cura the reload the definition.\n"
echo -e "\e[32m~~~~~ DONE ~~~~~\e[0m\n"

