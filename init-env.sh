#!/bin/bash
WORDPRESS_FILE="http://wordpress.org/latest.tar.gz"
FILE=wordpress.tar.gz

# Check if Docker is installed
  if ! which docker >/dev/null ; then
    echo "Install docker! Go to: https://docs.docker.com/engine/install"
    echo "and docker-compose! Go to: https://docs.docker.com/compose/install"
    echo "then run docker daemon and wait for it started!"
    exit -1    
  fi
#

# Check if docker-compose is installed
  if ! which docker-compose >/dev/null ; then
    echo "Install docker-compose! Go to: https://docs.docker.com/compose/install"
    exit -1  
  fi
#

# Check if docker is running
  if ! docker info > /dev/null 2>&1; then
    echo "Run docker daemon and wait for it started!"
    exit -1
  fi
#

# Get wordpress base files
  mkdir wordpress
  cd wordpress

  if test -f "$FILE"; then
      echo "$FILE exists, backuping..."
      mv $FILE "bak-"$FILE
  fi

  if which wget >/dev/null ; then
      echo "Downloading via wget."

      wget_output=$(wget $WORDPRESS_FILE)

      if [[ $wget_output -ne 200 ]]; then
        echo $wget_output
        echo "wget failed"
        exit 1; 
      fi

      if ! test -nf "$FILE"; then
          echo "$FILE not downloaded, wget failed."
      fi

  elif which curl >/dev/null ; then
      echo "Downloading via curl."
      curl_output=$(curl -L   --write-out '%{http_code}' $WORDPRESS_FILE -o $FILE)
      
      if [[ $curl_output -ne 200 ]]; then
        echo $curl_output
        echo "curl failed"
        exit 1; 
      fi

      if ! test -n "$FILE"; then
          echo "$FILE not downloaded, curl failed."
      fi

  else
      echo "Cannot download, neither wget nor curl is available. Download manually: $WORDPRESS_FILE"
      exit -1
  fi
#

# Decompress file
  tar xfz $FILE

  if [ ! $? -eq 0 ]; then
    echo "Failed decompressing file: $FILE"
    exit -1
  fi

  rm $FILE
#

# Build docker images
  docker-compose build

  if [ ! $? -eq 0 ]; then
    echo "Failed building images!"
    exit -1
  fi

  echo "DONE! Start developing!"
#
