「メモ帳」アプリの立ち上げる手順
1. 任意のディレクトリに移動して下さい。または`mkdir　任意の名前`で新たにディレクトリを作成して移動して下さい。
2. `git clone https://github.com/Yota310/Sinatra_practice.git`でローカルにアプリのソースコードを持ってきて下さい。
（現在PRを保持のためmainにマージしていません `git switch dev`でブランチをdevに切り替えてください。）
3. カレントディレクトリの配下に`Sinatra_practice`ができるのでそこに移動してくだい`cd Sinatra_practice`（ZIPの場合`cd Sinatra_practice-dev`）
4. `bundle install`でアプリの起動に必要なジェムをインストールして下さい。
5. `psql -Upostgres`でポストグレSQLを起動
6. その後任意のデータベースとmemoテーブルを作成
7. `CREATE DATABESE <データベース名>`でデータベースを作成
8. `CREATE TABLE memo `
   `memo_id CHAR(4) NOT NULL`
   `title VARCHAR(20) NOT NULL`
   `memo VARCHAR(100) NOT NULL`
   `PRIMARY KEY (memo_id)`でテーブルを作成
9. `bundle exec ruby memo.rb`でアプリを起動して下さい。
10. `http://localhost:4567`にアクセスするとアプリ画面に入れます
11. アプリは`control+c`で停止できます。
