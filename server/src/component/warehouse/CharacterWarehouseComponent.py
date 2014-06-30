#coding:utf8
'''
Created on 2010-3-18

@author: Administrator
'''
from component.Component import Component 
from util import dbaccess
from component.pack.Package import Package

class CharacterWarehouseComponent(Component):
    '''
    classdocs warehouse component
    '''


    def __init__(self,owner):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._wareHousePackage = Package(6,6)
        self._warehouses = 1    
        self._deposit = 0
        self._warehouseItem = []
        self._warehousePageItem = []
    
    def getWarehouses(self):
        return self._warehouses
    
    def setWarehouses(self,warehouse):
        self._warehouses = warehouse
        
    def getDeposit(self):
        return self._deposit
    
    def setDeposit(self,deposit):
        self._deposit = deposit
    
    def updataDeposit(self,money,type):
        coin = self._owner.finance.getCoin()
        deposit = self._deposit  
        if type== 1:
            coin -= money
            deposit += money
            if deposit >self._owner.level._level * 1000 +10000:    
                return {'result':False,'reason':u'存款已超出您现在的上限！'}
        else:
            coin += money
            deposit -= money
        self._owner.finance.setCoin(coin)
        self._deposit = deposit
        if dbaccess.updataDeposit(self._owner.baseInfo.id, coin, deposit):
            return {'result':True,'coin':coin,'deposit':deposit}
        else:
            return {'result':False,'reason':u'存取款错误'}