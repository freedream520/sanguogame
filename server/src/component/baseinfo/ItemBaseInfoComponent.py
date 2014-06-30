#coding:utf8
'''
Created on 2009-12-1

@author: hanbing
'''
from BaseInfoComponent import BaseInfoComponent

class ItemBaseInfoComponent(BaseInfoComponent):
    '''
    BaseInfo component for Item
    '''


    def __init__(self, owner, id, basename,itemTemplate=None):
        '''
        Constructor
        '''
        BaseInfoComponent.__init__(self, owner, id, basename)
        self._itemTemplate = itemTemplate #物品模版信息
        self._idInPackage = -1#物品在包裹栏、临时、装备栏中的唯一标识id
        self._itemLevel = 1 #物品等级

    def getName(self):
        '''根据属性计算出名字'''
        extraAttrList = self._owner.attribute.getExtraAttributeList()
        if extraAttrList:
            for attr in extraAttrList:
                str = ''
                str += attr['name']
            str += '的'+self._baseName
            return str
        else:
            return self._baseName
    
    def getItemTemplate(self):
        return self._itemTemplate
    
    def setItemTemplate(self,itemTemplate):
        self._itemTemplate = itemTemplate
        
    def getIdInPackage(self):
        return self._idInPackage
    
    def setIdInPackage(self,idInPackage):
        self._idInPackage = idInPackage
        
    def setItemLevel(self,itemLevel):
        self._itemLevel = itemLevel
    
    def getItemLevel(self):
        return self._itemLevel