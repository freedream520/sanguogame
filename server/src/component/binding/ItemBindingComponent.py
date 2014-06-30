#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''

from component.Component import Component 

class ItemBindingComponent(Component):
    '''
    binding component for item
    '''


    def __init__(self,owner,type=0,isBound=0):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._type = type #物品的绑定属性:0=非绑定物品1=拾取即绑定(物品出现在[角色]的[包裹栏],[临时包裹栏],或者[储存屋]即绑定)2=装备即绑定(物品被角色装备后即绑定)
        self._isBound = isBound #物品的当前的绑定状态
        
    def getType(self):
        return self._type
    
    def setType(self,type):
        self._type = type
        
    def getBound(self):
        return self._isBound
    
    def setBound(self,isBound):
        self._isBound = isBound
        
    def getBindTypeName(self):
        '''获取绑定属性名称'''
        type = self._type
        if type==0:
            return u"非绑定物品"
        elif type==1:
            return u"拾取即绑定"
        elif type==2:
            return u"装备即绑定"
        else:
            return u""
       
    def getCurrentBoundStatus(self):
        '''获取绑定状态描述'''
        isBound = self._isBound
        if isBound==0:
            return u"未绑定"
        else:
            return u"已绑定"
        
