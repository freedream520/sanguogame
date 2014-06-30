#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''
import math
from net.MeleeSite import pushMessage
from component.Component import Component
from util import dbaccess
from util.DataLoader import loader

class CharacterLevelComponent(Component):
    '''
    level component for character
    '''


    def __init__(self, owner, level = 10, exp = 0):
        '''
        Constructor
        '''
        Component.__init__(self, owner)
        self._level = level #玩家等级
        self._exp = exp #玩家经验
        self._twiceExp = 0#双倍经验值几率
        self.MAXLEVEL = 40#满级ֵ

    def getMaxExp(self):
        '''计算当前级别的最大经验值'''
        y = int(1 + math.pow((self._level - 60) / 10, 2))
        if(y < 1):
            y = 1
        maxExp = 100 + 60 * (self._level - 1) + 10 * self._level * (self._level + 1) * (self._level - 1)
        return int(maxExp)

    def getLevel(self):
        return self._level

    def setLevel(self, level):
        self._level = level

    def getExp(self):
        return self._exp

    def setExp(self, exp):
        self._exp = exp

    def getTwiceExp(self):
        return self._twiceExp

    def setTwiceExp(self, twiceExp):
        self._twiceExp = twiceExp

    def updateLevel(self):
        '''根据经验值更新等级'''
        if self._level >= self.MAXLEVEL:
            dbaccess.updatePlayerInfo(self._owner.baseInfo.id, {'exp' : 0})
            self._exp = 0
            return False

        id = self._owner.baseInfo.id
        sparePoint = self._owner.attribute.getSparePoint()
        baseStr = self._owner.attribute.getBaseStr()
        baseVit = self._owner.attribute.getBaseVit()
        baseDex = self._owner.attribute.getBaseDex()
        professionId = self._owner.profession.getProfession()
        maxExp = self.getMaxExp()
        if(self._exp >= maxExp):
            self._level += 1
            self._exp -= maxExp
            sparePoint += 1

            profession = loader.getById('profession', professionId, '*')
            baseStr += profession["perLevelStr"]
            baseVit += profession["perLevelVit"]
            baseDex += profession["perLevelDex"]
            maxHp = self._owner.attribute.getMaxHp(professionId, id, self._level)
            maxMp = self._owner.attribute.getMaxMp(professionId, id, self._level)
            dbaccess.updatePlayerInfo(id, {'level' : self._level, 'exp' : self._exp,
                                           'sparepoint' : sparePoint, 'baseStr' : baseStr,
                                           'baseDex' : baseDex, 'baseVit' : baseVit,
                                           'hp' : maxHp, 'mp' : maxMp})
            self._owner.attribute.setSparePoint(sparePoint)
            self._owner.attribute.setBaseStr(baseStr)
            self._owner.attribute.setBaseVit(baseVit)
            self._owner.attribute.setBaseDex(baseDex)
            pushMessage(str(self._owner.baseInfo.id), 'updataLevel')
            return True
        else:
            return False
