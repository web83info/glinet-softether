# 10.最終処理

echo '# 10.最終処理'

if [ "$GLINET_FIRMWARE" = 'Stock' ]; then
	cat <<- EOT
	# GL.iNET管理画面に戻るリンクを追加
	cat > /usr/lib/lua/luci/controller/glinet.lua << EOF
	module("luci.controller.glinet", package.seeall)
	function index()
		entry({"admin","system","glinet"},template("glinet"),_("GL.iNET"),80).leaf=true
	end
	EOF

	cat > /usr/lib/lua/luci/view/glinet.htm << EOF
	<%+header%>
	<div class="view">
		<h2 name="content"><%=translate("GL.iNET")%></h2>
		<p>Return to GL.iNET admin page.</p>
		<hr>
		<button id="jump_glinet" class="cbi-button cbi-button-action important">GL.iNET Admin Page</button>
	</div>
	<script type="text/javascript">
		document.getElementById("jump_glinet").onclick = function(){
			open( window.location.protocol + '//' + window.location.hostname + '/?', '_blank' ) ;
		};
	</script>
	<%+footer%>
	EOF

	EOT
fi

cat <<- EOT
# コミット＆再起動
uci commit
reboot

EOT
