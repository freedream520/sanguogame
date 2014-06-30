#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''

from component.Component import Component 

class ItemProfessionComponent(Component):
    '''
    classdocs
    '''


    def __init__(self,owner,professionRequire=0):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._professionRequire = professionRequire #物品职业需求
        
    def getProfessionRequire(self):
        return self._professionRequire
        
    def setProfessionRequire(self,professionRequire):
        self._professionRequire = professionRequire