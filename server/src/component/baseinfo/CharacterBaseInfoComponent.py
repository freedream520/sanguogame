#coding:utf8
'''
Created on 2009-12-1

@author: hanbing
'''
from BaseInfoComponent import BaseInfoComponent

class CharacterBaseInfoComponent(BaseInfoComponent):
    '''
    BaseInfo component for character
    '''


    def __init__(self, owner, id, basename,nickName=u"",type=0,portrait=u"",description=u"",status=1):
        '''
        Constructor
        '''
        BaseInfoComponent.__init__(self, owner, id, basename)
        self._type = type  #玩家类型
        self._nickName = nickName  #玩家昵称
        self._portrait = portrait  #人物头像
        self._description = description #介绍
        self._status = status #玩家当前状态
        self._town = -1 #所属城镇
        self._location = -1 #当前所属地点
        self._gender = 1 #性别
        self._password = ''
        
    def getType(self):
        return self._type
    
    def setType(self,type):
        self._type = type
        
    def getNickName(self):
        return self._nickName
    
    def setNickName(self,nickName):
        self._nickName = nickName
        
    def getPortrait(self):
        return self._portrait
    
    def setPortrait(self,portrait):
        self._portrait = portrait
        
    def getDescription(self):
        return self._description
    
    def setDescription(self,description):
        self._description = description
        
    def getStatus(self):
        if self._status == 1:
            return u'正常'
        elif self._status == 2:
            return u'修炼中'
        elif self._status == 3:
            return u'训练中'
        elif self._status == 4:
            return u'战斗中'
        elif self._status == 5:
            return u'死亡'
        elif self._status == 6:
            return u'卖艺中'
        else:
            return u''
    
    def setStatus(self,status):
        self._status = status
        
    def setTown(self,town):
        self._town = town
        
    def getTown(self):
        return self._town
    
    def setLocation(self,location):
        self._location = location
    
    def getLocation(self):
        return self._location
    
    def getGender(self):
        return self._gender
    
    def setGender(self,gender):
        self._gender = gender
        
    def getPassword(self):
        return self._password
    
    def setPassword(self,password):
        self._password = password