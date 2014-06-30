#coding:utf8
'''
Created on 2009-12-21

@author: wudepeng
'''

import util
from DataLoader import loader, connection
import datetime
from core.playersManager import PlayersManager

dbpool = None

'''---------------------------------------------------玩家信息数据库操作-------------------------------'''
def addPlayerInfo(username, password, email):
    '''玩家注册信息'''
    sql = "insert into `register` values(null,'%s','%s','%s')" % (username, password, email)
    cursor = dbpool.cursor()
    count = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if count >= 1:
        return True
    else:
        return False

def getAllPlayers(property, camp, profession):
    cursor = dbpool.cursor()
    if(camp == 0 and profession == 0):
        sql = "select * from `character` order by %s desc" % property
    elif camp == 0:
        sql = "select * from `character` where profession=%d order by %s desc" % (profession, property)
    elif profession == 0:
        sql = "select * from `character` where camp=%d order by %s desc" % (camp, property)
    else:
        sql = "select * from `character` where profession=%d and camp=%d order by %s desc" % (profession, camp, property)
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def getNewPlayerQuestProgress(id):
    '''获取当前玩家新手任务的步骤ID'''
    cursor = dbpool.cursor()
    sql = "select `newPlayerQuest` from `character` where id=%d" % id
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result[0]

def setNewPlayerQuestProgress(id, progressid):
    '''设置玩家新手任务的步骤'''
    cursor = dbpool.cursor()
    sql = "update `character` set newPlayerQuest=%d where id=%d" % (progressid, id)
    count = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if(count >= 1):
        return True
    else:
        return False

def setNotNewPlayer(id):
    '''设置玩家为非新手玩家'''
    cursor = dbpool.cursor()
    sql = "update `character` set isNewPlayer=0 where id=%d" % id
    count = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if(count >= 1):
        return True
    else:
        return False

def getNewPlayerQuestInfo(qid):
    cursor = dbpool.cursor()
    sql = "select * from `newplayer_quest` where id=%d" % qid
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def finishNewPlayerQuest(id, coin, coupon, exp):
    cursor = dbpool.cursor()
    sql = "update `character` set coin=%d,coupon=%d,exp=%d where id=%d" % (coin, coupon, exp, id)
    count = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if(count >= 1):
        return True
    else:
        return False

def getIsNewPlayer(id):
    cursor = dbpool.cursor()
    sql = "select isNewPlayer from `character` where id=%d" % id
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result[0]

def isExistUsername(username):
    '''匹配数据库中username'''
    cursor = dbpool.cursor()
    sql = "select username from `register` where username='%s'" % username
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    if result is None:
        return False
    return True

def addNewCharacter(username, password, nickname, path, gender, bid):
    cursor = dbpool.cursor()
    sql = "insert into `character`(name,nickName,portrait,gender,password,balloonId) values('%s','%s','%s',%d,'%s',%d)" % (username, nickname, path, gender, password, bid)
    #print '--------------character------------------------'
    #print sql
    count = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if(count >= 1):
        return True
    else:
        return False

def enterCountry(town, location, camp, username):
    cursor = dbpool.cursor()
    sql = "update `character` set camp=%d,town=%d,location=%d where name='%s'" % (camp, town, location, username)
#    print '--------------Camp------------------------'
#    print sql
    count = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if(count >= 1):
        return True
    else:
        return False

def enterCamp(town, location, camp, id):
    cursor = dbpool.cursor()
    sql = "update `character` set camp=%d,town=%d,location=%d where id=%d" % (camp, town, location, id)
#    print '--------------Camp------------------------'
#    print sql
    count = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if(count >= 1):
        return True
    else:
        return False

def initializeCharacter(username):
    '''初始化新手表格'''
    cursor = dbpool.cursor()
    sql2 = "insert into `character_lobby`(characterId) values(%d)" % getNewCharacter(username)
    sql3 = "insert into `balloon`(characterId) values(%d)" % getNewCharacter(username)
    sql4 = "insert into `character_rest`(characterId) values(%d)" % getNewCharacter(username)
    sql5 = "insert into `equipment_slot`(characterId) values(%d)" % getNewCharacter(username)
    sql6 = "insert into `character_practice`(characterId) values(%d)" % getNewCharacter(username)
#    print "-----------------character_lobby------------------------------"
#    print sql2
#    print "-----------------balloon------------------------------"
#    print sql3
#    print "-------------------character_rest----------------------------"
#    print sql4
#    print "----------------equipment_slot-------------------------------"
#    print sql5
#    print "----------------character_practice-------------------------------"
#    print sql6
#    print "-----------------end------------------------------"
    count2 = cursor.execute(sql2)
    count3 = cursor.execute(sql3)
    count4 = cursor.execute(sql4)
    count5 = cursor.execute(sql5)
    count6 = cursor.execute(sql6)
    dbpool.commit()
    cursor.close()
    if(count2 >= 1 and count3 >= 1 and count4 >= 1 and count5 >= 1 and count6 >= 1):
        return True
    else:
        return False

def searchBalloon(characterId):
    cursor = dbpool.cursor()
    cursor.execute("select id from `balloon` where characterId='%s'" % characterId)
    result = cursor.fetchone()
    cursor.close()
    return result[0]

def updateBalloon(username, bid):
    cursor = dbpool.cursor()
    sql = "update `character` set balloonId=%d  where id=%d" % (bid, getNewCharacter(username))
    count = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if(count >= 1):
        return True
    else:
        return False

def findSameNickNamePlayer(nickName):
    cursor = dbpool.cursor()
    cursor.execute("select nickName from `character` where nickName='%s'" % nickName)
    result = cursor.fetchone()
    cursor.close()
    return result

def getNewCharacter(username):
    '''根据玩家用户名查找ID'''
    cursor = dbpool.cursor()
    sql = "select id from `character` where name='%s'" % username
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result[0]

def createPlayerRole():
    '''创建玩家角色，增加玩家各信息记录'''
    sql = "insert into `mail` values(%d,%d,%d,%d,'%s',%d,'%s')" % (0, 1, 1, 2, '你好', 0, str(datetime.datetime.now()))
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def updateAllPlayersEnergy(energy):
    '''系统给所有玩家增加相应的活力'''
    cursor = dbpool.cursor()
    sql1 = "update `character` set energy=energy+%d" % energy
    cursor.execute(sql1)
    dbpool.commit()
    sql2 = "update `character` set energy=200 where energy>200"
    cursor.execute(sql2)
    dbpool.commit()
    cursor.close()

def resetAllPlayersEnterInstanceCount():
    '''系统给所有玩家重置进入副本次数'''
    cursor = dbpool.cursor()
    sql = "update `character` set enterInstanceCount=0"
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def _queryPlayerInfo(arg):
    cursor = dbpool.cursor()
    cursor.execute("select * from `character` where id=" + str(arg))
    result = cursor.fetchone()
    cursor.close()
    return result

