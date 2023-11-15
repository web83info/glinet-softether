# 12.GoodCloud

echo '# 12.GoodCloud'

if [ "$GOODCLOUD_ENABLE" = 1 ]; then
	glinet_api "cloud" "set_config" "Asia Pacific"
fi

echo
