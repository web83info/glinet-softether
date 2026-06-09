# 00.初期設定等

# セットアップログ
#   セットアップファイル名からログファイル名を生成（例：setup.sh => setup.log）
#   これ以降の標準出力と標準エラー出力をすべて tee に流す
cat <<- 'EOT'
# 00.初期設定等
LOG_FILE="$(basename "$0" .sh).log"
exec > >(tee -a "$LOG_FILE") 2>&1

EOT

# 実行開始
echo "echo '実行開始時刻'"
echo 'date'
echo 'echo'
echo

# スクリプトコメント

echo '# スクリプトコメント'

for i in $(seq 1 9)
do
	commentn=COMMENT${i}
	if [ -n "${!commentn}" ]; then
		cat <<- EOT
		echo "${!commentn}"
		EOT
	fi
done
echo

# パッケージマネージャー判定
cat <<- 'EOT'
# パッケージマネージャー判定
if type apk > /dev/null 2>&1; then
    PKG_UPDATE="apk update"
    PKG_INSTALLED="apk info"
    PKG_INSTALL="apk add"
    PKG_UPGRADE_ALL="apk info"
elif type opkg > /dev/null 2>&1; then
    PKG_UPDATE="opkg update"
    PKG_INSTALLED="opkg list-installed"
    PKG_INSTALL="opkg install"
    PKG_UPGRADE_ALL="opkg list-upgradable | cut -f 1 -d ' ' | xargs opkg upgrade"
fi

EOT

# 01.システム初期設定

echo '# 01.システム初期設定'

# イーサネットが一つしかない場合、WANとして外部と通信できるようにする
if [ "$has_only_one_ethernet" = 1 ]; then
	cat <<- 'EOT'
		uci set network.INTERNET_TMP=interface
		uci set network.INTERNET_TMP.proto='dhcp'
		uci set network.INTERNET_TMP.device='eth0'
		uci add_list firewall.@zone[0].network='lan'
		uci add_list firewall.@zone[0].network='INTERNET_TMP'
		uci del network.@device[0].ports
		uci commit
		/etc/init.d/network reload && sleep 30

	EOT
fi

# 事前実行コマンド
echo '# 事前実行コマンド'

for i in $(seq 1 9)
do
	command_beforen=COMMAND_BEFORE${i}
	if [ -n "${!command_beforen}" ]; then
		echo ${!command_beforen}
	fi
done
echo

cat <<- 'EOT'
# インターネットへの疎通が確認できるまで待機
echo 'インターネット接続を確認中...'
while :
do
    ping -c 1 openwrt.org > /dev/null 2>&1
    if [ $? == 0 ]; then
        break
    fi
done
echo 'インターネット接続を確認しました。'

EOT

cat <<- 'EOT'
# 時刻同期
date
ntpd -q -p 0.openwrt.pool.ntp.org
sleep 10
date
echo

EOT

# EXTROOT

if [ "$INSTALL_EXTROOT" != 0 ]; then
	script=$(<include/extroot)
	cat <<- EOF
	$script
	EOF
	echo
fi

cat <<- 'EOT'
# プロンプトに色を付ける
echo 'export PS1='\''\[\e[1;31m\]\u@\h:\w\$ \[\e[0m\]\'\' >> /etc/profile

EOT

if [ "$SYSTEM_ROOT_PASSWORD" ]; then
	echo '# rootパスワード'

	if [ "$GLINET_FIRMWARE" = 'Vanilla' ]; then
		echo "echo -e \"$SYSTEM_ROOT_PASSWORD"'\\n'"$SYSTEM_ROOT_PASSWORD\" | (passwd root)"
	fi

	if [ "$GLINET_FIRMWARE" = 'Stock' ]; then
		echo "echo -e \"$SYSTEM_ROOT_PASSWORD"'\\n'"$SYSTEM_ROOT_PASSWORD\" | (passwd root)"
		glinet_api "system" "set_password" "root" "" $SYSTEM_ROOT_PASSWORD
		echo "uci set oui-httpd.main.inited=1"
	fi

	echo
fi

if [ "$SYSTEM_LANGUAGE" ]; then
	cat <<- EOT
	# システム言語
	uci set luci.main.lang=$SYSTEM_LANGUAGE
	EOT
	if [ "$GLINET_FIRMWARE" = 'Stock' ]; then
		echo "uci set oui-httpd.main.lang=$SYSTEM_LANGUAGE"
	fi
	echo
fi

if [ "$SYSTEM_LAN_IPADDR" ]; then
	cat <<- EOT
	# インターフェース "lan"
	# デフォルトIPアドレス変更
	uci set network.lan.ipaddr='$SYSTEM_LAN_IPADDR'
	uci set dhcp.lan.ignore='1'
	EOT
fi

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

if [ "$SYSTEM_ADMIN_IPADDR" ]; then
	cat <<- EOT
	# デバイス "br-admin" 作成
	uci add network device
	uci set network.@device[-1].type='bridge'
	uci set network.@device[-1].name='br-admin'
	uci add_list network.@device[-1].ports='$glinet_interface_admin'

	# インターフェース "admin" 作成
	uci set network.admin=interface
	uci set network.admin.device='br-admin'
	uci set network.admin.proto='static'
	uci set network.admin.ipaddr='$SYSTEM_ADMIN_IPADDR'
	uci set network.admin.netmask='$SYSTEM_ADMIN_NETMASK'
	EOT
fi

if [ "$SYSTEM_ADMIN_GATEWAY" ]; then
	cat <<- EOT
	uci set network.admin.gateway='$SYSTEM_ADMIN_GATEWAY'
	EOT
fi

if [ "$SYSTEM_ADMIN_DNS" ]; then
	cat <<- EOT
	uci add_list network.admin.dns='$SYSTEM_ADMIN_DNS'
	EOT
fi

echo

if [ "$SYSTEM_ADMIN_IPADDR" ]; then
	cat <<- EOT
	uci add_list firewall.@zone[0].network='admin'

	EOT
fi

if [ "$SYSTEM_ADMIN_DHCP_ENABLE" != 0 ]; then

	cat <<- EOT
	uci set dhcp.admin=dhcp
	uci set dhcp.admin.interface='admin'
	uci set dhcp.admin.start='100'
	uci set dhcp.admin.limit='150'
	uci set dhcp.admin.leasetime='12h'

	EOT
fi


if [ "$SYSTEM_HOSTNAME" ]; then
	cat <<- EOT
	# ホスト名
	uci set system.@system[0].hostname=$SYSTEM_HOSTNAME

	EOT
fi

if [ "$SYSTEM_ZONENAME" ]; then
	cat <<- EOT
	# タイムゾーン名
	uci set system.@system[0].zonename=$SYSTEM_ZONENAME

	EOT
fi

if [ "$SYSTEM_TIMEZONE" ]; then
	cat <<- EOT
	# タイムゾーン
	uci set system.@system[0].timezone=$SYSTEM_TIMEZONE

	EOT
fi

if [ "$SYSTEM_NTP_SERVER" ]; then
	cat <<- 'EOT'
	# NTPサーバ
	uci delete system.ntp.server
	EOT
	printf_multi "uci add_list system.ntp.server=%s" "$SYSTEM_NTP_SERVER"
	echo
fi

if [ "$SSH_PUBKEY" ]; then
	cat <<- EOT
	# SSH公開鍵
	echo '$SSH_PUBKEY' > /etc/dropbear/authorized_keys
	EOT
	echo
fi
