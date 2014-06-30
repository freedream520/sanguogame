#coding:utf8
'''
Created on 2010-3-25

@author: chenwei
'''

from util import dbaccess


def addPlayer(username,password,email):
    if not isExist(username):
        if(dbaccess.addPlayerInfo(username, password, email) == True):
            return 0
        else:
            return 1
    else:
        return 2   
    
def isExist(username):
    return dbaccess.isExistUsername(username);

def isNeedCreatePlayer(username,password):
    if(dbaccess.isExitInRegister(username, password) <> None and dbaccess.isNewPlayer(username, password) == None):
        return True
    else:
        return False;
    
def createNewPlayer(username,password,nickname,path,gender):
    if gender == 1:
        bid = 4;
    else:
        bid = 5;       
    if(dbaccess.addNewCharacter(username, password, nickname, path, gender,bid)):
        if(dbaccess.initializeCharacter(username)):            
            return True
        else:
            return False
    else:
        return False

def getCharacterId(username):
    return dbaccess.getNewCharacter(username)

def chooseCamp(town,location,camp,id):
    return dbaccess.enterCamp(town, location, camp, id)

def selectProfession(pid,id):
    '''选择职业'''
    return dbaccess.updatePlayerProfession(pid, id)

def isRegisteredNickName(nickName):
    return dbaccess.findSameNickNamePlayer(nickName)