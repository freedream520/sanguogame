#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''
from component.Component import Component

from util import dbaccess
from util.DataLoader import loader

import random

class CharacterSkillComponent(Component):
    '''
    skill component for character
    '''


    def __init__(self, owner, activeSkill = 0, auxiliarySkills = [], passiveSkills = []):
        '''
        Constructor
        '''
        Component.__init__(self, owner)
        self._activeSkill = activeSkill #主动技能
        self._auxiliarySkills = auxiliarySkills #辅助技能组
        self._passiveSkills = passiveSkills #被动技能组

    def getActiveSkill(self):
        return self._activeSkill

    def setActiveSkill(self, activeSkill):
        self._activeSkill = activeSkill

    def getAuxiliarySkills(self):
        return self._auxiliarySkills

    def setAuxiliarySkills(self, skills):
        self._auxiliarySkills = skills

    def getPassiveSkills(self):
        return self._passiveSkills

    def setPassiveSkills(self, skills):
        self._passiveSkills = skills

    def getActiveSkillInfo(self):
        '''获取玩家装备的主动技能信息'''
        skillInfo = loader.getById('skill', self._activeSkill, ['name', 'icon', 'level'])
        return skillInfo

    def getLearnedSkills(self):
        '''获取玩家已修炼的技能信息'''
        self.learned_skillpool = {}          #所学技能分组

        learnedSkillsInfo = []
        learnedSkills = dbaccess.getLearnedSkills(self._owner.baseInfo.id)
        num = 0
        if learnedSkills is None:
            return learnedSkillsInfo
        for elm in learnedSkills:
            skillId = elm[2]
            skillLevel = elm[3]
            skillInfo = loader.getById('skill', skillId, '*')
            skillInfo['addEffectNames'] = []
            effects = []
            for effect in skillInfo['addEffect'].split(';'):
                if int(effect) <> -1:
                    effectInfo = loader.getById('effect', int(effect), ['name', 'description'])
                    effects.append(effectInfo['description'])
                    skillInfo['addEffectNames'].append(effectInfo['name'])
            learnedSkillsInfo.append({'skillInfo':skillInfo, 'skillLevel':skillLevel, 'effects':effects})
            num += 1
            self.learned_skillpool[ learnedSkillsInfo[-1]['skillInfo']["groupType"] ] = learnedSkillsInfo[-1]
        return learnedSkillsInfo

    def getLearnableSkills(self):
        '''获取玩家可学技能信息'''
        learnableSkillsInfo = []

        profession = self._owner.profession.getProfession()
        skills = loader.get('skill', 'skillProfession', profession, '*')
        for skill in skills:
            skill['addEffectNames'] = []
            effects = []
            canLearn = self.checkLearnSkillRequire(skill, False)[0]
            if canLearn:
                group = skill["groupType"]
                learened = group in self.learned_skillpool;
                canLearn = (not learened and skill["level"] == 1) or \
                           (learened and skill["level"] == self.learned_skillpool[group]["skillLevel"] + 1)
                if canLearn:
                    for effectId in skill['addEffect'].split(';'):
                        if int(effectId) <> -1:
                            effectInfo = loader.getById('effect', int(effectId), ['name', 'description'])
                            effects.append(effectInfo['description'])
                            skill['addEffectNames'].append(effectInfo['name'])
                    learnableSkillsInfo.append({'skillInfo':skill, 'skillLevel':skill['level'], 'effects':effects})

        return learnableSkillsInfo

    def getProfessionAllSkills(self):
        '''获取玩家当前职业的所有技能'''
        allSkills = []
        profession = self._owner.profession.getProfession()

        skills = loader.get('skill', 'skillProfession', profession, '*')
        for skill in skills:
            skill['addEffectNames'] = []
            group = skill["groupType"]
            learened = group in self.learned_skillpool;

            display = (not learened and skill["level"] == 1) or \
                    (learened and skill["level"] == self.learned_skillpool[group]["skillLevel"] + 1) or \
                    (learened and skill["maxLevel"] == skill["level"] and skill["maxLevel"] == \
                       self.learned_skillpool[group]["skillLevel"])
            if display:
                effects = []
                splitEffects = skill["addEffect"].split(';')
                if (len(splitEffects) > 0 and int(splitEffects[0]) != -1):
                    for i in range(0, len(splitEffects)):
                        effectInfo = loader.getById('effect', int(splitEffects[i]), ['name', 'description'])
                        effects.append(effectInfo['description'])
                        skill['addEffectNames'].append(effectInfo['name'])

                allSkills.append({'skillInfo':skill, 'skillLevel':skill['level'], 'effects':effects})

        return allSkills

    def learnSkill(self, skillId):
        '''学习技能'''
        id = self._owner.baseInfo.id

        skill = loader.getById('skill', skillId, '*')
        canLearn, reason = self.checkLearnSkillRequire(skill, True)
        if not canLearn:
            return False, reason

        skill = loader.getById('skill', skillId, '*')
        skills = dbaccess.getLearnedSkills(id)
        flag = False
        targetId = 0
        for elm in skills:
            info = loader.getById('skill', elm[2], ['groupType'])
            if info['groupType'] == skill['groupType']:
                flag = True
                targetId = elm[0]
                break
        if flag:
            dbaccess.updateSkillLevelForLearnSkill(targetId, {'skillId':skillId, 'skillLevel':skill['level']})
        else:
            dbaccess.insertForLearnSkill([0, id, skillId, skill['level']])

        if skill['type'] == 3:#被动技能习得即装备，就直接获得隐式效果
            string = ''
            for i in range(0, len(self._passiveSkills)):
                if i == 0:
                    string += str(self._passiveSkills[i])
                else:
                    string += ';' + str(self._passiveSkills[i])
            dbaccess.updatePlayerInfo(id, {'passiveSkills':string})
            addEffectIds = skill['addEffect'].split(';')
            addEffectRates = skill['addEffectRate'].split(';')
            for i in range(0, len(addEffectIds)):
                if i == 0:
                    if int(addEffectIds[i]) == -1:
                        return
                effect = loader.getById('effect', int(addEffectIds[i]), '*')
                if effect:
                    r = random.randint(0, 100000)
                    if 0 <= r < int(addEffectRates[i]):
                        self._owner.effect.triggerEffect(effect, 2)
        self.getLearnedSkills()
        self._owner.refreshInfectionOfSkill()
        return True, ''

    def equipSkill(self, skillId, skillType):
        '''装备技能'''
        id = self._owner.baseInfo.id

        targetSkill = loader.getById('skill', skillId, '*')
        if targetSkill:
            if targetSkill['type'] <> skillType:
                return False, u'装备技能地方不正确，请查看'
            if targetSkill['type'] == 1:#主动技能
                dbaccess.updatePlayerInfo(id, {'activeSkill':skillId})
                self.setActiveSkill(skillId)
                return True, [u'装备成功', targetSkill]
            elif targetSkill['type'] == 2:#辅助技能
                if self._owner.attribute.getMp() < targetSkill['useMp']:
                    return False, u'法力值不够'
                auxiliarySkills = self.getAuxiliarySkills()
                if skillId in auxiliarySkills:
                    return False, u'该辅助技能已经在应用中'
                else:
