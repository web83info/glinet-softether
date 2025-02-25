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

if [ "$SOFTETHER_INSTALL" != 0 ]; then

	if [ "$SOFTETHER_VERSION" = '4' ]; then
		softether_opkg=softethervpn-server
	elif [ "$SOFTETHER_VERSION" = '5' ]; then
		softether_opkg=softethervpn5-server
	else
		softether_opkg=softethervpn-server
	fi

	cat <<- EOT
	# SoftEtherインストール
	opkg install $softether_opkg
	sleep 15

	EOT

	cat <<- 'EOT'
	# SoftEther実行ファイルへのパスをPATHに追加
	echo 'export PATH=$PATH:/usr/libexec/softethervpn' >> /etc/profile

	EOT

fi

# ttyパッケージ
cat <<- 'EOT'
# ttyパッケージインストール
opkg install luci-app-ttyd luci-i18n-ttyd-ja
uci delete ttyd.@ttyd[0].interface

EOT

if [ -n "$PACKAGE_EXTRA" ]; then
	cat <<- EOT
	# 追加パッケージ
	opkg install $PACKAGE_EXTRA

	EOT
fi
