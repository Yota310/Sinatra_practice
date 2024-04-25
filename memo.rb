# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

FILE_PATH = 'private/memos.json'

def get_memos(file_path)
  @memos = JSON.parse(File.read(file_path)).to_h
end

def set_memos(file_path, memos)
  File.open(file_path, 'w') { |f| JSON.dump(memos, f) }
end

require 'sinatra/base'

module Sinatra
  module HTMLEscapeHelper
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end

  helpers HTMLEscapeHelper
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  get_memos(FILE_PATH)
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  get_memos(FILE_PATH)
  @memo = @memos[params[:id]]
  erb :show
end

post '/memos' do
  title = params[:title]
  memo = params[:memo]

  get_memos(FILE_PATH)
  id = 1
  id = (@memos.keys.map(&:to_i).max + 1).to_s unless @memos.empty?
  @memos[id] = { title:, memo: }
  set_memos(FILE_PATH, @memos)

  redirect '/memos'
end

get '/memos/:id/edit' do
  get_memos(FILE_PATH)
  @memo = @memos[params[:id]]
  erb :edit
end

post '/memos/:id' do
  get_memos(FILE_PATH)
  @memo = @memos[params[:id]]
  @memos[params[:id]] = { title: params[:title], memo: params[:memo] }
  set_memos(FILE_PATH, @memos)

  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  get_memos(FILE_PATH)
  @memos.delete(params[:id])
  set_memos(FILE_PATH, @memos)

  redirect '/memos'
end
