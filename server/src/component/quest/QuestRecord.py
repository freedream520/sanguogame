#coding:utf8
'''
Created on 2009-12-3

@author: wudepeng
'''

class QuestRecord(object):
    '''
    quest record
    '''


    def __init__(self):
        '''
        Constructor
        '''
        self._id = 0
        self._templateQuestId = 0 #任务模版
        self._applyTime = None
        self._finishTime = None
        self._status = 0
        self._itemBonus = -1
        self._questGoalProgress = [] #任务对应的任务目标进度
        self._templateQuestInfo = None
        
    def getId(self):
        return self._id 
    
    def setId(self,id):
        self._id = id
        
    def getQuestTemplateId(self):
        return self._templateQuestId
    
    def setQuestTemplateId(self,questId):
        self._templateQuestId = questId
        
    def getApplyTime(self):
        return self._applyTime
    
    def setApplyTime(self,time):
        self._applyTime = time
        
    def getFinishTime(self):
        return self._finishTime
    
    def setFinishTime(self,time):
        self._finishTime = time
        
    def getStatus(self):
        return self._status
    
    def setStatus(self,status):
        self._status = status
        
    def getItemBonus(self):
        return self._itemBonus
    
    def setItemBonus(self,item):
        self._itemBonus = item
        
    def getQuestGoalProgress(self):
        return self._questGoalProgress
    
    def setQuestGoalProgress(self,progresses):
        self._questGoalProgress = progresses
        
    def getQuestTemplateInfo(self):
        return self._templateQuestInfo
    
    def setQuestTemplateInfo(self,info):
        self._templateQuestInfo = info
        