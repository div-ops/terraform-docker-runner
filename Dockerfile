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
