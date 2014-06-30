#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''
from net.MeleeSite import pushMessage
from component.Component import Component
from core.Item import Item
from util import dbaccess
from util.DataLoader import loader, connection

from twisted.internet import reactor

import datetime

reactor = reactor

class CharacterQuestComponent(Component):
    """templateInfo component for character"""

    def __init__(self, owner):
        '''
        Constructor
        '''
        Component.__init__(self, owner)
        self.MAXREWARDQUESTCOUNT = 20
        self.AUTOFINISHTIME = 1800
        self.AUTOREFRESHTIME = 7200
        self.TEMPACTIVEQUESTCOUNT = 4
        self._progressingRecordList = [] #进行中任务记录 
        self._finishedRecordList = [] #完成任务记录
        self._callBol = True
        self._allQuestCallLater = None
        self._oneQuestCallLater = None
#        self.setProgressingQuests()

    def setProgressingRecordList(self, list):
        self._progressingRecordList = list

    def setFinishedRecordList(self, list):
        self._finishedRecordList = list

    def getProgressingRecordList(self):
        return self._progressingRecordList

    def getFinishedRecordList(self):
        self.setFinishedQuests()
        return self._finishedRecordList

    def setProgressingQuests(self):
        '''得到玩家进行中任务'''
        self._progressingRecordList = []
        records = dbaccess.getProgressingRecords(self._owner.baseInfo.id)
        for record in records:
            obj = self.wrapBriefQuestRecordObject(record, {})
            self._progressingRecordList.append(obj)

    def setFinishedQuests(self):
        '''得到玩家已完成任务'''
        self._finishedRecordList = []
        records = dbaccess.getFinishedRecords(self._owner.baseInfo.id)
        for record in records:
            obj = self.wrapBriefQuestRecordObject(record, {})
            self._finishedRecordList.append(obj)

    def getNewQusets(self, id, level):
        result = self.getReceiveableQuests()
        if result:
            pushMessage(str(id), 'newQuest')

    def getReceiveableQuests(self):
        '''得到玩家可接任务'''
        profession = self._owner.profession.getProfession()
        exec("profession=u\'" + str(profession) + "\'")
        camp = self._owner.camp.getCamp()
        level = self._owner.level.getLevel()

        templateList = dbaccess.getQuestRecordsTemlate(self._owner.baseInfo.id)

        cursor = connection.cursor()
        cursor.execute("select * from `quest_template` where minLevelRequire<=%d and maxLevelRequire>=%d and type<>2" % (level, level))
        result = cursor.fetchall()
        finishedList = self.getFinishedRecordList()
        list = []
        for templateInfo in result:
            questInfo = {}
            questInfo['provider'] = templateInfo['provider']
            questInfo['accepter'] = templateInfo['accepter']
            questInfo['name'] = templateInfo['name']
            questInfo['type'] = templateInfo['type']
            questInfo['category'] = templateInfo['category']
            questInfo['minLevelRequire'] = templateInfo['minLevelRequire']
            questInfo['questTemplateId'] = templateInfo['id']

            professionLimits = templateInfo['professionRequire'].split(';')
            parentQuestIds = templateInfo['parentId'].split(';')
            for parent in parentQuestIds:
                if int(parent) == -1:
                    if((templateInfo['campRequire'] == camp or templateInfo['campRequire'] == -1)\
                       and((profession in professionLimits) or (templateInfo['professionRequire'] == u'-1'))):
                        if(templateInfo['type'] == 4):
                            if(templateInfo['minLevelRequire'] == 38):
                                list.append(questInfo)
                            elif(profession in professionLimits):
                                list.append(questInfo)
                        else:
                            list.append(questInfo)
                else:
                    for quest in finishedList:
                        questTemplateId = quest['questTemplateId']
                        if questTemplateId == int(parent):
                            if((templateInfo['campRequire'] == camp or templateInfo['campRequire'] == -1)\
                               and((profession in professionLimits) or (templateInfo['professionRequire'] == u'-1'))):
                                if(templateInfo['type'] == 4):
                                    if(templateInfo['minLevelRequire'] == 38):
                                        list.append(questInfo)
                                    elif(profession in professionLimits):
                                        list.append(questInfo)
                                else:
                                    list.append(questInfo)
                if templateInfo['id'] in templateList:
                    if questInfo in list:
                        list.remove(questInfo)

        for elm in list:
            elm = self.wrapRecievableQuestObject(elm)
        return list

    def getQuestListOnNpc(self, npcId):
        '''获取npc身上的任务列表'''
        revievableQuests = []#npc可接任务列表
        getGoalQuests = []#npc已经达到任务目标的任务列表
        unGotGoalQuests = []#npc身上未达到任务目标的任务列表

        list = self.getReceiveableQuests()
        for templateInfo in list:
            if templateInfo['provider'] == npcId:
                revievableQuests.append(templateInfo)

#        self.setProgressingQuests()
        list = self.getProgressingRecordList()
        for info in list:
            if info['accepterInfo']['id'] == npcId:
                if self.isSatifyProgressingQuestGoals(info['questTemplateId']):
                    getGoalQuests.append(info)
                else:
                    unGotGoalQuests.append(info)
        return revievableQuests, getGoalQuests, unGotGoalQuests

    def applyQuest(self, questTemplateId):
        '''申领任务'''
        id = self._owner.baseInfo.id

