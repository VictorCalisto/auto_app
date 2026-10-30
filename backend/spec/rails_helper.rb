ENV["RAILS_ENV"] = "test"
require "spec_helper"
require_relative "../config/environment"
abort "Os testes não podem rodar em produção." if Rails.env.production?
require "rspec/rails"
require "faker"

Faker::Config.locale = "pt-BR"
Faker::Config.random = Random.new(RSpec.configuration.seed)

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before do
    Faker::UniqueGenerator.clear
  end

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
