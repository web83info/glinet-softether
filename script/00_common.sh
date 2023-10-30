# 00.スクリプト生成用初期設定

# 定数

# 機種名（指定がないときはSlateを指定したものとみなす）
if [ -z "$GLINET_MODEL" ]; then
	GLINET_MODEL=Slate
fi

# ファームウェア（指定がないときはStockを指定したものとみなす）
if [ -z "$GLINET_FIRMWARE" ]; then
	GLINET_FIRMWARE=Stock
fi

# 仮想ハブ最大数
hub_max=5

# VLAN最大数
vlan_max=10

# 機種ごと

if [ "$GLINET_MODEL" = 'Mango' ]; then
	# 内部構成
	glinet_has_switch=1
	glinet_switch_name=eth0
	glinet_switch_port_cpu=6
	glinet_switch_port_wan=0
	glinet_switch_port_lan1=1
	glinet_ethernet_wan_name=eth0.2
	glinet_ethernet_lan1_name=eth0.1
	glinet_interface_admin=eth0.1
	glinet_interface_lan=eth0
	glinet_button_side_gpio_regexp="|switch.*(hi|lo)"
	glinet_button_side_gpio_left=hi
	glinet_button_side_gpio_right=lo

	# SSID最大数
	wifi_ssid_max=4

	# 無線周波数帯
	wireless_24g=radio0
fi

if [ "$GLINET_MODEL" = 'Shadow' ]; then
	# 内部構成
	glinet_has_switch=0
	if [ "$GLINET_FIRMWARE" = 'Vanilla' ]; then
		glinet_ethernet_wan_name=eth1
		glinet_ethernet_lan1_name=eth0
	fi
	if [ "$GLINET_FIRMWARE" = 'Stock' ]; then
		glinet_ethernet_wan_name=eth0
		glinet_ethernet_lan1_name=eth1
	fi
	glinet_interface_admin=br-vlantap.1
	glinet_interface_lan=br-vlantap.2
	glinet_button_side_gpio_regexp="|switch.*(hi|lo)"
	glinet_button_side_gpio_left=hi
	glinet_button_side_gpio_right=lo

	# SSID最大数
	wifi_ssid_max=8

	# 無線周波数帯
	wireless_24g=radio0
fi

if [ "$GLINET_MODEL" = 'Creta' ]; then
	# 内部構成
	glinet_has_switch=1
	glinet_switch_name=eth0
	glinet_switch_port_cpu=0
	glinet_switch_port_lan1=2
	glinet_switch_port_lan2=1
	glinet_ethernet_wan_name=eth1
	glinet_ethernet_lan1_name=eth0.1
	glinet_ethernet_lan2_name=eth0.1
	glinet_interface_admin=eth0.1
	glinet_interface_lan=eth0

	# SSID最大数
	wifi_ssid_max=16

	# 無線周波数帯
	wireless_24g=radio1
	wireless_5g=radio0
	wireless_radio0_band=5g
	wireless_radio1_band=2g
fi

if [ "$GLINET_MODEL" = 'Slate' ]; then
	# 内部構成
	glinet_has_switch=1
	glinet_switch_name=eth0
	glinet_switch_port_cpu=0
	glinet_switch_port_wan=1
	glinet_switch_port_lan1=2
	glinet_switch_port_lan2=3
	glinet_ethernet_wan_name=eth0.2
	glinet_ethernet_lan1_name=eth0.1
	glinet_ethernet_lan2_name=eth0.1
	glinet_interface_admin=eth0.1
	glinet_interface_lan=eth0
	glinet_button_side_gpio_regexp="|switch-button.*(hi|lo)"
	glinet_button_side_gpio_left=lo
	glinet_button_side_gpio_right=hi

	# SSID最大数
	wifi_ssid_max=16

	# 無線周波数帯
	wireless_24g=radio1
	wireless_5g=radio0
	wireless_radio0_band=5g
	wireless_radio1_band=2g
fi