#        if (self._owner.attribute.getEnergy() <= 0):
#            return {'result':False, 'reason':u"您的活力已经不够了，赶快补充活力吧！"}
        questTemplate = loader.getById('quest_template', questTemplateId, '*')
        if not questTemplate:
            return{'result':False, 'reason':u'没有相应的任务'}

        activeRewardQuestCount = self.getRewardQuestCountForToday()
        if questTemplate['type'] == 2 :
            if(activeRewardQuestCount >= self.MAXREWARDQUESTCOUNT):
                return {'result':False, 'reason':u"接收任务失败！今天可接赏金任务已满！"}

        ret = self._isMatchLimit(questTemplate)
        if ret == 1:
            return {'result':False, 'reason':u" 您的级别尚未达到！"}
        if ret == 2:
            return {'result':False, 'reason':u" 您的阵营不符合该任务的阵营要求！"}
        if ret == 3:
            return {'result':False, 'reason':u" 您的职位不符合该任务的职位要求！"}
        if ret == 4:
            return {'result':False, 'reason':u" 您的职业不符合该任务的职业要求！"}
        if(questTemplate['type'] == 4):
            if(questTemplate['professionStageRequire'] < self._owner.profession.getProfessionStage()):
                return {'result':False, 'reason':u" 您已经完成该级转职任务，完成转职了，无需再接受！"}
            elif(questTemplate['professionStageRequire'] > self._owner.profession.getProfessionStage()):
                return {'result':False, 'reason':u" 您尚未完成前级转职任务！"}
        if ret == 5:
            return {'result':False, 'reason':u" 您的职业阶段不符合该任务的职业阶段要求！"}

        if dbaccess.getQuestCountByTemplateId(id, questTemplate['id']) > 0:
            return {'result':False, 'reason':u"接收任务失败！您已经在进行此任务"}

        if questTemplate['dropConfig'] != -1:
            result = dbaccess.selectQuestItem(self._owner.baseInfo.id, questTemplateId)
            if result:
                itemId = result[0]
                dbaccess.deleteQuestItem(result[1])
            else:
                dropItem = self._owner.dropping.getItemByDropping(questTemplate['dropConfig'])[0]
                if dropItem:
                    itemId = dropItem[0]
                else:
                    itemId = -1
        else:
            itemId = -1

        questRecordId = dbaccess.insertRecordForApplyQuest(self._owner.baseInfo.id, questTemplateId, itemId)
        if questTemplate['type'] == 2:
            dbaccess.updateTempActiveRewardQuestByQuestTemplateId(questTemplateId, id, {'isLock':1})

        self.setProgressingQuests()
        recordList = list(dbaccess.getPlayerTempActiveRewardQuests(id))
        recordList = self.wrapFixedRewardQuestListForClient(recordList)
        progressingList = self.getProgressingQuestsGroupByType()
        return {'result':True, 'data':{'questTemplateId':questTemplateId, \
                                      'receivedActiveCount':activeRewardQuestCount + 1, \
                                      'questRecordId':questRecordId, \
                                      'activeRewardQuestList':recordList, \
                                      'progressQuestList':progressingList}}

    def commitQuest(self, questId):
        '''提交任务'''
        id = self._owner.baseInfo.id

        questTemlateId = dbaccess.getQuestTemplateByQuestId(questId)
        result = self.isSatifyProgressingQuestGoals(questTemlateId)
        if not result:
            return {'result':result, 'reason':u'该任务尚未达到目标，不能完成'}
        #收集型删除任务物品
        questgoals = loader.get('questgoal', 'questId', questTemlateId, ['itemId', 'itemCount'])
        for questgoal in questgoals:
            if questgoal['itemCount'] > 0:
                dbaccess.deleteCollectionQuestItems(questgoal['itemId'], id, questgoal['itemCount'])

        dbaccess.operateForCommitQuest(questId,id)

        record = dbaccess.getQuestRecordById(questId)
        templateInfo = loader.getById('quest_template', record[1], ['coinBonus', 'type', 'expBonus'])
        coin = self._owner.finance.getCoin() + templateInfo['coinBonus']
        exp = self._owner.level.getExp() + templateInfo['expBonus']
        self._owner.finance.setCoin(coin)
        self._owner.level.setExp(exp)
        professionStage = int(self._owner.profession.getProfessionStage())
        attrs = {'coin':coin, 'exp':exp}
        if templateInfo['type'] == 2:
            #对active_reward_quest表的修改;赏金任务物品奖励持久化
            dbaccess.updateTempActiveRewardQuestByQuestTemplateId(questTemlateId, id, {'isFinish':1, 'isLock':0})
        elif templateInfo['type'] == 4:
            #转职任务
            professionStage += 1
            attrs['professionStage'] = professionStage
        dbaccess.updatePlayerInfo(self._owner.baseInfo.id, attrs)
        self._owner.profession.setProfessionStage(professionStage)
        currentProfessionStageIndex = int(self._owner.profession.getProfessionStage()) - 1
        #奖励任务奖励物品，放入玩家临时包裹蓝中
        if record[6] <> -1:
            item = dbaccess.getItemInfo(record[6])
            self._owner.pack.putOneItemIntoTempPackage(item)
            pushMessage(str(self._owner.baseInfo.id), 'newTempPackage')
            
        self._owner.pack.setTempPackage()
        self._owner.pack.setPackage()

        self.setProgressingQuests()
        if templateInfo['type'] == 2:
            pushMessage(str(self._owner.baseInfo.id), 'questFinish');
        self._owner.level.updateLevel()
        exp = self._owner.level.getExp()
        maxExp = self._owner.level.getMaxExp()
        return {'result':True, 'data':{'exp':exp,'maxExp':maxExp, 'coin':coin, \
                                      'currentProfessionStageIndex':currentProfessionStageIndex}}

    def getQuestDetails(self, questId):
        '''得到任务详细信息'''
        questRecord = dbaccess.getQuestRecordById(questId)
        questInfo = self.wrapQuestRecordObject(questRecord)
        if questRecord[5] == 0:
            questInfo['questType'] = 'progressing'
        else:
            questInfo['questType'] = 'finished'
        return questInfo

    def getRecievableQuestDetails(self, questTemplateId):
        '''获取可接任务详细信息'''
        templateInfo = loader.getById('quest_template', questTemplateId, '*')

        templateInfo = self.wrapRecievableQuestObject(templateInfo)
        questgoals = list(loader.get('questgoal', 'questId', questTemplateId, ['id', 'itemId', 'itemCount', 'killCount', 'npc']))
        for questgoal in questgoals:
            if questgoal['itemId'] <> -1:
                itemName = loader.getById('item_template', questgoal['itemId'], ['name'])['name']
            else:
                itemName = ''
            if questgoal['npc'] <> -1:
                npcNameInfo = loader.getById('npc', questgoal['npc'], ['name'])
                if npcNameInfo:
                    npcName = npcNameInfo['name']
                else:
                    npcName = u'无'
            else:
                npcName = ''
            questgoal['itemName'] = itemName
            npcInfo = {'id':questgoal['npc'], 'name':npcName}
            questgoal['npcInfo'] = npcInfo
            npcInfo = self._getQuestNpcInfo(questgoal['npc'], npcInfo)
            questgoal['parentPlaceList'] = self.getFullPlaceList(npcInfo)

        if templateInfo['dropConfig'] != -1:
            result = dbaccess.selectQuestItem(self._owner.baseInfo.id, questTemplateId)
            if result:
                itemId = result[0]
            else:
                dropItem = self._owner.dropping.getItemByDropping(templateInfo['dropConfig'])[0]
                if dropItem:
                    itemId = dropItem[0]
                    dbaccess.insertQuestTempItem(self._owner.baseInfo.id, questTemplateId, itemId)

            templateInfo['itemBonus'] = self.getQuestItemBouns(itemId)

        templateInfo['questgoals'] = questgoals
        templateInfo['questType'] = 'receieval'
        return templateInfo

    def getQuestItemBouns(self, itemId):
        '''任务奖励物品'''
        itemInfo = dbaccess.getItemInfo(itemId)
        itemTemplateInfo = loader.getById('item_template', itemInfo[2], '*')

        item = Item(itemInfo[0], itemTemplateInfo['name'])
        item.baseInfo.setItemTemplate(itemTemplateInfo)
        item.baseInfo.setItemLevel(int(itemInfo[6]))
        item.binding.setType(itemTemplateInfo['bind'])
        item.binding.setBound(int(itemInfo[5]))
        item.attribute.setSelfExtraAttribute(itemInfo[3])
        item.attribute.setDropExtraAttributes(itemInfo[4])

        itemTemplateInfo = item.baseInfo.getItemTemplate()
        info = {}
        info['itemLevel'] = item.baseInfo.getItemLevel()
        info['itemId'] = item.baseInfo.id
        info['bindType'] = item.binding.getBindTypeName()
        info['isBound'] = item.binding.getBound()
        info['isBoundDesc'] = item.binding.getCurrentBoundStatus()
        info['sellPrice'] = item.finance.getPrice()
