#coding:utf8
'''
Created on 2010-4-15

    zhaoxionghui
'''

from DataLoader import loader

class Effect:
    def __init__(self, **argv):
        self._id = 0
        self.info = None
        self._attacker = argv['attacker']
        self._defender = argv['defender']
        if argv.has_key('id'):
            self._id = int(argv['id'])
        else:
            level = argv['level']
            group = argv['groupID']
            self.init(level, group)
        if self._id != 0:
            self.init()

    def getAttacker(self):
        return self._attacker

    def getDefender(self):
        return self._defender

    def init(self, level = None, group = None):
        info = None
        if level is not None and group is not None:
            info = loader.getDataByMultiOption('effect', ['level', 'effectGroupId'], [level, group], '*')
            self._id = info['id']
        else:
            info = loader.getById("effect", self._id, '*')
        if info:
            self.info = info

    def getID(self): #获取效果ID
        return self._id

    def setID(self, id):
        self._id = id
        self.init()

    def getGroupID(self): #获取效果组ID
        if self.info is None:
            return None
        return self.info['effectGroupId']

    def getName(self): #获取效果名称描述
        if self.info:
            return self.info['name']

    def getLevel(self): #获取效果等级信息
        if self.info:
            return self.info['level']

    def getIcon(self):
        #状态显示ICON: '-1:没有ICON显示
        if self.info:
            return self.info['icon']

    def getDisPlayMode(self):
        #进入状态列表方式:1,不进入状态列表 ;2,进入显形状态列表;3,进入隐形状态列表;
        if self.info:
            return self.info['disPlayMode']

    def getLoseType(self):
        #失去方式:
            #1:时间限制
            #2:切换武器
            #4:使用技能
            #8:移动
            #16:死亡失去
            #32:离线失去;
            #64:回合失去
        if self.info:
            return self.info['loseType']

    def getType(self):
        #1:时效效果
        #2:永久效果
        #3:增益效果
        #4:减益效果
        if self.info:
            return self.info['type']

    def getIsInBattle(self):
        if self.info:
            return self.info['isInBattle']

    def getiRespondType(self):
        if self.info:
            return self.info['respondType']

    def getiBoutDuration(self):
        if self.info:
            return self.info['boutDuration']

    def getitimetype(self):
        if self.info:
            return self.info['timeType']

    def getiAidertime(self):
        if self.info:
            return self.info['aidertime']

    def getiTimeDuration(self):
        if self.info:
            return self.info['timeDuration']

    def getsScript(self):
        if self.info:
            return self.info['script']

    def getsDescription(self):
        if self.info:
            return self.info['description']

    def getsOwnerGetFx(self):#效果获得时自身特效
        if self.info:
            return self.info['ownerGetFx']

    def getsOwnerGetFxDelay(self):#效果播放时刻延迟
        if self.info:
            return self.info['ownerGetFxDelay']

    def getsOwnerRunFx (self):#效果执行时自身播放的特效
        if self.info:
            return self.info['ownerRunFx']

    def getsOwnerRunFxDelay(self): #延迟
        if self.info:
            return self.info['ownerRunFxDelay']

    def getsOwnerLoseFxDelay(self):
        if self.info:
            return self.info['ownerLoseFxDelay']

    def getsOwnerLoseFx(self):
        if self.info:
            return self.info['ownerLoseFx']

    def getsOpponentGetFx(self):
        if self.info:
            return self.info['opponentGetFx']

    def getsOpponentGetFxDelay(self):
        if self.info:
            return self.info['opponentGetFxDelay']

    def getsOpponentRunFx(self):
        if self.info:
            return self.info['opponentRunFx']

    def getsOpponentRunFxDelay(self):
        if self.info:
            return self.info['opponentRunFxDelay']

    def getsOpponentLoseFx(self):
        if self.info:
            return self.info['opponentLoseFx']

    def getsOpponentLoseFxDelay(self):
        if self.info:
            return self.info['opponentLoseFxDelay']

    def getsFullGetFx(self):
        if self.info:
            return self.info['fullGetFx']

    def getsFullGetFxDelay(self): #全屏的
        if self.info:
            return self.info['fullGetFxDelay']

    def getsFullRunFx(self):
        if self.info:
            return self.info['fullRunFx']

    def getsFullRunFxDelay(self):
        if self.info:
            return self.info['fullRunFxDelay']

    def getsFullLoseFx(self):
        if self.info:
            return self.info['fullLoseFx']

    def getsFullLoseFxDelay(self):
        if self.info:
            return self.info['fullLoseFxDelay']

