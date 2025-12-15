# 14.ttyd

echo '# 14.ttyd'

# ttyパッケージ
cat <<- 'EOT'
# ttyパッケージインストール
opkg install luci-app-ttyd luci-i18n-ttyd-ja
uci delete ttyd.@ttyd[0].interface

EOT
