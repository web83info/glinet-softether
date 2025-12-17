# 20.最終処理

echo '# 20.最終処理'

# 事後実行コマンド

echo '# 事後実行コマンド'

for i in $(seq 1 9)
do
	command_aftern=COMMAND_AFTER${i}
	if [ -n "${!command_aftern}" ]; then
		echo ${!command_aftern}
	fi
done

echo

cat <<- EOT
# コミット
uci commit

EOT

# SSL証明書
if [ "$SYSTEM_SSL_ENABLE" ] && [ "$SYSTEM_SSL_ENABLE" != 0 ]; then
	if [ "$SYSTEM_SSL_CERT_BY" = 'lets_encrypt' ]; then
		cat <<- EOT
		# SSL証明書取得
		/etc/init.d/acme start
		/etc/init.d/acme renew

		EOT
	fi
fi

# 実行終了
echo "echo '実行終了時刻'"
echo 'date'
echo 'echo'
echo

cat <<- EOT
# 再起動
reboot

EOT
