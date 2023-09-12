# 09.WiFi

echo '# 09.Wifi'

# 機種別に周波数帯とradio{0,1}を対応させる
if [ "$GLINET_MODEL" = 'Slate' ]; then
	wireless_24g=radio1
	wireless_5g=radio0
fi

if [ "$GLINET_MODEL" = 'Mango' ]; then
	wireless_24g=radio0
fi

if [ "$GLINET_MODEL" = 'Shadow' ]; then
	wireless_24g=radio0
fi

# 5GHz基本設定
if [ -n "${wireless_5g}" ]; then
	if [ "$WIRELESS5_ENABLE" != 0 ]; then
		cat <<- EOT
		# 5GHzから標準のSSID（OpenWrt）を削除
		uci del wireless.default_${wireless_5g}

		# 5GHz基本設定
		uci del wireless.${wireless_5g}.disabled
		uci set wireless.${wireless_5g}.channel='$WIRELESS5_CHANNEL'
		uci set wireless.${wireless_5g}.channels='$WIRELESS5_CHANNELS'
		uci set wireless.${wireless_5g}.country='$WIRELESS5_COUNTRY'
		uci set wireless.${wireless_5g}.cell_density='3'

		EOT
	fi
fi

# 2.4GHz基本設定
if [ -n "${wireless_24g}" ]; then
	if [ "$WIRELESS24_ENABLE" != 0 ]; then
		cat <<- EOT
		# 2.4GHzから標準のSSID（OpenWrt）を削除
		uci del wireless.default_${wireless_24g}

		# 2.4GHz基本設定
		uci del wireless.${wireless_24g}.disabled
		uci set wireless.${wireless_24g}.channel='$WIRELESS24_CHANNEL'
		uci set wireless.${wireless_24g}.channels='$WIRELESS24_CHANNELS'
		uci set wireless.${wireless_24g}.country='$WIRELESS24_COUNTRY'
		uci set wireless.${wireless_24g}.cell_density='3'

		EOT
	fi
fi

for i in $(seq 1 $wifi_ssid_max)
do
	wireless_wifin_name=WIRELESS_WIFI${i}_NAME
	wireless_wifin_radio=WIRELESS_WIFI${i}_RADIO
	if [ "${!wireless_wifin_radio}" = 5 ]; then
		wireless_wifin_radio=$wireless_5g
	fi
	if [ "${!wireless_wifin_radio}" = 24 ]; then
		wireless_wifin_radio=$wireless_24g
	fi
	wireless_wifin_ssid=WIRELESS_WIFI${i}_SSID
	wireless_wifin_encryption=WIRELESS_WIFI${i}_ENCRYPTION
	wireless_wifin_key=WIRELESS_WIFI${i}_KEY
	wireless_wifin_interface=WIRELESS_WIFI${i}_INTERFACE
	if [ -n "${!wireless_wifin_name}" ]; then
		cat <<- EOT
		uci set wireless.wifinet${i}=wifi-iface
		uci set wireless.wifinet${i}.device='$wireless_wifin_radio'
		uci set wireless.wifinet${i}.mode='ap'
		uci set wireless.wifinet${i}.ssid='${!wireless_wifin_ssid}'
		uci set wireless.wifinet${i}.encryption='${!wireless_wifin_encryption}'
		uci set wireless.wifinet${i}.key='${!wireless_wifin_key}'
		uci set wireless.wifinet${i}.network='${!wireless_wifin_interface}'

		EOT
	fi
done
