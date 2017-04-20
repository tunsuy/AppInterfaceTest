# AppInterfaceTest

该项目是对app的接口的相关测试

方案：  
在app端进行hook得到所有接口信息，通过pb协议和tcp通讯发送给服务端保存至数据库  
web端请求服务端，获取接口情况并展示

注：其他功能可以根据需要进行相关的增加，有了这些基础，那就很容易了

其中：  
1、服务端：使用go语言实现
* 主要是储存app接口的相关信息

2、app端：主要是基于AOP的思想，对app项目进行hook，得到所有的接口调用情况

3、web端：展示app接口信息，后面可以扩展到其他功能

服务端与app端协议：
* 交互协议：protobuf
* 通讯方式：tcp
