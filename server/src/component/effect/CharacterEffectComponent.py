#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''
from net.MeleeSite import pushMessage
from component.Component import Component

from util import dbaccess, util
from util.DataLoader import loader

import datetime
from twisted.internet import reactor

reactor = reactor

class CharacterEffectComponent(Component):
    '''
    effect component for character
    '''


    def __init__(self, owner):
        '''
        Constructor
        '''
        Component.__init__(self, owner)
        #以下的效果列表存放effectf_instance记录，并且有效果的icon
        self._skillEffects = [] #玩家所学技能产生的显示效果列表
        self._currentEffects = [] #玩家当前身上作用的物品效果
        self._invisibleEffects = []#隐式的效果列表

    def getSkillEffects(self):
        self._skillEffects = self.restEffectsList(dbaccess.getCurrentSkillEffectInstances(self._owner.baseInfo.id))
        return self._skillEffects

    def setSkillEffects(self, effects):
        self._skillEffects = effects

    def getCurrentEffects(self):
        self._currentEffects = self.restEffectsList(dbaccess.getCurrentItemEffectInstances(self._owner.baseInfo.id))
        return self._currentEffects

    def setCurrentEffects(self, effects):
        self._currentEffects = effects

    def getInvisibleEffects(self):
        return self._invisibleEffects

    def setInvisibleEffects(self, effects):
        self._invisibleEffects = effects

    def getSkillEffectsInfo(self):
        '''得到格式化的技能效果'''
        self.getSkillEffects()
        return self.formatEffectInfo(self._skillEffects)

    def getItemEffectsInfo(self):
        '''得到格式化的物品效果'''
        self.getCurrentEffects()
        return self.formatEffectInfo(self._currentEffects)

    def formatEffectInfo(self, effects):
        '''格式化效果'''
        list = []
        for effectInstance in effects:
            info = loader.getById('effect', effectInstance[2], ['timeDuration', 'icon', 'name', 'description'])
            if info:
                info['createTime'] = effectInstance[5]
                info['triggerType'] = effectInstance[6]
                info['currentTime'] = datetime.datetime.now()
                times = info['currentTime'] - info['createTime']
                info['timeDuration']=info['timeDuration']- times.seconds * 1000
                list.append(info)
        return list

    def calcImmeEffectForPlayer(self, effect):
        '''计算瞬时效果对玩家属性的影响'''
        owner = {}
        owner['hp'] = self._owner.attribute.getHp()
        owner['mp'] = self._owner.attribute.getMp()
        try:
            exec(effect['script'])
        except:
            pass

        profession = self._owner.profession.getProfession()
        id = self._owner.baseInfo.id
        level = self._owner.level.getLevel()
        maxHp = self._owner.attribute.getMaxHp(profession, id, level)
        maxMp = self._owner.attribute.getMaxMp(profession, id, level)
        if owner['hp'] > maxHp:
            owner['hp'] = maxHp
        if owner['mp'] > maxMp:
            owner['mp'] = maxMp
        dbaccess.updatePlayerInfo(self._owner.baseInfo.id, {'hp':owner['hp'], 'mp':owner['mp']})
        self._owner.attribute.setHp(owner['hp'])
        self._owner.attribute.setMp(owner['mp'])
        return owner['hp'], owner['mp']

    def triggerEffect(self, effect, triggerType):
        '''
                    触发效果
        @param triggerType: 1.物品触发 2.技能触发       
        '''
        id = self._owner.baseInfo.id

        if not effect:
            return False, u'效果不存在'
        if effect['type'] == 2 or effect['type'] == 4:#持久效果，增益效果
            canTrig, result = self.canTriggerEffect(effect)
            if canTrig:
                startTime = str(datetime.datetime.now())
                if effect['disPlayMode'] == 2:#显性列表
                    effectCount = len(self._skillEffects)
                    if effectCount >= 4:
                        return False, u'你身上已经有过多的辅助技能效果'
                    self.triggerVisibleEffect(result, effect, triggerType, startTime)
                    return True, ''
                elif effect['disPlayMode'] == 3:#隐性列表
                    effectCount = len(self._invisibleEffects)
                    if effectCount >= 10:
                        return False, u'你身上已经有过多的隐性效果'
                    #self.triggerInvisibleEffect(result, effect, triggerType, startTime)
                    self._invisibleEffects.append(effect)
                    return True, ''
            else:
                return False, u'您身上已经有更高等级的效果，无须使用此物品'
        else:
            pass

    def canTriggerEffect(self, effect):
        '''判断是否可以执行此效果，当同一角色已经持用同一group的高level效果时，低等级的新效果不能使用'''
        id = self._owner.baseInfo.id
        result = dbaccess.getEffectInstance(id, effect['effectGroupId'])
        return len(result) == 0 or result[-1][4] < effect["level"], result

    def triggerVisibleEffect(self, result, effect, triggerType, startTime):
        '''触发显示效果'''
        id = self._owner.baseInfo.id

        if len(result) == 0:
            lastInsertRecord = dbaccess.insertEffectInstance([0, id, effect['id'], effect['effectGroupId'], effect['level'], startTime, triggerType])
            obj = list(util.objectCopy(lastInsertRecord))
            obj.append(effect['icon'])
            if triggerType == 1:#物品触发
                self._currentEffects.append(lastInsertRecord)
                if len(self._currentEffects) > 4:#维持效果数量为4个
                    dbaccess.deleteEffectInstanceById(self._currentEffects[0][0])
                    self._currentEffects.remove(self._currentEffects[0])
            elif triggerType == 2:#技能触发
                self._skillEffects.append(lastInsertRecord)
                if len(self._skillEffects) > 4:#维持效果数量为4个
                    dbaccess.deleteEffectInstanceById(self._skillEffects[0][0])
                    self._skillEffects.remove(self._skillEffects[0])
        else:
            dbaccess.updateEffectInstance(result[0][0], {'effectId' : effect["id"], 'effectLevel' : effect["level"], \
                                                         'startTime':startTime})
            lastUpdateRecord = (result[0][0], id, effect['id'], effect['effectGroupId'], effect['level'], startTime, triggerType)
            obj = list(util.objectCopy(lastUpdateRecord))
            obj.append(effect['icon'])
            if triggerType == 1:
                for itemEffect in self._currentEffects:
                    itemEffect = list(itemEffect)
                    if itemEffect[0] == lastUpdateRecord[0]:
                        itemEffect[0] = obj
                        break
            elif triggerType == 2:#技能触发
                for skillEffect in self._skillEffects:
                    skillEffect = list(skillEffect)
                    if skillEffect[0] == lastUpdateRecord[0]:
                        skillEffect[0] = obj
                        break

        self.addEffectLifeListener(effect)

    def triggerInvisibleEffect(self, result, effect, triggerType, startTime):
        '''触发隐式效果'''
        id = self._owner.baseInfo.id

        if len(result) == 0:
            lastInserRecord = dbaccess.insertEffectInstance([0, id, effect['id'], effect['effectGroupId'], effect['level'], startTime, triggerType])
            self._invisibleEffects.append(lastInserRecord)
        else:
            dbaccess.updateEffectInstance(result[0][0], {'effectId' : effect["id"], 'effectLevel' : effect["level"], 'startTime':startTime})
            lastUpdateRecord = (result[0][0], id, effect['id'], effect['effectGroupId'], effect['level'], startTime, triggerType)
            self._invisibleEffects.append(lastUpdateRecord)

    def addEffectLifeListener(self, effect):
        '''增加效果生命监听'''
        reactor.callLater(effect['timeDuration'], self.effectDie, effect['id'])

    def effectDie(self, effectId):
        '''效果生命周期结束'''
        dbaccess.deleteEffectInstance(self._owner.baseInfo.id, effectId)
        self.setEffectsList()
        pushMessage(str(self._owner.baseInfo.id), 'effectOver')

    def setEffectsList(self):
        '''设置效果列表'''
        newSkillStr = ''
        newAuxiliarySkills = []
        id = self._owner.baseInfo.id
        auxiliarySkills = self._owner.skill.getAuxiliarySkills()
        effectInstances = dbaccess.getAllEffectInstances(id)
        
        for i in range(0,len(auxiliarySkills)):
            result = loader.getById('skill', auxiliarySkills[i], '*')
            effectList = result['addEffect'].split(';')
            effectCounts = len(effectList)
            difference = len(effectList)
            for list in effectList:
                for instance in effectInstances:
                    effectInfo = loader.getById('effect', instance[2], ['icon', 'disPlayMode'])
                    icon = effectInfo['icon']
                    effectDisplayMode = effectInfo['disPlayMode']
        
                    instance.append(icon)
                    if instance[6] == 1:
                        self._currentEffects.append(instance)
                    elif instance[6] == 2:
                        if effectDisplayMode == 3:#进入隐形状态列表
                            self._invisibleEffects.append(instance)
                        elif effectDisplayMode == 2:
                            self._skillEffects.append(instance)
                    if list == instance[2]:
                        difference -= 1
            if difference != effectCounts:
                newAuxiliarySkills.append(auxiliarySkills[i])
                if newSkillStr == '':
                    newSkillStr += str(auxiliarySkills[i])
                else:
                    newSkillStr += ',' + str(auxiliarySkills[i])
                    
        self._owner.skill.setAuxiliarySkills(newAuxiliarySkills)
        
        dbaccess.updatePlayerInfo(id, {'auxiliarySkills':newSkillStr})
        