#        info['extraAttributeList'] = []#{'name':'','value':''}
        info['extraAttributeList'] = item.attribute.getExtraAttributeList()
#        info['effect'] = itemComponent.effect.getItemEffect()
        info['name'] = item.baseInfo.getName()
        info['from'] = "Character"
        info['itemTemplateInfo'] = itemTemplateInfo

        professionRequire = info['itemTemplateInfo']['professionRequire']
        if info['itemTemplateInfo']['type'] < 1000000:
            if info['itemTemplateInfo']['type'] < 10:
                maxDamage = info['itemTemplateInfo']['maxDamage'] * 0.03 * (item.baseInfo.getItemLevel() - 1)
                minDamage = info['itemTemplateInfo']['minDamage'] * 0.03 * (item.baseInfo.getItemLevel() - 1)
                info['itemTemplateInfo']['maxDamage'] += int(maxDamage)
                info['itemTemplateInfo']['minDamage'] += int(minDamage)
        if professionRequire > 0:
            info['professionRequireName'] = loader.getById('profession', professionRequire, ['name'])['name']
        else:
            info['professionRequireName'] = u'无职业需求'

        return info

    def getQuestgoalDetails(self, progress, goal):
        '''获取任务目标进度详细信息'''
        details = {}
        details['currentKillCount'] = progress[3]
        tempCount = dbaccess.getCollectionQuestItemCount(goal['itemId'], self._owner.baseInfo.id)
        if tempCount > goal['itemCount']:
            details['currentCollectCount'] = goal['itemCount']
        else:
            details['currentCollectCount'] = tempCount
        details['hasTalkedToNpc'] = progress[5]
        details['killCount'] = goal['killCount']
        details['itemCount'] = goal['itemCount']
        details['questgoalId'] = goal['id']

        itemName = loader.getById('item_template', goal['itemId'], ['name'])
        if itemName:
            details['itemName'] = itemName['name']
        else:
            details['itemName'] = u'无物品名称'

        if goal['npc'] == -1:
            details['npcInfo'] = None
        else:
            npcName = loader.getById('npc', goal['npc'], ['name'])['name']
            npcInfo = {'id':goal['npc'], 'name':npcName}
            npcInfo = self._getQuestNpcInfo(goal['npc'], npcInfo)
            details['npcInfo'] = npcInfo
            #要得到地点完整路径
            result = self.getFullPlaceList(npcInfo)
            details['parentPlaceList'] = result

        return details

    def getFullPlaceList(self, npcInfo):
        '''获取questgoal完整路径地址'''
        placeData = loader.getById('place', npcInfo['placeId'], ['parentId', 'name'])
        if not placeData or len(placeData.items()) == 0:
            return 'The place is not exists'
        result = []
        parentId = placeData['parentId']
        if parentId == -1 or parentId == npcInfo['placeId']:
            result.append(placeData['name'])
            return
        while(True):
            parentData = loader.getById('place', parentId, ['parentId', 'name'])
            result.append(parentData['name'])
            if parentId == -1 or parentId == parentData['parentId']:
                break
            parentId = parentData['parentId']
        result.reverse()
        result.append(npcInfo['placeName'])

        if npcInfo['placeId'] > 1000:
            result = result[1:]
        return result

    def getChangingProfessionStageQuests(self):
        '''获取玩家转职任务'''
        id = self._owner.baseInfo.id
        profession = self._owner.profession.getProfession()
        camp = self._owner.camp.getCamp()
        cursor = connection.cursor()
        cursor.execute("select * from `quest_template` where type=4 and professionRequire=%d" % profession)
        quests = cursor.fetchall()
        questLV20 = None
        questLV38 = None
        for quest in quests:
            if quest['minLevelRequire'] == 20 and quest['campRequire'] == camp:
                questLV20 = quest
            else:
                questLV38 = quest
            questRecord = dbaccess.getQuestByTemplateId(id, quest['id'])
            if questRecord:
                quest['questRecordId'] = questRecord[0]
        return questLV20, questLV38



    def wrapQuestRecordObject(self, record):
        '''封装任务详细记录对象'''
        questRecord = {}
        questRecord['id'] = record[0]
        questRecord['questTemplageId'] = record[1]
        questRecord['applyTime'] = record[3]
        questRecord['finishTime'] = record[4]
        questRecord['status'] = record[5]
        #任务奖励信息
        questTemplateBonus = loader.getById('quest_template', record[1], ['coinBonus', 'expBonus'])
        questRecord['coinBonus'] = questTemplateBonus['coinBonus']
        questRecord['expBonus'] = questTemplateBonus['expBonus']
        itemId = record[6]
        if itemId == -1:
            questRecord['itemBonus'] = None
        else:
            questRecord['itemBonus'] = self.getQuestItemBouns(itemId)

        questRecord = self.wrapBriefQuestRecordObject(record, questRecord)

        templateInfo = loader.getById('quest_template', record[1], '*')
        questRecord['questTemplateInfo'] = templateInfo
        #目标provider的信息放在templateInfo中
        providerInfo = loader.getById('npc', templateInfo['provider'], ['image', 'name'])
        providerInfo = self._getQuestNpcInfo(templateInfo['provider'], providerInfo)
        accepterInfo = loader.getById('npc', templateInfo['accepter'], ['image', 'name'])
        accepterInfo = self._getQuestNpcInfo(templateInfo['provider'], accepterInfo)
        questRecord['providerInfo'] = providerInfo
        questRecord['accepterInfo'] = accepterInfo
        return questRecord

    def wrapRecievableQuestObject(self, questInfo):
        '''封装可接任务对象'''
        providerInfo = loader.getById('npc', questInfo['provider'], ['image', 'name'])
        providerInfo = self._getQuestNpcInfo(questInfo['provider'], providerInfo)
        accepterInfo = loader.getById('npc', questInfo['accepter'], ['image', 'name'])
        accepterInfo = self._getQuestNpcInfo(questInfo['accepter'], accepterInfo)
        questInfo['providerInfo'] = providerInfo
        questInfo['accepterInfo'] = accepterInfo
        return questInfo

    def wrapBriefQuestRecordObject(self, record, questInfo):
        '''封装简要任务记录信息'''
        questTemplateInfo = loader.getById('quest_template', record[1], ['name', 'type', 'category', 'accepter'])
        questInfo['name'] = questTemplateInfo['name']
        questInfo['type'] = questTemplateInfo['type']
        questInfo['category'] = questTemplateInfo['category']
        questInfo['id'] = record[0]
        questInfo['questTemplateId'] = record[1]
        accepterId = questTemplateInfo['accepter']
        accepterInfo = loader.getById('npc', accepterId, ['id', 'name'])
        if accepterInfo:
            questInfo['accepterInfo'] = accepterInfo
            self._getQuestNpcInfo(accepterId, accepterInfo)
            questInfo['accepterInfo']['parentPlaceList'] = self.getFullPlaceList(accepterInfo)
        else:
            questInfo['accepterInfo'] = None

        progresses = dbaccess.getQuestGoalProgressesForQuest(record[0])
        detailList = []
        for progress in progresses:
            goal = loader.getById('questgoal', progress[2], ['id', 'itemId', 'itemCount', 'killCount', 'npc', 'npcDialog', 'questId'])
            details = self.getQuestgoalDetails(progress, goal)
            detailList.append(details)
        questInfo['progressesDetails'] = detailList

        return questInfo

    def onSuccessKillOneMonster(self, monsterId, type = 'battle'):
        '''当成功杀死怪物，计算任务目标结果'''
        id = self._owner.baseInfo.id
        item = None
        self._owner.pack.setTempPackage()
        self._owner.pack.setPackage()
        progressingQuestList = self.getProgressingRecordList()
        for quest in progressingQuestList:
            for details in quest['progressesDetails']:
                if details['npcInfo']['id'] == monsterId:
                    if details['killCount'] > 0:#杀怪
                        details['currentKillCount'] += 1
                        if details['currentKillCount'] > details['killCount']:
                            details['currentKillCount'] = details['killCount']
                        dbaccess.updateQuestgoalProgress(quest['id'], details['questgoalId'], \
                                                          {'killMonsterCount':details['currentKillCount']})

                    if details['itemCount'] > 0:#收集
                        if type == 'battle':
                            itemTemplateId = loader.getById('questgoal', details['questgoalId'], ['itemId'])['itemId']
                            if itemTemplateId <> -1:
                                queryResult = dbaccess.getItemInfoByTemplateId(itemTemplateId, id)
                                if queryResult and len(queryResult) > 0:#玩家身上有该物品，为了后面的叠加
                                    item = queryResult[0]
                                    packageInfo = dbaccess.getItemInPackageByItemId(id, item[0])
                                    if packageInfo:#物品在包裹栏中
                                        dbaccess.updateItemAttrsInPackages('package', packageInfo[0], {'stack':packageInfo[4] + 1})
                                        self._owner.pack.setPackage()
                                    else:
                                        packageInfo = dbaccess.getItemInTempPackageByItemId(id, item[0])
                                        if packageInfo:
                                            dbaccess.updateItemAttrsInPackages('temporary_package', packageInfo[0], {'stack':packageInfo[4] + 1})
                                    self._owner.pack.setTempPackage()
