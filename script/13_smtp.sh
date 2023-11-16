# 13.SMTP

echo '# 13.SMTP'

if [ -n "$SMTP_ENABLE" ] && [ "$SMTP_ENABLE" != 0 ]; then
	cat <<- EOT
	# SMTPインストール
	opkg install msmtp

	EOT

	script=$(<include/_etc_msmtprc)
	script=${script//SMTP_HOST/${SMTP_HOST}}
	script=${script//SMTP_PORT/${SMTP_PORT}}
	script=${script//SMTP_FROM/${SMTP_FROM}}
	script=${script//SMTP_USER/${SMTP_USER}}
	script=${script//SMTP_PASSWORD/${SMTP_PASSWORD}}
	script=${script//SMTP_TLS/${SMTP_TLS}}
	script=${script//SMTP_STARTTLS/${SMTP_STARTTLS}}

	# SMTP設定
	cat <<- EOT
	# SMTP設定
	cat > /etc/msmtprc << 'EOF'
	$script
	EOF

	EOT

	# エイリアス
	if [ -n "$ROOT_EMAIL_TO" ] ; then
		cat <<- EOT
		# sendmailとして使えるようにシンボリックリンク
		ln -s /usr/bin/msmtp /usr/sbin/sendmail

		# エイリアス
		echo 'default:${ROOT_EMAIL_TO}' >> /etc/aliases

		EOT
	fi

fi

echo
