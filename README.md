## AAB文件重签名工具
在打包.aab文件发布GooglePlay时，GP默认会让你使用自动生成的签名，但对于需要加固的APP不是很方便，因此建议使用自己的签名来打包。
本工具实现自动对aab文件进行重签名，以及4k对齐。

### 使用方法
1. 编辑`confix.txt`，填入签名文件相关信息

    ```
    keystore:【文件相对路径】
    alias:【别名】
    password:【密码】
    ```
2. 执行`aab-sign.sh`脚本，即可输出重签名后的aab文件

## 生成GooglePlay签名
首次在GooglePlay上传自定义签名，GP会要求下载相关脚本，对自定义签名生成关联加密文件。
本工具提供生成脚本`gp-sign.sh`。

### 使用方法
1. 把从GP下载的`encryption_public_key.pem`、`pepk.jar`放入./googleplay文件夹
2. 执行```gp-sign.sh```生成output.zip
3. 把文件上传到GP
4. 接下来就可以把使用自定义签名的aab上传到GP了