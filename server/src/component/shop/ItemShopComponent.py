#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''

from component.Component import Component 

class ItemShopComponent(Component):
    '''
    shop component for item
    '''


    def __init__(self,owner):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._isOnSaleInShop = False #是否能在商店出现
        
    def getOnSaleInShop(self):
        return self._isOnSaleInShop
    
    def setOnSaleInShop(self):
        self._isOnSaleInShop = True
        
    
        
        
        

        