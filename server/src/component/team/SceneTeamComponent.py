#coding:utf8
'''
Created on 2010-3-12

@author: wudepeng
'''
from component.Component import Component

class SceneTeamComponent(Component):
    '''
    SceneTeamComponent
    '''


    def __init__(self,owner):
        '''
        Constructor for SceneTeamComponent
        '''
        Component.__init__(self,owner)
        self._canEnter = False
        
    def getCanEnter(self):
        return self._canEnter
    
    def setCanEnter(self,canEnter):
        self._canEnter = canEnter