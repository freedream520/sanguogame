#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''

from component.Component import Component 
from util import dbaccess

class CharacterFriendComponent(Component):
    '''
    friend component for character
    '''


    def __init__(self,owner,friends=[],enermies=[]):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
        self._friendCount = 20#玩家拥有好友数量上限（仇敌数量）<=100
        self._friends = friends #好友
        self._enermies = enermies #黑名单
#        self.queryFriends()
     
    def getFriendCount(self):
        return self._friendCount
    
    def setFriendCount(self,count):
        self._friendCount = count   
        
    def getFriends(self):
        return self._friends
    
    def setFriends(self,friends):
        self._friends = friends
        
    def getEnermies(self):
        return self._enermies
    
    def setEnermies(self,enermies):
        self._enermies = enermies
        
    def queryFriends(self):
        id = self._owner.baseInfo.id
        self._friends = []
        self._enermies = []
        result = dbaccess.getPlayerFriends(id)
        for elm in result:
            if elm[-2]==1:
                self._friends.append(elm)
            elif elm[-2]==2:
                self._enermies.append(elm)
    
    def addFriend(self,playerId,type,isSheildMail):
        id = self._owner.baseInfo.id
        props = [0,id,playerId,type,isSheildMail]
        result,lastInsertFriend = dbaccess.insertPlayerFriendRecord(props)
        if result:
            return result,lastInsertFriend
        else:
            if type ==1:
                return result,u'该玩家已经在您的好友名单中'
            else:
                return result,u'该玩家已经在您的仇敌名单中'
    
    def removeFriend(self,friendId):
        result = dbaccess.deletePlayerFriendRecord(friendId)
        return result
    
    def updataSheildedMail(self,friendId,isSheildMail):
        result = dbaccess.updataSheildedMail(friendId, isSheildMail)
        return result
      
