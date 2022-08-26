# Demo SCA Provider written using Sinatra fremework

### Run project locally

### Setup

```
cp config/application.example.yml config/application.yml
cp config/database.example.yml config/database.yml
cp config/sidekiq.example.yml config/sidekiq.yml
```

```
  bundle install
  rake db:create db:migrate
```

### launch redis
```
redis-server
```

### launch sidekiq
```
bundle exec sidekiq -r ./app.rb
```

### Next steps

1. Start ngrok on 4567 port:
 - `ngrok http 4567`
2. Set ngrok url as `service_url` in `application.yml`
3. In `application.yml` set `host: localhost` for `redis` and `sidekiq`
4. In `application.yml` set your provider id as `provider_id`
5. Run project:
  - `rackup config.ru`

### Run project using Docker

1. Run ngrok listening on 0.0.0.0:4567
  - `ngrok http 0.0.0.0:4567`
2. Copy ngrok url and paste it as `service_url` in `application.example.yml`
3. In `application.example.yml` set `host: redis` for `redis` and `sidekiq`
4. In `application.yml` set your provider id as `provider_id`
5. Build docker services:
  - `docker-compose build`
6. Run docker:
  - `docker-compose up`
