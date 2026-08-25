#!/usr/bin/env bash
set -e

# Install gems and precompile assets
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Run migrations for both Postgres (primary) and SQLite (sandbox)
bundle exec rails db:migrate

# Seed only the sandbox database with starting recipes
bundle exec rails runner "ActiveRecord::Base.connected_to(role: :sandbox) { load Rails.root.join('db', 'seeds.rb') if Bean.count == 0 }"