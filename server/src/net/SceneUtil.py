#coding:utf8
'''
Created on 2010-3-12

@author: wudepeng
'''
from util import dbaccess
from util.DataLoader import loader, connection

'''由于关于场景的代码很多，单独抽取出来'''

def getPlaceNpcs(placeId, player):
    '''获取场景npc列表'''
    characterId = player.baseInfo.id
    npc_place_list = []#某一场景对应的所有npc模版信息列表
    place_npc_list = loader.get('place_npc', 'placeId', placeId, ['npcId', 'questId'])
    quest_npc = {}#{'{questTemplateId}':npcId}
    for elm in place_npc_list:
        #刷boss怪，根据有无boss任务
        progressingQuestList = player.quest.getProgressingRecordList()
        bossQuestIdList = []
        flag = True
        n = 0
        if elm['questId'] <> u'-1':
            tempList = elm['questId'].split(';')
            for element in tempList:
                element = int(element)
                bossQuestIdList.append(element)
            for progressingQuest in progressingQuestList:
                isBreak = False
                if progressingQuest['questTemplateId'] in bossQuestIdList:
                    sequentialGoal = loader.getById('quest_template', progressingQuest['questTemplateId'], ['sequentialGoal'])['sequentialGoal']
                    if sequentialGoal == 0:#非线性显示
                        break
                    else:
                        m = 0
                        progresses = progressingQuest['progressesDetails']
                        for progress in progresses:
                            if progress['killCount'] > 0:
                                if progress['currentKillCount'] == progress['killCount']:
                                    if elm['npcId'] == progress['npcInfo']['id']:
                                        m = 1
                                        break
                                    else:
                                        continue
                                else:
                                    if elm['npcId'] == progress['npcInfo']['id']:
                                        isBreak = True
                                        flag = True
                                    break
                            elif progress['itemCount'] > 0:
                                itemId = loader.getById('questgoal', progress['questgoalId'], ['itemId'])['itemId']
                                count = dbaccess.getCollectionQuestItemCount(itemId, characterId)
                                if count == progress['itemCount']:
                                    if elm['npcId'] == progress['npcInfo']['id']:
                                        m = 1
                                        break
                                    else:
                                        continue
                                else:
                                    if elm['npcId'] == progress['npcInfo']['id']:
                                        isBreak = True
                                        flag = True
                                    break
                            else:
                                if progress['hasTalkedToNpc'] == 1:
                                    if elm['npcId'] == progress['npcInfo']['id']:
                                        m = 1
                                        break
                                    else:
                                        continue
                                else:
                                    if elm['npcId'] == progress['npcInfo']['id']:
                                        isBreak = True
                                        flag = True
                                    break
                        if m == 1:
                            n = 1
                            break
                else:
                    flag = False
                    continue
                if isBreak:
                    break
        if n == 1:
            continue
        if flag:
            k = 0
            globalQuestId = 0
            for questId in bossQuestIdList:
                questId = str(questId)
                if quest_npc.has_key(str(questId)) or not quest_npc.has_key('0'):#如果同任务的boss怪物已经有了，则此怪物不加入列表
                    k = 1
                    break
                globalQuestId = questId
            if k == 1:
                continue
            if len(progressingQuestList) == 0:
                if elm['questId'] == u'-1':
                    npcInfo = loader.getById('npc', elm['npcId'], '*')
                    if npcInfo == None:
                        continue
                    npc_place_list.append(npcInfo)
                    quest_npc[str(globalQuestId)] = elm['npcId']
            else:
                npcInfo = loader.getById('npc', elm['npcId'], '*')
                if npcInfo == None:
                    continue
                npc_place_list.append(npcInfo)
                quest_npc[str(globalQuestId)] = elm['npcId']
    return npc_place_list

def getMapPlaceInfo(placeId):
    '''获取区域地图详细信息;list中第一项为区域信息，后面的均为其子地点'''
    placeInfo = loader.getById('place', placeId, '*')
    if not placeInfo:
        return
    regionsList = []
    regionId = placeInfo['regionId']
    if regionId <> -1:
        regionInfo = loader.getById('place', regionId, '*')
        regionsList.append(regionInfo)
    else:
        regionId = placeInfo['id']
    places = loader.get('place', 'regionId', regionId, '*')
    for place in places:
        if place['type'] == u'地点':
            regionsList.append(place)
    return regionsList

def getPlaceChildList(result, placeInfo, placeId, player):
    '''获取场景子地点'''
    result['info']['childList'] = []
    if placeInfo['type'] == u'子地点':
        list = getBrotherPlaces(placeId, player)
        result['info']['childList'] = list#如果为子地点，存放自己和兄弟节点
        if placeId > 9100:#副本子地点
            result['info']['childList'] = []
    else:
        result['info']['childList'] = getChildPlaces(placeId)#存放其子地点
        if placeId > 9000 and placeId < 9100:#副本地点
            a = []
            a.append(result['info']['childList'][0])
            result['info']['childList'] = a
    return result['info']['childList']

def getChildPlaces(placeId):
    '''获取当前地点的所有下层地点'''
    cursor = connection.cursor()
    places = cursor.execute(u"select id,regionId,type,name,camp,levelRequire,image,extentLeft,extentTop,desciption,isBuilded from `place` where parentId=%d and type<>'地点'"\
                            % placeId).fetchall()
    cursor.close()
    if places and len(places) > 0:
        return places
    else:
        return []

def getSortedParentPlacesSquence(placeId):
    '''获取地点的所有父地点，顺序从高到低排序'''
    props = ['id', 'parentId', 'type', 'name', 'camp']
    placeData = loader.getById('place', placeId, props)
    if not placeData:
        return 'The place is not exists'
    result = []
    parentId = placeData['parentId']
    if parentId == -1 or parentId == placeId:
        result.append(placeData)
        return result
    while(True):
        parentData = loader.getById('place', parentId, props)
        if not parentData:
            break
        result.append(parentData)
        if parentId == -1 or parentId == parentData['parentId']:
            break
        parentId = parentData['parentId']

    result.reverse()
    return result

def getBrotherPlaces(placeId, player):
    '''获取同级兄弟地点'''
    parent = loader.getById('place', placeId, ['parentId'])
    if not parent:
        return
    parentId = parent['parentId']
    if parentId == -1:
        return
    brothers = loader.get('place', 'parentId', parentId, '*')
    brotherList = []
    for elm in brothers:
        if elm['id'] == player.baseInfo.id:
            continue
        brotherList.append(elm)
    return brotherList

def getPlayerPlaceTeamInfo(player):
    '''获取玩家场景组队信息'''
    teamInfo = {}
    isTeamMember = player.teamcom.amITeamMember()
    teamInfo['isTeamMember'] = isTeamMember
    if isTeamMember:
        pass
    return teamInfo
