# frozen_string_literal: true
# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :redis_store, servers: ["redis://#{Settings.redis.host}:6379/0/session"]
