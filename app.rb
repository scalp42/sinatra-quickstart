require 'sinatra/base'
require 'datamapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/todo.db")

class Note
  include DataMapper::Resource
  property :id, Serial
  property :content, Text, :required => true
  property :complete, Text, :required => true, :default => false
  property :created_at, DateTime
  property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!

class App < Sinatra::Base
  get '/' do
    'Hello App!'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
