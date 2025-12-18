# CONFIG読み込み
config_file=.config
if [ -n "$1" ]; then
	config_file="$1"
fi
source $config_file

# 00.スクリプト生成用初期設定
source ./00_common.sh

# 01.システム初期設定
source ./01_system.sh

# 02.パッケージインストール・アップデート
source ./02_package.sh

# 03.SoftEther設定
source ./03_softether.sh

# 04.既存LAN・WAN
source ./04_lan_wan.sh

# 05.ブリッジ
source ./05_bridge.sh

# 06.インターフェース
source ./06_interface.sh

# 07.VLAN
source ./07_vlan.sh

# 08.DHCP
source ./08_dhcp.sh

# 09.WiFi
source ./09_wifi.sh

# 10.管理UI
source ./10_adminui.sh

# 11.ボタン
source ./11_button.sh

# 12.GoodCloud
source ./12_goodcloud.sh

# 13.SMTP
source ./13_smtp.sh

# 14.SSL
source ./14_ssl.sh

# 15.uhttpd
source ./15_uhttpd.sh

# 16.ttyd
source ./16_ttyd.sh

# 20.最終処理
source ./20_final.sh

exit