#===============================================================================
#        for instance in effectInstances:
#            effectInfo = loader.getById('effect', instance[2], ['icon', 'disPlayMode'])
#            icon = effectInfo['icon']
#            effectDisplayMode = effectInfo['disPlayMode']
# 
#            instance.append(icon)
#            if instance[6] == 1:
#                self._currentEffects.append(instance)
#            elif instance[6] == 2:
#                if effectDisplayMode == 3:#进入隐形状态列表
#                    self._invisibleEffects.append(instance)
#                elif effectDisplayMode == 2:
#                    self._skillEffects.append(instance)
##===============================================================================


    def restEffectsList(self,effects):
        '''重新计算效果生命周期'''
        newEffects = []
        for value in effects:
            effectInfo = loader.getById('effect', int(value[2]), ['timeDuration'])
            if effectInfo:
                times = datetime.datetime.now() - value[5]
                milliSeconds = times.days*24*60*60*1000+times.seconds*1000+times.microseconds/1000
                if milliSeconds > effectInfo['timeDuration']:
                    dbaccess.deleteEffectInstance(self._owner.baseInfo.id, value[2])
                    self.setEffectsList()
                else:
                    time = effectInfo['timeDuration'] - milliSeconds
                    reactor.callLater(time, self.effectDie, value[0])
                    newEffects.append(value)
        return newEffects
            




class currentEffect(object):
    '''
    current effect record
    '''
    def __init__(self):
        self._id = -1
        self._characterId = -1 #玩家id
        self._effectId = -1 #效果id
        self._startTime = u"" #效果作用开始时间
        self._triggerType = 0 #1: 道具触发2: 技能触发

    def getId(self):
        return self._id

    def setId(self, id):
        self._id = id

    def getCharacterId(self):
        return self._characterId

    def setCharacterId(self, characterId):
        self._characterId = characterId

    def getEffectId(self):
        return self._effectId

    def setEffectId(self, effectId):
        self._effectId = effectId

    def getStartTime(self):
        return self._startTime

    def setStartTime(self, time):
        self._startTime = time

    def getTriggerType(self):
        return self._triggerType

    def setTriggerType(self, type):
        self._triggerType = type