#                                    details['currentCollectCount'] += 1
                                else:
                                    ret = self._owner.pack._tempPackage.isTempPackageFull()
                                    if not ret[0]:
                                        dbaccess.insertItemRecord([0, id, itemTemplateId, '-1', '-1', 0, 1])
                                        item = dbaccess.getLastInsertItemInfo()
                                        if item and len(item) > 0:
                                            self._owner.pack.putOneItemIntoTempPackage(item)
                                            pushMessage(str(self._owner.baseInfo.id), 'newTempPackage')
                                            self._owner.pack.setTempPackage()
                        else:
                            pass

#                        if details['currentCollectCount']>details['itemCount']:
#                            details['currentCollectCount']=details['itemCount']
#                        dbaccess.updateQuestgoalProgress(quest['id'], details['questgoalId'],\
#                                                          {'collectItemCount':details['currentCollectCount']})

        self.setProgressingQuests()
        return item

    def onTalkToNpc(self, npcId):
        '''当与npc对话，完成对话任务目标'''
        progressingQuestList = self.getProgressingRecordList()
        for quest in progressingQuestList:
            for details in quest['progressesDetails']:
                if details['npcInfo']['id'] == npcId:
                    if details['killCount'] == 0 and details['itemCount'] == 0:#对话
                        if details['hasTalkedToNpc'] == 0:
                            dbaccess.updateQuestgoalProgress(quest['id'], details['questgoalId'], \
                                                             {'hasTalkedtoNPC':1})

        self.setProgressingQuests()

    def isSatifyProgressingQuestGoals(self, questTemplateId):
        ''' 是否满足任务达成条件 '''
        characterId = self._owner.baseInfo.id

        questId = dbaccess.getQuestByTemplateId(characterId, questTemplateId)[0]
        questGoalProgresses = dbaccess.getQuestGoalProgressesForQuest(questId)
        for progress in questGoalProgresses:
            goal = loader.getById('questgoal', progress[2], '*')
                #'''杀怪'''
            if goal['killCount'] > 0:
                if goal["killCount"] > progress[3]:
                        return False
            if goal['itemCount'] > 0:
                count = dbaccess.getCollectionQuestItemCount(goal['itemId'], characterId)
                if goal["itemCount"] > count:
                    return False
