
2. 系统需求

	2.1 服务器环境，需要支持python
	2.2 数据库为mysql
	
3. 安装
	3.1 服务端配置文件melee.ini

[Game]                                           
DataDir = .\data

[web]                                    
web_host = 该地方填写游戏运营的对外网站域名或者IP地址
web_port = 该地方填写端口号
web_rootDir = 修改rootDir文件夹所在地址，例如：E:\melee\code\client\bin-debug
web_imagesDir = 修改imagesDir文件夹所在地址，例如：E:\melee\code\images
web_dataDir = 修改dataDir文件夹所在地址，例如：E:\melee\code\images\data
;web_rootPage = 默认游戏启动的页面文件名，例如：melee.html

[database]
db_host = 数据库IP地址
db_port = 数据库端口号
db_name = 数据库名称
db_user = 数据库对应的用户名
db_password = 数据库该用户名对应的密码

[log]
log_main= 应用程序错误日志保存的地址       例如：./mainErrors.log
log_secondary= 网络模块错误日志保存地址    例如：./secondaryErrors.log

	3.2客户端配置文件的修改melee.xml
在与客户端swf文件同级文件夹中，有一个melee.xml的文件，该文件用来配置客户端的IP访问地址、访问端口以及访问的服务名称。文件结构内容如下:
<config>
	<IPAddr>192.168.1.19</IPAddr>
	<Port>11008</Port>
	<Service>services</Service>
</config>

IPAddr的标签用来标示IP地址
Port用来标示端口号
Service用来标示服务名称
	
	3.2 Linux

4. 新增功能
	
	4.1 已经完成模块如下：
	世界观（三国的世界观）
	登陆游戏
	角色成长:经验升级,加点,攻击/暴击/破防/闪避的属性成长
	职业(6个职业:勇士/卫士/武士/侠士/谋士/术士)
	NPC&怪物
	地图:世界地图,城市地图,区域地图
	设施:赏金组织,宿屋,商店,议事中心,
	战斗:普通战斗,技能,掉落
	状态
	装备,道具
	好友
	邮件
	聊天
	任务
	死亡/复活
	挂机:修炼,修行
	仓库
	副本
	铸造:升级
	
5. 已知问题
	
	5.1暂无

	
