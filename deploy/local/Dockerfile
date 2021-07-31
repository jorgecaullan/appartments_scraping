FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -qq -y build-essential libpq-dev cron

WORKDIR /opt/appartment_search/

COPY ["./code/Gemfile", "./code/Gemfile.lock", "/opt/appartment_search/"]

RUN bundle install