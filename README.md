# サーバーチーム！

メンバー：井上，只平，延原

***

2014/9/16 16:36

## 延原さんと只平さんへの課題
  
	作業場所：  
	延原さん　/app/controller/shops_controller.rb  
	只平さん　/app/controller/base_shop_controller.rb	  
	  
	課題：  
	雑貨屋情報のサイトから，以下の情報を取り出してほしい  
	title:雑貨屋名（必須）  
	content:雑貨屋の説明文  
	image:画像のURL(絶対パス)  
	imageFlag:画像の有無（true or false）  
	site_url:雑貨屋サイトのURL（無ければ空文字を入れる）  
	  
	取り出したお店の情報はハッシュ（連想配列）に格納すること  
	ハッシュに情報格納する際には，category:"variery"も追加で格納すること  
  
	各ハッシュは配列に追加格納していくこと  
	
	最後に配列をjson形式で出力し，Webサイトの画面に表示されること  
	  
	  
	課題をこなす際に以下のメソッドを作ったので使っても構いません  
	getDoc(string)  
	render_json(array)  
	メソッド処理の詳細は こちらのファイルを見てね  
	/app/controllers/application_controller.rb  
	使い方はこちら  
	app/controllers/event_controller.rb  
	  
	動くかテストしたいとき  
	rails server コマンドをコマンドプロンプトで実行  
	http://localhost:3000/shops/variety をブラウザで見れる  


***

2014/9/12 17:30作成

## データベースの仕様（仮）

#### Userテーブル（ユーザのデータ）
  

| 項目        | データ型     | 説明       |
|:-----------|------------:|:------------:|
| id         |  primary_key integer |  ID  例. 24  |
| username   |  string |  ユーザ名  例. "ino"  |
| email      |  string |  メアド   例. "ino@exmaple.com"  |
| password   |  string |  パスワード   例. "inoino"   |
| currentLat |  float |   現在地・緯度   例. 36.5345 |
| currentLon |  float |   現在地・経度   例. 135.3723 |
| favorite_id | string |  お気に入りのIDの集まり  例. "5,11,18,25" |

  

#### Contentテーブル（イベント・レストラン・お店などのデータ）

| 項目        | データ型     | 説明       |
|:-----------|------------:|:------------:|
| id         |  primary_key integer |  ID  例. 25  |
| name       |  string |  お店・イベントの名前  |
| category   |  string |  カテゴリ（santa/umie/mitsui/など）  |
| content    |  text |    説明文   |
| favorite_count |  integer |  お気に入り合計数     |
| image   | string |   画像URL   例.http://umie/image/133.png |
| site_url  | string |  詳細サイトURL  例.http://umie/event/harabard |
  

***

2014/9/12 14:15作成

## これだけでなんとかなる厳選Gitコマンド５個

自分がある程度ファイルを編集したら，以下のコマンド順に使いましょう．

+ git add --all (自分が編集したファイルをコミットするための準備)  
+ git commit -m "メッセージ記入" （コミットする．これでプッシュ準備OK）  
+ git fetch （他人が編集したか確認）
+ git pull （他人が編集ファイルをダウンロード）
+ git push （コミットしたファイルを皆に共有する）

#### 注意（衝突について）

複数の人間が同時に同じファイルを編集してプッシュかプルをすると，  
gitさんはどっちの編集ファイルを優先して残して良いかわからなくなる  

+ gitさん「うわ〜．二つのファイルのどっちを優先して残していいかわからないよ〜」  
+ gitさん「面倒だから．二つのファイルを合体させて１つのファイルにして，どの行のコードを残すか人間に任せちゃおう．俺しーらね」  

この状態をcollision（衝突）という．  

これが発生すると，人間が自力で合体したコードを解読し，いらないコードを消す作業が必要になる．  
対処方法は，Google先生に聞きましょう．井上に聞いてもいいけど．


予防としては，事前にどのファイルをいじるか報告するといいかも．


***

2014/9/12 17:00更新

## サーバーチームのTODO:
+ やること（担当者）
+ RailsでDBを用意（井上．ちょっとやった．後々変更する可能性あり）
+ AmazonからDBサーバーをレンタルおよび連結（いつかやるかも：井上）
+ イベントのデータ取得するAPI作成（井上．３つのサイトから取得できた）
+ クーポンのデータ取得するAPI作成（未着手）
+ レストランのデータ取得するAPI作成（延原）
+ 現在地から近隣のお店のデータを取得するAPI作成（未着手）
+ お気に入りAPI作成（未着手）
	- ユーザお気に入りボタン押す．
	- ユーザ情報とイベントIDがサーバーに送られるので対処する．
+ ログイン機能（未着手）
	- FacebookやTwitterを利用するといいかも  

### 使えそうなWebAPI一覧
+ イベント系
	- __神戸ハーバーランド[イベント・ニュース一覧]__
		* http://umie.jp/news/event
	- __プラミアムアウトレット[イベント一覧]__
		* http://www.premiumoutlets.co.jp/kobesanda/events/
	- __マリンビア神戸[イベント一覧]__
		* http://www.31op.com/kobe/news/shop.html
	- じゃらん[イベント一覧]
		* http://www.jalan.net/ou/oup1400/ouw1401.do?lrgCd=280200
+ クーポン系
	 - ホットペッパークーポン
  		* http://mashupaward.jp/apis/103
	 - ホットペーパービューティ
		* http://mashupaward.jp/apis/109
	 - ポンパレ
	  	* http://mashupaward.jp/apis/101
+ 近隣のお店情報
 	- 神戸(三宮・元町)の雑貨屋 一覧
	  	* http://monobito.com/all_shop/4400/3/?sort=update
	- 神戸の雑貨屋一覧
	 	* http://zakka.30min.jp/hyogo/
	- 神戸ハーバーランド[ショップ一覧]
		* http://umie.jp/news/shops
	- Retty[神戸のレストラン]
		* http://retty.me/area/PRE28/ARE99/SUB9901/
	- RankingShare[神戸グルメランキング]
		* http://www.rankingshare.jp/list/%E7%A5%9E%E6%88%B8?genre_id=all
	- Foursquare[いろいろ]
		* https://ja.foursquare.com/
 	- Yahoo Local Search[いろいろ]
		* http://mashupaward.jp/apis/47
	- Yahoo 口コミ
		* http://developer.yahoo.co.jp/webapi/map/openlocalplatform/v1/reviewsearch.html
 	- 駅すぱぁと
  		* http://mashupaward.jp/apis/141
 	- BAR-NAVI
  		* http://webapi.suntory.co.jp/barnavidocs/api.html
+ 友達・SNS
 	- Facebook
  		* http://mashupaward.jp/apis/59
 	- Twitter
  		* http://dx.24-7.co.jp/twitterapi1-1-rest-api/
 	- Instgram
  		* http://mashupaward.jp/apis/60

****

試しにここに何か書き込んでコミット&プッシュしてみてください．

そうすれば，あなたもGitマスターの一員です！

後，何か皆に伝えたいこと・困ったことがあったら書いてもいいよ！

本当はプログラムの仕様を書くところだけどね．

井上

****

tst

****
延原
tst(´･ω･`)(´･ω･`)(´･ω･`)