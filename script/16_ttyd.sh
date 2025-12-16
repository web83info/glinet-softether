# 16.ttyd

echo '# 16.ttyd'

# ttyパッケージ
cat <<- 'EOT'
# ttyパッケージインストール
opkg install luci-app-ttyd luci-i18n-ttyd-ja
uci delete ttyd.@ttyd[0].interface
EOT

if [ "$SYSTEM_SSL_ENABLE" ]; then
	echo 'uci set ttyd.@ttyd[0].ssl=1';
	if [ "$SYSTEM_SSL_CERT_BY" = 'self' ]; then
		cat <<- EOT
			uci set ttyd.@ttyd[0].ssl_cert=/etc/uhttpd.cer
			uci set ttyd.@ttyd[0].ssl_key=/etc/uhttpd.key
		EOT
	fi

	if [ "$SYSTEM_SSL_CERT_BY" = 'lets_encrypt' ]; then
		cat <<- EOT
			uci set ttyd.@ttyd[0].ssl_cert=/etc/acme/${SYSTEM_HOSTNAME}/${SYSTEM_HOSTNAME}.cer
			uci set ttyd.@ttyd[0].ssl_key=/etc/acme/${SYSTEM_HOSTNAME}/${SYSTEM_HOSTNAME}.key
		EOT
	fi
fi

echo
