# terraform-docker-runner

### Dockerfile을 이용하여 AWS에 단일 instance로 웹서버를 띄울 수 있는 모듈입니다.

예시는 main.tf를 참고하세요.

# 사용법

## 1. .envrc 만들기

```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```

## 2. Dockerfile 만들기

예시

```
FROM node:14-alpine

RUN apk add git

RUN mkdir app

RUN ls -al

RUN pwd

WORKDIR /app

RUN git --version

RUN npx degit div-ops/nextjs-project

RUN yarn

RUN yarn build

CMD ["yarn", "start"]
```

## 3. deploy.sh 만들기

예시

```
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
```

## 4. main.tf 만들기

```
provider "aws" {
  region = var.region
}

variable "region" {
  default = "ap-northeast-2"
}

module "docker-single-runner" {
  source              = "./modules/docker-single-runner"
  SECURITY_GROUP_NAME = "web_security"
  SERVICE_PORTS       = [22, 80]
  KEY_NAME            = "my-service"
  DOMAIN              = "creco.me"
  DEPLOY_SCRIPT_PATH  = "deploy.sh"
  DOCKERFILE_PATH     = "Dockerfile"
}

output "URL" {
  value = module.docker-single-runner.URL
}

output "DOMAIN_URL" {
  value = module.docker-single-runner.DOMAIN_URL
}

output "REGISTER_NS" {
  value = module.docker-single-runner.REGISTER_NS
}

```

## 5. terraform init && apply

```
terraform init
terraform apply
```

## 6. Domain Name Server

Domain Name Server 등록해주기
