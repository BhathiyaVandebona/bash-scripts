#!/bin/bash

# Reading user arguments
if [ $# -ne 2 ]
then
  echo "Usage: <SOURCE_DIRECTORY> <DESTINATION_DIRECTORY>"
  echo "Please try again"
  exit 1
fi

source_folder=$1
destination_folder=$2
backup_date="$(date +%Y%m%d)"
backup_date_time="$(date +%Y%m%d:%H:%M:%S)"
suffix="_$backup_date.bac"
rsync_basic_options="-avt --stats"
# rsync_backup_options="-arv"

# else proceed with the backup process
if ! command -v rsync > /dev/null 2>&1
then
  echo "rsync command doesn't exist, aborting procedure"
fi

# function will backup a given directory
backup_dir ()
{
  local sf=$1
  local df=$2

  # if there aren't enough arguments then return
  if [ $# -ne 2 ]
  then
    echo "Function failed"
    return 1
  fi

  for _file_ in $(ls $sf)
  do
    if [ -f "$sf/$_file_" ];then
      echo "processing file -> $_file_"
      $(which rsync) $rsync_basic_options "$sf/$_file_" "$df/$_file_$suffix" >> "$log_file"
    elif [ -d "$sf/$_file_" ];then
      mkdir "$df/$_file_"
      backup_dir "$sf/$_file_" "$df/$_file_"
    fi
  done
}

# check write permission in the destination folder
if [ -w $destination_folder ]
then
  # check read permission in the source folder as well
  if [ -r $destination_folder ]
  then
    # if the file is not there in the destication folder
    if [ ! -d  "$destination_folder/$(basename $source_folder)" ]
    then
      mkdir "$destination_folder/$(basename $source_folder)"
      log_file="$destination_folder/$(basename $source_folder)/backup_$backup_date_time.log"
      backup_dir $source_folder "$destination_folder/$(basename $source_folder)"
    else
      mkdir "$destination_folder/$(basename $source_folder)_$backup_date_time"
      log_file="$destination_folder/$(basename $source_folder)_$backup_date_time/backup_$backup_date_time.log"
      backup_dir $source_folder "$destination_folder/$(basename $source_folder)_$backup_date_time"
    fi
    if [ $? -ne 0 ];then exit 1;fi
  else
    echo "You don't have read permission for $source_folder"
    exit 2
  fi
else
  echo "You don't have write permission for $destination_folder"
  exit 2
fi
