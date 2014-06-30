#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''
from component.Component import Component 

class CharacterTradeComponent(Component):
    '''
    trade component for character
    '''


    def __init__(self,owner):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._tradeRecords = [] #玩家交易记录
        self._currentTradeRecord = None #当前交易记录
        self._tradePackage = None #交易栏对象
        
    def getTradeRecords(self):
        return self._tradeRecords
    
    def setTradeRecords(self,list):
        self._tradeRecords = list
        
    def getCurrentTradeRecord(self):
        return self._currentTradeRecord
    
    def setCurrentTradeRecord(self,record):
        self._currentTradeRecord = record
        
    def getTradePackage(self):
        return self._tradePackage
    
    def setTradePackage(self,tradePackage):
        self._tradePackage = tradePackage