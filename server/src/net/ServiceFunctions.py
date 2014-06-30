#coding:utf8
'''
Created on 2009-12-6

@author: hanbing
'''

from MeleeSite import ServiceFunction, pushMessage

from util import dbaccess
from util.DataLoader import loader, connection
from core.Character import PlayerCharacter
#from core.Scene import Scene
from SceneUtil import *
from core.RegisterHandler import *
import datetime
import math
from twisted.internet import reactor
from core.playersManager import PlayersManager
from core.NewPlayerQuest import *

reactor = reactor

scenePlayers = {}#{'playerId':[]}玩家场景列表

def updateAllPlayers(delta):
    PlayersManager().update(delta)
    reactor.callLater(delta, updateAllPlayers, delta)

updateAllPlayers(0.5)
'''---------------------------------------------------------玩家注册-----------------------------------------------------'''
@ServiceFunction
def registerPlayerInfo(packet, message, username, password, email):
    '''注册用户信息'''
    if(addPlayer(username, password, email) == 0):
        return {'result':True, 'reason':'注册成功', 'data':{'username':username, 'password':password}}
    if(addPlayer(username, password, email) == 1):
        return {'result':False, 'reason':'注册失败，请重新注册', 'data':{'username':username, 'password':password}}
    if(addPlayer(username, password, email) == 2):
        return {'result':False, 'reason':'该用户名已存在，请重新注册', 'data':{'username':username, 'password':password}}

@ServiceFunction
def getVersion(packet, message):
    import MeleeServices
    return {'result':True, "data":MeleeServices.version}

@ServiceFunction
def acceptEnterCamp(packet, message, town, location, camp, id):
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':'invalid user id'}
    if(chooseCamp(town, location, camp, id)):
        player.camp.setCamp(camp)
        player.baseInfo.setLocation(location)
        player.baseInfo.setTown(town)
        return {'result':True, 'reason':'阵营选择成功', 'data':{'town':town, 'location':location, 'camp':camp, 'id':player.baseInfo.id, 'username':player.baseInfo.getName()}}
    else:
        return {'result':False, 'reason':'阵营选择失败，请重新选择'}

@ServiceFunction
def handlerProfession(packet, message, pid, id):
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':'invalid user id'}
    if(selectProfession(pid, id)):
        player.profession.setProfession(pid)
        return {'result':True, 'reason':'职业选择成功', 'data':{'id':id, 'username':player.baseInfo.getName()}}
    else:
        return {'result':False, 'reason':'职业选择失败，请重新选择'}

@ServiceFunction
def activeNewPlayer(packet, message, username, password, nickname, path, gender):
    if(createNewPlayer(username, password, nickname, path, gender)):
        record = dbaccess.getPlayerIdAndPasswordByName(username)
        id = int(record[0])
        if PlayersManager().getPlayerByID(id):
            return {'result':False, 'reason':u'该用户已经登陆'}
        else:
            player = PlayerCharacter(id, username, message)
            data = dbaccess._queryPlayerInfo(id)
            player.initPlayer(data)
            PlayersManager().addPlayer(player)
            return {'result':True, 'data':{'id':id, 'username':username}}
    else:
        return {'result':False, 'reason':'人物创建失败，请重新创建'}
'''--------------------------------------------------------角色信息--------------------------------------------'''

@ServiceFunction
def loginToServer(packet, message, userName, password):
    '''登陆验证玩家'''
#    try:
#        #connection_id = packet.channel.channel_set.connection_manager.generateId()
#        connection = 0#packet.channel.connect(connection_id)
#        print connection_id, 
#    except:
#        pass
    #clientID = message.response_msg.body.clientId
    if not userName or userName == u'' or userName == '':
        return {'result':False, 'reason':u'用户名不能为空'}
    if not password or password == u'' or password == '':
        return {'result':False, 'reason':u'密码不能为空'}
    if(isNeedCreatePlayer(userName, password)):
        return {'result':u'new'}
    record = dbaccess.getPlayerIdAndPasswordByName(userName)
    if record:
        if password == record[1]:
            #player
            id = int(record[0])
            player = PlayersManager().getPlayerByID(id)
            if player is not None:
                player.archiveInfo()
                PlayersManager().dropPlayer(player)
            playerNew = PlayerCharacter(id, userName, message)
            data = dbaccess._queryPlayerInfo(id)
            playerNew.initPlayer(data)
            PlayersManager().addPlayer(playerNew)
            return {'result':True, 'data':{'id':id}}
        else:
            return {'result':False, 'reason':u'用户民或密码错误'}
    else:
        return {'result':False, 'reason':u'用户名或密码错误'}

@ServiceFunction
def logoffServer(packet, message, id):
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    player.archiveInfo()
    PlayersManager().dropPlayer(player)
    return {'result':True, 'reason':None}

@ServiceFunction
def syncWithServer(k, v, id, time):
    ''''''
    try:
        PlayersManager().getPlayerByID(id).sync()
    except:
        return {"result":False, "reason":u'用户异常退出', "tag":u"logout"}
    return {'result':True, 'data':{'time':time}}

@ServiceFunction
def refresh(packet, message, id):
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    player.updateData()
    player.level.updateLevel()
    return {'result':True, 'reason':None}

@ServiceFunction
def getPlayerInfo(packet, message, id):
    '''
          获取玩家详细信息
    @param id：玩家id
    '''
    connection_id = packet.channel.channel_set.connection_manager.generateId()
    #print connection_id, connection_id, message
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    characterInfo = {}#玩家详细信息
    player.level.updateLevel()
    characterInfo['id'] = player.baseInfo.id
    characterInfo['name'] = player.baseInfo.getName()
    characterInfo['type'] = int(player.baseInfo.getType())
    characterInfo['baseStr'] = int(player.attribute.getBaseStr())
    characterInfo['baseVit'] = int(player.attribute.getBaseVit())
    characterInfo['baseDex'] = int(player.attribute.getBaseDex())
    characterInfo['manualStr'] = int(player.attribute.getManualStr())
    characterInfo['manualVit'] = int(player.attribute.getManualVit())
    characterInfo['manualDex'] = int(player.attribute.getManualDex())
    characterInfo['extraStr'] = int(player.attribute.getExtraStr())
    characterInfo['extraDex'] = int(player.attribute.getExtraDex())
    characterInfo['extraVit'] = int(player.attribute.getExtraVit())
    characterInfo['gender'] = int(player.baseInfo.getGender())
    characterInfo['sparePoint'] = int(player.attribute.getSparePoint())
    characterInfo['nickName'] = player.baseInfo.getNickName()
    characterInfo['portrait'] = player.baseInfo.getPortrait()
    characterInfo['level'] = int(player.level.getLevel())
    characterInfo['description'] = player.baseInfo.getDescription()
    characterInfo['status'] = player.baseInfo.getStatus()
    characterInfo['profession'] = player.profession.getProfessionName()
    characterInfo['professionDescription'] = player.profession.getProfessionDescription()
    characterInfo['allProfessionStages'] = player.profession.getAllProfessionStage()
    characterInfo['currentProfessionStageIndex'] = int(player.profession.getProfessionStage()) - 1

    characterInfo['maxHp'] = player.attribute.getMaxHp(player.profession.getProfession(), id, player.level.getLevel())
    characterInfo['hp'] = int(player.attribute.getHp())
    characterInfo['maxMp'] = player.attribute.getMaxMp(player.profession.getProfession(), id, player.level.getLevel())
    characterInfo['mp'] = int(player.attribute.getMp())
    characterInfo['exp'] = int(player.level.getExp())
    characterInfo['maxExp'] = int(player.level.getMaxExp())
    characterInfo['location'] = player.baseInfo.getLocation()
    characterInfo['town'] = player.baseInfo.getTown()
    characterInfo['coupon'] = int(player.finance.getCoupon())
    characterInfo['coin'] = int(player.finance.getCoin())
    characterInfo['gold'] = int(player.finance.getGold())
    characterInfo['energy'] = int(player.attribute.getEnergy())
    characterInfo['pkStatus'] = player.battle.getPkStatus(player.baseInfo.getStatus())
    characterInfo['station'] = u'自由人'
    characterInfo['camp'] = int(player.camp.getCamp())
    characterInfo['hitRate'] = player.attribute.getHit()
    characterInfo['criRate'] = player.attribute.getCri()
    characterInfo['dodgeRate'] = player.attribute.getMiss()
    characterInfo['bogeyRate'] = player.attribute.getBre()
    characterInfo['currentSpeed'] = player.attribute.getCurrSpeed()
    characterInfo['currentSpeedDescription'] = player.attribute.getCurrSpeedDescription(characterInfo['currentSpeed'])
    characterInfo['currentDefense'] = player.attribute.getCurrDefense()
    characterInfo['currentDamage'] = player.attribute.getCurrDamage()

    characterInfo['isTeamMember'] = player.teamcom.amITeamMember()
    characterInfo['isLeader'] = player.teamcom.amITeamLeader()

    characterInfo['skillEffects'] = player.effect.getSkillEffectsInfo()
    characterInfo['itemEffects'] = player.effect.getItemEffectsInfo()
    characterInfo['warehouses'] = player.warehouse.getWarehouses()
    characterInfo['deposit'] = player.warehouse.getDeposit()
    characterInfo['growthRate'] = player.attribute.getGrowthRate(player.profession.getProfession())
    player.mail.isNewMail(id)
    player.quest.getNewQusets(id, int(player.level.getLevel()))
    player.quest.setProgressingQuests()
    return characterInfo

