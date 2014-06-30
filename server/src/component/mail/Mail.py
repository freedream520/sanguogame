#coding:utf8

'''
Created on 2009-12-3

@author: wudepeng
'''

class Mail(object):
    '''
    mail object
    '''


    def __init__(self,senderId,receiverId,content,type=1,isReaded=False,sendTime=u""):
        '''
        Constructor
        '''
        self._senderId = senderId #发送人id
        self._receiverId = receiverId #接受人id
        self._type = type #邮件的类型（1.系统信函  2.玩家信函  3.交易信函 = 0
        self._content = content #邮件的内容
        self._isReaded = isReaded #是否已读
        self._sendTime = sendTime #发送时间
        
    def getSenderId(self):
        return self._senderId
    
    def setSenderId(self,senderId):
        self._senderId = senderId
        
    def getReceiverId(self):
        return self._receiverId
    
    def setReceiverId(self,receiverId):
        self._receiverId = receiverId
        
    def getContent(self):
        return self._content
    
    def setContent(self,content):
        self._content = content
        
    def getType(self):
        return self._type
    
    def setType(self,type):
        self._type = type
        
    def getIsReaded(self):
        return self._isReaded
    
    def setReaded(self,readed):
        self._isReaded = readed
        
    def getSenderTime(self):
        return self._sendTime
    
    def setSenderTime(self,senderTime):
        self._sendTime = senderTime