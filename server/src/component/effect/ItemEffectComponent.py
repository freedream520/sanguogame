#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''
from component.Component import Component 

class ItemEffectComponent(Component):
    '''
    effect component for item
    '''


    def __init__(self,owner):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._effect = None #物品上所产生的效果
        
    def getEffect(self):
        return self._effect
    
    def setEffect(self,effect):
        self._effect = effect
        
    def getItemEffect(self):
        '''获取物品模版效果'''
        return self._owner.baseInfo.getItemTemplate()['effectId']
        