@ServiceFunction
def getOtherPlayerInfo(packet, message, id, playerId):
    '''获得其他玩家信息'''

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    data = dbaccess._queryPlayerInfo(playerId)
    otherPlayer = PlayerCharacter(playerId, data[3], message)
    otherPlayer.initPlayer(data)
    characterInfo = {}#玩家详细信息
    characterInfo['type'] = int(otherPlayer.baseInfo.getType())
    characterInfo['baseStr'] = int(otherPlayer.attribute.getBaseStr())
    characterInfo['baseVit'] = int(otherPlayer.attribute.getBaseVit())
    characterInfo['baseDex'] = int(otherPlayer.attribute.getBaseDex())
    characterInfo['manualStr'] = int(otherPlayer.attribute.getManualStr())
    characterInfo['manualVit'] = int(otherPlayer.attribute.getManualVit())
    characterInfo['manualDex'] = int(otherPlayer.attribute.getManualDex())
    characterInfo['nickName'] = otherPlayer.baseInfo.getNickName()
    characterInfo['portrait'] = otherPlayer.baseInfo.getPortrait()
    characterInfo['level'] = int(otherPlayer.level.getLevel())
    characterInfo['profession'] = otherPlayer.profession.getProfessionName()
    characterInfo['allProfessionStages'] = otherPlayer.profession.getAllProfessionStage()
    characterInfo['currentProfessionStageIndex'] = int(otherPlayer.profession.getProfessionStage()) - 1
    characterInfo['hp'] = int(otherPlayer.attribute.getHp())
    characterInfo['maxHp'] = otherPlayer.attribute.getMaxHp(otherPlayer.profession.getProfession(), id, otherPlayer.level.getLevel())
    characterInfo['mp'] = int(otherPlayer.attribute.getMp())
    characterInfo['maxMp'] = otherPlayer.attribute.getMaxMp(otherPlayer.profession.getProfession(), id, otherPlayer.level.getLevel())
    characterInfo['camp'] = int(otherPlayer.camp.getCamp())
    characterInfo['hitRate'] = otherPlayer.attribute.getHit()
    characterInfo['criRate'] = otherPlayer.attribute.getCri()
    characterInfo['dodgeRate'] = otherPlayer.attribute.getMiss()
    characterInfo['bogeyRate'] = otherPlayer.attribute.getBre()
    characterInfo['currentSpeed'] = otherPlayer.attribute.getCurrSpeed()
    characterInfo['currentSpeedDescription'] = otherPlayer.attribute.getCurrSpeedDescription(characterInfo['currentSpeed'])
    characterInfo['currentDefense'] = otherPlayer.attribute.getCurrDefense()
    characterInfo['currentDamage'] = otherPlayer.attribute.getCurrDamage()
    return characterInfo

def formatePlayerInfo(elm):
    '''格式化玩家信息'''
    info = {}
    newPlayer = PlayerCharacter(elm[0], elm[2])
    newPlayer.initPlayer(elm)
    info['id'] = elm[0]
    info['nickname'] = elm[3]
    info['gender'] = newPlayer.baseInfo.getGender()
    info['profession'] = newPlayer.profession.getProfessionName()
    info['camp'] = newPlayer.camp.getCampName()
    info['level'] = newPlayer.level.getLevel()
    info['professionStage'] = newPlayer.profession.getAllProfessionStage()[newPlayer.profession.getProfessionStage() - 1]
    info['isOnLine'] = PlayersManager().getPlayerByID(info["id"]) is not None
    info['popularity'] = 0
    info['goodevil'] = 0
    info['renqi'] = 0
    info['coin'] = int(newPlayer.finance.getCoin())
    info['prestige'] = 0
    info['legion'] = u'无'
    return info

def formatePlayerInfo2(player):
    '''格式化玩家信息'''
    info = {}
    info['id'] = player.baseInfo.id
    info['nickname'] = player.baseInfo.getNickName()
    info['gender'] = player.baseInfo.getGender()
    info['profession'] = player.profession.getProfessionName()
    info['camp'] = player.camp.getCampName()
    info['level'] = player.level.getLevel()
    info['professionStage'] = player.profession.getAllProfessionStage()[player.profession.getProfessionStage() - 1]
    info['isOnLine'] = PlayersManager().getPlayerByID(info["id"]) is not None
    info['popularity'] = 0
    info['goodevil'] = 0
    return info

@ServiceFunction
def getPlayerInfoByName(packet, message, id, placeId, playerName):
    '''
           根据当前场景下玩家姓名查找玩家信息
    @param placeId: 当前场景地点的id
    @param playerName: 输入的玩家的姓名
    '''
    elm = dbaccess.getPlayerInfoInOnePlaceByName(placeId, playerName)
    info = {}
    player = PlayerCharacter(elm[0], elm[2])
    info['id'] = elm[0]
    info['name'] = elm[2]
    info['profession'] = player.profession.getProfessionName()
    info['camp'] = player.camp.getCampName()
    info['level'] = player.level.getLevel()
    info['professionStage'] = player.profession.getProfessionStage()
    info['isOnLine'] = True
    return info

def getEstablishmentNpcInfo(placeId):
    '''获取相应设施npc信息'''
    cursor = connection.cursor()
    cursor.execute("select npcId from `place_npc` where placeId=%d" % placeId)
    npcId = cursor.fetchone()['npcId']
    npcInfo = loader.getById('npc', npcId, ['id', 'image', 'name', 'dialogContent'])
    return npcInfo

def canDoService(id):
    player = PlayersManager().getPlayerByID(id)
    if player is None: #or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    status = player.baseInfo.getStatus()
    if status == u'死亡' or status == u'战斗中':
        return {'result':False, 'reason':u"您已经处于" + status + "状态"}
    if status == u'修炼中':
        return {'result':False, 'reason':u"您已经处于" + status + "状态", 'data':player.practice.getPracticeInfo()}
    return {'result':True}

'''--------------------------------------------------------玩家属性--------------------------------------'''
@ServiceFunction
def addPoint(packet, message, id, type, all = 0):
    '''
            玩家属性加点
    @param type: 玩家所要加的哪个属性name
    @param all: 是否全部加到这个属性上0:1
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return {'result':True, 'data':player.attribute.addAttributePoint(type, all)}

@ServiceFunction
def searchSameNickName(packet, message, nickName):
    if(isRegisteredNickName(nickName) != None):
        return {'result':False, 'reason':'该角色名已存在'}
    else:
        return {'result':True}

@ServiceFunction
def isHaveSameUsername(packet, message, username):
    if not isExist(username):
        return {'result':True}
    else:
        return {'result':False}


@ServiceFunction
def reassginPoint(packet, message, id, payType, payNum):
    '''
            洗点
    @param payType: 支付类型   'gold','coupon'    
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return {'result':True, 'data':player.attribute.reassginAttributePoint(payType, payNum)}

'''--------------------------------------------------------场景、地图信息---------------------------------'''
@ServiceFunction
def enterPlace(packet, message, id, placeId, force = False):
    '''进入场景地点'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    if player.baseInfo.getLocation() != placeId:
        ret = canDoService(id)
        if not ret['result']:
            return ret
        status = player.baseInfo.getStatus()
        if status == u'训练中' or status == u'卖艺中':
            return {'result':False, 'reason':u"您已经处于" + status + "状态"}
        if not ret['result']:
            return ret
    placeInfo = loader.getById('place', placeId, '*')
    if not placeInfo:
        return {'result':False, 'reason':'The place is not exists'}
    if not player.teamcom.amITeamMember() or force:
        if placeInfo['levelRequire'] > player.level.getLevel():
            return {'result':False, 'reason':u'您的级别不够，需要达到 %d 级才能进入' % placeInfo['levelRequire']}
    else:
        if player.teamcom.amITeamLeader():
            info = player.teamcom.getMyTeamInfomation()
            for i in info:
                if i["type"] == 1:
                    tmp_p = PlayersManager().getPlayerByID(i["id"])
                    if tmp_p:
                        if placeInfo['levelRequire'] > tmp_p.level.getLevel():
                            return {'result':False, 'reason':u'您的队伍中玩家需要都达到 %d 级才能进入' % placeInfo['levelRequire']}
                    else:
                        data = dbaccess._queryPlayerInfo(i["id"])
                        if data is None:
                            return {'result':False, 'reason':u'队伍信息异常:找不到ID %d 对应的玩家信息' % i["id"]}
                        if placeInfo['levelRequire'] > data[6]:
                            return {'result':False, 'reason':u'您的队伍中玩家需要都达到 %d 级才能进入' % placeInfo['levelRequire']}
            teamType = placeInfo["teamType"]
            if player.teamcom.isMyTeamIllegal():
                player.teamcom.disbandTeam()
                player.teamcom.setMyTeam(0)
                player.teamcom.updateCharacterTeamInfomation()
                #return {'result':False, 'reason':u'队伍信息不符合组队规则'}
            if teamType == 0:
                return {"result":False, "reason":"该地点不允许任何组队"}
            elif teamType == 1:
                if player.teamcom.getPCNumbersInTeam() != 1 or player.teamcom.getNPCNumbersInTeam() != 1:
                    return {"result":False, "reason":"只允许玩家与NPC组队"}
            elif teamType == 2:
                if player.teamcom.hasNPCMembersInTeam():
                    return {"result":False, "reason":"只允许玩家与玩家组队"}
            elif teamType == 3:
                pass#return {"result":False, "reason":"允许玩家与玩家/NPC组队"}
            else:
                pass
        else:
            return {"result":False, "reason":"您不是队长，不能自由移动"}
    #更新数据库和内存中玩家位置信息
    dbaccess.updatePlayerInfo(id, {'location':placeId})
    player.baseInfo.setLocation(placeId)
    result = {}
    result['placeInfo'] = placeInfo
    regionInfo = loader.getById('place', placeInfo['regionId'], ['name', 'image', 'type'])
    result['placeInfo']['regionName'] = regionInfo['name']
    result['placeInfo']['regionImage'] = regionInfo['image']
    result['info'] = {}
    result['info']['npcsInfo'] = getPlaceNpcs(placeInfo['id'], player)
    result['info']['childs'] = getMapPlaceInfo(placeId)
    result['info']['childList'] = getPlaceChildList(result, placeInfo, placeId, player)
    result['info']['parentPlacesSquence'] = getSortedParentPlacesSquence(placeId)
    result['info']['playerList'] = getPlacePlayerList(placeId, player)
    result['info']['playerTeamInfo'] = getPlayerPlaceTeamInfo(player)
    if player.teamcom.amITeamLeader():
        info = player.teamcom.getMyTeamInfomation()
        for i in info:
            if i["type"] == 1:
                tmp_p = PlayersManager().getPlayerByID(i["id"])
                if tmp_p:
                    pushMessage(str(i["id"]), "you enter place:%d" % placeId)
    return {'result':True, 'data':result}

def getPlacePlayerList(placeId, player):
    '''获取场景总的玩家列表'''
    pageCount = 10

    result = dbaccess._queryPlacePlayers(placeId, player.baseInfo.id)
    playerList = []
    for elm in result:
        info = formatePlayerInfo(elm)
        playerList.append(info)
    scenePlayers[str(player.baseInfo.id)] = playerList
    return playerList[:pageCount]

@ServiceFunction
def getPagePlayers(packet, message, id, page):
    '''获取某一页场景玩家列表'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    pageCount = 10
    totalPage = math.ceil(len(scenePlayers[str(id)]) / pageCount)
    if totalPage == 0:
        totalPage += 1
    return {'result':True, 'data':{'playerList':scenePlayers[str(id)][(page - 1) * pageCount:page * pageCount], 'page':totalPage}}

