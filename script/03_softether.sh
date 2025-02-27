# 03.SoftEther設定

echo '# 03.SoftEther設定'

if [ "$SOFTETHER_INSTALL" != 0 ]; then

	cat <<- EOT
	# SoftEtherコンフィグファイル生成スクリプト
	cat > vpncmd.txt << EOF
	ServerPasswordSet $SE_SERVERPASSWORD
	ListenerDelete 443
	HubDelete DEFAULT

	EOT

	for i in $(seq 1 $hub_max)
	do
		se_hubn_name=SE_HUB${i}_NAME
		se_hubn_cascade_serveraddress=SE_HUB${i}_CASCADE_SERVERADDRESS
		se_hubn_cascade_hubname=SE_HUB${i}_CASCADE_HUBNAME
		se_hubn_cascade_username=SE_HUB${i}_CASCADE_USERNAME
		se_hubn_cascade_password=SE_HUB${i}_CASCADE_PASSWORD
		if [ -n "${!se_hubn_name}" ]; then
			cat <<- EOT
			HubCreate ${!se_hubn_name} /PASSWORD
			Hub ${!se_hubn_name}
			CascadeCreate ${!se_hubn_name}_CASCADE /SERVER:${!se_hubn_cascade_serveraddress} /HUB:${!se_hubn_cascade_hubname} /USERNAME:${!se_hubn_cascade_username}
			CascadeUsernameSet ${!se_hubn_name}_CASCADE /USERNAME:${!se_hubn_cascade_username}
			CascadePasswordSet ${!se_hubn_name}_CASCADE /TYPE:standard /PASSWORD:${!se_hubn_cascade_password}
			CascadeOnline ${!se_hubn_name}_CASCADE
			Hub
			BridgeCreate ${!se_hubn_name} /DEVICE:hub${i} /TAP:yes

			EOT
		fi
	done

	cat <<- 'EOT'
	flush
	EOF

	# SoftEtherコンフィグファイル生成
	vpncmd localhost:5555 /SERVER /IN:vpncmd.txt
	rm vpncmd.txt

	# SoftEtherコンフィグファイルを保存させる
	/etc/init.d/softethervpnserver stop
	/etc/init.d/softethervpnserver start

	# SoftEtherコンフィグファイルをバックアップの対象にする
	echo '/usr/libexec/softethervpn/lang.config' >> /etc/sysupgrade.conf
	echo '/usr/libexec/softethervpn/vpn_server.config' >> /etc/sysupgrade.conf
	EOT

fi

echo
