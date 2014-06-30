#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''
from component.Component import Component 

class ItemQuestComponent(Component):
    '''
    quest component for item
    '''


    def __init__(self,owner,dropItemId=0,questList=[]):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._dropItemId = dropItemId #任务指定掉落物品
        self._questList = questList #玩家当前任务
        
    def getDropItemId(self):
        return self._dropItemId
    
    def setDropItemId(self,id):
        self._dropItemId = id
        
    def isQuestItem(self):
        #todo
        pass
    
    def relateToWhichQuest(self):
        #todo
        pass        