@ServiceFunction
def queryPlacePlayerListByCondition(packet, message, id, placeId, condition):
    '''根据查询条件查询场景玩家列表'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    if condition.has_key('camp'):
        if condition['camp'] == u'魏国':
            condition['camp'] = 1
        elif condition['camp'] == u'蜀国':
            condition['camp'] = 2
        elif condition['camp'] == u'吴国':
            condition['camp'] = 3
    if condition.has_key('professionPosition'):
        pass
    list = []
    return list

@ServiceFunction
def getWorldMapInfo(packet, message, id, placeId):
    ''''''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    wMapPlaces = []
    isLevelRequired = False
    isCampRequired = False

    cursor = connection.cursor()
    sql = "select id,name,regionId,type,levelRequire,wextentLeft,wextentTop,camp from `place` where (wextentLeft<>-1 or wextentTop<>-1)"
    cursor.execute(sql)
    result = cursor.fetchall()
    for place in result:
        cursor.execute("select name from `place` where parentId=%d and regionId=%d" % (place['regionId'], place['regionId']))
        childNames = cursor.fetchall()
        if(place['type'] == u"城市"):
            if(place['id'] != player.baseInfo.getTown()):
                if place['camp'] == -1:
                    isCampRequired = True
                else:
                    isCampRequired = False
            else:
                isCampRequired = True
        else:
            isCampRequired = True
        if(place['id'] == 1):
            isCampRequired = False
        if place['levelRequire'] <= player.level.getLevel():
            isLevelRequired = True
        else:
            isLevelRequired = False
        wMapPlaces.append({'id':place['id'], 'name':place['name'], 'type':place['type'], 'wextentLeft':place['wextentLeft']\
                           , 'wextentTop':place['wextentTop'], 'childNames':childNames, 'isLevelRequired':isLevelRequired, \
                           'isCampRequired':isCampRequired})

    cursor.close()
    locationRegion = loader.getById('place', placeId, ['regionId'])#当前玩家所处的区域，用于在在世界地图上标识
    return {'wMapPlaces':wMapPlaces, 'locationRegion':locationRegion}


'''------------------------------------------------包裹栏、临时包裹栏、装备栏、仓库、交易栏、锻造操作------------------------'''
@ServiceFunction
def getItemsInPackage(packet, message, id):
    '''获取玩家包裹栏中的物品'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return player.pack.getItemsInPackage()

@ServiceFunction
def getItemsInTempPackage(packet, message, id):
    '''获取玩家临时包裹栏中的物品'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return player.pack.getItemsInTempPackage()

@ServiceFunction
def getItemsInEquipSlot(packet, message, id):
    '''获取玩家装备栏'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return player.pack.getItemsInEquipSlot()

@ServiceFunction
def getOtherEquipSlot(packet, message, id, playerId):
    '''获取其他玩家装备栏'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    data = dbaccess._queryPlayerInfo(playerId)
    otherPlayer = PlayerCharacter(playerId, data[3])
    otherPlayer.initPlayer(data)
    return otherPlayer.pack.getItemsInEquipSlot()

@ServiceFunction
def isValidPositionInPackage(packet, message, id, position, formerPosition, package = 'package'):
    '''
            在包裹栏中是否是合法的位置
    @param position: 位置（数组）
    @param formerPosition: 以前的位置
    @param package: 'package'默认为包裹蓝
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    if player.baseInfo.getStatus() == u'死亡' or player.baseInfo.getStatus() == u'战斗中':
        return {'result':False, 'reason':u"您已经处于" + player.baseInfo.getStatus() + "状态"}
    result = player.pack.isValidPositionInPackage(position, formerPosition, package)
    if result:
        return {'result':result}
    else:
        return {'result':result, 'reason':u'位置不合法'}

@ServiceFunction
def moveItem(packet, message, id, position, formerPosition, packageType, splitTo, stack = 0):
    '''
            在某个物品库中移动物品的位置（根据情况判断是移动、拆分还是合并）
    @param position: 物品的当前位置
    @param packageType: "package":包裹蓝,"temporary_package"：临时包裹蓝
    @param formerPosition: 原先的位置
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return player.pack.movePackItem(position, formerPosition, packageType, splitTo, stack)

@ServiceFunction
def moveItemFromOnePackageToAnother(packet, message, id, fromPack, toPack, fromPosition, toPosition, stack):
    '''
           从一个栏中向另一个栏中移动物品
    @param fromPack: 物品所在栏类型
    @param toPack: 移动目标栏类型
    @param fromPosition: 物品所在位子
    @param toPosition: 移到的位子
    @param stack: 移动的层叠数
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return player.pack.moveItemFromOnePackageToAnother(fromPack, toPack, fromPosition, toPosition, stack)

@ServiceFunction
def sellAllItemsInTempPackage(packet, message, id):
    '''
            卖出临时包裹栏中的所有物品
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return player.pack.sellAllTempPackage()

@ServiceFunction
def sellPackageItem(packet, message, id, itemId, packageType, count):
    '''
            卖出栏中的物品
    @param itemId: 物品id
    @param packageType: 栏类型
    @param count: 数量 
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return player.pack.sellPackageItem(itemId, packageType, count)

@ServiceFunction
def useItem(packet, message, id, itemId):
    '''使用物品'''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return player.pack.useItem(itemId)

@ServiceFunction
def dropItem(packet, message, id, itemId, packageType):
    '''
            丢去物品
    @param itemId: 物品id
    @param packageType: 包裹栏类型
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return player.pack.dropItem(itemId, packageType)

@ServiceFunction
def getWarehouseInfo(packet, message, id, placeId):
    '''
    获取仓库信息 
    '''
    player = PlayersManager().getPlayerByID(id)
    if not player:
        return {'result':False, 'reason':u'与服务器的连接中断'}

    npcInfo = getEstablishmentNpcInfo(placeId)
    items = player.pack.setWarehousePackage()
    player.pack.setWarehousePackageItems(0)
    return {'result':True, 'data':{'npcInfo':npcInfo, 'items':items}}

@ServiceFunction
def nextPageWarehouse(packet, message, id, idx):
    '''
    仓库翻页
    @param idx:第几个仓库 
    @param data: 第几个仓库 中物品的更新
    '''
    player = PlayersManager().getPlayerByID(id)
    if not player:
        return {'result':False, 'reason':u'与服务器的连接中断'}
    player.pack.setWarehousePackageItems(idx)

@ServiceFunction
def getDealPackage(packet, message, id, playerId):
    '''
    获得交易栏装备
    @param playerId: 玩家ID
    '''
    player = PlayersManager().getPlayerByID(id)
    if not player:
        return {'result':False, 'reason':u'与服务器的连接中断'}

@ServiceFunction
def getForgingPackage(packet, message, id, placeId):
    '''
    获得锻造包
    '''
    player = PlayersManager().getPlayerByID(id)
    if not player:
        return {'result':False, 'reason':u'与服务器的连接中断'}

    npcInfo = getEstablishmentNpcInfo(placeId)
    items = player.pack.setForgingPackage()
    return {'result':True, 'data':{'npcInfo':npcInfo, 'items':items}}

@ServiceFunction
def setSyntheticItem(packet, message, id):
    '''
    合成物品
    '''
    player = PlayersManager().getPlayerByID(id)
    if not player:
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return player.pack.setSyntheticItem()

'''--------------------------------------------战斗操作---------------------------------------------'''
@ServiceFunction
def fightWithNpc(packet, message, id, npcId, battleType):
    '''
          与npc战斗
    @param npcId: npc的id
    battleType:战斗类型     1.‘野外战斗’；2.副本战斗 ；3.‘决斗’....
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    if player.attribute.getEnergy() <= 0 and battleType != 2:
        return {'result':False, 'reason':u"您的活力不够，赶快补充哦"}
    from core.Character import Monster
    if player.teamcom.amITeamLeader():
        return {'result':False, 'data':"组队没弄好"}
        data = player.teamcom.battleToSinglePC(Monster(npcId))
    else:
        data = player.battle.fightTo(Monster(npcId), battleType = 1, timeLimit = 360)

    for winner in data['battleEventProcessList'][-1][-1][0]['battleResult']['winner']:
        if winner == id:#以后在组队战斗再修改
        #如果是副本战斗，更新副本进度、location
            if battleType == 2:
                location = player.baseInfo.getLocation()
                if location in player.instance.getInstanceLayers():
                    index = player.instance.getInstanceLayers().index(location)
                    if index <> len(player.instance.getInstanceLayers()) - 1:
                        index += 1
                    location = player.instance.getInstanceLayers()[index]
                    dbaccess.updatePlayerInfo(id, {'location':location})
                    player.baseInfo.setLocation(location)
                    attrs = {'instanceLayerId':location}
                    player.instance.updatePlayerInstanceProgressInfo(attrs)
    return {'result':True, 'data':data, 'username':player.baseInfo.getName(), 'id':player.baseInfo.id}



    from core.Character import Monster
    if player.teamcom.amITeamLeader():
        data = player.teamcom.battleToSinglePC(Monster(npcId))
    else:
        data = player.battle.fightTo(Monster(npcId), battleType = 1, timeLimit = 360)
    return {'result':True, 'data':data}

    party1 = []
    party2 = []
    party1Players = []
    party2Players = []
    members = []
