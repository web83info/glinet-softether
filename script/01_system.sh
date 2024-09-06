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

if [ -n "$SYSTEM_ROOT_PASSWORD" ] ;then
	echo '# rootパスワード'

	if [ "$GLINET_FIRMWARE" = 'Vanilla' ]; then
		cat <<- EOT
		echo -e "$SYSTEM_ROOT_PASSWORD\n$SYSTEM_ROOT_PASSWORD" | (passwd root)
		EOT
	fi

	if [ "$GLINET_FIRMWARE" = 'Stock' ]; then
		glinet_api "system" "set_password" "root" "" $SYSTEM_ROOT_PASSWORD
		echo "uci set oui-httpd.main.inited=1"
	fi

	echo
fi

if [ -n "$SYSTEM_LANGUAGE" ] ;then
	cat <<- EOT
	# システム言語
	uci set luci.main.lang=$SYSTEM_LANGUAGE
	EOT
	if [ "$GLINET_FIRMWARE" = 'Stock' ]; then
		echo "uci set oui-httpd.main.lang=$SYSTEM_LANGUAGE"
	fi
	echo
fi

[ -n "$SYSTEM_LAN_IP" ] && cat <<- EOT
# インターフェース "lan"
# デフォルトIPアドレス変更
uci set network.lan.ipaddr='$SYSTEM_LAN_IP'
uci set dhcp.lan.ignore='1'
EOT

cat <<- EOT
uci del network.@device[0].ports
uci add_list network.@device[0].ports='$glinet_interface_lan'

EOT

cat <<- 'EOT'
# インターフェース "lan"
# ipv6を無効にする
uci del network.lan.ip6assign
uci del dhcp.lan.ra
uci del dhcp.lan.ra_slaac
uci del dhcp.lan.dhcpv6

EOT

[ -n "$SYSTEM_ADMIN_IP" ] && cat <<- EOT
# デバイス "br-admin" 作成
uci add network device
uci set network.@device[-1].type='bridge'
uci set network.@device[-1].name='br-admin'
uci add_list network.@device[-1].ports='$glinet_interface_admin'

# インターフェース "admin" 作成
uci set network.admin=interface
uci set network.admin.device='br-admin'
uci set network.admin.proto='static'
uci set network.admin.ipaddr='$SYSTEM_ADMIN_IP'
uci set network.admin.netmask='255.255.255.0'

uci add_list firewall.@zone[0].network='admin'

uci set dhcp.admin=dhcp
uci set dhcp.admin.interface='admin'
uci set dhcp.admin.start='100'
uci set dhcp.admin.limit='150'
uci set dhcp.admin.leasetime='12h'

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

if [ -n "$SSH_PUBKEY" ]; then
	cat <<- EOT
	# SSH公開鍵
	echo '$SSH_PUBKEY' > /etc/dropbear/authorized_keys
	EOT
	echo
fi
