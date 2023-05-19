ARG BASE_IMAGE


FROM alpine:3.17.2 AS alpine-base
RUN apk add --no-cache chromium chromium-chromedriver nodejs tini \
    && adduser -u 1000 -H -D bot
# Replace cdc token to prevent begin detected
RUN sed -i s/cdc_/fan_/g /usr/bin/chromedriver
ENV CHROME_BIN=/usr/bin/chromium-browser CHROME_PATH=/usr/lib/chromium/


FROM alpine-base AS alpine-font
RUN apk add --no-cache font-noto-cjk


FROM ${BASE_IMAGE}
ARG VARIANT
USER bot
COPY dist /app
ENV TZ=Asia/Taipei
ENV IMAGE_VARIANT=${VARIANT}
WORKDIR /app
ENTRYPOINT [ "tini", "--", "node", "index.js" ]