#    if player.teamcom.amITeamMember():#组队战斗
#        if not player.teamcom.amITeamLeader():
#            return {'result':False, 'reason':u'您不是队长，无法战斗'}
#        members = player.teamcom.getMyTeamInfomation()
#        for elm in members:
#            if elm['id'] != -1:
#                party1.append(elm['id'])
#                if elm['id'] == player.baseInfo.id:
#                    party1Players.append(player)
#                else:
#                    data = dbaccess._queryPlayerInfo(elm['id'])
#                    member = PlayerCharacter(data[0], data[2])
#                    member.initPlayer(data)
#                    party1Players.append(member)
#        for member in party1Players:
#            if battleType == 1:
#                dbaccess.updatePlayerInfo(member.baseInfo.id, {'status':4, 'energy':member.attribute.getEnergy() - 1})
#                member.attribute.setEnergy(member.attribute.getEnergy() - 1)
#            member.baseInfo.setStatus(4)
#        party2 = [npcId]
#    else:
#        if player.attribute.getEnergy() <= 0:
#            return {'result':False, 'reason':u"您的活力不够，赶快补充哦"}
#        party1 = [id]
#        party2 = [npcId]
#        party1Players = [player]
#        if battleType == 1:
#            dbaccess.updatePlayerInfo(id, {'status':4, 'energy':player.attribute.getEnergy() - 1})
#            player.attribute.setEnergy(player.attribute.getEnergy() - 1)
#        player.baseInfo.setStatus(4)
#    player.battle.processOneBattleByCompute(party1, party2, party1Players, party2Players, battleType)
#    data = player.battle.getResultDataForClient()

    if player.teamcom.amITeamMember():#组队战斗
        if not player.teamcom.amITeamLeader():
            return {'result':False, 'reason':u'您不是队长，无法战斗'}
        members = player.teamcom.getMyTeamInfomation()
        error = False
        eName = None
        for member in members:
            if member["type"] == 2:
                continue
            tmp = PlayersManager().getPlayerByID(member["id"])
            if tmp is not None:
                if tmp.attribute.getEnergy() < 0:
                    error = True
                    eName = tmp.baseInfo.getNickName()
            else:
                data = dbaccess._queryPlayerInfo(member['id'])
                if data[16] < 0:
                    error = True
                    eName = data[3]
        if error:
            return {'result':False, 'reason':u'队伍成员 %s 活力不够，无法战斗' % eName}
        for member in members:
            if member["type"] == 2:
                continue
            tmp = PlayersManager().getPlayerByID(member["id"])
            if battleType == 1:
                if tmp is None:
                    data = dbaccess._queryPlayerInfo(member['id'])
                    tmp = PlayerCharacter(data[0], data[3])
                    tmp.initPlayer(data)
                dbaccess.updatePlayerInfo(tmp.baseInfo.id, {'status':4, 'energy':tmp.attribute.getEnergy() - 1})
                tmp.attribute.setEnergy(tmp.attribute.getEnergy() - 1)
                tmp.baseInfo.setStatus(4)
                party1Players.append(tmp)
            party1.append(member["id"])
        party2 = [npcId]
    else:
        if player.attribute.getEnergy() <= 0:
            return {'result':False, 'reason':u"您的活力不够，赶快补充哦"}
        party1 = [id]
        party2 = [npcId]
        party1Players = [player]
        if battleType == 1:
            dbaccess.updatePlayerInfo(id, {'status':4, 'energy':player.attribute.getEnergy() - 1})
            player.attribute.setEnergy(player.attribute.getEnergy() - 1)
        player.baseInfo.setStatus(4)
    player.battle.processOneBattleByCompute(party1, party2, party1Players, party2Players, battleType)
    data = player.battle.getResultDataForClient()

    for winner in data['battleEventProcessList'][-1][-1][0]['battleResult']['winner']:
        if winner == id:#以后在组队战斗再修改
        #如果是副本战斗，更新副本进度、location
            if battleType == 2:
                location = player.baseInfo.getLocation()
                if location in player.instance.getInstanceLayers():
                    index = player.instance.getInstanceLayers().index(location)
                    if index <> len(player.instance.getInstanceLayers()) - 1:
                        index += 1
                    location = player.instance.getInstanceLayers()[index]
                    dbaccess.updatePlayerInfo(id, {'location':location})
                    player.baseInfo.setLocation(location)

    for member in members:
        if member["id"] == id:
            continue
        pushMessage(str(member['id']), 'team battle')

    return {'result':True, 'data':data}

@ServiceFunction
def getProcessingBattleData(packet, message, id):
    '''获取正在战斗中数据'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    #由于组队时，其他成员也会调用这个方法，所以将成员信息重置,保证是最新
#    data = dbaccess._queryPlayerInfo(id)
#    player.initPlayer(data)
#    if player.teamcom.amITeamLeader():
#        pass
#    else:
#        player = PlayersManager().getPlayerByID(player.teamcom.getTeamLeaderID())
    if player.baseInfo.getStatus() == u'战斗中':#战斗还在继续中
        return {'result':True, 'data':player.battle.getResultDataForClient()}
    else:
        return {'result':False, 'reason':u"已经结束战斗"}

@ServiceFunction
def reliveInCurrentPlace(packet, message, id, coinNum):
    '''
            玩家原地复活
    @param coinNum: 铜币量
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    return player.attribute.reliveInCurrentPlace(coinNum)

@ServiceFunction
def reliveInTown(packet, message, id):
    '''
            玩家回城复活
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    return player.attribute.reliveInTown()

@ServiceFunction
def reliveOnUsingGold(packet, message, id, payType, payNum):
    '''
            玩家黄金复活
    @param payType: 支付类型：'gold','coupon'
    @param payNum:  支付数量
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    return player.attribute.reliveOnUsingGold(payType, payNum)

'''--------------------------------------------对话操作---------------------------------------------'''
@ServiceFunction
def talkToNpc(packet, message, id, npcId):
    '''
          与npc对话
    @param npcId: npc的id
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    player.quest.onTalkToNpc(npcId)

    return {'result':False, 'data':player.quest.getQuestListOnNpc(npcId)}

'''------------------------------------------------任务操作---------------------------------------'''
@ServiceFunction
def getProgressingQuests(packet, message, id):
    '''
            得到当前任务列表
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    player.quest.setProgressingQuests()
    return {'result':False, 'data':player.quest.getProgressingRecordList()}

@ServiceFunction
def getFinishedQuests(packet, message, id):
    '''
            得到已经完成任务列表
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return {'result':True, 'data':player.quest.getFinishedRecordList()}

@ServiceFunction
def getRecievableQuests(packet, message, id):
    '''
            得到可接收的任务列表
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return {'result':False, 'data':player.quest.getReceiveableQuests()}

@ServiceFunction
def applyQuest(packet, message, id, questTemplateId):
    '''
            申领任务 
    @param questTemplateId: 任务模版id
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return player.quest.applyQuest(questTemplateId)

@ServiceFunction
def commitQuest(packet, message, id, questId):
    '''
        提交任务
    @param questId: 任务id
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    result = player.quest.commitQuest(questId)
    if not result['result']:
        return result
    result['data']['id'] = questId
    result['reason'] = u'任务完成'
    return result

@ServiceFunction
def getQuestDetails(packet, message, id, questId):
    '''
            获取任务详细信息
    @param questId: 任务记录id
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return{'result':True, 'data':player.quest.getQuestDetails(questId)}

@ServiceFunction
def getRecievableQuestDetails(packet, message, id, questTemplateId):
    '''
            获取可接任务详细信息
    @param questTemplateId: 任务模版id
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return {'result':True, 'data':player.quest.getRecievableQuestDetails(questTemplateId)}

@ServiceFunction
def getActiveRewardQuestPanelInfo(packet, message, id, placeId):
    '''获取赏金任务组织界面详细信息'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    npcInfo = getEstablishmentNpcInfo(placeId)
#    activeRewardQuestList,progressList = player.quest.autoRefreshActiveRewardQuestList(npcInfo['id'])
    activeRewardQuestList = player.quest.getFixedRewardQuestList(npcInfo['id'])
    progressList = player.quest.getProgressingQuestsGroupByType()
    currentRewardQuestCount = player.quest.getRewardQuestCountForToday()
    maxCount = player.quest.MAXREWARDQUESTCOUNT
    intervalSeconds = 7200
    enterRecord = dbaccess.getPlayerQuestRoomInfo(id)
    if enterRecord:
        delta = datetime.datetime.now() - enterRecord[2]
        intervalSeconds -= delta.seconds
        if intervalSeconds <= 0:
            player.quest.autoRefreshActiveRewardQuestList(npcInfo['id'])
            dbaccess.updatePlayerEnterQuestRoomTime(id, str(datetime.datetime.now()))
            intervalSeconds = 7200
        else:
            player.quest.AUTOREFRESHTIME = intervalSeconds
            player.quest.autoRefreshActiveRewardQuestList(npcInfo['id'])
    else:
        player.quest.autoRefreshActiveRewardQuestList(npcInfo['id'])
        dbaccess.insertPlayerQuestRoomInfo(id, str(datetime.datetime.now()))

    return {'result':True, 'data':{'npcInfo':npcInfo, 'activeRewardQuestList':activeRewardQuestList, \
                                  'currentRewardQuestCount':currentRewardQuestCount, \
                                  'maxCount':maxCount, 'intervalSeconds':intervalSeconds, \
                                  'progressQuestList':progressList\
                                  }}

@ServiceFunction
def autoFinishActiveRewardQuest(packet, message, id, questTemplateId):
    '''
          自动完成赏金任务
    @param questTemplateId: 赏金任务模版id(如果已经接受的赏金任务，questTemplateId实际是任务记录id)
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    questRecord = dbaccess.getQuestRecordById(questTemplateId)
    if questRecord and len(questRecord) > 0:
        questTemplateId = questRecord[1]
    return player.quest.autoFinishActiveRewardQuest(questTemplateId)

@ServiceFunction
def getImmediateFinishTime(packet, message, id, questRecordId):
    '''
            获取立即完成赏金任务的时间
    @param questRecordId: 赏金任务记录id
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

#    player = players[str(id)]
    now = datetime.datetime.now()
    questRecord = dbaccess.getQuestRecordById(questRecordId)
    if not questRecord or len(questRecord) <= 0:
        return {'result':False, 'reason':u'没有找到相应的任务'}
    deltaTime = questRecord[4] - now
    seconds = deltaTime.seconds

    return {'result':True, 'data':{'leftSeconds':seconds}}

@ServiceFunction
def immediateFinishActiveRewardQuest(packet, message, id, questRecordId, payType, payNum):
    '''
          立即完成赏金任务
    @param questRecordId: 赏金任务id，如果之前是直接自动完成、没有接受，则是任务模版id
    @param payType: 支付类型   'gold','coupon'
    @param payNUm: 支付数量
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    questRecord = dbaccess.getQuestByTemplateId(id, questRecordId)
    if questRecord and len(questRecord) > 0:
        questRecordId = questRecord[0]
    return player.quest.immediateFinishActiveRewardQuest(questRecordId, payType, payNum)

@ServiceFunction
def autoRefreshActiveRewardQuestList(packet, message, id, npcId):
    '''
          自动刷新赏金任务列表
    @param id: 玩家id
    @param npcId: npcid
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return player.quest.autoRefreshActiveRewardQuestList(npcId)

@ServiceFunction
def immediateRefreshActiveRewardQuestList(packet, message, id, payType, payNum, npcId):
    '''
          立即刷新赏金任务列表
    @param payType: 支付类型
    @param payNum: 支付数量
    @param npcId: npcid
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return player.quest.immediateRefreshActiveRewardQuestList(payType, payNum, npcId)

