#gem 'rom', '0.6.0'
#gem 'rom-sql', '0.4.0'
#gem 'rom-rails', '0.3.0'

gem_group(:development, :test) do
  gem "rspec"
  gem "rspec-rails"
  gem "capybara"
  gem "database_cleaner"
  #gem "spring-commands-rspec"
end

#application "require 'rom-rails'"

# initialize the git repository
git :init
git :add => '.'
git :commit => '-m "init"'

run 'bundle'

# rspec stuff
generate "rspec:install"

gsub_file "spec/rails_helper.rb",
  "config.use_transactional_fixtures = true",
  "config.use_transactional_fixtures = false"

insert_into_file "spec/rails_helper.rb",
  after: "config.use_transactional_fixtures = false\n" do
  <<-CONTENT

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  CONTENT
end
# end of rspec stuff