class Skill:

    __Probability_Constant = 100000.0

    def __init__(self, id = 0):
        self._id = id
        self.info = None
        self.rate = None
        self.effectList = []
        self.init()

    def init(self):
        skillinfo = loader.getById('skill', self._id, '*')
        if skillinfo is None:
            self.info = skillinfo

    def setID(self, id):
        self._id = id
        self.init()

    def getLevelRequire(self): #修炼等级要求
        if self.info is None:
            return None
        return self.info['levelRequire']

    def getProfessionStageRequire(self): #修炼职业阶段要求
        if self.info is None:
            return None
        return self.info['professionStageRequire']

    def getID(self):
        return self._id

    def getSkillProfession(self): #技能所属职业
        if self.info is None:
            return None
        return self.info['skillProfession']

    def getName(self): #技能名称
        if self.info is None:
            return None
        return self.info['name']

    def getIcon(self): #技能图片信息
        if self.info is None:
            return None
        return self.info['icon']

    def getDescription(self): #技能描述
        if self.info is None:
            return None
        return self.info['description']

    def getWeaponRequire(self): #技能施展时的武器需求
        if self.info is None:
            return None
        return self.info['weapon'] #1，重型武器；2，中型武器；4，轻型武器；

    def getCoinRequiredForLearning(self):#学习技能所需金钱数量
        if self.info is None:
            return None
        return self.info['useCoin']

    def getSkillMaxLevel(self): #技能等级增幅上限
        if self.info is None:
            return None
        return self.info['maxLevel']

    def getSkillType(self): #技能类型信息
        if self.info is None:
            return None
        return self.info['type'] #1, 主动技能；2，（主动）辅助技能；3，被动技能

    def getLevel(self): #技能等级信息
        if self.info is None:
            return None
        return self.info['level']

    def getConsumeMpValue(self): #技能施展时的MP消耗
        if self.info is None:
            return None
        return self.info['useMp']

    def _getSkillProbabilityOfOccurrence(self): #技能发动概率
        if self.info is None:
            return None
        return self.info['useRate'] / self.__Probability_Constant

    def _getSkillEffectProbabilityOfOccurrence(self): #技能效果发动概率
        if self.info is None:
            return None
        __last = 0
        f = lambda x: 0 <= x <= 1 and x or (x > 1 and 1 or 0)
        __rateList = [f(int(i) / self.__Probability_Constant) for i in self.info['addEffectRate'].split(';')]
#        rateList = []
#        for i in __rateList:
#            __cp = 1 - __last
#            __p = __cp * i
#            rateList.append(__p)
#            __last += __p

        return __rateList

    def getSkillGroup(self):
        if self.info is None:
            return None
        return self.info['groupType']

    def _getEffects(self):
        if self.info is None:
            return None
        return self.info['addEffect']

    def _getSkillEffect(self): #技能释放成功后所能获得的具体效果
        return

    def __removeEffect(self):
        #removeEffect unicode:-1
        pass

    def __removeEffectRate(self):
        #removeEffectRate unicode: 0
        pass
#iId    
#iSkillProfession    
#sName    
#sIcon    
#sDescription    
#iWeapon    
#iMaxLevel    
#iLevel    
#iType    
#iUseMp    
#iUseRate    
#iLevelRequire    
#iUseCoin    
#iProfessionStageRequire    
#sAddEffect    
#sAddEffectRate    
#sRemoveEffect    
#sRemoveEffectRate    
#iGroupType
