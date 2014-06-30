#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''

from component.Component import Component 

class SceneCampComponent(Component):
    '''
    camp component for scene
    '''


    def __init__(self,owner,campRequire=3):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._campRequire = campRequire #场景阵营要求
        
    def getCamp(self):
        return self._campRequire
    
    def setCampRequire(self,camp):
        self._campRequire = camp
        
    def isCampRequired(self,campRequire,characterCamp):
        if campRequire <> characterCamp:
            return False
        return True