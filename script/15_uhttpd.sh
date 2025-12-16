# 15.uhttpd

echo '# 15.uhttpd'

# uhttpd
if [ "$SYSTEM_SSL_ENABLE" ]; then
	cat <<- EOT
	opkg install luci-app-uhttpd
	uci set uhttpd.main.redirect_https='1'
	EOT

	if [ "$SYSTEM_SSL_CERT_BY" = 'self' ]; then
		cat <<- EOT
		uci set uhttpd.main.cert=/etc/uhttpd.cer
		uci set uhttpd.main.key=/etc/uhttpd.key
		EOT
	fi

	if [ "$SYSTEM_SSL_CERT_BY" = 'lets_encrypt' ]; then
		cat <<- EOT
		uci set uhttpd.main.cert=/etc/acme/${SYSTEM_HOSTNAME}/${SYSTEM_HOSTNAME}.cer
		uci set uhttpd.main.key=/etc/acme/${SYSTEM_HOSTNAME}/${SYSTEM_HOSTNAME}.key
		EOT
	fi

fi

echo
