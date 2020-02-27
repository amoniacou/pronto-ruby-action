FROM ruby:2.6.5-alpine

ENV PRONTO_HOME /runner
ENV BUNDLE_GEMFILE ${PRONTO_HOME}/Gemfile
WORKDIR ${PRONTO_HOME}
COPY Gemfile* ./

RUN apk --no-cache add jq git libgit2 \
  && apk add --update --no-cache --virtual pronto-builddeps \
  cmake \
  openssl \
  openssl-dev \
  build-base \
  yaml-dev \
  zlib-dev \
  libgit2-dev \
  && gem install bundler \
  && addgroup -S pronto \
  && adduser -S -G pronto -h ${PRONTO_HOME} pronto \
  && bundle config build.rugged --use-system-libraries \
  && bundle install && apk del --purge pronto-builddeps

COPY . ./

WORKDIR ${PRONTO_HOME}

ENTRYPOINT ["/runner/pronto"]
