require 'sinatra'
require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'data_mapper'
require 'haml'
require 'builder'

SITE_TITLE = "TODOs"
SITE_DESCRIPTION = "Get things done with this app."

configure :test do
  @@db = "sqlite3://#{Dir.pwd}/todo_test.db"
end

configure :development, :production do
  @@db = "sqlite3://#{Dir.pwd}/todo.db"
end

DataMapper::setup(:default, @@db)

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
  enable :sessions
  register Sinatra::Flash
  helpers Sinatra::RedirectWithFlash
  use Rack::MethodOverride

  helpers do
    include Haml::Helpers
    alias_method :h, :html_escape
  end

  get '/' do
    @notes = Note.all :order => :id.desc
    @title = 'All TODOs'
    if @notes.empty?
      flash.now[:error] = 'No TODOs found. Add your first below.'
    end
    haml :home
  end

  post '/' do
    n = Note.new
    n.content = params[:content]
    n.created_at = Time.now
    n.updated_at = Time.now
    if n.save
      redirect '/', :notice => 'TODO saved successfully.'
    else
      redirect '/', :error => 'Failed to save TODO.'
    end
  end

  get '/rss.xml' do
    @notes = Note.all :order => :id.desc
    builder :rss
  end

  get '/:id' do
    @note = Note.get params[:id]
    @title = "Edit note ##{params[:id]}"
    if @note
      haml :edit
    else
      redirect '/', :error => "Can't find that TODO."
    end
  end

  put '/:id' do
    n = Note.get params[:id]
    unless n
      redirect '/', :error => "Can't find that TODO."
    end
    n.content = params[:content]
    n.complete = params[:complete] ? 1 : 0
    n.updated_at = Time.now
    if n.save
      redirect '/', :notice => "TODO updated successfully."
    else
      redirect '/', :error => 'Error updating TODO.'
    end
  end

  delete '/:id' do
    n = Note.get params[:id]
    if n.destroy
      redirect '/', :notice => 'TODO deleted successfully.'
    else
      redirect '/', :error => 'Error deleting TODO.'
    end
  end

  get '/:id/delete' do
    @note = Note.get params[:id]
    @title = "Confirm deletion of TODO ##{params[:id]}"
    haml :delete
  end

  get '/:id/complete' do
    n = Note.get params[:id]
    n.complete = n.complete ? 0 : 1 # flip it
    n.updated_at = Time.now
    if n.save
      redirect '/', :notice => "State changed successfully."
    else
      redirect '/', :error => "Error changing state."
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
