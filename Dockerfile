FROM ruby:2.7.2
ARG RAILS_ENV

RUN gem update --system && gem install bundler
ENV RAILS_SERVE_STATIC_FILES true

RUN mkdir /app
WORKDIR /app
COPY . /app

RUN bundle install
RUN rails db:setup