'''------------------------------------------------技能操作---------------------------------------'''
@ServiceFunction
def getSkillPanelInfo(packet, message, id):
    '''获取玩家技能界面详细信息'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    equipedActiveSkill = player.skill.getActiveSkillInfo()

    learnedSkills = player.skill.getLearnedSkills()

    professionLV20, professionLV38 = player.quest.getChangingProfessionStageQuests()
    changeProfessionStageQuests = {'LV20':professionLV20, 'LV38':professionLV38}

    return {'result':True, 'data':{'equipedActiveSkill':equipedActiveSkill, \
                                  'learnedSkills':learnedSkills, \
                                  'changeProfessionStageQuests':changeProfessionStageQuests}}

@ServiceFunction
def getLearnedSkills(packet, message, id):
    '''获取玩家当前已学信息'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    learnedSkills = player.skill.getLearnedSkills()
    return {'result':True, 'data':learnedSkills}

@ServiceFunction
def getLearnableSkills(packet, message, id):
    '''获取玩家可学技能'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    learnableSkills = player.skill.getLearnableSkills()
    return {'result':True, 'data':learnableSkills}

@ServiceFunction
def getAllSkills(packet, message, id):
    '''获取玩家所有技能'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    allSkills = player.skill.getProfessionAllSkills()
    return {'result':True, 'data':allSkills}

@ServiceFunction
def learnSkill(packet, message, id, skillId):
    '''
        获取玩家技能界面详细信息
    @param skillId: 技能id
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    result, desc = player.skill.learnSkill(skillId)
    if result:
        return {'result':True}
    else:
        return {'result':False, 'reason':u'无法学习此技能:\n' + desc}

@ServiceFunction
def equipSkill(packet, message, id, skillId, skillType):
    '''
            装备技能
    @param skillId: 技能id
    @param skillType: 技能类型：1主动 2辅助
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    result, desc = player.skill.equipSkill(skillId, skillType)
    if result:
        return {'result':True, 'data':desc}
    else:
        return {'result':False, 'reason':desc}

@ServiceFunction
def getSkillSettings(packet, message, id):
    '''
    获得高级技能设置
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    result = dbaccess.getSkillSettings(id)
    if not result:
        return {'result':False}
    else:
        return {'result':True, 'data':result}

@ServiceFunction
def updataSkillSettings(packet, message, id, isNew, warriorSkillId, guardianSkillId, samuraiSkillId, toShiSkillId, advisersSkillId, warlockSkillId):
    '''
    更新技能设置
    @param isNew:是否新设置
    @param warriorSkillId:对抗勇士的技能ID
    @param guardianSkillId:对抗卫士技能ID
    @param samuraiSkillId:对抗武士技能ID
    @param toShiSkillId:对抗使士技能ID
    @param advisersSkillId:对抗谋士技能ID
    @param warlockSkillId:对抗术士技能ID
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    result = player.skill.updataSkillSettings(isNew, warriorSkillId, guardianSkillId, samuraiSkillId, toShiSkillId, advisersSkillId, warlockSkillId)
    return result
'''------------------------------------------------宿屋操作---------------------------------------'''
@ServiceFunction
def getRestRoomInfo(packet, message, id, placeId):
    '''
         获取宿屋的信息
    @param placeId: 宿屋id
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    npcInfo = getEstablishmentNpcInfo(placeId)

    restRecord = dbaccess.getPlayerRestRecord(id)
    countList = list(restRecord[2:])
    countList[0] = 1 - int(countList[0])
    countList[1] = 1 - int(countList[1])
    countList[2] = 1 - int(countList[2])
    countList[3] = 2 - int(countList[3])

    return {'result':True, 'data':{'npcInfo':npcInfo, 'countList':countList}}

@ServiceFunction
def restOperate(packet, message, id, type, payType, payNum):
    '''
            宿屋中各种休息操作
    @param type: 支付币的类型：'meal','nap','lightSleep','peacefulSleep','spoor'
    @param payType: 'coin','gold','coupon'
    @param payNum: 支付的数量    
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return player.attribute.doRest(type, payType, payNum)

'''------------------------------------------------大厅操作---------------------------------------'''
@ServiceFunction
def getLobbyInfo(packet, message, id, placeId):
    '''
          获取大厅信息
    @param placeId: 地点id
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    npcInfo = getEstablishmentNpcInfo(placeId)

    lobbyInfo = None
    status = player.baseInfo.getStatus()
    if status == u'训练中' or status == u'卖艺中':
        lobbyRecord = dbaccess.getPlayerLobbyRecord(id)
        if not lobbyRecord or len(lobbyRecord) == 0:
            return {'result':False, 'reason':u'没有您的大厅记录'}
        finishTime = lobbyRecord[3]
        seconds = (finishTime - datetime.datetime.now()).seconds
        lobbyInfo = {'seconds':seconds}
    return {'result':True, 'data':{'lobbyInfo':lobbyInfo, 'npcInfo':npcInfo}}

@ServiceFunction
def lobbyOperate(packet, message, id, type, duration):
    '''
          大厅操作：修炼、卖艺
    @param type: 操作类型：1、训练   2、卖艺
    @param duration: 持续时间
        训练得到的经验=[(自身等级+1)*33]^1.15*训练小时数
        训练消耗的铜币=[(自身等级+1)*44]^1.15*训练小时数
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    level = player.level.getLevel()
    exp = player.level.getExp()
    coin = player.finance.getCoin()
    startTime = datetime.datetime.now()
    finishTime = startTime + datetime.timedelta(hours = 1)
    status = 0

    getExp = 0
    costCoin = 0
    if type == 1:#训练
        status = 3
        getExp = int(math.pow((level + 1) * 33, 1.15) * duration)
        costCoin = int(math.pow(((level) + 1) * 44, 1.15) * duration)
        exp += getExp
        coin -= costCoin
        if coin < 0:
            return {'result':False, 'reason':u'您的铜币不足'}
        dbaccess.updatePlayerInfo(id, {'status':status, 'coin':coin})
        bonusCount = getExp
    else:#卖艺
        status = 6
        pass
    dbaccess.updatePlayerLobbyRecord(id, {'startTime':str(startTime), 'finishTime':str(finishTime), 'isDoubleBonus':0})
    player.finance.setCoin(coin)
    player.baseInfo.setStatus(status)
    statusDesc = player.baseInfo.getStatus()
    durationTime = duration * 3600
    reactor.callLater(durationTime, doWhenLobbyOperateFinsihed, {'status':1, 'coin':coin, 'exp':exp}, player)

    return {'result':True, 'data':{'status':statusDesc, 'bonusCount':bonusCount, \
                                   'startTime':startTime, 'finishTime':finishTime, \
                                   'duration':duration}}
def doWhenLobbyOperateFinsihed(attrs, player):
    '''当大厅操作时间结束时'''
    now = datetime.datetime.now()
    lobbyRecord = dbaccess.getPlayerLobbyRecord(player.baseInfo.id)
    finishTime = lobbyRecord[3]
    if (not finishTime) or (finishTime > now):
        return
    dbaccess.updatePlayerInfo(player.baseInfo.id, attrs)
    pushMessage(str(player.baseInfo.id), 'finish')
    player.baseInfo.setStatus(1)
    player.finance.setCoin(attrs['coin'])
    player.level.setExp(attrs['exp'])
    player.level.updateLevel()

@ServiceFunction
def lobbyDoubleBonus(packet, message, id, type, payType, payNum):
    '''
            大厅操作双倍奖励
    @param type: 操作类型：1、训练   2、卖艺
    @param payType: 'gold','coupon'
    @param payNum: 支付的数量    
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    gold = player.finance.getGold()
    coupon = player.finance.getCoupon()
    level = player.level.getLevel()
    bonus = 0
    lobbyRecord = dbaccess.getPlayerLobbyRecord(id)
    if lobbyRecord[2] == None or lobbyRecord[3] == None:
        return {'result':False, 'reason':u'您的大厅操作记录不正确'}
    duration = int(((lobbyRecord[3] - lobbyRecord[2]).seconds) / 3600)
    if type == 1:
        count = 0
        if payType == 'gold':
            gold -= payNum
            if gold < 0:
                return {'result':False, 'reason':u'您的黄金不足'}
            count = gold
        else:
            coupon -= payNum
            if coupon < 0:
                return {'result':False, 'reason':u'您的礼券不足'}
            count = coupon
        dbaccess.updatePlayerInfo(id, {payType:count})
        bonus = int(math.pow((level + 1) * 33, 1.15) * duration * 2)
    else:
        pass
    dbaccess.updatePlayerLobbyRecord(id, {'isDoubleBonus':1})

    return {'result':True, 'data':{'bonus':bonus, 'gold':gold, 'coupon':coupon}}

@ServiceFunction
def terminateLobbyOperation(packet, message, id, type):
    '''
          中断大厅操作
    @param type: 操作类型：1、训练   2、卖艺
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    level = player.level.getLevel()
    lobbyRecord = dbaccess.getPlayerLobbyRecord(id)
    if lobbyRecord[2] == None or lobbyRecord[3] == None:
        return {'result':False, 'reason':u'您的大厅操作记录不正确'}
    now = datetime.datetime.now()
    duration = int(((lobbyRecord[3] - now).seconds) / 3600)
    bonus = 0
    exp = player.level.getExp()
    if type == 1:
        if lobbyRecord[4] == 1:#双倍奖励
            bonus = int(math.pow((level + 1) * 33, 1.15) * duration * 2)
        else:
            bonus = int(math.pow((level + 1) * 33, 1.15) * duration)
            exp += bonus
        dbaccess.updatePlayerInfo(id, {'status':1, 'exp':exp})
        player.level.setExp(exp)
        player.level.updateLevel()
        player.baseInfo.setStatus(1)
    else:
        pass
    return {'result':True, 'data':{'bonus':bonus, 'level':player.level.getLevel()}}

