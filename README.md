# glinet-softether
Use SoftEther on Gl.inet router

# コーディングルール

* 1行出力
```
echo
```

* 2行以上出力（変数展開あり）

```
cat <<- EOT
EOT
```

* 2行以上出力（変数展開なし）

```
cat <<- 'EOT'
EOT
```

* 変数がTRUEなら

```
if [ "$hoge" != 0 ]; then
	# Do something
fi
```

* 変数がFALSEなら

```
if [ "$hoge" = 0 ]; then
	# Do something
fi
```

