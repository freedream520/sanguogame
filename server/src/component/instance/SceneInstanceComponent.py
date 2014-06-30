#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''

from component.Component import Component 

class SceneInstanceComponent(Component):
    '''
    instance component for scene
    '''


    def __init__(self,owner):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._isBelongToInstance = False
        
    def getBelongToInstance(self):
        #根据场景baseinfo的regionid判断是否属于场景
        pass
