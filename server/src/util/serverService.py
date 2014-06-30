#coding:utf8
'''
Created on 2010-1-11

@author: wudepeng
'''
import dbaccess
from twisted.internet import reactor

reactor = reactor

def addEnergyPerDay():
    '''每天8点加点90活力'''
    energy = 90
    
    try:
        dbaccess.updateAllPlayersEnergy(energy)
    except Exception,e:
        print e
    reactor.callLater(3600*24,addEnergyPerDay)
    
def resetPlayerRestCountPerDay():
    '''每天8点玩家宿屋操作次数置0'''
    try:
        dbaccess.resetPlayerRestCount()
    except Exception,e:
        print e
    reactor.callLater(3600*24,resetPlayerRestCountPerDay)    
        
def resetPlayerEnterInstanceCount():
    '''每天8点玩家进入副本次数置零'''
    try:
        dbaccess.resetAllPlayersEnterInstanceCount()
    except Exception,e:
        print e
    reactor.callLater(3600*24,resetPlayerEnterInstanceCount)   