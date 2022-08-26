FROM ruby:2.5.7
ENV BUNDLER_VERSION=2.3.9
RUN gem install bundler -v 2.3.9
WORKDIR app

COPY Gemfile Gemfile.lock ./
COPY ./config/application.example.yml ./config/application.yml
COPY ./config/database.example.yml ./config/database.yml
COPY ./config/sidekiq.example.yml ./config/sidekiq.yml

COPY . ./

RUN bundle check || bundle install
RUN rake db:create db:migrate

EXPOSE 4567