#                if goal["itemCount"] > progress[4]:
#                    return False
                #'''收集'''
            if goal['killCount'] == 0 and goal['itemCount'] == 0:
                #'''对话'''
                if progress[5] == 0:
                    return False

        return True

    def _isMatchLimit(self, templateInfo):
        '''判断是否符合接收条件'''
        characterId = self._owner.baseInfo.id
        profession = self._owner.profession.getProfession()
        camp = self._owner.camp.getCamp()
        level = self._owner.level.getLevel()
        professionStage = self._owner.profession.getProfessionStage()

        parentId = templateInfo['parentId']
        minLevelRequire = templateInfo['minLevelRequire']
        maxLevelRequire = templateInfo['maxLevelRequire']
        campRequire = templateInfo['campRequire']
        professionRequire = templateInfo['professionRequire']
        professionStageRequire = templateInfo['professionStageRequire']

        if parentId != '' or parentId != u'' :
            parentIds = parentId.split(';')
            for id in parentIds:
                id = int(id)
                if dbaccess.getQuestCountByTemplateId(characterId, id) > 0:
                    return 0
        if (level < minLevelRequire) and (minLevelRequire != -1):
            return 1
        if (camp != campRequire) and (campRequire != -1):
            return 2
    #    if (char['title']) < positionlimit and (positionlimit!=-1):
    #        return 3
    #    if((profession!=professionRequire) and (professionRequire!=-1)):
    #        return 4
        if(professionStage < professionStageRequire) and (professionStageRequire != -1):
            return 5
        return 6

    def _getQuestNpcInfo(self, npcId, info):
        '''获取任务npc信息'''
        cursor = connection.cursor()
        cursor.execute("select placeId from `place_npc` where npcId=%d" % npcId)
        placeId = cursor.fetchall()
        placeIdLen = len(placeId)
        for id in placeId:
            cursor.execute("select name,camp,type from `place` where id=%d" % int(id['placeId']))
            placeName = cursor.fetchone()
            if placeIdLen != 1:
                if placeName['camp'] == self._owner.camp.getCamp() or placeName['camp'] == -1:
                    info['placeId'] = id['placeId']
                    info['placeName'] = placeName['name']
                    info['parentPlaceList'] = self.getFullPlaceList(info)
            else:
                info['placeId'] = id['placeId']
                info['placeName'] = placeName['name']
                info['parentPlaceList'] = self.getFullPlaceList(info)
            cursor.close()
        return info


