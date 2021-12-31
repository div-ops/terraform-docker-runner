echo "[deploy] start"

# Docker 설치
sudo yum -y upgrade
sudo yum -y install docker

# Docker 설치 확인
docker -v

# Docker 실행
sudo service docker start

# Dockerfile 가져오기
cp /tmp/Dockerfile ./Dockerfile

# 빌드
sudo docker build . -t nextjs-runner

# 실행
sudo docker run -d -p 80:3000 nextjs-runner

echo "[deploy] done"
