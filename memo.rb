# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pg'

def connect_db
  @dbname = 'sinatra'
  @user = 'postgres'
  @password = 'pgpassword'
  PG.connect(dbname: @dbname, user: @user, password: @password)
end

def db_to_memos
  connection = connect_db
  @memos = connection.exec('SELECT * from memo order by memo_id')
  connection.finish
end

def db_to_memo
  connection = connect_db
  sql = 'SELECT * FROM MEMO WHERE memo_id = $1'
  @memo = connection.exec_params(sql, [params[:id]])
  connection.finish
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
  db_to_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  db_to_memo
  erb :show
end

post '/memos' do
  connection = connect_db
  title = params[:title]
  memo = params[:memo]
  db_to_memos
  id = 1
  id = (@memos.column_values(0).map(&:to_i).max + 1).to_s unless @memos.ntuples.zero?
  sql = 'INSERT INTO memo(memo_id,title,memo) VALUES ($1, $2, $3)'
  connection.exec_params(sql, [id, title, memo])
  connection.finish
  redirect '/memos'
end

get '/memos/:id/edit' do
  db_to_memo
  erb :edit
end

post '/memos/:id' do # 更新
  connection = connect_db
  sql = 'UPDATE memo SET title = $1, memo = $2 WHERE memo_id = $3'
  connection.exec_params(sql, [params[:title], params[:memo], params[:id]])
  connection.finish
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  connection = connect_db
  sql = 'DELETE FROM memo WHERE memo_id = $1'
  connection.exec_params(sql, [params[:id]])
  connection.finish
  redirect '/memos'
end