# '''赏金任务'''


    def getAllRecievableRewardQuestList(self, npcId):
        '''得到所有符合玩家条件的赏金任务列表'''
        questLevel = 10
        level = self._owner.level.getLevel()
        camp = self._owner.camp.getCamp()
        if level >= 10 and level < 20:
            questLevel = 10
        elif level >= 20 and level < 30:
            questLevel = 20
        elif level >= 30 and level < 40:
            questLevel = 30
        elif level >= 40 and level < 50:
            questLevel = 40
        elif level >= 50 and level < 60:
            questLevel = 50
        else:
            questLevel = 60
        cursor = connection.cursor()
        cursor.execute("select * from `quest_template` where type=2 and provider=%s and minLevelRequire =%d\
         and campRequire=%d" % (npcId, questLevel, camp))
        rewardQuestList = cursor.fetchall()
        cursor.close()
        return rewardQuestList

    def getFixedRewardQuestList(self, npcId):
        '''得到玩家的绑定的赏金任务列表（4个),active_reward_quest'''
        id = self._owner.baseInfo.id
        recordList = list(dbaccess.getPlayerTempActiveRewardQuests(id))
        if len(recordList) < self.TEMPACTIVEQUESTCOUNT:
            index = self.TEMPACTIVEQUESTCOUNT - len(recordList)
            recordList = self.getAllRecievableRewardQuestList(npcId)[0:index]
            i = 1
            for elm in recordList:
                createTime = str(datetime.datetime.now())
                insertProps = [0, id, elm['id'], 0, createTime, 0, i]
                dbaccess.insertActiveRewardQuest(insertProps)
                i += 1
            recordList = dbaccess.getPlayerTempActiveRewardQuests(id)

        
        if self.rewardQuestListIsFinish(recordList):
            recordList = list(dbaccess.getPlayerTempActiveRewardQuests(id))
        rewardList = []
        rewardList = self.wrapFixedRewardQuestListForClient(recordList)
        return rewardList
    
    def rewardQuestListIsFinish(self,recordList): 
        '''判断赏金任务自动完成任务是否已过期'''
        bol = False
        for elm in recordList:
            elm = elm[2:]
            templateId = elm[0]
            elm = list(elm)
            quest = loader.getById('quest_template', templateId, ['name', 'category'])
            elm.append(quest['name'])
            elm.append(quest['category'])

            if elm[3] == 1:#锁定
                questRecord = dbaccess.getQuestByTemplateId(self._owner.baseInfo.id, templateId)
                if questRecord:
                    elm[0] = questRecord[0]
                    if questRecord[4]:
                        if datetime.datetime.now() > questRecord[4]:
                            self._finishActiveRewardQuest(templateId)
                            bol = True
        
        return bol                    

    def wrapFixedRewardQuestListForClient(self, recordList):
        '''整理玩家的绑定的赏金任务列表，返回到客户端'''
        result = []
        for elm in recordList:
            elm = elm[2:]
            templateId = elm[0]
            elm = list(elm)
            quest = loader.getById('quest_template', templateId, ['name', 'category'])
            elm.append(quest['name'])
            elm.append(quest['category'])

            if elm[3] == 1:#锁定
                questRecord = dbaccess.getQuestByTemplateId(self._owner.baseInfo.id, templateId)
                if questRecord:
                    elm[0] = questRecord[0]
                    if questRecord[4]:
