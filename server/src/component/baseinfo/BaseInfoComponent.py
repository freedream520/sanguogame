#coding:utf8
'''
Created on 2009-12-1

@author: hanbing
'''

from component.Component import Component

class BaseInfoComponent(Component):
    '''
    抽象的基本信息对象
    '''


    def __init__(self, owner, id, basename):
        '''
        创建基本信息对象
        @param id: owner的id
        @param name: 基本名称（可能会根据某些规则才能获得具体名称）
        '''
        Component.__init__(self,owner)
        self.id = id                   # owner的id
        self._baseName = basename       # 基本名字
        
    def getName(self):
        return self._baseName
        