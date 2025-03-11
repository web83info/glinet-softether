# 00.スクリプトコメント

echo '# 00.スクリプトコメント'

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

# 01.システム初期設定

echo '# 01.システム初期設定'

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
while :
do
    ping -c 1 openwrt.org > /dev/null 2>&1
    if [ $? == 0 ]; then
        break
    fi
done

EOT

# EXTROOT

if [ "$INSTALL_EXTROOT" != 0 ]; then
	cat <<- 'EOT'
	# EXTROOT
	SETUP_SCRIPT_DIR=$(cd $(dirname $0); pwd)
	SETUP_SCRIPT_FILENAME=`basename $0`
	SETUP_SCRIPT='. '$SETUP_SCRIPT_DIR'/'$SETUP_SCRIPT_FILENAME

	if [ $(opkg list-installed | grep block-mount)='' ]; then

	    # EXTROOTインストール処理
		#   再起動後に自スクリプトを再実行
		#   再々実行されないよう、再実行時に自スクリプト呼び出しを削除
	    sed -i 's/exit 0//g' /etc/rc.local
	    echo $SETUP_SCRIPT >> /etc/rc.local
	    echo 'sed -i "s;'$SETUP_SCRIPT';;g" /etc/rc.local' >> /etc/rc.local
	    echo 'sed -i "/^sed -i/d" /etc/rc.local' >> /etc/rc.local

	    chmod +x /etc/rc.local

	    opkg update
	    opkg install block-mount kmod-fs-ext4 e2fsprogs parted kmod-usb-storage

	    DISK="/dev/sda"
	    parted -s ${DISK} -- mklabel gpt mkpart extroot 2048s -2048s
	    DEVICE="${DISK}1"
	    echo y | mkfs.ext4 -L extroot ${DEVICE}

	    ORIG="$(block info | sed -n -e '/MOUNT="\S*\/overlay"/s/:\s.*$//p')"
	    uci -q delete fstab.rwm
	    uci set fstab.rwm="mount"
	    uci set fstab.rwm.device="${ORIG}"
	    uci set fstab.rwm.target="/rwm"
	    uci commit fstab

	    eval $(block info ${DEVICE} | grep -o -e 'UUID="\S*"')
	    eval $(block info | grep -o -e 'MOUNT="\S*/overlay"')
	    uci -q delete fstab.extroot
	    uci set fstab.extroot="mount"
	    uci set fstab.extroot.uuid="${UUID}"
	    uci set fstab.extroot.target="${MOUNT}"
	    uci commit fstab

	    mount ${DEVICE} /mnt
	    tar -C ${MOUNT} -cvf - . | tar -C /mnt -xf -

	    reboot
	
	fi

	EOT

fi

cat <<- 'EOT'
# プロンプトに色を付ける
echo 'export PS1='\''\[\e[1;31m\]\u@\h:\w\$ \[\e[0m\]\'\' >> /etc/profile

EOT

if [ "$SYSTEM_ROOT_PASSWORD" ]; then
	echo '# rootパスワード'

	if [ "$GLINET_FIRMWARE" = 'Vanilla' ]; then
		echo "echo -e \"$SYSTEM_ROOT_PASSWORD\n$SYSTEM_ROOT_PASSWORD\" | (passwd root)"
	fi

	if [ "$GLINET_FIRMWARE" = 'Stock' ]; then
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
