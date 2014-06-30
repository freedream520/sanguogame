'''
Created on 2010-4-6

@author: chenwei
'''
from util import dbaccess
from core.playersManager import PlayersManager

def getNewPlayerQuestProgress(id):
    
    return dbaccess.getNewPlayerQuestProgress(id)

def setNewPlayerQuestProgress(id,progressid):
    
    return dbaccess.setNewPlayerQuestProgress(id, progressid)

def setNotNewPlayer(id):
    return dbaccess.setNotNewPlayer(id)

def getIsNewPlayer(id):
    
    return dbaccess.getIsNewPlayer(id)

def getNewPlayerQuestInfo(qid):
    
    return dbaccess.getNewPlayerQuestInfo(qid)

def giveReward(id,coin,coupon,exp):    
    player = PlayersManager().getPlayerByID(id)
    player.finance.setCoin(int(player.finance.getCoin())+coin)
    player.level.setExp(int(player.level.getExp())+exp)
    player.finance.setCoupon(int(player.finance.getCoupon())+coupon)
    dbaccess.updatePlayerInfo(id, {'coin':int(player.finance.getCoin()),
                                   'coupon' : int(player.finance.getCoupon()),
                                   'exp' : int(player.level.getExp())})
    player.level.updateLevel()
    
def giveFirstWeapon(id,wid):           
    if dbaccess.giveNewPlayerWeapon(id,wid):
        return True
    else:
        return False

    
def putFirstWeaponIntoPackage(id,tid,position):
    if dbaccess.isSendBefore(id, tid) == None:
        itemId = dbaccess.getNewPlayerWeapon(id,tid);
        if dbaccess.setWeaponToPackage(id,itemId,position):
            return True
        else:
            return False
    else:
        return False
    
    
def setIsAttackedMonster(id,isKilled):
    if dbaccess.setHasKilledMonster(id, isKilled):
        return True
    else:
        return False
    
def getIsAttackedMonster(id):
    return dbaccess.getHasKilledMonster(id)
        