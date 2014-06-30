#coding:utf8
'''
Created on 2009-12-4

@author: wudepeng
'''

class Effect(object):
    '''
    effect object
    '''


    def __init__(self):
        '''
        Constructor
        '''
        self.id = 0
        self.effectGroupId = 0 #效果的分类id
        self.level = 1 #等级:提供调用接口编号，用于被其他功能调用.控制所调用状态的等级.
        self.name = u"" #效果名称
        self.displayMode = 1 #进入状态列表方式:1:不进入状态列表2:进入显形状态列表3:进入隐形状态列表
        self.icon = '-1' #状态显示ICON:'-1:没有ICON显示
        self.loseType =0 #失去方式:1:时间限制2:切换武器4:使用技能8:移动16:死亡失去32:离线失去;64:回合失去
        self.type =  1#1:时效效果2:永久效果3:增益效果4:减益效果
        self.isInBattle = 1 #是否用在战斗中
        self.respondType = 1 #效果响应方式：1:从攻击回合开始时响应2:从攻击回合结束时响应3:从收到攻击前响应4:从收到攻击后响应5:从当前秒开始前响应6:从当前秒结束后响应7:从战斗结束领取奖励时响应
        self.islooprespond = 0 #是否循环响应
        self.boutduration = 0 #持续回合
        self.timeType = 0 #状态计时类型:1:真实计2:游戏在线计时3:游戏离线计时4:战斗时间
        self.timeDuration = 0 #持续时间:'-1:代表状态是永久性存在的.(显示表现为[N/A])0~999999999:填写持续的时间(毫秒)注:即使效果没有持续时间
        self.script = u"" #执行脚本
        self.respondDesc = u"" #效果响应时的描述
        self.loseDesc = u"" #效果失去时的描述
        self.description = u"" #效果描述
