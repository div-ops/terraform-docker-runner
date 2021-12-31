echo "[deploy] start"

# Docker, git 설치
sudo yum -y upgrade
sudo yum -y install docker git

# Docker 설치 확인
docker -v

# Docker 실행
sudo service docker start

# Dockerfile 가져오기
cp /tmp/Dockerfile ./Dockerfile

# 제거
sudo docker kill $(sudo docker ps -q)
sudo docker rm $(sudo docker ps -a -q)
sudo docker rmi nextjs-runner

[ -d ./creco.me/.git ] && cd creco.me && git pull origin HEAD && cd - || echo 'skip'
[ ! -d ./creco.me/.git ] && git clone --depth=1 https://$GIT_TOKEN@github.com/creco-org/creco.me.git || echo 'skip'

# 빌드
sudo docker build -t nextjs-runner .

# 실행
sudo docker run -d -p 80:3000 nextjs-runner

echo "[deploy] done"
