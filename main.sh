
#GO TO PACKETRIOT AND CREATE A FREE ACCOUNT
#https://packetriot.com/

PKTRIOT_VERSION=pktriot-0.10.10



function install_pktriot {
    wget https://download.packetriot.com//linux/tarballs/$PKTRIOT_VERSION.amd64.tar.gz

    tar -xvf $PKTRIOT_VERSION.amd64.tar.gz
    mv $PKTRIOT_VERSION tunnel
    rm $PKTRIOT_VERSION.amd64.tar.gz

}




function install_java16 {
  echo installing java version 16

  wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/16.0.1+9/7147401fd7354114ac51ef3e1328291f/jdk-16.0.1_linux-x64_bin.tar.gz

  tar -xvzf jdk-16.0.1_linux-x64_bin.tar.gz 
  mv jdk-16.0.1 jdk16
  rm jdk-16.0.1_linux-x64_bin.tar.gz 
}


function install_minecraft {
  echo installing minecraft server

  wget https://launcher.mojang.com/v1/objects/0a269b5f2c5b93b1712d0f5dc43b6182b9ab254e/server.jar

  mkdir server
  mv server.jar server/server.jar
}

function run_minecraft {
  #Minecraft-Server needs to be a var
  path=`pwd`
  cd server
  $path/jdk16/bin/java -Xmx2G -Xms2G -jar server.jar nogui
  cd -
}


function setup_pktriot {
  #you need an account for this. You can create an account for free on the website. 
  echo make_ sure you created an account. Choose 3 for_ the config location
  cd tunnel
  ./pktriot configure
  ./pktriot tunnel tcp allocate
  cd -
}

function run_pktriot {
  #
  cd tunnel
  ./pktriot tcp 25565
  cd -
}

function main {
  #first we need to check for installs

  #make sure java install
  if [ ! -d "jdk16" ]
  then
    echo installing java16...
    install_java16

  else
    echo java already installed, skipping
  fi

  #make sure pktriot install 
  if [ ! -d "tunnel" ]
  then
    echo installing pktriot...
    install_pktriot
    setup_pktriot

  else
    echo pktriot already installed
  fi

  #make sure the server is installed
  if [ ! -d "server" ]
  then
    echo installing server...
    install_minecraft
    run_minecraft
    exit 1 
    #setup

  else
    echo server already installed
  fi

  run_pktriot & 
  run_minecraft &
  wait
}


main
