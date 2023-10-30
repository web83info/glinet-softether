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

# 04.スイッチ
source ./04_switch.sh

# 05.ブリッジ
source ./05_bridge.sh

# 06.VLAN
source ./06_vlan.sh

# 07.インターフェース
source ./07_interface.sh

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

# 20.最終処理
source ./20_final.sh

exit