@ServiceFunction
def lobbyOperatingSetting(packet, message, id, type):
    '''
          大厅操作设置
    @param type: 操作类型：1、训练   2、卖艺
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    level = player.level.getLevel()

    lobbyRecord = dbaccess.getPlayerLobbyRecord(id)
    if lobbyRecord[2] == None or lobbyRecord[3] == None:
        return {'result':False, 'reason':u'您的大厅操作记录不正确'}
    now = datetime.datetime.now()
    totalTime = int(((lobbyRecord[3] - lobbyRecord[2]).seconds) / 3600)
    duration = int(((lobbyRecord[3] - now).seconds) / 3600)
    bonusCount = 0
    if type == 1:
        if lobbyRecord[4] == 1:
            bonusCount = int(math.pow((level + 1) * 33, 1.15) * totalTime * 2)
        else:
            bonusCount = int(math.pow((level + 1) * 33, 1.15) * totalTime)
    else:
        pass

    return {'result':True, 'data':{'isDoubleBonus':lobbyRecord[4], 'bonusCount':bonusCount, \
                                   'startTime':lobbyRecord[2], 'finishTime':lobbyRecord[3], \
                                   'duration':duration, 'totalTime':totalTime}}

'''------------------------------------------------怪物修炼---------------------------------------'''
@ServiceFunction
def getMonsterPracticeExp(packet, message, id, monsterId):
    '''
          获取一个怪物修炼经验奖励
    @param monsterId: 怪物id
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return player.practice.getMonsterPracticeExp(monsterId)

@ServiceFunction
def pratice(packet, message, id, monsterId, singleExpBonus, monsterCount, monsterLevel):
    '''
          修炼怪物
    @param monsterId: 怪物id
    @param singleExpBonus: 每个怪得到的经验奖励
    @param monsterCount: 修炼怪物数量
    @param monsterLevel: 修炼怪物等级
    '''
    ret = canDoService(id)
    if not ret['result']:
        return ret

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return player.practice.pratice(monsterId, singleExpBonus, monsterCount, monsterLevel)

@ServiceFunction
def terminatePractice(packet, message, id):
    '''
          终止玩家修炼
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    return player.practice.terminatePractice()

@ServiceFunction
def immediateFinishPractice(packet, message, id, payType, payNum):
    '''立即完成修炼'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    return player.practice.immediateFinishPractice(payType, payNum)

'''------------------------------------------------聊天---------------------------------------'''
@ServiceFunction
def chatConnecting(packet, message, id, topic, content):
    '''玩家聊天连接中'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    name = player.baseInfo.getNickName()
    if topic == u'综合':
        pass
    elif topic == u'世界':
        pass
    elif topic == u'国家':
        pass
    elif topic == u'场景':
        pass
    elif topic == u'军团':
        pass
    elif topic == u'队伍':
        pass
    else:
        toPlayer = dbaccess.getPlayerIdAndPasswordByNickname(topic)
        if not toPlayer:
            return {'result':False, 'reason':u'玩家不存在'}

    str = ''
    str += topic + "^^^" + player.camp.getCamp().__str__() + "^^^" + name + "^^^" + content + "^^^" + player.baseInfo.getNickName() + "^^^" + player.baseInfo.getLocation().__str__()
    str.encode('utf8')
    pushMessage(topic, str)

    return {'result':True, 'data':{'id':player.baseInfo.id}}

'''----------------------------------------------商店---------------------------------------'''
@ServiceFunction
def getShopInfo(packet, message, id, placeId):
    '''获取商店信息'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    refreshTime = player.shop.enterShop(placeId)
#    refreshTime = 60
    shopNpcInfo = player.shop.getShopNpcInfo(placeId)
    pagedShopItems = player.shop.getPagedShopItems(placeId)
    relatedShops = player.shop.getRelatedShops()

    return {'result':True, 'data':{'shopNpcInfo':shopNpcInfo, 'pagedShopItems':pagedShopItems, \
                                  'refreshTime':refreshTime, 'relatedShops':relatedShops}}

@ServiceFunction
def buyItem(packet, message, id, itemTemplateId, dropExtraAttributeId, stack, position, toPosition):
    '''
            购买物品
    @param itemTemplateId: 物品模版id
    @param dropExtraAttributeId: 附加属性（string）
    @param stack: 层叠数
    @param position: 在商店栏中的位置坐标（x,y）
    @param toPosition: 要放置包裹栏中坐标
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    coin = player.finance.getCoin()
    price = player.shop.getShopItemPrice(itemTemplateId, dropExtraAttributeId) * stack
    coin -= price
    if coin < 0:
        return {'result':False, 'reason':u'铜币量不足'}
    result = player.shop.buyItem(itemTemplateId, dropExtraAttributeId, stack, toPosition)
    if result[0]:
        player.finance.setCoin(coin)
        return {'result':result[0], 'data':{'newItem':result[1], 'formerPosition':position, 'coin':coin}}
    else:
        return {'result':result[0], 'reason':result[1]}

@ServiceFunction
def immediateRefreshShopItems(packet, message, id, placeId, payType, payCount):
    '''立即刷新商店物品'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    gold = player.finance.getGold()
    coupon = player.finance.getCoupon()
    if payType == 'gold':
        gold -= payCount
        if gold < 0:
            return {'result':False, 'reason':u'黄金量不足'}
        player.finance.setGold(gold)
    elif payType == 'coupon':
        coupon -= payCount
        if coupon < 0:
            return {'result':False, 'reason':u'礼券量不足'}
        player.finance.setCoupon(coupon)
    refreshTime = player.shop.enterShop(placeId)
    pagedShopItems = player.shop.getPagedShopItems(placeId)
    return {'result':True, 'data':{'pagedShopItems':pagedShopItems, 'refreshTime':refreshTime, 'coupon':coupon, 'gold':gold}}

@ServiceFunction
def refreshShopItems(packet, message, id, placeId):
    '''时间到，自动刷新商店物品'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    refreshTime = player.shop.enterShop(placeId)
    pagedShopItems = player.shop.getPagedShopItems(placeId)
    return {'result':True, 'data':{'pagedShopItems':pagedShopItems, 'refreshTime':refreshTime}}

'''----------------------------------------------好友、仇敌---------------------------------------'''
@ServiceFunction
def getPlayerFrinds(packet, message, id, type):
    '''
            获取玩家好友/仇敌列表
    @param type: 关系类型 1.好友 2.仇敌
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    friendCount = player.friend.getFriendCount()
    player.friend.queryFriends()
    friends = []
    if type == 1:
        friends = player.friend.getFriends()
    elif type == 2:
        friends = player.friend.getEnermies()

    list = []
    for elm in friends:
        info = formatFriendInfo(elm)
        list.append(info)
    return {'result':True, 'data':{'friends':list, 'friendCount':friendCount}}

@ServiceFunction
def expandPlayerFriendCount(packet, message, id, count, payType, payCount):
    '''
        扩展玩家好友数量上限
    @param count:数量
    @param payType: 支付类型
    @param payCount: 支付数量 
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    gold = player.finance.getGold()
    coupon = player.finance.getCoupon()
    if payType == 'gold':
        gold -= payCount
        if gold < 0:
            return {'result':False, 'reason':u'黄金量不足'}
        player.finance.setGold(gold)
    elif payType == 'coupon':
        coupon -= payCount
        if coupon < 0:
            return {'result':False, 'reason':u'礼券量不足'}
        player.finance.setCoupon(coupon)
    friendCount = player.friend.getFriendCount()
    friendCount += count
    if friendCount > 100:
        return {'result':False, 'reason':u'您添加的数目超过上限100'}
    dbaccess.updatePlayerInfo(id, {'friendCount':friendCount})
    player.friend.setFriendCount(friendCount)
    gold = player.finance.getGold()
    coupon = player.finance.getCoupon()
    return {'result':True, 'data':{'friendCount':friendCount, 'gold':gold, 'coupon':coupon}}

@ServiceFunction
def addPlayerFriend(packet, message, id, playerName, type, isSheildMail, content):
    '''
         添加好友/仇敌
    @param playerName: 要添加玩家名字
    @param type: 关系类型 1.好友 2.仇敌
    @param isSheildMail: 是否屏蔽邮件  true/false
    @param content: 添加好友的邮件内容
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    playerId = dbaccess.getPlayerIdByNickName(playerName)
    if not playerId:
        return {'result':False, 'reason':u'没有找到您指定的人物！'}
    else:
        if playerId[0] == id:
            return {'result':False, 'reason':u'您不能添加自己！'}
    result = player.friend.addFriend(playerId[0], type, isSheildMail)
    info = None
    if result[0]:
        if type == 1:
            player.mail.addMail(id, int(playerId[0]), 2, content, 0, '')
        info = formatFriendInfo(result[1])
        return {'result':result[0], 'data':{'newFriend':info}}
    else:
        return {'result':result[0], 'reason':result[1]}

@ServiceFunction
def removePlayerFriend(packet, message, id, friendId):
    '''
         删除好友/仇敌
    @param friendId: 好友列表ID
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    result = player.friend.removeFriend(friendId)
    if result:
        return {'result':True, 'friendId':friendId}
    else:
        return {'result':False, 'reason':u'没有找到您指定的人物！'}

@ServiceFunction
def updataIsSheildedMail(packet, message, id, friendId, isSheildMail):
    '''
            修改邮件屏蔽功能
    @param friendId: 好友列表ID
    @param isSheildMail: 是否邮件屏蔽功能
    '''

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    result = player.friend.updataSheildedMail(friendId, isSheildMail)

    if result:
        return {'result':True}
    else:
        return {'result':False}

def formatFriendInfo(info):
    '''格式化好友信息'''
    friendInfo = {}
    playerInfo = dbaccess._queryPlayerInfo(info[0])
    if not info :
        return {}
    player = PlayerCharacter(playerInfo[0], playerInfo[2])
    friendInfo['id'] = int(playerInfo[0])
    friendInfo['nickname'] = playerInfo[3]
    friendInfo['level'] = int(player.level.getLevel())
    friendInfo['camp'] = player.camp.getCampName()
    friendInfo['profession'] = player.profession.getProfessionName()
    friendInfo['isSheildedMail'] = int(info[8])
    friendInfo['friendId'] = int(info[6])
    friendInfo['type'] = int(info[7])

    return friendInfo

'''----------------------------------------------邮件---------------------------------------'''
@ServiceFunction
def addMail(packet, message, id, playerName, content, reference,systemId = None):
    '''
    添加邮件
    @param receiverId: 接受人昵名
    @param content: 内容
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    playerId = dbaccess.getPlayerIdByNickName(playerName)
    if not playerId:
        return {'result':False, 'reason':u'没有找到您指定的人物！'}
    else:
        if systemId == None:
            if playerId[0] == id:
                return {'result':False, 'reason':u'您不能给自己发邮件！'}
    if systemId <> None:
        result = player.mail.addMail(-1, int(playerId[0]), 1, content, 0, reference)
    else:
        result = player.mail.addMail(id, int(playerId[0]), 2, content, 0, reference)
    if result:
        return {'result':True, 'reason':u'您的消息已经成功发送！'}
    else:
        return {'result':False, 'reason':u'没有找到您指定的人物！'}


