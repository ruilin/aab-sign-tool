#!/bin/sh
echo "【生成GooglePlay签名密钥脚本】\n* Version: 1.0 \n* Auth: Ruilin"
# 指定配置文件路径
config_file="./config.txt"

# 检查配置文件是否存在
if [ ! -f "$config_file" ]; then
    echo "Error: Config file not found: $config_file"
    exit 1
fi

ksFile=""
ksAlias=""
ksPassword=""

# 读取配置文件内容
while IFS=':' read -r key value || [[ -n "$key" ]]; do
    # 忽略空行和以#开头的注释行
    if [[ ! "$key" =~ ^[[:space:]]*$ && ! "$key" =~ ^# ]]; then
        # 移除首尾空格
        key=$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        value=$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        # 输出配置项
        echo "$key: $value"
        if [ "$key" = "keystore" ]; then
          ksFile=$value
        elif [ "$key" = "alias" ]; then
          ksAlias=$value
        elif [ "$key" = "password" ]; then
          ksPassword=$value
        fi
    fi
done < "$config_file"

# echo "config: $ksFile; $ksAlias; $ksPassword"

echo "请手动输入密码"

/Users/apple/Downloads/jdk-21.0.2.jdk/Contents/Home/bin/java -jar ./googleplay/pepk.jar --keystore="$ksFile" --alias="$ksAlias" --output=output.zip --include-cert --rsa-aes-encryption --encryption-key-path=./googleplay/encryption_public_key.pem

echo "完成！"