def getPlayerIdAndPasswordByName(name):
    '''根据用户昵称获取id'''
    cursor = dbpool.cursor()
    sql = "select id,password,name from `character` where name='%s'" % name
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def isExitInRegister(username, password):
    '''检查该用户是否存在于注册表'''
    cursor = dbpool.cursor()
    sql1 = "select username,password from `register` where username='%s' and password='%s'" % (username, password)
    cursor.execute(sql1)
    result = cursor.fetchone()
    cursor.close()
    return result

def isNewPlayer(username, password):
    '''是否存在于玩家表中'''
    cursor = dbpool.cursor()
    sql2 = "select name,password from `character` where name='%s' and password='%s'" % (username, password)
    cursor.execute(sql2)
    result = cursor.fetchone()
    cursor.close()
    return result



def getPlayerIdAndPasswordByNickname(nickname):
    '''根据用户昵称获取id'''
    cursor = dbpool.cursor()
    sql = "select id from `character` where nickName='%s'" % nickname
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def _queryPlacePlayers(placeId, characterId):
    '''查询场景中玩家列表'''
    cursor = dbpool.cursor()
    cursor.execute("select * from `character` where location="\
                   + str(placeId) + " and id<>" + str(characterId))
    result = cursor.fetchall()
    cursor.close()
    return result

def getPlayerInfoInOnePlaceByName(placeId, name):
    '''根据当前场景下玩家姓名查找玩家信息'''
    cursor = dbpool.cursor()
    cursor.execute("select * from `character` where location=%d and name=%s"\
                   % (placeId, name))
    result = cursor.fetchone()
    cursor.close()
    return result

def getPlayerBalloonInfo(id):
    '''获取玩家balloon信息'''
    cursor = dbpool.cursor()
    cursor.execute("select * from `balloon` where id=%d" % id)
    result = cursor.fetchone()
    cursor.close()
    return result

def updatePlayerInfo(id, attrs):
    '''修改玩家信息'''
    sql = 'update `character` set'
    sql = util.forEachUpdateProps(sql, attrs)
    sql += " where id=%d" % id
    cursor = dbpool.cursor()
    count = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if(count >= 1):
        return True
    else:
        return False


'''-----------------------------------------------------物品信息----------------------------------------------'''
def insertItemRecord(list):
    '''增加物品记录'''
    sql = "insert into `item` values("
    sql = util.generateInsertSql(sql, list)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    return None

def deleteItem(itemId, id):
    sql = "delete from `item` where id=%d and characterId=%d" % (itemId, id)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def getItemTemplate(itemId):
    '''得到物品模版id'''
    sql = "select itemTemplateId from `item` where id=%d" % itemId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    if result:
        return result[0]
    else:
        return - 1
    cursor.close()
    return result

