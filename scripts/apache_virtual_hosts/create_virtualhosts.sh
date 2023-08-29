
#!/bin/bash

# Basic script for creating name based virtualhosts in Apache server on Debian and Ubuntu
# Assumes that the web pages you want to host are in the /var/www directory by default,
# if not then the directory will be assumed as /var/www/web_site_dir

## Constants
sitesAvailable='/etc/apache2/sites-available'
sitesEnabled='/etc/apache2/sites-enabled'
hosts='/etc/hosts';

## Variables
domainName=$1 # Domain name
documentRootDir=$2 # Document root of the web site
email='webmaster@gmail.com' # You can provide a email if needed but for now it will always be set to this
indexFileContent='
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://webrtc.github.io/adapter/adapter-latest.js"></script>
    <link rel="stylesheet" href="main.css">
</head>
<body>
  <p>Have fun!</p>
</body>
</html>';
addIndexPage=1; # flag used to indicate the injection of the index page to the document root

# Check whether the user is root
if [ "$(whoami)" != 'root' ]
then
  echo "Cannot execute this script without root user permissions";
  exit 1;
fi

# Check whether Apache server is installed
if [ -z "$(which apache2)" ]
then
  echo "Seems Apache server is not installed, please install the Apache server before running this script";
  exit 1;
fi

# domain name +> empty case
if [ -z "$domainName" ]
then
  echo 'You need to provide a domain name for your server.';
  echo 'Usage: ./apache_virtual_hosts.sh (create|delete) DOMAIN_NAME other_options';
  exit 1;
fi

# domain name +> checking the existence
output=$(apache2ctl -S 2>&1);
if echo "$output" | grep -q "$domainName"
then
  echo -e "\n\e[31mThe domain name that you entered already exists, please restart the process after making amends.
for further information use the apache2ctl -S command to look at all the enabled domains\e[0m\n";
fi

## document root
if [ -z "$documentRootDir" ] # empty case
then
  echo -e "You have not provided a document root directory for your web site.
We can create a document root for you, the default directory will be assumed as 
the /var/www and the document root will be named \e[32m${domainName//./}\e[0m.
Do you want to proceed? Y(yes) n(no)";
        response='n';
        read response;
        if [[ $response == 'n' || $response == 'no' ]]
        then 
          echo 'Terminating the process, start the process again when you feel ready.';
          exit 0;
        fi

        documentRootDir="/var/www/${domainName//./}";
        echo -e "Document root will be set to: \e[32m$documentRootDir\e[0m";

elif [[ $documentRootDir =~ ^/ && -e $documentRootDir ]] # if this is the full path of a direcotry
then
  echo -e "Document root will be set to: \e[32m$documentRootDir\e[0m";
  addIndexPage=0;
elif [[ $documentRootDir =~ ^/ && -e "/var/www$documentRootDir" ]] # if this is in the /var/www/ directory
then
  documentRootDir="/var/www$documentRootDir";
  echo -e "Document root will be set to: \e[32m$documentRootDir\e[0m";
  addIndexPage=0;
else # otherwise no option to proceed
  echo -e "\n\e[32mThere is something wrong with the document root directory that you provided please, check again and restart the process.\e[0m\n";
  exit 1;
fi

# function for creating virtual hosts

function create() { # calling create $domainName $documentRootDir
  local dn=$1; # doamin name
  local drd=$2; # document root directory
  local ip=$3; # add index page
  
  
  if [[ ! -e $drd ]] # if the document root doesn't exist create it
  then

    echo -e "Creating the document root directory \e[32m$drd\e[0m.";
    sudo mkdir "$drd";
    echo "Done creating the document root directory.";

    if [[ $addIndexPage == 1 ]] # add the index.html page only if needed
    then
      echo -e "Creating the default index page of the web site \e[32m$drd/index.html\e[0m.";
      echo "$indexFileContent" > "$drd/index.html";
      echo "Done creating the index file.";
    fi 
  fi

  if [[ $? -eq 0 ]] # the file creating went well
  then
    # create the configuration file
      echo -e "Creating the default configuration page of the virtual host \e[32m$sitesAvailable/${dn//./}.conf\e[0m.";
      if ! sudo bash -c "echo '
        <VirtualHost *:80>
              ServerAdmin $email
              ServerName $dn
              DocumentRoot $drd
              <Directory $drd>
                  AllowOverride None
              </Directory>

              ErrorLog /var/log/apache2/${dn//./}.log
              LogLevel error
              CustomLog /var/log/apache2/$dn.log combined
          </VirtualHost>' > '$sitesAvailable/${dn//./}.conf'" 
    then
      echo -e $"Now errors where detected. Process cannot be completed";
    exit 1;
  else
    echo -e $"\nNew VirtualHost has been created.\n";
    echo "Enabling the VirtualHost configuration";
    sudo a2ensite "${dn//./}.conf";
    sudo systemctl reload apache2;
    echo "Your VirtualHost is now enabled.";

    echo "Changing the /etc/hosts file to redirect the server URL properly...";

    sudo bash -c "echo '127.0.0.1 	$dn' >> $hosts";

    # sudo systemctl restart systemd-resolved; # may not work for Debian systems

    echo "Done Changing the /etc/hosts file";

    echo -e "\nYou can now access your website through this URL: http://$dn\n";

    echo -e "\nHave fun.\n";
  fi
  else 
    echo -e "Something went wrong when creating the directory. Terminating the process";
    exit 1;
  fi

}

echo "Processing...";
create "$domainName" "$documentRootDir" "$addIndexPage";

