#!/bin/bash

apt install -y net-tools

# Check if port 80 is listening
if netstat -tnlp | grep -q ':80'; then
  # Stop the service using systemctl
  sudo systemctl stop apache2  && systemctl disable  apache2  # change 'apache2' to the name of your web server service
  echo "Stopped port 80 service."
else
  echo "Port 80 is not currently listening."
fi

echo "Checking Permission"
current_uid=$(id -u)
# Check if the current user is root (UID 0)
if [ $current_uid -ne 0 ]; then
  echo "######################### Error: This script must be run as root #############################"
  exit 1
fi
# Continue with the rest of the script
echo "########################### Running as root. Continuing with the script.############################"
echo "Updating system Please Wait"
sudo apt -y update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" -y
sudo apt -y update
echo "Installing Docker"
sudo apt install -y docker-ce
sudo systemctl enable --now  docker
echo -n "Login Docker Hub:"
for i in {1..5}; do
  sleep 1
  echo -n "."
done
echo ""
docker login -u himanshuubuy  -p Honey@123
echo "######################## Login Succeed ########################"
echo "######################## Setting Up Docker Containers ##########################"
docker pull himanshuubuy/ubuy:ubuytest_env_v3
mkdir -p /home/cloudpanel/Abroad && docker run -it -d --name ubuy_test_env -p 80:80 -p 443:443 --mount type=bind,source=/home/cloudpanel/Abroad,target=/home/cloudpanel/Abroad himanshuubuy/ubuy:ubuytest_env_v3 /bin/bash && docker exec -it ubuy_test_env php-fpm -g 'daemon off;'
rm -rf /home/cloudpanel/Abroad
cd /home/cloudpanel/ && git clone https://github.com/ubuy-llc/Abroad.git
cd /home/cloudpanel/Abroad &&  git checkout development-master
echo -n "################### Creating Environment: ################################"
for i in {1..5}; do
  sleep 1
  echo -n "."
done
echo ""
echo "
APP_DEBUG=1
APP_ENVIRONMENT=local

BASE_HOST=https://test-abroad.theubuy.com

SESSION_SAVE_HANDLER=memcache
SESSION_SAVE_PATH=192.168.1.157:11211

SESSION_SAVE_HANDLER_ADMIN=memcache
SESSION_SAVE_PATH_ADMIN=192.168.1.157:11211

REDISCACHE_HOST=192.168.1.157:6379

DB_WRITE_HOST=192.168.1.158
DB_READ_HOST=192.168.1.158
DB_READ_REPLICA_HOST=192.168.1.158
DB_UBUY_REPLICA_HOST=192.168.1.158
DB_UBUY_REPLICA_2_HOST=192.168.1.158

DB_WRITE_HOST_MARIA=192.168.1.158
DB_READ_HOST_MARIA=192.168.1.158

DB_USER=ubuy
DB_PASSWORD=6MRl-BdUpcmNd50u
DB_NAME=mazade-new

DB_USER_TEST=ubuy
DB_PASSWORD_TEST=6MRl-BdUpcmNd50u
DB_NAME_TEST=ubuy

DOCUMENT_DB_HOST=192.168.1.106
DOCUMENT_DB_USER=master
DOCUMENT_DB_PASSWORD=6MRl-BdUpcmNd50u
DOCUMENT_DB_NAME=mazade-new



DOCUMENT_DB_NAME_LOGS=ubuy_logs"  >  /home/cloudpanel/Abroad/.env



echo -n "############################# Setting Up domain: ##################################"
for i in {1..5}; do
  sleep 1
  echo -n "."
done
echo ""
sudo echo "127.0.0.1 test-abroad.theubuy.com" >> /etc/hosts
sudo echo "127.0.0.1 www.test-abroad.theubuy.com" >> /etc/hosts
echo "For HTTPS browse this URL:-  https://test-abroad.theubuy.com/en/"
echo "For HTTP browse this URL:-  http://test-abroad.theubuy.com/en/"
echo "For PHPMYADMIN browse this URL:- http://192.168.1.158/pma/ "
echo -n "Setting up container DockerService Script:"
for i in {1..5}; do
  sleep 1
  echo -n "."
done
echo ""
echo "
#!/bin/bash
echo "Checking Permission"
current_uid=$(id -u)
# Check if the current user is root (UID 0)
if [ \$current_uid -ne 0 ]; then
          echo "Error: This script must be run as root."
            exit 1
fi
# Continue with the rest of the script
echo "Running as root. Continuing with the script."
container_name="ubuy_test_env"
action=\$1
start_container() {
        echo "Starting the Docker container..."
        docker start \$container_name && sleep 5 &&  docker exec -it  \$container_name php-fpm -g 'daemon off;'
    }
stop_container() {
          echo "Stopping the Docker container..."
          docker stop \$container_name
    }
restart_container() {
          echo "Restarting the Docker container..."
          docker restart \$container_name && docker exec -it  \$container_name php-fpm -g 'daemon off;'
    }
case \$action in
        start)
                start_container
                ;;
        stop)
                stop_container
                ;;
        restart)
                restart_container
                ;;
        *)
                echo "Error: Invalid action. Use start, stop, or restart."
                exit 1
                ;;
        esac
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     Docker container action completed @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
" > /root/DockerService.sh
chmod +x /root/DockerService.sh
echo "For Starting the conatiner run this command from root user sh DockerService.sh start"
echo "For Stoping the conatiner run this command from root user sh DockerService.sh stop"
echo "For Restarting the conatiner run this command from root user sh DockerService.sh restart"
sh /root/DockerService.sh restart
cat << 'EOF'
  __________
< Setup complete >
 ----------
   \
    \
        .--.
       |o_o |
       |:_/ |
      //   \ \
     (|     | )
    /'\_   _/`\
    \___)=(___/"
 | |  | | |  _ \  | |  | | \ \   / /
 | |  | | | |_) | | |  | |  \ \_/ /
 | |  | | |  _ <  | |  | |   \   /
 | |__| | | |_) | | |__| |    | |
  \____/  |____/   \____/     |_|
Enjoy coding in a good way! """
EOF

rm -rf /root/testabroad-docker.sh