# 02.パッケージインストール・アップグレード

echo '# 02.パッケージインストール・アップグレード'

cat <<- 'EOT'
# パッケージリスト取得
$PKG_UPDATE

EOT

if [ "$PACKAGE_UPGRADE" != 0 ]; then
	cat <<- 'EOT'
	# インストール済パッケージアップグレード
	$PKG_UPGRADE_ALL

	EOT
fi

# LuCI 言語ファイル
cat <<- 'EOT'
# LuCI 言語ファイルインストール
$PKG_INSTALL luci-i18n-base-ja

EOT

# SFTPサーバー
cat <<- 'EOT'
# SFTPサーバーインストール
$PKG_INSTALL openssh-sftp-server

EOT

# SoftEther

if [ "$SOFTETHER_INSTALL" != 0 ]; then

	if [ "$SOFTETHER_VERSION" = '4' ]; then
		softether_pkg=softethervpn-server
	elif [ "$SOFTETHER_VERSION" = '5' ]; then
		softether_pkg=softethervpn5-server
	else
		softether_pkg=softethervpn-server
	fi

	cat <<- EOT
	# SoftEtherインストール
	\$PKG_INSTALL $softether_pkg
	sleep 15

	EOT

	cat <<- 'EOT'
	# SoftEther実行ファイルへのパスをPATHに追加
	echo 'export PATH=$PATH:/usr/libexec/softethervpn' >> /etc/profile

	EOT

fi

if [ "$PACKAGE_EXTRA" ]; then
	cat <<- EOT
	# 追加パッケージ
	\$PKG_INSTALL $PACKAGE_EXTRA

	EOT
fi
