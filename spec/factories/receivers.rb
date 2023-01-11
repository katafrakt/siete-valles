# frozen_string_literal: true

FactoryBot.define do
  factory :receiver do
    external_id { SecureRandom.hex(16) }
  end
end
