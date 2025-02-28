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
	EOT

	if [ -n "$WIRELESS_2G_CHANNEL" ]; then
		echo "uci set wireless.${radio_2g}.channel='$WIRELESS_2G_CHANNEL'"
	fi

	if [ -n "$WIRELESS_2G_CHANNELS" ]; then
		echo "uci set wireless.${radio_2g}.channels='$WIRELESS_2G_CHANNELS'"
	fi

	if [ -n "$WIRELESS_2G_COUNTRY" ]; then
		echo "uci set wireless.${radio_2g}.country='$WIRELESS_2G_COUNTRY'"
	fi

	if [ -n "$WIRELESS_2G_HTMODE" ]; then
		echo "uci set wireless.${radio_2g}.htmode='$WIRELESS_2G_HTMODE'"
	fi

	cat <<- EOT
	uci set wireless.${radio_2g}.cell_density='3'

	EOT

fi

if [ -n "$WIRELESS_5G1_ENABLE" ] && [ "$WIRELESS_5G1_ENABLE" != 0 ]; then
	# 5GHz(1) 基本設定
	radio_5g1_name=wireless_${wireless_5g1_name}_name
	radio_5g1=${!radio_5g1_name}
	cat <<- EOT
	# 5GHz(1) 基本設定
	uci del wireless.default_${radio_5g1}
	uci del wireless.${radio_5g1}.disabled
	uci set wireless.${radio_5g1}.band=5g
	EOT

	if [ -n "$WIRELESS_5G1_CHANNEL" ]; then
		echo "uci set wireless.${radio_5g1}.channel='$WIRELESS_5G1_CHANNEL'"
	fi

	if [ -n "$WIRELESS_5G1_CHANNELS" ]; then
		echo "uci set wireless.${radio_5g1}.channels='$WIRELESS_5G1_CHANNELS'"
	fi

	if [ -n "$WIRELESS_5G1_COUNTRY" ]; then
		echo "uci set wireless.${radio_5g1}.country='$WIRELESS_5G1_COUNTRY'"
	fi

	if [ -n "$WIRELESS_5G1_HTMODE" ]; then
		echo "uci set wireless.${radio_5g1}.htmode='$WIRELESS_5G1_HTMODE'"
	fi

	cat <<- EOT
	uci set wireless.${radio_5g1}.cell_density='3'

	EOT

fi

if [ -n "$WIRELESS_5G2_ENABLE" ] && [ "$WIRELESS_5G2_ENABLE" != 0 ]; then
	# 5GHz(2) 基本設定
	radio_5g2_name=wireless_${wireless_5g2_name}_name
	radio_5g2=${!radio_5g2_name}
	cat <<- EOT
	# 5GHz(1) 基本設定
	uci del wireless.default_${radio_5g2}
	uci del wireless.${radio_5g2}.disabled
	uci set wireless.${radio_5g2}.band=5g
	EOT

	if [ -n "$WIRELESS_5G2_CHANNEL" ]; then
		echo "uci set wireless.${radio_5g2}.channel='$WIRELESS_5G2_CHANNEL'"
	fi

	if [ -n "$WIRELESS_5G2_CHANNELS" ]; then
		echo "uci set wireless.${radio_5g2}.channels='$WIRELESS_5G2_CHANNELS'"
	fi

	if [ -n "$WIRELESS_5G2_COUNTRY" ]; then
		echo "uci set wireless.${radio_5g2}.country='$WIRELESS_5G2_COUNTRY'"
	fi

	if [ -n "$WIRELESS_5G2_HTMODE" ]; then
		echo "uci set wireless.${radio_5g2}.htmode='$WIRELESS_5G2_HTMODE'"
	fi

	cat <<- EOT
	uci set wireless.${radio_5g2}.cell_density='3'

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
	if [ "${!wireless_wifin_radio}" = 5G1 ]; then
		wireless_wifin_radio=${radio_5g1}
	fi
	if [ "${!wireless_wifin_radio}" = 5G2 ]; then
		wireless_wifin_radio=${radio_5g2}
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

echo
