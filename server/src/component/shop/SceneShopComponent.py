#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''

from component.Component import Component 

class SceneShopComponent(Component):
    '''
    
    '''


    def __init__(self,owner):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._shopQualityId = 0 #品质id
        self._shopExtraAttributeId = 0 #商店物品附加属性配置id
        self._minLevel = 0 #出现商品等级下限
        self._maxLevel = 0 #出现物品等级上限
        
    def getShopQualityId(self):
        return self._shopQualityId
    
    def setShopQualityId(self,qualityId):
        self._shopQualityId = qualityId
        
    def getShopExtraAttributeId(self):
        return self._shopExtraAttributeId
    
    def setShopExtraAttributeId(self,shopExtraAttributeId):
        self._shopExtraAttributeId = shopExtraAttributeId
        
    def getMinLevel(self):
        return self._minLevel
    
    def getMaxLevel(self):
        return self._maxLevel
    
    def setMinLevel(self,minLevel):
        self._minLevel = minLevel
        
    def setMaxLevel(self,maxLevel):
        self._maxLevel = maxLevel