@ServiceFunction
def mailList(packet, message, id):
    '''
    获取邮件
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    mailList = player.mail.mailList();
    list = []
    if mailList <> None:
        for elm in mailList:
            info = formatMailInfo(elm)
            list.append(info)
    return {'result':True, 'data':{'mails':list}}

@ServiceFunction
def deleteMail(packet, message, id, mailId):
    '''
    删除邮件
    @param mailId: 邮件ID
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    result = player.mail.deleteMail(mailId)
    if result:
        return {'result':True}
    else:
        return {'result':False, 'reason':u'删除失败！'}


def formatMailInfo(info):
    '''格式化邮件信息'''
    mailInfo = {}
    if not info :
        return {}
    mailInfo['id'] = int(info[0])
    if info[1] <> -1:
        playerInfo = dbaccess._queryPlayerInfo(info[1])
        mailInfo['name'] = playerInfo[3]
    else:
        mailInfo['name'] = ''
    mailInfo['systemType'] = info[7]
    mailInfo['sendTime'] = info[6]
    mailInfo['content'] = info[4]
    mailInfo['type'] = int(info[3])
    mailInfo['reference'] = info[8]
    mailInfo['isFriend'] = int(info[9])
    mailInfo['playerId'] = int(info[1])

    return mailInfo

'''----------------------------------------------副本---------------------------------------'''
@ServiceFunction
def getPlayerInstanceProgress(packet, message, id):
    '''获取玩家副本进度'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    instanceProgressInfo = player.instance.getPlayerInstanceProgressInfo()
    return {'result':True, 'data':{'instanceProgressInfo':instanceProgressInfo}}

@ServiceFunction
def clearPlayerInstanceProgressInfo(packet, message, id):
    '''清除玩家副本进度信息'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    result = player.instance.removePlayerInstanceProgressInfo()
    if result:
        return {'result':True, 'data':{'location':player.baseInfo.getLocation()}}
    else:
        return {'result':False, 'reason':u'清除副本失败'}

@ServiceFunction
def enterInstance(packet, message, id, placeId):
    '''
          进入副本
    @param placeId: 副本地点id
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    result, reason = player.instance.enterInstance(placeId)
    if result:
        energy = player.attribute.getEnergy()
        layer = player.instance.getInstancePlaceId()
        return {'result':result, 'data':{'energy':energy, 'layer':layer}}
    else:
        return {'result':result, 'reason':reason}

@ServiceFunction
def getInstanceStatus(packet, message, id, placeId):
    '''获取玩家副本完成状态'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    isFinished = False
    instanceId = player.instance.getInstanceId()
    if instanceId == -1:
        isFinished = False
    else:
        if instanceId == placeId:
            isFinished = True
        else:
            isFinished = False
    return isFinished
'''----------------------------------------------组队---------------------------------------'''
@ServiceFunction
def launchAddTeamMember(packet, message, id, playerId, playerType = 1, placeID = None):
    '''发起组队邀请'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    other = PlayersManager().getPlayerByID(playerId)
    if other is None:
        return {'result':False, 'reason':'对方不在线'}
    if placeID is not None:
        retType = loader.getById('place', placeID, ['teamType'])
        if retType is not None:
            teamType = retType["teamType"]
            if teamType == 0:
                return {"result":False, "reason":"该地点不允许任何组队"}
            elif teamType == 1:
                if playerType != 2:
                    return {"result":False, "reason":"只允许玩家与NPC组队"}
            elif teamType == 2:
                if playerType != 1:
                    return {"result":False, "reason":"只允许玩家与玩家组队"}
            elif teamType == 3:
                pass#return {"result":False, "reason":"允许玩家与玩家/NPC组队"}
            else:
                pass
    return player.teamcom.launchAddTeamMember(other)

@ServiceFunction
def responseJoinTeamRequest(packet, message, id, launcherNickname):
    '''
          玩家回应组队请求，获取请求队伍的成员信息
    @param launcherNickname: 发起人昵称
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    other = PlayersManager().getPlayerByNickname(launcherNickname)
    if other is None:
        return {"result":False, "reason":"找不到昵称对应的玩家"}
    allInfo = other.teamcom.getMyTeamInfomation()
    members = []
    for item in allInfo:
        if item["type"] == 1:#玩家
            playerID = str(item["id"])
            member = formatePlayerInfo(dbaccess._queryPlayerInfo(playerID))
            member["isLeader"] = False
            if other.teamcom.amITeamLeader():
                member["isLeader"] = True
            members.append(member)
        elif item["type"] == 2:#NPC
            pass
        else:#其他
            pass
    if len(members) == 0:
        members.append(formatePlayerInfo(dbaccess._queryPlayerInfo(other.baseInfo.id)))
        members[0]["isLeader"] = True
    return {'result':True, 'data':{'members':members}}

@ServiceFunction
def confirmJoin(packet, message, id, launcherId):
    '''
           确认加入队伍
    @param launcherId: 发起人id
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    lancher = PlayersManager().getPlayerByID(launcherId)
    if lancher is not None:
        pass
    else:
        info = dbaccess._queryPlayerInfo(launcherId)
        if info:
            lancher = PlayerCharacter(info[0], info[2])
            lancher.initPlayer(info)
        else:
            return {'result':False, 'reason':'目标玩家不存在或者已经被注销'}
    if lancher:
        if lancher.teamcom.getMyTeamID() == 0:
            lancher.teamcom.rebuildMyTeam()
        if lancher.teamcom.hasMemberInTeamWithID(player.baseInfo.id):
            return {'result':False, 'reason':'您已经加入该队伍了'}
        else:
            result, reason = lancher.teamcom.addCharacterIntoMyTeam(player)
            if result:
                #player.team = lancher.team
                teamID = lancher.teamcom.getMyTeamID()
                player.teamcom.resetMyTeam(teamID)
                for info in lancher.teamcom.getMyTeamInfomation():
                    if info["id"] != player.baseInfo.id:
                        pushMessage(str(lancher.baseInfo.id), "已经加入了您的队伍")
                player.teamcom.updateCharacterTeamInfomation()
                lancher.teamcom.updateCharacterTeamInfomation()
            return {'result':result, 'reason':reason}
    return {'result':False, 'reason':'目标玩家不存在或者已经被注销'}

@ServiceFunction
def cancelJoinTeamRequest(packet, message, id, launcherId):
    '''不接受组队请求'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    lancher = PlayersManager().getPlayerByID(launcherId)
    if lancher is not None:
        pass
    else:
        info = dbaccess._queryPlayerInfo(launcherId)
        if info:
            lancher = PlayerCharacter(info[0], info[2])
            lancher.initPlayer(info)
        else:
            return {'result':False, 'reason':'没有找到发起人'}
#    for info in lancher.teamcom.getMyTeamInfomation():
#        if info["id"] != id:
#            pushMessage(str(info["id"]), u'取消了您的组队邀请！')
    pushMessage(str(launcherId), u'取消了您的组队邀请！')
    return {'result':True}

@ServiceFunction
def noticeTeamMemberToRefreshTeamList(packet, message, id):
    '''通知队伍各成员刷新场景队伍列表信息'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    list = []
    teamMembers = player.teamcom.getMyTeamInfomation()
    leaderID = player.teamcom.getTeamLeaderID()
    for member in teamMembers:
        p = PlayersManager().getPlayerByID(member['id'])
        if p is None:
            memberData = dbaccess._queryPlayerInfo(member['id'])
            if memberData:
                memberInfo = formatePlayerInfo(memberData)
                memberInfo['isLeader'] = leaderID == member['id']
                list.append(memberInfo)
        else:
            memberInfo = formatePlayerInfo2(p)
            memberInfo['isLeader'] = p.teamcom.amITeamLeader()
            list.append(memberInfo)
    if len(list) == 1 and list[0]['isLeader']:
        list = []
        info = player.teamcom.disbandTeam()
        for i in info:
            if i["type"] == 1:
                member = PlayersManager().getPlayerByID(i["id"])
                if member is not None:
                    member.teamcom.resetMyTeam(0)
                    member.teamcom.updateCharacterTeamInfomation()
                else:
                    dbaccess.updateCharacterTeamInfo(i["id"], 0)
    return {'result':True, 'data':{'members':list}}

@ServiceFunction
def disbandTeam(packet, message, id):
    '''解散组队'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    if not player.teamcom.amITeamMember():
        return {'result':False, 'reason':u'您不在队伍中'}

    if not player.teamcom.amITeamLeader():
        return {'result':False, 'reason':u'您不是队长,没有权限'}

    status = player.baseInfo.getStatus()
    if status == u'修炼中' or status == u'战斗中':
        return {'result':False, 'reason':u'战斗中不能解散队伍'}
    teamInfo = player.teamcom.disbandTeam()
    for p in teamInfo:
        if p["type"] == 1:
            member = PlayersManager().getPlayerByID(p["id"])
            if member is not None:
                member.teamcom.resetMyTeam(0)
                member.teamcom.updateCharacterTeamInfomation()
                pushMessage(str(p['id']), player.baseInfo.getNickName() + u'已经解散队伍')
            else:
                dbaccess.updateCharacterTeamInfo(p["id"], 0)
    if True:
        return {'result':True}
    else:
        return {'result':False, 'reason':u'解散组队失败'}

@ServiceFunction
def removeTeamMember(packet, message, id, memberId, memberType = 1):
    '''队长剔除队员'''
    if id == memberId:
        return {"result":False, "reason":u"玩家不能自己T自己"}

    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    if not player.teamcom.amITeamLeader():
        return {'result':False, 'reason':u"您不是队长，没有权限"}

    status = player.baseInfo.getStatus()
    if status == u'修炼中' or status == u'战斗中':
        return {'result':False, 'reason':u'战斗中不能剔除队伍'}

    result, reason = player.teamcom.kickoutMember(memberId, memberType)
    if result:
        kickedmem = PlayersManager().getPlayerByID(memberId)
        removedMemberNickname = None
        if kickedmem:
            removedMemberNickname = kickedmem.baseInfo.getNickName()
        else:
            memberInfo = dbaccess._queryPlayerInfo(memberId)
            if memberInfo is not None and len(memberInfo) > 0:
                removedMemberNickname = memberInfo[3]
            else:
                {'result':False, 'reason':u"数据库中找不到玩家昵称"}
        pushMessage(str(id), u'您已经成功剔除' + removedMemberNickname)
        if kickedmem:
            pushMessage(str(memberId), u'您已经被剔除出队伍了')
        for info in player.teamcom.getMyTeamInfomation():
            memID = info["id"]
            if memID != id and PlayersManager().getPlayerByID(memID) is not None:
                pushMessage(str(memID), removedMemberNickname + u'已经被踢出队伍了')
    return {'result':False, 'reason':reason}

