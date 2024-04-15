「メモ帳」アプリの立ち上げる手順
1. 任意のディレクトリに移動して下さい。または`mkdir　任意の名前`で新たにディレクトリを作成して移動して下さい。
2. `git clone https://github.com/Yota310/Sinatra_practice.git`でローカルにアプリのソーズコードを持ってきて下さい。
（現在PRを保持のためmainにマージしていません `git switch dev`でブランチをdevに切り替えてください。）
3. カレントディレクトリの配下に`Sinatra_practice`ができるのでそこに移動してくだい`cd Sinatra_practice`（ZIPの場合`cd Sinatra_practice-dev`）
4. `bundle install`でアプリの起動に必要なジェムをインストールして下さい。
5. `bundle exec ruby memo.rb`でアプリを起動して下さい。
6. `http://localhost:4567`にアクセスするとアプリ画面に入れます
7. アプリは`control+c`で停止できます。
