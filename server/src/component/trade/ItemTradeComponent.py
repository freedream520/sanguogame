#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''

from component.Component import Component 

class ItemTradeComponent(Component):
    '''
    trade component for item
    '''


    def __init__(self,owner,tradType=1):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._tradeType = tradType #可否被交易交易类型:1=可以被交易2=不可交易给[玩家]、[拍卖行]4=不可出售给[商店]
        
    def getTradeType(self):
        return self._tradeType
    
    def setTradeType(self,type):
        self._tradeType = type

        
