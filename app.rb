require 'sinatra/base'
require 'data_mapper'
require 'haml'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/todo.db")

class Note
  include DataMapper::Resource
  property :id, Serial
  property :content, Text, :required => true
  property :complete, Boolean, :required => true, :default => false
  property :created_at, DateTime
  property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!

class App < Sinatra::Base

  use Rack::MethodOverride

  get '/' do
    @notes = Note.all :order => :id.desc
    @title = 'All TODOs'
    haml :home
  end

  post '/' do
    n = Note.new
    n.content = params[:content]
    n.created_at = Time.now
    n.updated_at = Time.now
    n.save
    redirect '/'
  end

  get '/:id' do
    @note = Note.get params[:id]
    @title = "Edit note ##{params[:id]}"
    haml :edit
  end

  put '/:id' do
    n = Note.get params[:id]
    n.content = params[:content]
    n.complete = params[:complete] ? 1 : 0
    n.updated_at = Time.now
    n.save
    redirect '/'
  end

  delete '/:id' do
    n = Note.get params[:id]
    n.destroy
    redirect '/'
  end

  get '/:id/delete' do
    @note = Note.get params[:id]
    @title = "Confirm deletion of note ##{params[:id]}"
    haml :delete
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
