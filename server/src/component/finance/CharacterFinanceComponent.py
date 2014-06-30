#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''

from component.Component import Component 

class CharacterFinanceComponent(Component):
    '''
    finance component for character
    '''


    def __init__(self,owner,coin=0,gold=0,coupon=0):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._coin = coin #铜币
        self._gold = gold #黄金
        self._coupon = coupon #礼券
        
    def getCoin(self):
        return self._coin
    
    def setCoin(self,coin):
        self._coin = coin
        
    def getGold(self):
        return self._gold
    
    def setGold(self,gold):
        self._gold = gold
        
    def getCoupon(self):
        return self._coupon
    
    def setCoupon(self,coupon):
        self._coupon = coupon
