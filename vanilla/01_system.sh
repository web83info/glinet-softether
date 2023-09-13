# 01.システム初期設定

echo '# 01.システム初期設定'

cat <<- 'EOT'
# インターネットへの疎通がないときには終了
ping -c 1 openwrt.org > /dev/null 2>&1
if [ $? != 0 ]; then
	echo "No Internet. Aborting."
	exit 1
fi

# プロンプトに色を付ける
echo 'export PS1='\''\[\e[1;31m\]\u@\h:\w\$ \[\e[0m\]\'\' >> /etc/profile

EOT

[ -n "$SYSTEM_LANGUAGE" ] && cat <<- EOT
# システム言語
uci set luci.main.lang=$SYSTEM_LANGUAGE

EOT

[ -n "$SYSTEM_LAN_IP" ] && cat <<- EOT
# デフォルトIPアドレス変更
uci set network.lan.ipaddr=$SYSTEM_LAN_IP

EOT

cat <<- 'EOT'
# lanのipv6を無効にする
uci del network.lan.ip6assign
uci del dhcp.lan.ra
uci del dhcp.lan.ra_slaac
uci del dhcp.lan.ra_flags
uci del dhcp.lan.dhcpv6

EOT

[ -n "$SYSTEM_HOSTNAME" ] && cat <<- EOT
# ホスト名
uci set system.@system[0].hostname=$SYSTEM_HOSTNAME

EOT

[ -n "$SYSTEM_ZONENAME" ] && cat <<- EOT
# タイムゾーン名
uci set system.@system[0].zonename=$SYSTEM_ZONENAME

EOT

[ -n "$SYSTEM_TIMEZONE" ] && cat <<- EOT
# タイムゾーン
uci set system.@system[0].timezone=$SYSTEM_TIMEZONE

EOT

if [ -n "$SYSTEM_NTP_SERVER" ]; then
	cat <<- 'EOT'
	# NTPサーバ
	uci delete system.ntp.server
	EOT
	printf_multi "uci add_list system.ntp.server=%s" "$SYSTEM_NTP_SERVER"
	echo
fi
