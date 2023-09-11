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

cat <<- 'EOT'
# SoftEtherインストール
opkg install softethervpn-server

EOT

# SoftEther実行ファイルへのパスをPATHに追加
cat <<- 'EOT'
# SoftEther実行ファイルへのパスをPATHに追加
echo 'export PATH=$PATH:/usr/libexec/softethervpn' >> /etc/profile

EOT

[ -n "$PACKAGE_EXTRA" ] && cat <<- EOT
# 追加パッケージ
opkg install $PACKAGE_EXTRA

EOT
