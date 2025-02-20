# 20.最終処理

echo '# 20.最終処理'

# 事後実行コマンド

echo '# 事後実行コマンド'

for i in $(seq 1 9)
do
	command_aftern=COMMAND_AFTER${i}
	if [ -n "${!command_aftern}" ]; then
		cat <<- EOT
		${!command_aftern}
		EOT
	fi
done
echo

cat <<- EOT
# コミット＆再起動
uci commit
reboot

EOT
