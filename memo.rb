# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pg'

FILE_PATH = 'private/memos.json'

def connect_db
  PG.connect(dbname: 'sinatra', user: 'postgres', password: 'pgpassword')
end

def db_to_memos
  memos = connect_db
  @memos = memos.exec('SELECT * from memo')
end

def db_to_memo
  sql = 'SELECT * FROM MEMO WHERE memo_id = $1'
  @memo = connect_db.exec_params(sql, [params[:id]])
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
  title = params[:title]
  memo = params[:memo]
  memos = to_memos
  id = 1
  id = (memos.column_values(0).map(&:to_i).max + 1).to_s unless memos.ntuples.zero?
  sql = 'INSERT INTO memo(memo_id,title,memo) VALUES ($1, $2, $3)'
  connect_db.exec_params(sql, [id, title, memo])
  redirect '/memos'
end

get '/memos/:id/edit' do
  db_to_memo
  erb :edit
end

post '/memos/:id' do # 更新
  sql = 'UPDATE memo SET title = $1, memo = $2 WHERE memo_id = $3'
  connect_db.exec_params(sql, [params[:title], params[:memo], params[:id]])
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  sql = 'DELETE FROM memo WHERE memo_id = $1'
  connect_db.exec_params(sql, [params[:id]])

  redirect '/memos'
end