def getItemInfo(itemId):
    '''得到物品信息'''
    sql = "select * from `item` where id=%d" % itemId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def getItemInfoByTemplateId(templateId, characterId):
    '''根据物品模版id得到物品信息'''
    sql = "select * from `item` where itemTemplateId=%d and characterId=%d" % (templateId, characterId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def getLastInsertItemInfo():
    '''得到最近插入的item信息'''
    sql = "select * from `item` where id=LAST_INSERT_ID()"
    cursor = dbpool.cursor()
    cursor.execute(sql)
    lastInsertItem = cursor.fetchone()
    cursor.close()
    return lastInsertItem

def getSelfAndDropExtraAttr(equipmentId):
    '''得到装备的selfExtraAttribute和 dropExtraAttribute'''
    sql = "select selfExtraAttributeId,dropExtraAttributeId from `item` where id=" + str(equipmentId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    if result:
        return result[0]
    else:
        return "None"

def getIdFromPackagesByItemId(characterId, itemId, itemTemplateId, bodyType, packageType):
    ''''''
    cursor = dbpool.cursor()
    if packageType == 'equipment_slot':
        sql = "select %s from `%s` where characterId=%s" % (bodyType, packageType, characterId)
        cursor.execute(sql)
        result = cursor.fetchone()
        cursor.close()
        return result[0]
    else:
        sql = "select id from `%s` where characterId=%d and itemId=%d" % (packageType, characterId, itemId)
        cursor.execute(sql)
        result = cursor.fetchall()
        cursor.close()
        if len(result) > 0:
            return result[0][0]
        else:
            return - 1

'''--------------------------------------------------------------------------------------------------------'''
def getItemsInOnePosition(characterId, position, packageType):
    '''获取栏中特定格子上的物品（组）'''
    sql = "select * from `%s` where characterId=%d and position='%s'" % (packageType, characterId, position)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def updateItemAttrsInPackages(packageType, id, attrs):
    '''修改栏中物品记录'''
    sql = "update %s set" % packageType
    sql = util.forEachUpdateProps(sql, attrs)
    sql += " where id=%d" % id
#    print sql
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    return None

def mergeItemsForSameItemId(stack, packageType, itemId, packageItemId1, packageItemId2):
    '''
            合并物品
    @param itemId: 物品表id
    @param packageItemId1: 要合并到的物品
    @param packageItemId2: 要合并到的item ，package/temporary_package表中的id
    '''
    cursor = dbpool.cursor()
    cursor.execute("select stack from `%s` where id=%d" % (packageType, packageItemId1))
    formerStack = cursor.fetchone()[0]
    stack = stack + int(formerStack)
    updateSql = "update `%s` set stack=%d where id=%d" % (packageType, stack, packageItemId1)
    deletePackageItem = "delete from `%s` where id=%d" % (packageType, packageItemId2)
    deleteItem = "delete from `item` where id=%d" % itemId
    cursor.execute(updateSql)
    cursor.execute(deletePackageItem)
    cursor.execute(deleteItem)
    dbpool.commit()
    cursor.close()
    return True

def splitItemsOnOperateDB(stack, insertProps, splitIn, splitTo, packageItemId, itemInstance, page):
    '''
            拆分道具，修改数据库
    @param itemInstance: 要拆分的item表记录        
    '''
    updateSql = "update `%s` set stack=%d where id=%d" % (splitIn, stack, packageItemId)
    insertItemSql = "insert into `item` values(%d,%d,%d,%d,'%s',%d,%d)" % (0, itemInstance[1], itemInstance[2], itemInstance[3], itemInstance[4], itemInstance[5], 1)

    cursor = dbpool.cursor()
    cursor.execute(updateSql)
    cursor.execute(insertItemSql)
    dbpool.commit()

    cursor.execute("select id from `item` where id= LAST_INSERT_ID()")
    lastItemRecord = cursor.fetchone()

    if splitTo == 'warehouse_package':
        insertPackageSql = "insert into `%s` values(%d,%d,%d,'%s',%d,%d)" % (splitTo, 0, insertProps[1], \
                                                                        lastItemRecord[0], insertProps[3], insertProps[4], page)
    else:
        insertPackageSql = "insert into `%s` values(%d,%d,%d,'%s',%d)" % (splitTo, 0, insertProps[1], \
                                                                        lastItemRecord[0], insertProps[3], insertProps[4])
    cursor.execute(insertPackageSql)
    dbpool.commit()

    cursor.execute("select id,itemId,position,stack from `%s` where id=LAST_INSERT_ID()" % splitTo)
    ret = cursor.fetchone()

    cursor.close()
    position = util.splitPosition(ret[2])
    return {'result':True, 'spareCount':stack, 'isMerge':False, 'dragId':packageItemId, 'destId':ret[0], \
                    'currentDestStack':ret[3], 'currentPosition':position, 'newSplitRecord':ret, \
                    'isSlotPackage':False}

def moveItemFromOneToAnother(fromPack, toPack, idInFromPack, props, characterId):
    '''移动物品到另一个栏中
    fromPack为装备栏时，idInFromPack为装备栏表中的字段（位置）
    '''
    if fromPack == 'equipment_slot':
        delOrUpdateSql = "update `%s` set %s=-1 where characterId=%d" % (fromPack, idInFromPack, characterId)
        isSlotPackage = True
    elif fromPack == 'shop_package':
        pass
    else:
        delOrUpdateSql = "delete from `%s` where id=%d" % (fromPack, idInFromPack)
        isSlotPackage = False
    if toPack == 'equipment_slot':
        pass
    else:
        insertSql = "insert into `%s` values(%d,%d,%d,'%s',%d)" % (toPack, props[0], props[1], props[2], \
                                                                 props[3], props[4])
    if toPack == 'warehouse_package':
        insertSql = "insert into `%s` values(%d,%d,%d,'%s',%d,%d)" % (toPack, props[0], props[1], props[2], \
                                                                 props[3], props[4], props[5])

    cursor = dbpool.cursor()
    cursor.execute(delOrUpdateSql)
    cursor.execute(insertSql)
    dbpool.commit()

    cursor.execute("select id,itemId,position,stack from `%s` where id=LAST_INSERT_ID()" % toPack)
    ret = cursor.fetchone()
    cursor.close()
    position = util.splitPosition(ret[2])
    return {'result':True, 'spareCount':0, 'isMerge':False, 'dragId':idInFromPack, 'destId':ret[0], \
                    'currentDestStack':ret[3], 'currentPosition':position, 'newSplitRecord':ret, \
                    'isSlotPackage':isSlotPackage}

def mergeItemFromAnother(fromPack, toPack, idInFromPack, idInToPack, stack):
    '''合并来自其他栏中同类型的物品
                目前只考虑在玩家包裹蓝中容许合并
    '''
    delSql = "delete from `%s` where id=%d" % (fromPack, int(idInFromPack))
    updateSql = "update `%s` set stack=stack+%d where id=%d" % (toPack, stack, idInToPack)
    cursor = dbpool.cursor()
    cursor.execute(delSql)
    cursor.execute(updateSql)
    dbpool.commit()
    cursor.execute("select id,itemId,position,stack from `%s` where id=%d" % (toPack, idInToPack))
    ret = cursor.fetchone()
    cursor.close()
    position = eval("[" + ret[2] + "]")
    return {'result':True, 'spareCount':0, 'isMerge':True, 'dragId':idInFromPack, 'destId':ret[0], \
                    'currentDestStack':ret[3], 'currentPosition':position, 'newSplitRecord':None, \
                    'isSlotPackage':False}

def weapEquipment(fromPack, idInFromPack, toPosition, itemId, characterId):
    '''穿上装备'''
    delSql = "delete from `%s` where id=%d" % (fromPack, idInFromPack)
    updateSql = "update `equipment_slot` set %s=%d where characterId=%d" % (toPosition, itemId, characterId)
    cursor = dbpool.cursor()
    cursor.execute(delSql)
    cursor.execute(updateSql)
    dbpool.commit()
    cursor.execute("select id from `item` where id=%d" % itemId)
    itemId = cursor.fetchone()[0]
    cursor.close()
    return itemId

def exchangeItem(fromPack, idInFromPack, fromPosition, toPosition, itemId, equipedItemId, characterId):
    '''装备栏和包裹蓝之间装备互换'''
    sql1 = "update `%s` set itemId=%d,stack=1 where id=%d" % (fromPack, equipedItemId, idInFromPack)
    sql2 = "update `equipment_slot` set %s=%d where characterId=%d" % (toPosition, itemId, characterId)
    cursor = dbpool.cursor()
    cursor.execute(sql1)
    cursor.execute(sql2)
    dbpool.commit()
    cursor.close()
    return idInFromPack, equipedItemId

def deletePackageItem(id, itemId, packageType, bodyType, characterId):
    '''删除物品相关记录'''
    cursor = dbpool.cursor()
    if id <> -1:
        if packageType == 'equipment_slot':
            sql1 = "update `%s` set %s=-1 where characterId=%d" % (packageType, bodyType, characterId)
        else:
            sql1 = "delete from `%s` where id=%d" % (packageType, id)
    else:
        sql1 = ''
    selectQuest = "select * from `quest_record` where characterId=%d and itemBonus =%d" % (characterId, itemId)
    result = cursor.execute(selectQuest)
#    if result == 0:
#        sql2 = "delete from `item` where id=%d" % itemId
#        cursor.execute(sql2)
    cursor.execute(sql1)
    dbpool.commit()
    cursor.close()

def deleteCollectionQuestItems(itemTemplateId, characterId, count):
    '''删除玩家收集任务物品'''
    sql1 = "select id from `item` where characterId=%d and itemTemplateId=%d" % (characterId, itemTemplateId)
    cursor = dbpool.cursor()
    cursor.execute(sql1)
    itemIds = cursor.fetchall()
    for itemId in itemIds:
        itemId = itemId[0]
        try:
            sql2 = "delete from `package` where itemId=%d" % itemId
            cursor.execute(sql2)
            sql2 = "delete from `temporary_package` where itemId=%d" % itemId
            cursor.execute(sql2)
        except:
            pass
#        sql3 = "delete from `item` where id=%d" % itemId
#        cursor.execute(sql3)
        dbpool.commit()

def getCollectionQuestItemCount(itemTemplateId, characterId):
    '''获取玩家收集任务物品'''
    sql = "select id from `item` where characterId=%d and itemTemplateId=%d" % (characterId, itemTemplateId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    count = 0
    itemIdList = cursor.fetchall()
    for item in itemIdList:
        itemId = item[0]
        stack = 0
        sql1 = "select stack from `package` where itemId=%d" % itemId
        cursor.execute(sql1)
        result = cursor.fetchone()
        if result:
            stack = result[0]
        else:
            sql2 = "select stack from `temporary_package` where itemId=%d" % itemId
            cursor.execute(sql2)
            result = cursor.fetchone()
            if result:
                stack = result[0]
        count += stack
    cursor.close()
    return count

'''-----------------------------------------------------玩家装备栏信息-----------------------------------------'''

def getPlayerItemsInEquipmentSlot(characterId):
    '''得到玩家装备栏中物品id'''
    sql = "select id from `equipment_slot` where characterId=" + str(characterId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    if len(result) >= 1:
        return result[0]
    else:
        return []

def getDetailsInEquipmentSlot(characterId):
    '''获取玩家装备物品信息'''
    sql = "select * from `equipment_slot` where characterId=" + str(characterId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    if len(result) >= 1:
        return result[0]
    else:
        return []

'''-----------------------------------------------------玩家包裹栏信息-------------------------------------------'''
def getItemInPackage(id):
    '''得到玩家装备栏中某个物品'''
    sql = "select id,itemId,position,stack from `package` where id=" + str(id)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def getItemInPackageByItemId(id, itemId):
    '''根据物品id得到玩家包裹栏中某个物品'''
    sql = "select * from `package` where characterId=%d and itemId=%d" % (id, itemId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def getPlayerItemsInPackage(characterId):
    '''得到玩家装备栏中物品'''
    sql = "select id,itemId,position,stack from `package` where characterId=" + str(characterId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def insertRecordInPackage(list):
    '''包裹蓝中增加记录'''
    sql = "insert into package values("
    sql = util.generateInsertSql(sql, list)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.execute("select id,itemId,position,stack from `package` where id=LAST_INSERT_ID()")
    result = cursor.fetchone()
    cursor.close()
    return result

def deleteRecordInPackage(id, itemId):
    '''删除包裹栏中物品信息'''
    sql1 = "delete from `package` where id=%d" % id
#    sql2 = "delete from `item` where id=%d" % itemId
    cursor = dbpool.cursor()
    cursor.execute(sql1)
#    cursor.execute(sql2)
    dbpool.commit()
    cursor.close()

def updateRecordInPackage(id, attrs):
    '''修改包裹栏物品信息'''
    sql = 'update `package` set'
    sql = util.forEachUpdateProps(sql, attrs)
    sql += " where id=%d" % id
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

'''-----------------------------------------------------玩家临时包裹栏信息-------------------------------------------'''
def getItemInTempPackage(id):
    '''得到玩家装备栏中物品'''
    sql = "select id,itemId,position,stack from `temporary_package` where id=" + str(id)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def getItemInTempPackageByItemId(id, itemId):
    '''根据物品id得到玩家装备栏中某个物品'''
    sql = "select * from `temporary_package` where characterId=%d and itemId=%d" % (id, itemId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def getPlayerItemsInTempPackage(characterId):
    '''得到玩家装备栏中物品'''
    sql = "select id,itemId,position,stack from `temporary_package` where characterId=" + str(characterId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def insertRecordInTempPackage(list):
    '''临时包裹蓝中增加记录'''
    sql = "insert into `temporary_package` values("
    sql = util.generateInsertSql(sql, list)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    return None

def deleteItemsInTemPackage(itemId, idInPackage, characterId):
    '''删除临时包裹栏中物品'''
    cursor = dbpool.cursor()
    sql1 = "delete from `temporary_package` where id=%d" % idInPackage
    cursor.execute(sql1)
    selectQuest = "select * from `quest_record` where characterId=%d and itemBonus =%d" % (characterId, itemId)
    result = cursor.execute(selectQuest)
#    if result == 0:
#        sql2 = "delete from `item` where id=%d" % itemId
#        cursor.execute(sql2)
    dbpool.commit()
    cursor.close()
    return True

'''-------------------------------------------------任务信息---------------------------------------------------'''
def getQuestRecordsTemlate(characterId):
    '''获取玩家任务记录模版id'''
    sql = "select questtemplateId from `quest_record` where characterId=%d" % characterId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    templateIdList = []
    for elm in result:
        templateIdList.append(elm[0])
    return templateIdList

def getQuestRecordById(id):
    '''根据id查找任务'''
    sql = "select * from `quest_record` where id=%d " % id
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def getQuestTemplateByQuestId(id):
    '''根据id查找任务模版id'''
    sql = "select questtemplateId from `quest_record` where id=%d " % id
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result[0]

def getQuestCountByTemplateId(characterId, templateId):
    '''根据模版id获取符合条件的任务数目'''
    sql = "select count(*) from `quest_record` where status=0 and characterId=%d and questtemplateId=%d" % (characterId, templateId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result[0][0]

def getQuestByTemplateId(characterId, templateId):
    '''根据模版id获取符合条件的信息'''
    sql = "select * from `quest_record` where characterId=%d and questtemplateId=%d order by id desc" % (characterId, templateId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    if len(result) > 0:
        return result[0]
    else:
        return None

def getProgressingRecords(characterId):
    '''获取进行中任务'''
    sql = "select * from `quest_record` where characterId=%d and status=0" % characterId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def getFinishedRecords(characterId):
    '''获取已完成任务'''
    sql = "select * from `quest_record` where characterId=%d and status=1 order by id desc limit 0,20" % characterId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def getActiveRewardQuest(characterId):
    '''获取玩家当天已经申领的赏金任务数量'''
    now = str(datetime.datetime.today().year) + "-"
    now += str(datetime.datetime.today().month) + "-"
    now += str(datetime.datetime.today().day)
    cursor = dbpool.cursor()
    cursor.execute("select questtemplateId from `quest_record` where characterId = " + str(characterId)\
                             + " and date(applyTime) = '" + now + "'")
    result = list(cursor.fetchall())
    cursor.close()
    for quest in result:
        type = loader.getById('quest_template', quest[0], ['type'])['type']
        if int(type) != 2:
            result.remove(quest)
    return len(result)

def getQuestGoalProgressesForQuest(questId):
    '''获取某个任务的任务目标进度'''
    sql = "select * from `quest_goal_progress` where questRecordId=%d" % questId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def updateQuestRecordByTemplateId(templateId, attrs):
    '''根据模版id更新任务记录'''
    sql = "update `quest_record` set"
    sql = util.forEachUpdateProps(sql, attrs)
    sql += " where questtemplateId=%d" % templateId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def insertRecordForApplyQuest(characterId, questtemplateId, itemId):
    '''申领任务时，增加相应记录'''
    insertSql = "insert into `quest_record`(id,questtemplateId,characterId,applyTime,status,itemBonus) values(%d,%d,%d,'%s',%d,%d)" % (0, questtemplateId, characterId, \
                                                                           str(datetime.datetime.now()), \
                                                                           0, itemId)
    cursor = dbpool.cursor()
    cursor.execute(insertSql)
    dbpool.commit()

    cursor.execute("select id from `quest_record` where id=LAST_INSERT_ID()")
    recordId = cursor.fetchone()[0]

    loaderCursor = connection.cursor()
    loaderCursor.execute("select id from `questgoal` where questId=%d" % questtemplateId)
    questgoals = loaderCursor.fetchall()
    loaderCursor.close()

    for questgoal in questgoals:
        goalId = questgoal['id']
        sql = "insert into `quest_goal_progress` values(%d,%d,%d,%d,%d,%d)" % (0, recordId, goalId, 0, 0, 0)
        cursor.execute(sql)
    dbpool.commit()
    cursor.close()

    return recordId

def operateForCommitQuest(questId, characterId):
    '''提交任务，操作数据库'''
    cursor = dbpool.cursor()
    updateSql = "update `quest_record` set finishTime='%s',status=%d where id=%d" % (str(datetime.datetime.now()), 1, questId)
    delSql = "delete from `quest_goal_progress` where questRecordId=%d" % questId
    cursor.execute(updateSql)
    cursor.execute(delSql)
    dbpool.commit()
    cursor.close()

def updateTempActiveRewardQuestByQuestTemplateId(templateId, characterId, attrs):
    '''根据quest id修改active_reward_quest中记录'''
    sql = 'update `active_reward_quest` set'
    sql = util.forEachUpdateProps(sql, attrs)
    sql += " where questTemplateId=%d and characterId=%d" % (templateId, characterId)
#    print sql
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    return None

def getPlayerTempActiveRewardQuests(characterId):
    '''获取玩家的activef_reward_quest中记录'''
    sql = "select * from `active_reward_quest` where characterId=%d" % characterId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def updateQuestgoalProgress(questRecordId, questGoalId, props):
    '''更新quest_goal_progress'''
    sql = "update `quest_goal_progress` set"
    sql = util.forEachUpdateProps(sql, props)
    sql += " where questRecordId=%d and questGoalId=%d" % (questRecordId, questGoalId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def insertActiveRewardQuest(props):
    '''增加active_reward_quest记录'''
    sql = "insert into `active_reward_quest` values("
    sql = util.generateInsertSql(sql, props)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def getQuestRecordOfToday(characterId):
    '''得到玩家当天的任务记录'''
    now = datetime.datetime.now()
    year = now.year
    month = now.month
    day = now.day
    dateStr = str(year) + "-" + str(month) + "-" + str(day)
    sql = "select * from `quest_record` where characterId=%d and date(applyTime)='%s'" % (characterId, dateStr)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def deleteUnLockedActiveRewardQuests(characterId):
    '''删除玩家未锁定的赏金任务（即不是进行中任务）'''
    cursor = dbpool.cursor()

    cursor.execute("select sequence,questTemplateId from `active_reward_quest` where characterId=%d and isLock=0" % characterId)
    query = cursor.fetchall()
    sequenceList = []
    for elm in query:
#        selectSql = "select itemId from `quest_temp_item` where characterId = %d and questTemplateId=%d" % (characterId, int(elm[1]))
#        cursor.execute(selectSql)
#        result = cursor.fetchone()
#        if result:
#            deleteSql = "delete from `item` where id=%d" % (result[0])
#            cursor.execute(deleteSql)
#            dbpool.commit()
        deleteSql = "delete from `quest_temp_item` where characterId = %d and questTemplateId=%d" % (characterId, int(elm[1]))
        cursor.execute(deleteSql)
        dbpool.commit()
        sequenceList.append(elm[0])

    deleteSql = "delete from `active_reward_quest` where characterId = %d and isLock=0" % characterId
    cursor.execute(deleteSql)
    dbpool.commit()

    querySql = "select questTemplateId from `active_reward_quest` where characterId=%d" % characterId
    cursor.execute(querySql)
    result = cursor.fetchall()
    list = []
    for elm in result:
        list.append(elm[0])
    return list, sequenceList

def getPlayerQuestRoomInfo(characterId):
    '''获取玩家进入赏金组织信息'''
    sql = "select * from `character_quest_room` where characterId=%d" % characterId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def insertPlayerQuestRoomInfo(characterId, date):
    '''添加玩家进入赏金组织记录'''
    sql = "insert into `character_quest_room` values(0,%d,'%s')" % (characterId, date)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def updatePlayerEnterQuestRoomTime(characterId, date):
    '''更新玩家进入赏金组织时间'''
    sql = "update `character_quest_room` set enterTime='%s' where characterId=%d" % (date, characterId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def insertQuestTempItem(id, questTemplateId, tiemID):
    '''任务奖励物品临时存放表'''
    sql = "insert into `quest_temp_item` values(0,%d,%d,%d)" % (id, questTemplateId, tiemID)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def selectQuestItem(id, questTemplateId):
    sql = "select itemId,id from `quest_temp_item` where characterId=%d and questTemplateId=%d" % (id, questTemplateId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def deleteQuestItem(id):
    sql = "delete from `quest_temp_item` where id=%d" % (id)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

'''-------------------------------------------------战斗信息---------------------------------------------------'''
def saveBattleRecordAndBattleEvents(props, events):
    '''保存战斗记录和战斗事件记录'''
    sql = "insert into `battle_record` values("
    sql = util.generateInsertSql(sql, props)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.execute("select id from `battle_record` where id=LAST_INSERT_ID()")
    battleRecord = cursor.fetchone()[0]
    for event in events:
        event.insert(0, 0)#插入流水id，数据库中
        event.insert(1, battleRecord)
        eachSql = "insert into `battle_event` values("
        eachSql = util.generateInsertSql(eachSql, event)
        cursor.execute(eachSql)
    dbpool.commit()
    cursor.close()

def getLastInsertedBattleRecord():
    '''得到最近插入的战斗记录'''
    sql = 'select * from `battle_record` where id=LAST_INSERT_ID()'
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def getPlayerLastBattleRecord(id):
    '''得到玩家最近的战斗记录'''
    id = str(id)
    sql = "select * from `battle_record` where party1Id like '%%%s%%' or party2Id like '%%%s%%' order by id desc limit 0,1" % (id, id)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def getBattleEventsByRecord(battleRecordId):
    '''获取战斗记录的所有事件记录'''
    sql = "select second,type,originator,content from `battle_event` where battleRecord=%d" % battleRecordId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result


def saveBattleRecord(playerid, data):
    '''保存战斗记录和战斗事件记录'''
    content = util.tranverseObjectToPickleStr(data)
    sql = '''insert into `battle_record2` values(0,%d,"%s")''' % (playerid, content)
#    print sql
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def getLastBattleRecord(playerid):
    '''得到最近插入的战斗记录'''
    sql = 'select * from `battle_record2` where playerId = %d order by id desc limit 0, 1' % playerid
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

'''-------------------------------------------------技能信息---------------------------------------------------'''
def getLearnedSkills(characterId):
    '''得到玩家已经修炼的技能记录'''
    sql = "select * from `character_skill` where characterId=%d" % characterId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def getLearnedSkillRecord(characterId, skillId):
    '''得到玩家已经修炼的特定技能记录'''
    sql = "select * from `character_skill` where characterId=%d and skillId=%d" % (characterId, skillId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    if len(result) == 0:
        result = None
    else:
        result = result[0]
    cursor.close()
    return result

def insertForLearnSkill(insertProps):
    '''学习技能，插入新技能记录'''
    sql = "insert into `character_skill` values("
    sql = util.generateInsertSql(sql, insertProps)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def updateSkillLevelForLearnSkill(id, props):
    '''学习技能时，已经修炼该技能，则跟新技能级别'''
    sql = 'update `character_skill` set'
    sql = util.forEachUpdateProps(sql, props)
    sql += " where id=%d" % id
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def getSkillSettings(characterId):
    '''获得技能设置'''
    sql = "select * from `character_skill_settings` where characterId=%d" % (characterId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def interSkillSettings(props):
    '''插入技能设置记录'''
    sql = "insert into `character_skill_settings` values("
    sql = util.generateInsertSql(sql, props)
    cursor = dbpool.cursor()
    reslut = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    return reslut

def updataSkillSettings(props):
    '''更新技能设置记录'''
    sql = 'update `character_skill_settings` set'
    sql = util.forEachUpdateProps(sql, props)
    sql += " where characterId=%d" % (props[1])
    cursor = dbpool.cursor()
    reslut = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    return reslut

'''-------------------------------------------------效果信息---------------------------------------------------'''
def getEffectInstance(characterId, effectGroupId):
    '''获取效果实例'''
    sql = "select * from `effect_instance` where characterId=%d and effectGroupId=%d \
    order by effectLevel" % (characterId, effectGroupId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def getAllEffectInstances(characterId):
    ''''''
    sql = "select * from `effect_instance` where characterId=%d" % characterId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def getEffectCount(characterId, triggerType):
    '''根据触发类型获得玩家效果实例的数量'''
    sql = "select count(id) from `effect_instance` where characterId=%d and triggerType=%d"\
    % (characterId, triggerType)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result[0][0]

def insertEffectInstance(props):
    '''插入效果实例'''
    sql = "insert into `effect_instance` values("
    sql = util.generateInsertSql(sql, props)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    querySql = "select * from `effect_instance` where id=LAST_INSERT_ID()"
    cursor.execute(querySql)
    lastInsert = cursor.fetchone()
    cursor.close()
    return lastInsert

def updateEffectInstance(id, props):
    '''修改效果实例'''
    sql = "update `effect_instance` set"
    sql = util.forEachUpdateProps(sql, props)
    sql += " where id=%d" % id
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def deleteEffectInstanceById(id):
    '''根据id删除效果实例'''
    sql = "delete from `effect_instance` where id=%d" % id
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def deleteEffectInstance(characterId, effectId):
    '''删除玩家特定效果id的效果实例'''
    sql = "delete from `effect_instance` where characterId=%d and effectId=%d" % (characterId, effectId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def getCurrentSkillEffectInstances(characterId):
    '''获取当前持续效果技能效果'''
    sql = "select * from `effect_instance` where characterId=%d and triggerType=2" % characterId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return list(result)

def getCurrentItemEffectInstances(characterId):
    '''获取当前持续物品效果'''
    sql = "select * from `effect_instance` where characterId=%d and triggerType=1" % characterId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return list(result)

'''-------------------------------------------------宿屋信息---------------------------------------------------'''
def getPlayerRestRecord(characterId):
    '''获取玩家当天的宿屋各种操作的次数'''
    sql = "select * from `character_rest` where characterId = %d" % characterId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def resetPlayerRestCount():
    '''置0玩家的宿屋操作次数'''
    sql = "update `character_rest` set napCount=0,lightSleepCount=0,peacefulSleepCount=0,spoorCount=0"
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def updatePlayerRestRecord(characterId, props):
    '''修改玩家宿屋操作记录'''
    sql = "update `character_rest` set"
    sql = util.forEachUpdateProps(sql, props)
    sql += " where characterId = %d" % characterId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

'''-------------------------------------------------大厅信息---------------------------------------------------'''
def getPlayerLobbyRecord(characterId):
    '''获取玩家大厅记录'''
    sql = "select * from `character_lobby` where characterId = %d" % characterId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def updatePlayerLobbyRecord(characterId, props):
    '''修改玩家大厅记录'''
    sql = "update `character_lobby` set"
    sql = util.forEachUpdateProps(sql, props)
    sql += " where characterId = %d" % characterId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()
'''-------------------------------------------------怪物修炼---------------------------------------------------'''
def getPlayerPracticeRecord(characterId):
    '''获取玩家修炼记录'''
    sql = "select * from `character_practice` where characterId = %d" % characterId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def updatePlayerPracticeRecord(characterId, props):
    '''修改玩家修炼记录'''
    sql = "update `character_practice` set"
    sql = util.forEachUpdateProps(sql, props)
    sql += " where characterId = %d" % characterId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

'''-------------------------------------------------商店---------------------------------------------------'''
def getPlayerShopRecord(characterId, placeId):
    '''获取玩家进入指定商店记录'''
    sql = "select * from `character_shop` where characterId=%d and shopId=%d" % (characterId, placeId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def insertPlayerShopRecord(props):
    '''插入进入商店记录'''
    sql = "insert into `character_shop` values("
    sql = util.generateInsertSql(sql, props)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def updatePlayerEnterShopTime(characterId, shopId, time):
    '''更新玩家进入指定商店时间'''
    sql = "update `character_shop` set enterTime='%s' where characterId=%d and shopId=%d" % (time, characterId, shopId)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

'''-------------------------------------------------好友、仇敌---------------------------------------------------'''
def getPlayerFriends(characterId):
    '''获取玩家好友、仇敌'''
    sql = "select c.id,c.name,c.nickName,c.level,c.camp,c.profession,cf.id,cf.type,cf.isSheildedMail from `character` as c ,`character_friend` as cf where c.id = cf.playerId and  c.id in (select playerId from `character_friend` where characterId=%d)" % characterId
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def insertPlayerFriendRecord(props):
    '''添加玩家好友记录'''
    cursor = dbpool.cursor()
    querySql = "select type from `character_friend` where characterId=%d and playerId =%d" % (props[1], props[2])
    cursor.execute(querySql)
    record = cursor.fetchone()
    if record:
        if record[0] == props[3]:
            return False, record
        else:
            sql = "update `character_friend` set type='%d',isSheildedMail='%d' where characterId=%d and playerId=%d" % (props[3], props[4], props[1], props[2])
            cursor = dbpool.cursor()
            cursor.execute(sql)
            dbpool.commit()
            querySql = "select c.id,c.name,c.nickName,c.level,c.camp,c.profession,cf.id,cf.type,cf.isSheildedMail from `character` as c ,`character_friend` as cf where c.id = cf.playerId and c.id=(select playerId from `character_friend` where characterId=%d and playerId =%d)" % (props[1], props[2])
            cursor.execute(querySql)
            result = cursor.fetchone()
            cursor.close()
            return True, result
    else:
        sql = "insert into `character_friend` values("
        sql = util.generateInsertSql(sql, props)
        cursor.execute(sql)
        dbpool.commit()
        querySql = "select c.id,c.name,c.nickName,c.level,c.camp,c.profession,cf.id,cf.type,cf.isSheildedMail from `character` as c ,`character_friend` as cf where c.id = cf.playerId and c.id=(select playerId from `character_friend` where id= LAST_INSERT_ID())"
        cursor.execute(querySql)
        result = cursor.fetchone()
        cursor.close()
        return True, result

def deletePlayerFriendRecord(id):
    '''删除玩家好友记录'''
    cursor = dbpool.cursor()
    sql = "delete from `character_friend` where id=%d " % (id)
    result = cursor.execute(sql)
    dbpool.commit()
    if result > 0:
        return True
    else:
        return False

def updataSheildedMail(id, isSheildMail):
    ''''修改邮件屏蔽功能'''
    sql = "update `character_friend` set isSheildedMail='%d' where id=%d" % (isSheildMail, id)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    return True

def getPlayerIdByNickName(nickName):
    '''根据用户名昵名获取id'''
    cursor = dbpool.cursor()
    sql = "select id from `character` where nickName='%s'" % nickName
    cursor.execute(sql)
    result = cursor.fetchone()
    if not result:
        return None
    else:
        return result

'''-----------------------------------------------------邮件-----------------------------------------------'''
def insertMail(props):
    '''添加邮件'''
    cursor = dbpool.cursor()
    sql = "select * from `character_friend` where characterId='%d' and playerId='%d' and type=2 and isSheildedMail=1" % (props[2], props[1])
    cursor.execute(sql)
    isSendMail = cursor.fetchone()
    result = 0
    if not isSendMail:
        sql = "insert into `mail` values("
        sql = util.generateInsertSql(sql, props)
        result = cursor.execute(sql)
        dbpool.commit()
    cursor.close()
    if result >= 1:
        return True
    else:
        return False

def getMailList(id):
    '''获取玩家所有邮件'''
    cursor = dbpool.cursor()

    sql = "select a.*,ifnull(b.id,0) as isFriend from `mail` a left join `character_friend` b on (a.senderId=b.playerId and a.receiverId = b.characterId) where a.receiverId = '%d' or a.type = 4" % id
    cursor.execute(sql)
    result = cursor.fetchall()
    sql = "update `mail` set isReaded=1 where receiverId=%d" % (id)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if not result:
        return None
    else:
        return result

def deleteMail(id):
    cursor = dbpool.cursor()
    sql = "delete from `mail` where id=%d " % (id)
    result = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if result > 0:
        return True
    else:
        return False

def isNewMail(id):
    cursor = dbpool.cursor()
    sql = "select * from `mail` where receiverId=%d and isReaded=0" % (id)
    result = cursor.execute(sql)
    cursor.close()
    if result > 0:
        return True
    else:
        return False

'''-------------------------------------------------副本---------------------------------------------------'''
def getPlayerInstanceProgressRecord(characterId):
    '''获取玩家副本进度记录'''
    cursor = dbpool.cursor()
    sql = "select * from `character_instance` where characterId=%d" % characterId
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def insertPlayerInstanceProgressRecord(props):
    '''插入玩家副本进度'''
    cursor = dbpool.cursor()
    sql = "insert into `character_instance` values("
    sql = util.generateInsertSql(sql, props)
    cursor.execute(sql)
    dbpool.commit()
    cursor.execute("select * from `character_instance` where id = LAST_INSERT_ID()")
    result = cursor.fetchone()
    cursor.close()
    return result

def deletePlayerInstanceProgressRecord(id):
    '''修改玩家副本进度'''
    cursor = dbpool.cursor()
    sql = 'delete from `character_instance` where characterId=%d' % id
    result = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if result >= 1:
        return True
    else:
        return False

def updatePlayerInstanceProgressRecord(attrs, id):
    '''修改玩家副本进度'''
    cursor = dbpool.cursor()
    sql = 'update `character_instance` set'
    sql = util.forEachUpdateProps(sql, attrs)
    sql += " where characterId=%d" % id
    result = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if result >= 1:
        return True
    else:
        return False
'''-------------------------------------------------组队---------------------------------------------------'''
def getPlayerTeamRecord(id):
    '''获取关于玩家组队记录'''
    sql = "select * from `team` where member1=%d or member2=%d or member3=%d" % (id, id, id)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def insertPlayerTeamRecord(launcherId):
    '''插入玩家组队记录'''
    cursor = dbpool.cursor()
    sql = "insert into `team` values(0,%d,%d,%d,%d,%d,%d,%d)" % (launcherId, 1, -1, 1, -1, 1, launcherId)
    result = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if result >= 1:
        return True
    else:
        return False

def updatePlayerTeamRecord(id, attrs):
    '''更新玩家组队记录'''
    sql = "update `team` set"
    sql = util.forEachUpdateProps(sql, attrs)
    sql += " where member1=%d or member2=%d or member3=%d" % (id, id, id)
    cursor = dbpool.cursor()
    result = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if result >= 1:
        return True
    else:
        return False

def deletePlayerTeamRecord(id):
    '''删除玩家组队记录'''
    sql = "delete from `team` where leader=%d" % id
    cursor = dbpool.cursor()
    result = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if result >= 1:
        return True
    else:
        return False

def confirmJoin(id, launcherId, type):
    '''确认加入'''
    cursor = dbpool.cursor()
    cursor.execute("select * from `team` where leader=%d" % launcherId)
    record = cursor.fetchone()
    if record:
        if record[3] <> -1 and record[5] <> -1:
            return False, u'队伍已满'
        if record[3] == -1:
            sql = "update `team` set member2=%d,member2Type=%d where leader=%d" % (id, type, launcherId)
        else:
            sql = "update `team` set member3=%d,member3Type=%d where leader=%d" % (id, type, launcherId)
        result = cursor.execute(sql)
        dbpool.commit()
        if result >= 1:
            return True, ''
        else:
            return False, '加入失败'
    else:
        return False, '没有找到相应的队伍'

    ########################

def getTeamInfomation(id):
    cursor = dbpool.cursor()
    cursor.execute("select leader, member1, member1Type, member2, member2Type, member3, member3Type from `team` where team.id = %d" % id)
    record = cursor.fetchone()
    cursor.close()
    if record is None:
        return None
    ret = {}
    ret["leader"] = record[0]
    ret[1] = (record[1], record[2])
    ret[2] = (record[3], record[4])
    ret[3] = (record[5], record[5])
    return ret

def addTeamMember(teamID, info):#info = {"id":playerID, "type":personType}}
    cursor = dbpool.cursor()
    cursor.execute("select member1, member2, member3 from `team` where id=%d" % teamID)
    record = cursor.fetchone()
    if not record:
        cursor.close()
        return False, "队伍不存在"
    pos = None
    if record[0] == 0:
        pos = ("member1", "member1Type")
    elif record[1] == 0:
        pos = ("member2", "member2Type")
    elif record[2] == 0:
        pos = ("member3", "member3Type")
    if pos is None:
        cursor.close()
        return False, "数据库中信息已满"
    sql = "update `team` set %s=%d, %s=%d where id=%d" % (pos[0], info["id"], pos[1], info["type"], teamID)
    ret = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if ret >= 1:
        return True, None
    else:
        return False, '数据库中加入玩家信息失败'

def setTeamLeader(teamID, playerID):
    cursor = dbpool.cursor()
    cursor.execute("select * from `team` where id=%d" % teamID)
    record = cursor.fetchone()
    if record[1] != playerID and record[3] != playerID and record[5] != playerID:
        cursor.close()
        return False, "数据库组队信息记录中没有该玩家 %d" % playerID
    ret = cursor.execute("update `team` set leader=%d where id=%d" % (playerID, teamID))
    dbpool.commit()
    cursor.close()
    if ret >= 1:
        return True, None
    return False, "更改队伍中队长信息失败"

def createNewTeam():
    sql = 'insert into `team` values(NULL, 0, 1, 0, 1, 0, 1, NULL)'
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    sql = "select id from `team` where id=LAST_INSERT_ID()"
    cursor.execute(sql)
    record = cursor.fetchone()
    cursor.close()
    if record:
        return record[0]
    else:
        return 0

def updateCharacterTeamInfo(id, teamID):
    sql = "update `character` set teamID=%d where id=%d" % (teamID, id)
    cursor = dbpool.cursor()
    ret = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if ret >= 1:
        return True, None
    return False, "Character Table teamID update fail"

def disbandTeam(id):
    sql = "delete from `team` where id=%d" % id
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

def kickOneOutTeam(teamID, playerID):
    cursor = dbpool.cursor()
    cursor.execute("select member1, member2, member3, leader from `team` where id=%d" % teamID)
    record = cursor.fetchone()
    if not record:
        cursor.close()
        return False, "找不到数据库中的组队信息"
    else:
        if record[3] == playerID:
            cursor.close()
            return False, "队长不能将自己T出队伍"
        pos = None
        if record[0] == playerID:
            pos = ("member1", "member1Type")
        elif record[1] == playerID:
            pos = ("member2", "member2Type")
        elif record[2] == playerID:
            pos = ("member3", "member3Type")
        if pos is None:
            cursor.close()
            return True, "玩家不在队伍中"
        ret = cursor.execute("update `team` set %s=%d, %s=%d where id=%d" % (pos[0], 0, pos[1], 1, teamID))
        player = PlayersManager().getPlayerByID(playerID)
        if player is None:
            cursor.execute("update `character` set teamID=0 where id=%d" % playerID)
        else:
            player.teamcom.resetMyTeam(0)
            player.teamcom.updateCharacterTeamInfomation()
        dbpool.commit()
        cursor.close()
        if ret >= 1:
            return True, None
        else:
            return False, "Kick out False"
        return False, '没有找到相应的队伍'

def sortTeamMembers(teamID, infolist):
    assert len(infolist) <= 3
    assert len(infolist) >= 2
    while True:
        if len(infolist) < 3:
            infolist.append({"id":0, "type":1})
        else:
            break

    def formatlist(lst, max = 3):
        values = []
        for i in range(len(lst)):
            values.append("member%d=%d,member%dType=%d" % (i + 1, lst[i]["id"], i + 1, lst[i]["type"]))
        has = len(values)
        elapse = max - has
        if elapse > 0:
            for i in range(elapse):
                values.append("member%d=%d,member%dType=%d" % (i + has + 1, 0, i + has + 1, 1))
        return ','.join(values)
    sql = "update `team` set %s where id=%d" % (formatlist(infolist), teamID)
    cursor = dbpool.cursor()
    ret = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if ret >= 1 :
        return True, None
    else:
        return False, "sortTeamMembers Error"

'''-------------------------------------------------招募---------------------------------------------------'''
def getPlayerRecruitedNPCMembersInfo(id):
    '''根据玩家ID获取玩家所招募的NPC信息'''
    cursor = dbpool.cursor()
    sql = "select recruitmembers from `character` where id=%d" % id
    cursor.execute(sql)
    record = cursor.fetchone()
    if record:
        return record[0]
    else:
        return None

def updatePlayerRecruitedNPCMembersInfo(id, text):
    '''根据玩家ID更新玩家所招募的NPC信息'''
    cursor = dbpool.cursor()
    sql = "update `character` set recruitmembers=%s where id=%d" % (text, id)
    ret = cursor.execute(sql)
    dbpool.commit()
    if ret >= 1:
        return True, None
    else:
        return False, "Error, updatePlayerRecruitedNPCMembersInfo"

'''-------------------------------------------------仓库---------------------------------------------------'''
def getWarehousePackage(id, packageCounts):
    '''得到玩家装备栏中物品'''
    sql = "select id,itemId,position,stack from `warehouse_package` where characterId='%d' and packageCounts='%d'" % (id, packageCounts)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def updataDeposit(id, coin, deposit):
    sql = "update `character` set coin='%d', deposit='%d' where id=%d" % (coin, deposit, id)
    cursor = dbpool.cursor()
    result = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if result >= 1:
        return True
    else:
        return False

'''------------------------------------------------锻造------------------------------------------'''
def getForgingPackage(id):
    sql = "select id,itemId,position,stack from `forging_package` where characterId='%d'" % (id)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchall()
    cursor.close()
    return result

def deleteUpgradeItem(id, counts):
    if counts == 1:
#        sql = 'delete from `item` where id=%d' % (id)
#        cursor = dbpool.cursor()
#        cursor.execute(sql)
#        dbpool.commit()
#        cursor.close()
        sql = 'delete from `forging_package` where itemId=%d' % (id)
        cursor = dbpool.cursor()
        cursor.execute(sql)
        dbpool.commit()
        cursor.close()
    else:
        sql = "update `forging_package` set stack='%d' where itemId=%d" % (counts - 1, id)
        cursor = dbpool.cursor()
        cursor.execute(sql)
        dbpool.commit()
        cursor.close()

def updataForgingPackage(id, itemLevel):
    sql = "update `item` set itemLevel='%d' where id=%d" % (itemLevel, id)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    dbpool.commit()
    cursor.close()

'''------------------------------------------------职业选择--------------------------------------------------'''
def updatePlayerProfession(pid, id):
    cursor = dbpool.cursor()
    sql = "update `character` set profession=%d where id=%d" % (pid, id)
    count = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if(count >= 1):
        return True
    else:
        return False

'''---------------------------------------------新手武器-------------------------------------------'''
def giveNewPlayerWeapon(id, wid):
    cursor = dbpool.cursor()
    sql = "insert `item` set characterId=%d,itemTemplateId=%d" % (id, wid)
#    print '-----------------------item-------------------'
#    print sql
    count = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if(count >= 1):
        return True
    else:
        return False

def getNewPlayerWeapon(id, tid):
    sql = "select id from `item` where characterId=%d and itemTemplateId = %d" % (id, tid)
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result[0]


def setWeaponToPackage(id, itemId, position):
    cursor = dbpool.cursor()
    sql = "insert `package` set characterId=%d,itemId=%d,position='%s'" % (id, itemId, position)
    count = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if(count >= 1):
        return True
    else:
        return False

def isSendBefore(id, tid):
    sql = "select id from `package` where characterId=%d and itemId = %d" % (id, getNewPlayerWeapon(id, tid))
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result

def setHasKilledMonster(id, isKilled):
    cursor = dbpool.cursor()
    sql = "update `character` set isKilledMonster=%d where id=%d" % (isKilled, id)
    count = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if(count >= 1):
        return True
    else:
        return False

def getHasKilledMonster(id):
    sql = "select isKilledMonster from `character` where id=%d " % id
    cursor = dbpool.cursor()
    cursor.execute(sql)
    result = cursor.fetchone()
    cursor.close()
    return result[0]

def testLevel(id):
    cursor = dbpool.cursor()
    sql = "update `character` set level=15 where id=%d" % (id)
    count = cursor.execute(sql)
    dbpool.commit()
    cursor.close()
    if(count >= 1):
        return True
    else:
        return False
