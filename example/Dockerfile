FROM node:14-alpine

WORKDIR /app

COPY ./creco.me /app/creco.me

WORKDIR /app/creco.me

RUN yarn set version stable

RUN yarn

RUN yarn build

CMD ["yarn", "start"]
