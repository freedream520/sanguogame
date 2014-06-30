#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''
from component.Component import Component 

class SceneBalloonComponent(Component):
    '''
    Balloon component for scene
    '''


    def __init__(self,owner):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        