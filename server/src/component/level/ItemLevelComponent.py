#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''

from component.Component import Component 

class ItemLevelComponent(Component):
    '''
    level component for item
    '''


    def __init__(self,owner,levelRequire=0,qualityLevel=0):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._levelRequire = levelRequire #等级需求
        self._qualityLevel = qualityLevel #品质等级
     
    def getLevelRequire(self):
        return self._levelRequire  
    
    def setLevelRequire(self,level):
        self._levelRequire = level
    
    def getQualityLevel(self):
        return self._qualityLevel
    
    def setQualityLevel(self,level):
        self._qualityLevel = level