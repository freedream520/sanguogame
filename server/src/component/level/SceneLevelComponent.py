#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''

from component.Component import Component 

class SceneLevelComponent(Component):
    '''
    level component for scene
    '''


    def __init__(self,owner,levelRequire=0):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._levelRequire = levelRequire #场景玩家等级限制
        
    def getLevelRequire(self):
        return self._levelRequire
    
    def setLevelRequire(self,level):
        self._levelRequire = level
        
    def isLevelRequired(self,levelRequire,charLevel):
        if levelRequire> charLevel:
            return False
        return True