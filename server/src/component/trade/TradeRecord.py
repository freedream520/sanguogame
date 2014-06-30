#coding:utf8
'''
Created on 2009-12-3

@author: wudepeng
'''

class TradeRecord(object):
    '''
    trade record 
    '''


    def __init__(self):
        '''
        Constructor
        '''
        self._id = 0
        self._startId = 0 #记录交易发起人id
        self._receiveId = 0 #记录交易接受人id
        self._status = u"" #记录交易状态
        self._comment = u"" #记录交易信息
        self._startTime = u"" #记录开始时间
        
    def getId(self):
        return self._id
    
    def setId(self,id):
        self._id = id
        
    def getStartId(self):
        return self._startId
    
    def setStartId(self,startId):
        self._startId = startId
        
    def getReceiveId(self):
        return self._receiveId
    
    def setReceiveId(self,id):
        self._receiveId = id
        
    def getStatus(self):
        return self._status
    
    def setStatus(self,status):
        self._status = status
        
    def getComment(self):
        return self._comment
    
    def setComment(self,comment):
        self._comment = comment
        
    def getStartTime(self):
        self._startTime
        
    def setStartTime(self,time):
        self._startTime = time
        