#coding:utf8
'''
Created on 2009-12-3

@author: wudepeng
'''

class QuestGoalProgress(object):
    '''
    quest goal progress
    '''


    def __init__(self):
        '''
        Constructor
        '''
        self._id = 0
        self._questId = 0 #任务实例id
        self._questGoalId = 0 #任务目标id
        self._killMonsterCount =0  #已经杀死怪物数量  = 0
        self._collectItemCount=0 #收集道具数量 = 0
        self._isTalkKeyNpc=0 #是否已经和关键npc对话过 = 0
        
    def getId(self):
        return self._id
    
    def setId(self,id):
        self._id = id
    
    def getQuestId(self):
        return self._questId
    
    def setQuestId(self,questId):
        self._questId = questId
    
    def getQuestGoalId(self):
        return self._questGoalId
    
    def setQuestGoalId(self,goalId):
        self._questGoalId = goalId
    
    def getKillMonsterCount(self):
        return self._killMonsterCount
    
    def setKillMonsterCount(self,count):
        self._killMonsterCount = count
    
    def getCollectItemCount(self):
        return self._collectItemCount
    
    def setCollectItemCount(self,count):
        self._collectItemCount = count
    
    def getIsTalkKeyNpc(self):
        return self._isTalkKeyNpc
    
    def setTalkedKeyNpc(self):
        self._isTalkKeyNpc = 1
        