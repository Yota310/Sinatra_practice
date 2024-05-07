# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pg'

FILE_PATH = 'private/memos.json'

def connect_db
  PG.connect( dbname: 'sinatra', user: 'postgres', password: 'pgpassword')
end
def get_memos
  memos = connect_db
  @memos = memos.exec("SELECT * from memo")
end

def get_memo()
  memos = connect_db
  @memo = memos.exec("SELECT * FROM MEMO WHERE memo_id = '#{params[:id]}'")
  @memo.values
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
  get_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  get_memo
  erb :show
end

post '/memos' do
  title = params[:title]
  memo = params[:memo]
  
  memos = get_memos
  id = 1
  id = (memos.column_values(0).map{|n| n.to_i}.max + 1).to_s unless memos.ntuples == 0
  connect_db.exec("INSERT INTO memo(memo_id,title,memo) VALUES ('#{id}','#{title}', '#{memo}')")

  redirect '/memos'
end

get '/memos/:id/edit' do
  get_memo
  erb :edit
end

post '/memos/:id' do # 更新
  memos = connect_db
  memos.exec("
  UPDATE memo
    SET (title, memo) = ('#{params[:title]}', '#{params[:memo]}' )
    WHERE memo_id = '#{params[:id]}'
  ")
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memos = connect_db
  memos.exec("DELETE FROM memo
  WHERE memo_id = '#{params[:id]}'  
  ")

  redirect '/memos'
end
