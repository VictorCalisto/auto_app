FROM ruby:4.0.6-bookworm

ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_BIN=/usr/local/bundle/bin \
    PATH=/usr/local/bundle/bin:$PATH

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       libpq-dev \
       postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /backend

COPY backend/Gemfile backend/Gemfile.lock ./
RUN bundle install

COPY backend/ .

EXPOSE 3000

CMD ["bash", "-lc", "rm -f /backend/tmp/pids/server.pid && bin/rails db:prepare && exec bin/rails server -b 0.0.0.0 -p 3000"]
