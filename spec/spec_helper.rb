require 'rspec'
require 'pg'
require 'album'
require 'song'
require 'pry'
require './config'

DB = PG.connect(TEST_DB_PARAMS)

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM albums *;")
    DB.exec("DELETE FROM sold_albums *;")
    DB.exec("DELETE FROM songs *;")
  end
end
