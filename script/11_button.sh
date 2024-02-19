# 11.ボタン

function button_wifi_on_off() {
	script_rc_local=$(<include/_etc_rc.local)
	script_rc_local=${script_rc_local//GLINET_BUTTON_SIDE_GPIO_REGEXP/${glinet_button_side_gpio_regexp}}
	script_rc_local=${script_rc_local//GLINET_BUTTON_SIDE_GPIO_LEFT/${glinet_button_side_gpio_left}}
	script_rc_local=${script_rc_local//GLINET_BUTTON_SIDE_GPIO_RIGHT/${glinet_button_side_gpio_right}}

	script_profile=$(<include/_etc_profile)
	script_profile=${script_profile//GLINET_BUTTON_SIDE_GPIO_REGEXP/${glinet_button_side_gpio_regexp}}
	script_profile=${script_profile//GLINET_BUTTON_SIDE_GPIO_LEFT/${glinet_button_side_gpio_left}}
	script_profile=${script_profile//GLINET_BUTTON_SIDE_GPIO_RIGHT/${glinet_button_side_gpio_right}}

	cat <<- EOT
	# ボタンの位置に応じてWifiのオンオフを切り替える
	sed -i 's/exit 0//g' /etc/rc.local
	cat > /etc/rc.local << 'EOF'
	$script_rc_local
	EOF

	chmod +x /etc/rc.local

	EOT

	cat <<- EOT
	# ボタンのスライドに応じてWifiのオンオフを切り替える
	cat > /etc/gl-switch.d/wifi.sh << 'EOF'
	$(<include/_etc_gl-switch.d_wifi.sh)
	EOF

	chmod +x /etc/gl-switch.d/wifi.sh

	EOT

	cat <<- EOT
	# ボタンスライドでWifi切り替え
	uci set switch-button.@main[0].func="wifi"

	EOT

	cat <<- EOT
	# シェルログイン時にWifiの状況を通知
	cat >> /etc/profile << 'EOF'
	$script_profile
	EOF

	EOT

}

echo '# 11.ボタン'

if [ "$GLINET_MODEL" = 'Shadow' ] && [ "$GLINET_FIRMWARE" = 'Stock' ]; then
	button_wifi_on_off
fi

if [ "$GLINET_MODEL" = 'Slate' ] && [ "$GLINET_FIRMWARE" = 'Stock' ]; then
	button_wifi_on_off
fi

if [ "$GLINET_MODEL" = 'Beryl' ] && [ "$GLINET_FIRMWARE" = 'Stock' ]; then
	button_wifi_on_off
fi
