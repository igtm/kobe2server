﻿# サーバーチーム！

メンバー：井上，只平，延原

***

2014/9/12 14:15

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

gitさん「うわ〜．二つのファイルのどっちを優先して残していいかわからないよ〜」  
gitさん「面倒だから．二つのファイルを合体させて１つのファイルにして，どの行のコードを残すか人間に任せちゃおう．俺しーらね」  

この状態をcollision（衝突）という．  

これが発生すると，人間が自力で合体したコードを解読し，いらないコードを消す作業が必要になる．
対処方法は，Google先生に聞きましょう．井上に聞いてもいいけど．


予防としては，事前にどのファイルをいじるか報告するといいかも．


***

2014/9/11 16:29

## サーバーチームのTODO:
+ やること（担当者）
+ RailsでDBを用意（井上）
+ AmazonからDBサーバーをレンタルおよび連結（いつかやるかも：井上）
+ イベントのデータ取得するAPI作成（井上）
+ クーポンのデータ取得するAPI作成（未着手）
+ レストランのデータ取得するAPI作成（延原）
+ 現在地から近隣のお店のデータを取得するAPI作成（未着手）
+ お気に入りAPI作成（未着手）
	- ユーザお気に入りボタン押す．
	- ユーザ情報とイベントIDがサーバーに送られるので対処する．
+ ログイン機能
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