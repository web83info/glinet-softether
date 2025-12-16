# 14.SSL

echo '# 14.SSL'

# SSL証明書
if [ "$SYSTEM_SSL_ENABLE" ]; then
	if [ "$SYSTEM_SSL_CERT_BY" = 'lets_encrypt' ]; then
		cat <<- EOT
			# SSL証明書取得
			opkg install luci-app-acme acme-acmesh-dnsapi

			uci del acme.example_wildcard
			uci del acme.example_subdomain

			uci set acme.@acme[0].account_email=${SYSTEM_SSL_ACME_EMAIL}

			uci set acme.lets_encrypt=cert
			uci set acme.lets_encrypt.enabled='1'
			uci add_list acme.lets_encrypt.domains=${SYSTEM_HOSTNAME}
			uci set acme.lets_encrypt.validation_method=${SYSTEM_SSL_ACME_METHOD}
			uci set acme.lets_encrypt.dns='dns_cf'
			uci add_list acme.lets_encrypt.credentials='CF_Token="${SYSTEM_SSL_ACME_CF_TOKEN}"'
			uci add_list acme.lets_encrypt.credentials='CF_Account_ID="${SYSTEM_SSL_ACME_CF_ACCOUNT_ID}"'
			uci add_list acme.lets_encrypt.credentials='CF_Zone_ID="${SYSTEM_SSL_ACME_CF_ZONE_ID}"'
			uci set acme.lets_encrypt.staging='0'
			uci set acme.lets_encrypt.key_type='rsa2048'

			sed -i 's/exit 0//g' /etc/rc.local
			echo '/etc/init.d/acme renew' >> /etc/rc.local
		EOT
	fi
fi

echo
