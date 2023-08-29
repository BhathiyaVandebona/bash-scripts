#!/bin/bash

# Basic script for deleting virtual hosts in Apache server on Debian and Ubuntu
# THIS SCRIPT ASSUMES THAT THE CONFIGURATION HAPPENED WITHOUT ANY SUPPORT OR DNS
# THUS REMOVES THE HOST NAME FROM THE /etc/hosts IF EXISTS

## Constants
sitesAvailable='/etc/apache2/sites-available';
sitesEnabled='/etc/apache2/sites-enabled';
hosts='/etc/hosts';

## Variables
domainName=$1; # Domain name

# Check whether the user is root
if [ "$(whoami)" != 'root' ]
then
  echo "Cannot execute this script without root user permissions";
  exit 1;
fi

# Check whether Apache server is installed
if [ -z "$(which apache2)" ]
then
  echo -e "\nSeems Apache server is not installed, please install the Apache server before running this script.\n";
  exit 1;
fi

# function for deleting virtual hosts
function cleanUp() { # calling create $domainName $documentRootDir
  local dn=$1; # domain name
  local scf=$2; # site configuration file (which is inside of the /etc/apache2/sites-available) +> site configuration file
  local scfn=$(basename "$scf"); # name of the site configuration file +> site configuration file name which is used to enable or disable a site

  # Extract the document root directory from the .conf file in the /etc/apache2/sites-available directory
  # If the document root exists remove the document root as well
  documentRoot=$(grep -P '^\s*DocumentRoot\s*' "$scf" | awk '{print $2}')
  if [ -n "$documentRoot" ] && [ -d "$documentRoot" ]
  then
    echo -e "\n\e[33m Do you want to remove the document root of the site as well?(Y|n) \e[0m\n";
    local response='n';
    read response;
    if [ "$response" == 'Y' ]
    then
      # Remove the document root as well
      sudo rm -r "$documentRoot";
      if [ $? -ne 0 ]
      then
        return 1;
      fi
    fi
  fi

  # Remove the site-configuration file
  echo -e "Removing the site configuration file $scf.\n";
  sudo rm "$scf";
  echo -e "Removed the site configuration file.\n";
      
  if [ $? -ne 0 ]
  then
    return 1;
  else
    return 0;
  fi
}

## domain name checks
# Find out whether the domainName corresponds to a site in the sites-available directory
if siteConfigurationFile=$(find "$sitesAvailable" -type f -name '*.conf' -print0 | xargs -0 grep -l "$domainName")
then
  # check whether the site is enabled
  # if enabled prompt for authorization
  output=$(sudo apache2ctl -S 2>&1);
  if echo "$output" | grep -q "$domainName" # check if the host site to be deleted is among the enabled sites
  then
    echo -e "\n\e[33m $domainName is among the sites that are enabled, do you want to proceed with the deletion?(Y|n)\e[0m\n";
    response='n';
    read response;
    if [ "$response" == 'n' ]
    then
      # terminate the process
      echo -e "\nTerminating the deleting process, start over again after deciding.\n";
      exit 0;
    fi

    echo -e "Disabling the site $domainName.\n";
    sudo a2dissite "$(basename "$siteConfigurationFile")"; # Disable the site first
    echo -e "Disabled the site $domainName.\n";
    echo -e "Reloading the Apache server.\n";
    sudo systemctl reload apache2; # Reload the Apache server 
    echo -e "Done Reloading the Apache server.\n";
  fi

  echo -e "Deleting site configuration files.\n";
  # start deleting the host
  cleanUp $domainName $siteConfigurationFile

  echo -e "Virtual host was successfully removed.\n";

else
  echo -e "\n\e[31m The server name (or alias) you entered does not correspond to any of the sites available in the /etc/apache2/sites-available directory, aborting the process.\e[0m\n";
  exit 1;
fi
