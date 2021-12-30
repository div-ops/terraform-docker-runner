echo "[deploy] start"

# cd /tmp

pwd

ls -al

sudo yum -y upgrade

sudo yum -y install docker

docker -v

sudo service docker start

sudo docker load -i /tmp/output.current.tar
sudo docker run -d -p 3000:3000 nextjs-runner

echo "[deploy] done"
