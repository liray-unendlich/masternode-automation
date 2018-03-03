#!/bin/bash
#please do this script as root.
######################################################################
echo "*********** Phore マスターノード設定スクリプトへようこそ ***********"
echo 'Ubuntu16.04に必要なパッケージをすべてインストールします。'
echo 'その後Phoreのウォレットをコンパイルし、設定、実行します。'
echo '****************************************************************************'
sleep 1
echo '*** パッケージのインストール ***'
sleep 2
apt-get update -y
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get install -y nano htop wget
apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libboost-all-dev
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev
sleep 1
echo '*** 完了 1/4 ***'
sleep 1
echo '*** ステップ 2/4 ***'
echo '*** ファイアウォールの設定・スタートを行います。 ***'
sudo apt-get install -y ufw
sudo ufw allow ssh/tcp
sudo limit ssh/tcp
sudo ufw allow 28878/tcp
sudo ufw logging on
sudo ufw --force enable
sudo ufw status
sleep 1
echo '*** 2/4 完了 ***'
sleep 1
echo '*** ステップ 3/4 ***'
echo '***hppcoind, hppcoin-cliをダウンロード***'
wget https://www.dropbox.com/s/dq0tke0mt21tvqy/hppcoind
wget https://www.dropbox.com/s/398bdhab82lhm0c/hppcoin-cli
sudo mv hppcoind hppcoin-cli /usr/local/bin/
echo '***インストールを開始します***'
  echo '*** インストールとしてウォレットの起動・初期設定を行います。 ***'
  sleep 1
  mkdir .hppcoin
  rpcusr=$(more /dev/urandom  | tr -d -c '[:alnum:]' | fold -w 20 | head -1)
  rpcpass=$(more /dev/urandom  | tr -d -c '[:alnum:]' | fold -w 20 | head -1)
  ipaddress=$(curl inet-ip.info)
  echo "マスターノードプライベートキー(ステップ2の結果)を入力もしくはペーストしてください。"
  read mngenkey
  while [ ${#mngenkey} -ne 51 ]
  do
    echo "入力されたプライベートキーは正しくありません。もう一度確認してください。"
    read mngenkey
  done
  echo -e "rpcuser=$rpcusr \nrpcpassword=$rpcpass \nrpcallowip=127.0.0.1 \nlisten=1 \nserver=1 \ndaemon=1 \nstaking=0 \nlmnode=1 \nlogtimestamps=1 \nmaxconnections=256 \nexternalip=$ipaddress:28878 \nbind=$ipaddress \nlmnodeprivkey=$mngenkey \n" > ~/.phore/phore.conf
  echo '*** 設定が完了しましたので、ウォレットを起動して同期を開始します。 ***'
  hppcoind
  echo '10秒後に getinfo コマンドの出力結果を表示します。'
  sleep 10
  hppcoin-cli getinfo
  sleep 2
  echo '同期が完了すれば、phore-qtのウォレットからマスターノードを実行できます！'
  sleep 2
else
  echo "入力が間違っているようです。アップデートの場合: '-u', 新規インストールの場合: '-i'をオプションとしてください。"
　echo "終了します。"
fi