if [ "$GLINET_MODEL" = 'Beryl' ]; then
	# 内部構成
	glinet_has_switch=0
	glinet_ethernet_wan_name=wan
	glinet_ethernet_lan1_name=lan2
	glinet_ethernet_lan2_name=lan1
	glinet_interface_admin=br-vlantap.1
	glinet_interface_lan=br-vlantap.2
	glinet_button_side_gpio_regexp="|switch.*(hi|lo)"
	glinet_button_side_gpio_left=lo
	glinet_button_side_gpio_right=hi

	# SSID最大数
	wifi_ssid_max=16

	# 無線周波数帯
	wireless_24g=radio0
	wireless_5g=radio1
	wireless_radio0_band=2g
	wireless_radio1_band=5g
fi


if [ "$GLINET_MODEL" = 'Convex' ]; then

	if [ "$GLINET_FIRMWARE" = 'Vanilla' ]; then
		# 内部構成
		glinet_has_switch=0
		glinet_ethernet_wan_name=wan
		glinet_ethernet_lan1_name=lan1
		glinet_ethernet_lan2_name=lan2
		glinet_interface_admin=br-vlantap.1
		glinet_interface_lan=br-vlantap.2

		# SSID最大数
		wifi_ssid_max=16

		# 無線周波数帯
		wireless_24g=radio0
		wireless_5g=radio1
		wireless_radio0_band=2g
		wireless_radio1_band=5g
	fi

	# if [ "$GLINET_FIRMWARE" = 'Stock' ]; then
	#     # 未対応
	# fi

fi

if [ "$GLINET_MODEL" = 'SlateAX' ]; then
	# 内部構成
	glinet_has_switch=0
	glinet_ethernet_wan_name=eth0
	glinet_ethernet_lan1_name=eth1
	glinet_ethernet_lan2_name=eth2
	glinet_interface_admin=br-vlantap.1
	glinet_interface_lan=br-vlantap.2

	# SSID最大数
	wifi_ssid_max=16

	# 無線周波数帯
	wireless_24g=radio1
	wireless_5g=radio0
	wireless_radio0_band=5g
	wireless_radio1_band=2g
fi

if [ "$GLINET_MODEL" = 'AC1304' ]; then
	# 内部構成
	glinet_has_switch=0
	glinet_ethernet_wan_name=wan
	glinet_ethernet_lan1_name=lan
	glinet_interface_admin=br-vlantap.1
	glinet_interface_lan=br-vlantap.2

	# SSID最大数
	wifi_ssid_max=16

	# 無線周波数帯
	wireless_24g=radio0
	wireless_5g=radio1
	wireless_radio0_band=2g
	wireless_radio1_band=5g
fi

if [ "$GLINET_MODEL" = 'ERX' ]; then
	# 内部構成
	glinet_has_switch=0
	glinet_ethernet_wan_name=eth0
	glinet_ethernet_lan1_name=eth1
	glinet_ethernet_lan2_name=eth2
	glinet_ethernet_lan3_name=eth3
	glinet_ethernet_lan4_name=eth4
	glinet_interface_admin=br-vlantap.1
	glinet_interface_lan=br-vlantap.2
fi

# スペース区切りの文字列を分割し、複数行で処理するためのサブルーチン
function printf_multi() {
	array=($2)
	for S in "${array[@]}"; do
		printf "$1\n" $S
	done
}

# GL.iNET API呼び出し
function glinet_api() {
	if [ "$GLINET_FIRMWARE" != 'Stock' ]; then
		return
	fi

	# 呼び出すAPIごとのパラメタ設定
	# rootパスワード
	if [ "$1" = 'system' ] || [ "$2" = 'set_password' ]; then
		param_detail=$(cat <<- EOT
			"username": "$3",
			"old_password": "$4",
			"new_password": "$5"
		EOT
		)
	fi

	# GoodCloudログイン
	if [ "$1" = 'cloud' ] || [ "$2" = 'set_config' ]; then
		param_detail=$(cat <<- EOT
			"cloud_enable": true,
			"rtty_ssh": true,
			"rtty_web": true,
			"clear_token": true,
			"serverzone": "$3"
		EOT
		)
	fi
	# API共通パラメタ
	json=$(cat <<- EOT
	'{
		"jsonrpc":"2.0",
		"method":"call",
		"params":[
			"",
			"$1",
			"$2",
			{$param_detail}
		],
		"id":1
	}'
	EOT
	)

	# curlコマンド生成
	param="curl"
	param+=" -H 'glinet: 1'"
	param+=" -s"
	param+=" -k http://127.0.0.1/rpc"
	param+=" -d "
	param+=$json

	echo $param
}
