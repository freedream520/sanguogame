#coding:utf8
'''
Created on 2009-12-3

@author: wudepeng
'''

class Quest(object):
    '''
    quest object
    '''


    def __init__(self):
        '''
        Constructor
        '''
        self.id = 0
        self.name = u"" #任务名称
        self.type = 1 #任务类型： 1:主线任务 2:赏金任务 3:支线任务 4:转职任务5:副本任务
        self.goalType = u"" #目标类型描述 
        self.parentId = u"" #前置任务
        self.provider = 0 #接受人ID:  npcid   = 0
        self.providerDialog = u"" #提供者的对话 
        self.providerHint = u"" #提供者的提示 
        self.accepter = 0; #交付人ID = 0
        self.accepterDialog = u"" #交付人的对话 
        self.description = u"" #任务描述
        self.isSpecial = False #是否是特殊任务
        self.specialNpc = 0 #特殊任务npc
        self.expBonus = 0 #经验奖励
        self.coinBonues = 0 #铜币奖励
        self.dropItemId = 0 #掉落物品
        self.levelRequire = 0 #级别要求
        self.campRequire = 0 #阵营要求
        self.positionRequire = 0 #职位要求
        self.professionRequire = 0 #职业要求
        self.stageRequire = 0 #职业阶段要求
        
        