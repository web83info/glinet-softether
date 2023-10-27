module("luci.controller.glinet", package.seeall)
function index()
	entry({"admin","system","glinet"},template("glinet"),_("GL.iNET"),80).leaf=true
end
