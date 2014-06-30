#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''
from component.Component import Component
import datetime
from util import dbaccess
from net.MeleeSite import pushMessage

class CharacterMailComponent(Component):
    '''
    mail component for character
    '''


    def __init__(self, owner, mailList = []):
        '''
        Constructor
        '''
        Component.__init__(self, owner)
        self._mailList = mailList #玩家的邮件列表

    def getMailList(self):
        return self._mailList

    def setMailList(self, mailList):
        self._mailList = mailList

    def addMail(self, senderId, receiverId, type, content, systemType, reference):
        sendTime = datetime.datetime.now()
        props = [0, senderId, receiverId, type, content, 0, str(sendTime), systemType, reference]
        result = dbaccess.insertMail(props);
        if result:
            pushMessage(str(receiverId), 'newMail')
        return True

    def mailList(self):
        id = self._owner.baseInfo.id
        self._mailList = []
        result = dbaccess.getMailList(id)
        return result

    def deleteMail(self, id):
        result = dbaccess.deleteMail(id)
        return result

    def isNewMail(self, id):
        result = dbaccess.isNewMail(id)
        if result:
            pushMessage(str(id), 'newMail')
