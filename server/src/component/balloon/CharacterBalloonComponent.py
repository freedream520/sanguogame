#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''

from component.Component import Component 

class CharacterBalloonComponent(Component):
    '''
    balloon component for character
    '''


    def __init__(self,owner,face=u"",intro=u"",startBattleSentence=u"",criSentence=u"",breSentence=u"",criAndBreSentence=u"",\
                 missSentence=u"",beMissedSentence=u"",beCrackedSentence=u"",usingSkillSentence=u"",winSentence=u"",failSentence=u""):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._id = -1
        self._startBattleSentence = startBattleSentence #战斗开始登场宣言
        self._criSentence = criSentence #暴击宣言
        self._breSentence = breSentence #破防宣言
        self._criAndBreSentence = criAndBreSentence #暴击加破防宣言
        self._missSentence = missSentence #闪避宣言
        self._beMissedSentence = beMissedSentence #被闪避宣言
        self._beCrackedSentence = beCrackedSentence #被重击宣言
        self._usingSkillSentence = usingSkillSentence #使用技能宣言
        self._winSentence = winSentence #胜利宣言
        self._failSentence = failSentence #失败宣言
        
    def getId(self):
        return self._id
    
    def setId(self,id):
        self._id = id
        
    def getFace(self):
        return self._face
    
    def getStartBattleSentence(self):
        return self._startBattleSentence
    
    def setStartBattleSentence(self,startBattleSentence):  
        self._startBattleSentence = startBattleSentence
        
    def getCriSentence(self):
        return self._criSentence
    
    def setCriSentence(self,criSentence):
        self._criSentence = criSentence
        
    def getBreSentence(self):
        return self._breSentence
    
    def setBreSentence(self,breSentence):
        self._breSentence = breSentence
        
    def getCriAndBreSentence(self):
        return self._criAndBreSentence
    
    def setCriAndBreSentence(self,criAndBreSentence):
        self._criAndBreSentence = criAndBreSentence
        
    def getMissSentence(self):
        return self._missSentence
    
    def setMissSentence(self,missSentence):
        self._missSentence = missSentence
        
    def getBeMissedSentence(self):
        return self._beMissedSentence
    
    def setBeMissedSentence(self,beMissedSentence):
        self._beMissedSentence = beMissedSentence
        
    def getBeCrackedSetence(self):
        return self._beCrackedSentence
    
    def setBeCrackedSetence(self,beCrackedSentence):
        self._beCrackedSentence = beCrackedSentence
        
    def getUsingSkillSentence(self):
        return self._usingSkillSentence
    
    def setUsingSkillSentence(self,usingSkillSentence):
        self._usingSkillSentence = usingSkillSentence
        
    def getWinSentence(self):
        return self._winSentence
    
    def setWinSentence(self,winSentence):
        self._winSentence = winSentence
        
    def getFailSentence(self):
        return self._failSentence
    
    def setFailSentence(self,failSentence):
        self._failSentence = failSentence
    
    
    