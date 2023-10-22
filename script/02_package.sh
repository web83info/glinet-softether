# 02.パッケージインストール・アップグレード

echo '# 02.パッケージインストール・アップグレード'

cat <<- 'EOT'
# パッケージリスト取得
opkg update

EOT

if [ "$PACKAGE_UPGRADE" != 0 ]; then
	cat <<- EOT
	# インストール済パッケージアップグレード
	opkg list-upgradable | cut -f 1 -d ' ' | xargs opkg upgrade

	EOT
fi

# LuCI 言語ファイル
cat <<- 'EOT'
# LuCI 言語ファイルインストール
opkg install luci-i18n-base-ja

EOT

# SoftEther
cat <<- 'EOT'
# SoftEtherインストール
opkg install softethervpn-server

# SoftEther実行ファイルへのパスをPATHに追加
echo 'export PATH=$PATH:/usr/libexec/softethervpn' >> /etc/profile

EOT

# ttyパッケージ
cat <<- 'EOT'
# ttyパッケージインストール
opkg install luci-app-ttyd luci-i18n-ttyd-ja
uci set ttyd.@ttyd[0].interface='@admin'

EOT

[ -n "$PACKAGE_EXTRA" ] && cat <<- EOT
# 追加パッケージ
opkg install $PACKAGE_EXTRA

EOT
