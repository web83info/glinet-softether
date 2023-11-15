# 09.WiFi

echo '# 09.Wifi'

if [ -n "$WIRELESS_2G_ENABLE" ] && [ "$WIRELESS_2G_ENABLE" != 0 ]; then
	# 2.4GHz基本設定
	radio_2g_name=wireless_${wireless_2g_name}_name
	radio_2g=${!radio_2g_name}
	cat <<- EOT
	# 2.4GHz基本設定
	uci del wireless.default_${radio_2g}
	uci del wireless.${radio_2g}.disabled
	uci set wireless.${radio_2g}.band=2g
	uci set wireless.${radio_2g}.channel='$WIRELESS_2G_CHANNEL'
	uci set wireless.${radio_2g}.channels='$WIRELESS_2G_CHANNELS'
	uci set wireless.${radio_2g}.country='$WIRELESS_2G_COUNTRY'
	uci set wireless.${radio_2g}.cell_density='3'

	EOT
fi

if [ -n "$WIRELESS_5G_ENABLE" ] && [ "$WIRELESS_5G_ENABLE" != 0 ]; then
	# 5GHz基本設定
	radio_5g_name=wireless_${wireless_5g_name}_name
	radio_5g=${!radio_5g_name}
	cat <<- EOT
	# 5GHz基本設定
	uci del wireless.default_${radio_5g}
	uci del wireless.${radio_5g}.disabled
	uci set wireless.${radio_5g}.band=5g
	uci set wireless.${radio_5g}.channel='$WIRELESS_5G_CHANNEL'
	uci set wireless.${radio_5g}.channels='$WIRELESS_5G_CHANNELS'
	uci set wireless.${radio_5g}.country='$WIRELESS_5G_COUNTRY'
	uci set wireless.${radio_5g}.cell_density='3'

	EOT
fi

# 各SSID
for i in $(seq 1 $wifi_ssid_max)
do
	wireless_wifin_name=WIRELESS_WIFI${i}_NAME
	wireless_wifin_radio=WIRELESS_WIFI${i}_RADIO
	if [ "${!wireless_wifin_radio}" = 2G ]; then
		wireless_wifin_radio=${radio_2g}
	fi
	if [ "${!wireless_wifin_radio}" = 5G ]; then
		wireless_wifin_radio=${radio_5g}
	fi
	wireless_wifin_ssid=WIRELESS_WIFI${i}_SSID
	wireless_wifin_encryption=WIRELESS_WIFI${i}_ENCRYPTION
	wireless_wifin_key=WIRELESS_WIFI${i}_KEY
	wireless_wifin_interface=WIRELESS_WIFI${i}_INTERFACE
	if [ -n "${!wireless_wifin_name}" ]; then
		cat <<- EOT
		uci set wireless.${!wireless_wifin_name}=wifi-iface
		uci set wireless.${!wireless_wifin_name}.device='${wireless_wifin_radio}'
		uci set wireless.${!wireless_wifin_name}.mode='ap'
		uci set wireless.${!wireless_wifin_name}.ssid='${!wireless_wifin_ssid}'
		uci set wireless.${!wireless_wifin_name}.encryption='${!wireless_wifin_encryption}'
		uci set wireless.${!wireless_wifin_name}.key='${!wireless_wifin_key}'
		uci set wireless.${!wireless_wifin_name}.network='${!wireless_wifin_interface}'

		EOT
	fi
done
