#coding:utf8
'''
Created on 2009-12-3

@author: wudepeng
'''

class QuestGoal(object):
    '''
    quest goal
    '''


    def __init__(self):
        '''
        Constructor
        '''
        self._templateQuestId = 0 #关联任务id
        self._type = 1 #目标类型1:杀怪 2:收集 3:对话 4:擂台 5:刺杀
        self._keyNpcId = -1 #关联怪物/NPC的ID 
        self._keyNpcDialog = u"" # char关联NPC的对话
        self._killMonsterCount=0 # 需要杀掉怪物的数量 
        self._keyItemId = -1 #任务道具id
        self._keyItemCount = 0 #道具数量  
        self._keyItemDropRate= 90000 #道具掉落几率 
        
    def getQuestId(self):
        return self._templateQuestId
    
    def setQuestId(self,questId):
        self._templateQuestId = questId
        
    def getType(self):
        return self._type
    
    def setType(self,type):
        self._type = type
        
    def getKeyNpcId(self):
        return self._keyNpcId
    
    def setKeyNpcId(self,keyNpcId):
        self._keyNpcId = keyNpcId
        
    def getKeyNpcDialog(self):
        return self._keyNpcDialog
    
    def setKeyNpcDialog(self,dialog):
        self._keyNpcDialog = dialog
        
    def getKillMonsterCount(self):
        return self._killMonsterCount
    
    def setKillMonsterCount(self,count):
        self._killMonsterCount = count
    
    def getKeyItemId(self):
        return self._keyItemId
    
    def setKeyItemId(self,keyItemId):
        self._keyItemId = keyItemId

    def getKeyItemCount(self):
        return self._keyItemCount
    
    def setkeyItemCount(self,count):
        self._keyItemCount = count
        
    def getKeyItemDropRate(self):
        return self._keyItemDropRate
    
    def setKeyItemDropRate(self,rate):
        self._keyItemDropRate = rate

    