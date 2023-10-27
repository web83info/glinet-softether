# 10.最終処理

echo '# 10.最終処理'

# GL.iNET管理画面に戻るリンクを追加
if [ "$GLINET_FIRMWARE" = 'Stock' ]; then
	cat <<- EOT
	# GL.iNET管理画面に戻るリンクを追加
	cat > /usr/lib/lua/luci/controller/glinet.lua << EOF
	$(<include/_usr_lib_lua_luci_controller_glinet.lua)
	EOF

	cat > /usr/lib/lua/luci/view/glinet.htm << EOF
	$(<include/_usr_lib_lua_luci_view_glinet.htm)
	EOF

	EOT
fi

cat <<- EOT
# コミット＆再起動
uci commit
reboot

EOT