#                    for i in range(0, len(auxiliarySkills)):
#                        result = loader.getById('skill', auxiliarySkills[i], '*')
#                        if result['groupType'] == targetSkill['groupType']:
#                            if result['level'] < targetSkill['level']:
#                                auxiliarySkills[i] = skillId
#                                effecList = result['addEffect'].split(';')
#                                for list in effectList:
#                                    dbaccess.deleteEffectInstance(id, list)
#                            else:
#                                return False, u'无法装备同类型等级的技能'
#                        else:
#                            auxiliarySkills.append(skillId)
                    if len(auxiliarySkills) == 0:
                        auxiliarySkills.append(skillId)
                    else:
                        return False, u'无法装备多个辅助技能'
                    string = ''
                    for i in range(0, len(auxiliarySkills)):
                        if i == 0:
                            string += str(auxiliarySkills[i])
                        else:
                            string += ',' + str(auxiliarySkills[i])
                    deltaMp = self._owner.attribute.getMp() - targetSkill['useMp']
                    dbaccess.updatePlayerInfo(id, {'mp':deltaMp, 'auxiliarySkills':string})
                    self._owner.attribute.setMp(deltaMp)
                #增加效果
                addEffectIds = targetSkill['addEffect'].split(';')
                addEffectRates = targetSkill['addEffectRate'].split(';')
                for i in range(0, len(addEffectIds)):
                    r = random.randint(0, int(addEffectRates[i]))
                    if r > 0 and r < addEffectRates[i]:
                        effect = loader.getById('effect', int(addEffectIds[i]), '*')
                        if effect:
                            self._owner.effect.triggerEffect(effect, 2)
                #删除效果
                removeEffectIds = targetSkill['removeEffect'].split(';')
                removeEffectRates = targetSkill['removeEffectRate'].split(';')
                for i in range(0, len(removeEffectIds)):
                    r = random.randint(0, int(removeEffectRates[i]))
                    if r > 0 and r < int(removeEffectRates[i]):
                        dbaccess.deleteEffectInstance(id, effect['id'])

                return True, [u'装备成功', self._owner.effect.getSkillEffectsInfo()]
            elif targetSkill['type'] == 3:#被动技能
                return False, u'被动技能无法装备'
        else:
            return False, u'技能尚未修炼'


    def checkLearnSkillRequire(self, skill, checkCoin):
        '''检查是否到达技能可学条件'''
        professionStage = self._owner.profession.getProfessionStage()
        level = self._owner.level.getLevel()
        coin = self._owner.finance.getCoin()
        if (professionStage < skill["professionStageRequire"]):
            return False, u"没有达到技能要求的职业阶段"
        if (level < skill["levelRequire"]):
            return False, u"角色等级(LV:" + str(level) + u")小于技能要求等级(LV" + str(skill["levelRequire"]) + u")"
        if (int(coin) < int(skill["useCoin"])):
            return False, u"没有足够的铜币学习此技能"

        return True, u""

    def updataSkillSettings(self, isNew, warriorSkillId, guardianSkillId, samuraiSkillId, toShiSkillId, advisersSkillId, warlockSkillId):
        id = self._owner.baseInfo.id
        props = [0, id, warriorSkillId, guardianSkillId, samuraiSkillId, toShiSkillId, advisersSkillId, warlockSkillId]
        if isNew:
            result = dbaccess.interSkillSettings(props)
        else:
            result = dbaccess.updataSkillSettings(props)

        if result >= 1:
            return True
        else:
            return False