#                        deltaTime = questRecord[3] + datetime.timedelta(minutes = 30)
                        if datetime.datetime.now() < questRecord[4]:
                            deltaTime = questRecord[4] - datetime.datetime.now()
                            seconds = deltaTime.seconds
                            elm.append(seconds)
                            reactor.callLater(seconds, self._finishActiveRewardQuest, templateId)
                    else:
                        elm.append(-1)
                else:
                    elm.append(-1)
            elif elm[1] == 1:#已完成
                questRecord = dbaccess.getQuestByTemplateId(self._owner.baseInfo.id, templateId)
                if questRecord:
                    elm[0] = questRecord[0]
                elm.append(-1)
            else:
                elm.append(-1)

            result.append(elm)
        return result

    def autoFinishActiveRewardQuest(self, questTemplateId):
        '''自动完成赏金任务'''
        id = self._owner.baseInfo.id

        now = datetime.datetime.now()
        delta = datetime.timedelta(minutes = self.AUTOFINISHTIME / 60)
        nextTime = (now + delta).isoformat(' ')

        progressingRecords = dbaccess.getProgressingRecords(id)
        i = 0
        for record in progressingRecords:
            if record[1] == questTemplateId:
                self._oneQuestCallLater = reactor.callLater(self.AUTOFINISHTIME, self._finishActiveRewardQuest, questTemplateId)
                dbaccess.updateQuestRecordByTemplateId(questTemplateId, {'finishTime':nextTime})
                break
            i += 1
        if i >= len(progressingRecords):
            ret = self.applyQuest(questTemplateId)
            if not ret['result']:
                return ret
            self._oneQuestCallLater = reactor.callLater(self.AUTOFINISHTIME, self._finishActiveRewardQuest, questTemplateId)
            dbaccess.updateQuestRecordByTemplateId(questTemplateId, {'finishTime':nextTime})

        recordList = list(dbaccess.getPlayerTempActiveRewardQuests(id))
        recordList = self.wrapFixedRewardQuestListForClient(recordList)
        progressingList = self.getProgressingQuestsGroupByType()
        currentRewardQuestCount = self.getRewardQuestCountForToday()

        return {'result':True, 'data':{'autoFinishTime':self.AUTOFINISHTIME, 'activeRewardQuestList':recordList, \
                                      'progressQuestList':progressingList, 'currentRewardQuestCount':currentRewardQuestCount}}

    def immediateFinishActiveRewardQuest(self, questRecordId, payType, payNum):
        '''立即完成赏金任务'''
        id = self._owner.baseInfo.id

        templateId = dbaccess.getQuestTemplateByQuestId(questRecordId)
        gold = self._owner.finance.getGold()
        coupon = self._owner.finance.getCoupon()
        if payType == 'gold':
            gold -= payNum
            if gold < 0:
                return {'result':False, 'reason':u'您的黄金量不足'}
            dbaccess.updatePlayerInfo(id, {'gold':gold})
            self._owner.finance.setGold(gold)
        else:
            coupon -= payNum
            if coupon < 0:
                return {'result':False, 'reason':u'您的礼券量不足'}
            dbaccess.updatePlayerInfo(id, {'coupon':coupon})
            self._owner.finance.setCoupon(coupon)
        dbaccess.operateForCommitQuest(questRecordId,id)
        dbaccess.updateTempActiveRewardQuestByQuestTemplateId(templateId, id, {'isFinish':1, 'isLock':0})

        self.setProgressingQuests()

        recordList = list(dbaccess.getPlayerTempActiveRewardQuests(id))
        recordList = self.wrapFixedRewardQuestListForClient(recordList)
        progressingList = self.getProgressingQuestsGroupByType()

        questBonus = loader.getById('quest_template', templateId, ['coinBonus', 'expBonus'])
        coin = self._owner.finance.getCoin() + questBonus['coinBonus']
        self._owner.finance.setCoin(coin)
        exp = self._owner.level.getExp() + questBonus['expBonus']
        self._owner.level.setExp(exp)
        self._owner.level.updateLevel()
        record = dbaccess.getQuestRecordById(questRecordId)
        
        if record[6] <> -1:
            item = dbaccess.getItemInfo(record[6])
            self._owner.pack.putOneItemIntoTempPackage(item)
            pushMessage(str(self._owner.baseInfo.id), 'newTempPackage')
        
        self._oneQuestCallLater.cancel()
        
        return {'result':True, 'data':{'questRecordId':questRecordId, 'coupon':coupon, 'gold':gold, \
                                      'coin':coin, 'exp':exp, \
                                      'activeRewardQuestList':recordList, \
                                      'progressQuestList':progressingList}}

    def autoRefreshActiveRewardQuestList(self, npcId):
        '''
                      自动刷新赏金任务列表
        @param id: 玩家id
        '''
        if not self._callBol:
            return 
        
        self._callBol = False
        id = self._owner.baseInfo.id

        self._allQuestCallLater = reactor.callLater(self.AUTOREFRESHTIME, self.refreshActiveRewardQuestList, npcId,False)

        currentList = self.getFixedRewardQuestList(npcId)
        progressingList = self.getProgressingQuestsGroupByType()

        return{'result':True, 'data':{'refreshTime':self.AUTOREFRESHTIME, 'activeRewardQuestList':currentList, 'progressQuestList':progressingList}}

    def immediateRefreshActiveRewardQuestList(self, payType, payNum, npcId):
        '''
                      立即刷新赏金任务列表
        @param payType: 支付类型
        @param payNum: 支付数量
        '''
        id = self._owner.baseInfo.id

        gold = self._owner.finance.getGold()
        coupon = self._owner.finance.getCoupon()
        if payType == 'gold':
            gold -= payNum
            if gold < 0:
                return {'result':False, 'reason':u'您的黄金量不足'}
            dbaccess.updatePlayerInfo(id, {'gold':gold})
            self._owner.finance.setGold(gold)
        else:
            coupon -= payNum
            if coupon < 0:
                return {'result':False, 'reason':u'您的礼券量不足'}
            dbaccess.updatePlayerInfo(id, {'coupon':coupon})
            self._owner.finance.setCoupon(coupon)

        self._allQuestCallLater.cancel()
        activeRewardQuestList, progressingList = self.refreshActiveRewardQuestList(npcId,True)
        return{'result':True, 'data':{'activeRewardQuestList':activeRewardQuestList, \
                                     'progressQuestList':progressingList, \
                                     'intervalSeconds':self.AUTOREFRESHTIME, \
                                     'gold':gold, 'coupon':coupon}}

    def getProgressingQuestsGroupByType(self):
        '''获取按任务类型分类的进行中任务'''
        mainThreadQuests = []
        subThreadQuests = []
        activeRewardQuests = []

        for elm in self._progressingRecordList:
            info = {'id':elm['id'], 'name':elm['name']}
            if elm['type'] == 1:
                mainThreadQuests.append(info)
            elif elm['type'] == 2:
                activeRewardQuests.append(info)
            elif elm['type'] == 3:
                subThreadQuests.append(info)
            else:
                pass
        return mainThreadQuests, subThreadQuests, activeRewardQuests

    def getRewardQuestCountForToday(self):
        '''获取今天已接赏金任务数量'''
        id = self._owner.baseInfo.id

        count = 0
        questRecordList = dbaccess.getQuestRecordOfToday(id)
        for record in questRecordList:
            type = loader.getById('quest_template', record[1], ['type'])['type']
            if type == 2:
                count += 1
        return count

    def _finishActiveRewardQuest(self, templateId):
        '''在赏金组织内提交完成赏金任务'''
        id = self._owner.baseInfo.id

        questRecord = dbaccess.getQuestByTemplateId(id, templateId)
        if not questRecord:
            return
        questId = questRecord[0]
        dbaccess.operateForCommitQuest(questId,id)
        dbaccess.updateTempActiveRewardQuestByQuestTemplateId(templateId, id, {'isFinish':1, 'isLock':0})

        pushMessage(str(self._owner.baseInfo.id), 'questFinish');

        questBonus = loader.getById('quest_template', templateId, ['coinBonus', 'expBonus'])
        coin = self._owner.finance.getCoin() + questBonus['coinBonus']
        self._owner.finance.setCoin(coin)
        exp = self._owner.level.getExp() + questBonus['expBonus']
        self._owner.level.setExp(exp)
        self._owner.level.updateLevel()
        record = dbaccess.getQuestRecordById(questId)
        if record[6] <> -1:
            item = dbaccess.getItemInfo(record[6])
            self._owner.pack.putOneItemIntoTempPackage(item)
            pushMessage(str(self._owner.baseInfo.id), 'newTempPackage')
        self._owner.pack.setTempPackage()
        self._owner.pack.setPackage()
        self.setProgressingQuests()

    def refreshActiveRewardQuestList(self, npcId,type):
        '''刷新赏金任务'''  
        self._callBol = True
        id = self._owner.baseInfo.id

        templateIdList, sequenceList = dbaccess.deleteUnLockedActiveRewardQuests(id)
        recievableList = list(self.getAllRecievableRewardQuestList(npcId))

        import random
        count = self.TEMPACTIVEQUESTCOUNT - len(templateIdList)
        i = 0
        while(True):
            if i == count:
                break
            r = random.randint(0, len(recievableList) - 1)
            if recievableList[r]['id'] in templateIdList:
                continue
            insertProps = [0, id, recievableList[r]['id'], 0, str(datetime.datetime.now()), 0, sequenceList[i]]
            dbaccess.insertActiveRewardQuest(insertProps)
            templateIdList.append(recievableList[r]['id'])
            i += 1

#        dbaccess.updatePlayerEnterQuestRoomTime(id, (datetime.datetime.now()))
        if type:
            pushMessage(str(self._owner.baseInfo.id), 'restFinish')

        currentList = self.getFixedRewardQuestList(npcId)
        progressingList = self.getProgressingQuestsGroupByType()

        return currentList, progressingList