@ServiceFunction
def resortTeamMember(packet, message, id, sortedIdList):
    '''
          对玩家进行排序
    @param sortedIdList: 要排的新顺序
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}

    if not player.teamcom.amITeamLeader():
        return {'result':False, 'reason':u"您不是队长，没有权限"}
    status = player.baseInfo.getStatus()
    if status == u'修炼中' or status == u'战斗中':
        return {'result':False, 'reason':u'战斗中不能改变队伍成员位置'}
    result, reason = player.teamcom.queueMembers(sortedIdList)
    if result:
        for info in player.teamcom.getMyTeamInfomation():
            if PlayersManager().getPlayerByID(info["id"]):
                pushMessage(str(info["id"]), 'resort')
    return {'result':result, 'reason':reason}

@ServiceFunction
def transferTeamLeaderPosition(packet, message, id, toPlayerId):
    '''
          转让队长职务
    @param toPlayerId: 要转让给的玩家id
    '''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    toPlayer = PlayersManager().getPlayerByID(toPlayerId)
    if toPlayer is None:
        toPlayer = PlayerCharacter(toPlayerId)
    status = player.baseInfo.getStatus()
    if status == u'修炼中' or status == u'战斗中':
        return {'result':False, 'reason':u'战斗中不能改变队伍成员职务信息'}
    result, reason = player.teamcom.resetTeamLeader(toPlayer)
    if result:
        for info in player.teamcom.getMyTeamInfomation():
            member = PlayersManager().getPlayerByID(info["id"])
            if member:
                if info["id"] == toPlayerId:
                    pushMessage(str(info['id']), u'您已经成为队长')
                else:
                    pushMessage(str(info['id']), toPlayer.baseInfo.getNickName() + u'已经成为队长')
    return {'result':result, 'reason':reason}

@ServiceFunction
def leaveTeam(packet, message, id):
    '''玩家离开队伍，如果是队长离开则解散队伍'''
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    myNickName = player.baseInfo.getNickName()
    members = player.teamcom.getMyTeamInfomation()
    status = player.baseInfo.getStatus()
    if status == u'修炼中' or status == u'战斗中':
        return {'result':False, 'reason':u'战斗中不能离开队伍'}
    result, reason = player.teamcom.leave()
    if result:
#        player.teamcom.resetMyTeam(0)
#        player.teamcom.updateCharacterTeamInfomation()
        if len(members) - 1 <= 1:
            for p in members:
                if p["type"] == 1 and p["id"] != id:
                    member = PlayersManager().getPlayerByID(p["id"])
                    if member is not None:
                        member.teamcom.resetMyTeam(0)
                        member.teamcom.updateCharacterTeamInfomation()
                        pushMessage(str(p['id']), u'人数太少，' + u'已经解散队伍')
                    else:
                        dbaccess.updateCharacterTeamInfo(p["id"], 0)
        else:
            for info in members:
                p = PlayersManager().getPlayerByID(info["id"])
                if p :
                    if p.baseInfo.id != id:
                        pushMessage(str(info['id']), myNickName + u'已经离开队伍')
                    else:
                        pushMessage(str(info['id']), u'您已经离开队伍')

    return {"result":result, "reason":reason}

'''--------------------------------------------招募------------------------------------------------'''
@ServiceFunction
def listNPCInfoInTask(packet, message, playerID, taskID):
#    {"result":True, "data":[{}, ...]}
    player = PlayersManager().getPlayerByID(playerID)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    data = player.recruitcom.queryTaskNPCInfo(taskID)
    if data:
        return {"result":True, "data":data}
    return {"result":False, "reason":"No NPC Infomation result"}

@ServiceFunction
def listAllMyNPC(packet, message, playerID):
    player = PlayersManager().getPlayerByID(playerID)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    data = player.recruitcom.getRecruitedMembers()
    if data:
        return {'result':False, "data":data}
    return {'result':False, 'reason':u'与服务器的连接中断'}

@ServiceFunction
def listNPCInStore(packet, message, playerID, storeID = 0):
    pass

@ServiceFunction
def playerGetNPC(packet, message, playerID, NPCID):
    pass

@ServiceFunction
def playerSetNPCState(packet, message, playerID, NPCID, inTeam = 0): #设置NPC 出战 或进营帐
    '''
        inTeam:
            0, 进营帐
            1，出战
    '''
    player = PlayersManager().getPlayerByID(playerID)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    ret = player.recruitcom.setNPCState(NPCID, inTeam)
    if ret:
        return {"result":True, "reason":None}
    return {"result":False, "reason":"set NPC state failed in serviceFunction.py"}

@ServiceFunction
def getNPCWuJiangInfomation(packet, message, playerID, NPCID):
    player = PlayersManager().getPlayerByID(playerID)
    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    data = player.recruitcom.queryNPCWuJiangInfo(NPCID)
    if data:
        return {"result":True, "data":data}
    return {"result":False, "reason":"No NPC Infomation result"}

'''--------------------------------------------仓库------------------------------------------------'''
@ServiceFunction
def depositMoney(packet, message, id, coin, type):
    '''仓库存款
    @param coin:钱数
    @param type:类型 1 存款 2取款  
    '''

    player = PlayersManager().getPlayerByID(id)
    if not player:
        return {'result':False, 'reason':u'与服务器的连接中断'}
    return player.warehouse.updataDeposit(int(coin), type)

'''-------------------------------------------获取所有玩家信息------------------------------'''
@ServiceFunction
def listAllPlayerInfo(packet, message, page, property, camp, profession, id = None):
    pageSize = 10
    currentPage = 0
    if(len(dbaccess.getAllPlayers(property, camp, profession)) % pageSize != 0):
         totalPage = len(dbaccess.getAllPlayers(property, camp, profession)) / pageSize + 1
    else:
         totalPage = len(dbaccess.getAllPlayers(property, camp, profession)) / pageSize
    result = dbaccess.getAllPlayers(property, camp, profession)
    playerList = []
    for elm in result:
        info = formatePlayerInfo(elm)
        playerList.append(info)
    if(id != None):
        for i in range(0, len(playerList)):
            if(playerList[i]['id'] == id):
                currentPage = i / 10 + 1
                return {'result':True, 'data':{'playerList':playerList[(currentPage - 1) * pageSize:currentPage * pageSize], 'page':totalPage, 'currentPage':currentPage}}
    if totalPage == 0:
        totalPage += 1
    return {'result':True, 'data':{'playerList':playerList[(page - 1) * pageSize:page * pageSize], 'page':totalPage}}

'''-----------------------------------------------------新手任务--------------------------------------'''
@ServiceFunction
def isNewPlayer(packet, message, id):
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {"result":False, "reason":''}
    if(getIsNewPlayer(id) == 1):
        return {'result':True, 'progress':getNewPlayerQuestProgress(id), 'isKilled':getIsAttackedMonster(id)}
    else:
        return {'result':False}

@ServiceFunction
def NewPlayerQuestInfo(packet, message, id):
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {"result":False, "reason":''}
    return {'data':getNewPlayerQuestInfo(getNewPlayerQuestProgress(id))}

@ServiceFunction
def addReward(packet, message, id, coin, coupon, exp):
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {"result":False, "reason":''}
    giveReward(id, coin, coupon, exp)
    return {'coin':int(player.finance.getCoin()), 'coupon':int(player.finance.getCoupon()), 'exp':int(player.level.getExp()), 'data':{'id':player.baseInfo.id, 'username':player.baseInfo.getName()}}

@ServiceFunction
def changeQuestProgress(packet, message, id, progressid):
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {"result":False, "reason":''}
    setNewPlayerQuestProgress(id, progressid)
    return {'progress':getNewPlayerQuestProgress(id)}

@ServiceFunction
def sendNewPlayerWeapon(packet, message, id, wid, position):
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {"result":False, "reason":''}
    if giveFirstWeapon(id, wid):
        putFirstWeaponIntoPackage(id, wid, position)
        player.pack.setPackage();
    return {'progress':getNewPlayerQuestProgress(id), 'data':{'id':player.baseInfo.id, 'username':player.baseInfo.getName()}}

@ServiceFunction
def sendNewPlayerThing(packet, message, id, mid, width, height):
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {"result":False, "reason":''}
    toPosition = player.pack._package.findSparePositionForItem(width, height)
    if toPosition != [-1, -1] :
        if giveFirstWeapon(id, mid):
            if putFirstWeaponIntoPackage(id, mid, str(toPosition[0]) + "," + str(toPosition[1])):
                player.pack.setPackage();
                return {'result':True}

        else:
            return {'result':False, 'reason':u'此物品存在'}
    else:
        return {'result':False, 'reason':u'包裹栏已满'}

@ServiceFunction
def getPlayerHasKilledMonster(packet, message, id):
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {"result":False, "reason":''}
    return getIsAttackedMonster(id)

@ServiceFunction
def changePlayerHasKilledMonster(packet, message, id, isKilled):
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {"result":False, "reason":''}
    if setIsAttackedMonster(id, isKilled):
        return {'reason':True}
    else:
        return {'reason':False}

@ServiceFunction
def changeNewPlayerState(packet, message, id):
    player = PlayersManager().getPlayerByID(id)
    if player is None or not player.checkClientID(message):
        return {"result":False, "reason":''}
    if setNotNewPlayer(id):
        return{'reason':'OK', 'result':True}
    else:
        return{'reason':'fault', 'result':False}

'''---------------------------------测试方法----------------------------------------'''
@ServiceFunction
def changeCharacter(packet, message, id):
    player = PlayersManager().getPlayerByID(id)

    if player is None or not player.checkClientID(message):
        return {'result':False, 'reason':u'与服务器的连接中断'}
    if dbaccess.testLevel(id):

        return {'result':True, 'username':player.baseInfo.getName(), 'property':property}
    else:
        return {'result':False, 'username':player.baseInfo.getName(), 'property':property}

@ServiceFunction
def echo(packet, message, arg):
    print arg
    return arg
