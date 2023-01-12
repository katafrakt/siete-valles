FROM ruby:3.0.2 AS build

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y nodejs postgresql-client vim --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

COPY Gemfile Gemfile.lock ./

RUN bundle config --global frozen 1
RUN bundle config set without 'development test'
RUN bundle install --jobs=3 --retry=3

COPY . ./

ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY=$RAILS_MASTER_KEY
RUN bundle exec rake assets:precompile

FROM ruby:3.0.2

WORKDIR /usr/src/app/

COPY --from=build /usr/src/app/ ./

RUN bundle install --jobs=3 --retry=3

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]