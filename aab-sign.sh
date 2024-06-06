#!/bin/sh
echo "【AAB重签名脚本】\n* Version: 1.0 \n* Auth: Ruilin"
echo ""
printf "输入文件名:"
read -e fileName
# 检查文件是否存在
if [ ! -f "$fileName" ]; then
    echo "文件 '$fileName' 不存在."
    exit 1
fi

printf "输入配置文件名(默认./config.txt):"
# 指定配置文件路径
config_file="./config.txt"
read -e config_file
# 检查文件是否存在
if [ ! -f "$config_file" ]; then
    echo "文件 '$config_file' 不存在."
    exit 1
fi

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

echo "config: $ksFile; $ksAlias; $ksPassword"

source ~/.bash_profile
echo "删除旧签名 ==============>"
zip -d $fileName META-INF/\*
echo "重新签名 ==============>"
jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 -keystore $ksFile $fileName $ksAlias<<EOF
$ksPassword
$ksPassword
EOF
# 检查命令执行是否成功
if [ $? -eq 0 ]; then
    echo "签名完成！"
else
    echo "签名失败！"
    exit 1
fi

echo "4k对齐 ==============>"
outputFile="${fileName%.*}-4k.aab"
rm $outputFile
zipalign -v 4 $fileName $outputFile

# 检查命令执行是否成功
if [ $? -eq 0 ]; then
    echo "输出文件：$outputFile"
    echo "完成！！！"
else
    echo "执行失败！！"
    exit 1
fi
