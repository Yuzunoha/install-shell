#!/bin/bash

# インストールされているバージョン文字列
currentver=""

# インストールされているか判定
if type "docker-compose" > /dev/null 2>&1; then
  # インストールされている。バージョンを取得する。1.24.1とか
  a=`docker-compose -v`
  a=($a)
  a=${a[2]}
  a=${a/,/}
  currentver=$a
fi

# 最新版の文字列を取得する。1.25.4とか
latestver=$(curl https://api.github.com/repos/docker/compose/releases/latest | jq .tag_name)
latestver=${latestver/\"/}
latestver=${latestver/\"/}

# 最新版があるか判定
if [ $currentver = $latestver ]; then
  echo "既に最新版 ${latestver} がインストールされています"
  exit
fi

echo "最新版 ${latestver} をインストールします"
 
# docker-composeのinstall先のパス
output='/usr/local/bin/docker-compose'

# ダウンロード
echo `curl -L https://github.com/docker/compose/releases/download/${latestver}/docker-compose-$(uname -s)-$(uname -m) > $output`

# 実行権限付与
chmod +x $output

# 確認出力
echo `docker-compose --version`

