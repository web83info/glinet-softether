# 11.ボタン

echo '# 11.ボタン'

if [ "$GLINET_MODEL" = 'Slate' ] && [ "$GLINET_FIRMWARE" = 'Stock' ]; then
	cat <<- EOT
	# ボタンの位置に応じてWifiのオンオフを切り替える
	sed -i 's/exit 0//g' /etc/rc.local
	cat > /etc/rc.local << 'EOF'
	$(<include/_etc_rc.local)
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
fi
