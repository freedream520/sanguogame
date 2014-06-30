#coding:utf8
'''
Created on 2010-3-2

@author: wudepeng
'''

from component.Component import Component
from net.MeleeSite import pushMessage
from component.pack.Package import Package
from util import util
from util.DataLoader import loader, connection
from util import dbaccess
import random
import datetime
from twisted.internet import reactor

reactor = reactor

class CharacterShopComponent(Component):
    '''
    character shop component
    '''

    def __init__(self, owner):
        '''
        Constructor
        '''
        Component.__init__(self, owner)
        self.shopPackage = Package(6, 8)
        self.weaponPagedItems = [[]]#武器店分页后数组
        self.armorPagedItems = [[]]#防具店...
        self.materialPagedItems = [[]]#材料店...
        self.groceriesPagedItems = [[]]#杂货店...
        self.REFRESHSHOPITEMSTIME = 3600

    def getShopNpcInfo(self, placeId):
        '''获取商店npc信息'''
        shopNpcInfo = loader.get('shop', 'type', placeId, ['description'])
        shopNpcInfo = shopNpcInfo[0]
        npcId = loader.get('place_npc', 'placeId', placeId, ['npcId'])[0]['npcId']
        npcImage = loader.getById('npc', npcId, ['image'])['image']
        shopNpcInfo['image'] = npcImage
        shopNpcInfo['id'] = npcId
        return shopNpcInfo

    def getPagedShopItems(self, placeId):
        '''获取分页后的商店物品'''
        pagedItems = [[]]
        self.shopPackage._items = []

        placeName = loader.getById('place', placeId, ['name'])
        if not placeName:
            return []
        placeName = placeName['name']
        if placeName == u'武器屋':
            pagedItems = self.weaponPagedItems
        elif placeName == u'防具屋':
            pagedItems = self.armorPagedItems
        elif placeName == u'材料店':
            pagedItems = self.materialPagedItems
        elif placeName == u'杂货店':
            pagedItems = self.groceriesPagedItems
        if pagedItems == [[]]:
            items = self.getShopItems(placeId)
            i = 0
            for item in items:
                itemWidth = item['itemTemplateInfo']['width']
                itemHeight = item['itemTemplateInfo']['height']
                position = self.shopPackage.findSparePositionForItem(itemWidth, itemHeight)
                if position == [-1, -1]:
                    i += 1
                    self.shopPackage._items = []
                    pagedItems.append([])
                    position = [0, 0]
                    item['position'] = position
                else:
                    item['position'] = position
                pagedItems[i].append(item)
                self.shopPackage.putItemByPosition(position, item)
            if placeName == u'武器屋':
                self.weaponPagedItems = util.objectCopy(pagedItems)
            elif placeName == u'防具屋':
                self.armorPagedItems = util.objectCopy(pagedItems)
            elif placeName == u'材料店':
                self.materialPagedItems = util.objectCopy(pagedItems)
            elif placeName == u'杂货店':
                self.groceriesPagedItems = util.objectCopy(pagedItems)
        return pagedItems

    def buyItem(self, itemTemplateId, dropExtraAttributeId, stack, toPosition):
        '''购买物品'''
        id = self._owner.baseInfo.id

        templateInfo = loader.getById('item_template', itemTemplateId, ['width', 'height'])
        position = self._owner.pack._package.scanItemGrids(toPosition, templateInfo['width'], templateInfo['height'])
        if not position :
            return False, u'此地已有物品'

        list = [0, id, itemTemplateId, -1, dropExtraAttributeId, 0, 1]
        dbaccess.insertItemRecord(list)
        item = dbaccess.getLastInsertItemInfo()


        packageList = [0, id, item[0], str(toPosition[0]) + "," + str(toPosition[1]), stack]
        newPackageInfo = dbaccess.insertRecordInPackage(packageList)
        newPackageInfo = self._owner.pack.wrapNewRecordInPackage({'newSplitRecord':newPackageInfo})
        self._owner.pack.setPackage()
        return True, newPackageInfo

    def getRelatedShops(self):
        '''获取玩家所在国家的四所相关商店'''
        camp = self._owner.camp.getCamp()
        sql = "select id,name from `place` where camp=%d and (name='武器屋' or name='防具屋' or name='杂货屋' or name='材料屋')" % camp
        cursor = connection.cursor()
        cursor.execute(sql)
        result = cursor.fetchall()
        cursor.close()
        return result

    def enterShop(self, placeId):
        '''玩家进入商店'''
        characterId = self._owner.baseInfo.id
        enterShopRecord = dbaccess.getPlayerShopRecord(characterId, placeId)
        now = datetime.datetime.now()
        if enterShopRecord:
            delta = self.REFRESHSHOPITEMSTIME - (now - enterShopRecord[3]).seconds
            if delta < 0:
                dbaccess.updatePlayerEnterShopTime(characterId, placeId, str(now))
                time = self.REFRESHSHOPITEMSTIME
            else:
                time = delta
        else:
            props = [0, placeId, characterId, str(now), '']
            dbaccess.insertPlayerShopRecord(props)
            time = self.REFRESHSHOPITEMSTIME

        reactor.callLater(self.REFRESHSHOPITEMSTIME, self.refreshShopItems, placeId)

        return time

    def refreshShopItems(self, placeId):
        ''''''
        id = self._owner.baseInfo.id
        pushMessage(str(id), 'refresh shop items')

    def getShopItems(self, placeId):
        '''获取商店物品'''
        shopInfo = loader.get('shop', 'type', placeId, '*')[0]
        count = shopInfo['count']
        list = []
        for i in range(0, count):
            item = self.getOneShopItem(shopInfo)
#            k = 0
            while not item:
#                if k==5:
#                    break
#                k += 1
                item = self.getOneShopItem(shopInfo)
            if item:
                list.append(item)
        return list

    def getOneShopItem(self, shopInfo):
        '''得到一个商店物品'''
        negtiveDelta = (self._owner.level.getLevel() - shopInfo['qualityLevelNegtiveDelta']) / 3
        positiveDelta = (self._owner.level.getLevel() + shopInfo['qualityLevelPositiveDelta']) / 3
        qualityLevel = random.randint(negtiveDelta, positiveDelta)
        goodTypes = shopInfo['goodsType'].split(';')

        types = []
        tempTypes1 = []#存放>1000的临时数组
        tempTypes2 = []#存放<=1000临时数组
        for elm in goodTypes:
            elm = int(elm)
            types.append(elm)
            if elm > 1000:
                tempTypes1.append(elm)
            else:
                tempTypes2.append(elm)
        for type1 in tempTypes1:
            for type2 in tempTypes2:
                type = type1 + type2
                types.append(type)

        itemTemplateList = loader.get('item_template', 'qualityLevel', qualityLevel, '*')
        shopItemList = []
        for itemTemplate in itemTemplateList:
            if itemTemplate['type'] in types:
                shopItemList.append(itemTemplate)
        if len(shopItemList) == 0:
            return None
        r = random.randint(0, len(shopItemList))
        if r > 0:
            r -= 1
        itemTemplate = shopItemList[r]
        #计算附加属性
        exAttrCount = self.getShopItemExtraAttrCount(shopInfo)
        extraAttributes = []
        name = u''
        for i in range(0, exAttrCount):
            attribute = self.getShopItemExtraAttr(shopInfo)
            flag = 0
            for elm in extraAttributes:
                if elm['id'] == attribute['id']:
                    attribute = self.getShopItemExtraAttr(shopInfo)
                    continue
                else:
                    flag += 1
                    continue
            if flag == len(extraAttributes):
                extraAttributes.append(attribute)
            name += attribute['name']

        info = {}
        info['itemTemplateInfo'] = itemTemplate
        info['extraAttributeList'] = extraAttributes
        bindType = itemTemplate['bind']
        bindTypeDesc = u''
        if bindType == 0:
            bindTypeDesc = u"非绑定物品"
        elif bindType == 1:
            bindTypeDesc = u"拾取即绑定"
        elif bindType == 2:
            bindTypeDesc = u"装备即绑定"
        else:
            bindTypeDesc = u""
        info['bindType'] = bindTypeDesc
        if name == u'':
            info['name'] = itemTemplate['name']
        else:
            info['name'] = name + "的" + itemTemplate['name']
        #价格
        extraAttribute = ''
        for elm in extraAttributes:
            extraAttribute += str(elm['id']) + ","
        info['sellPrice'] = self.getShopItemPrice(itemTemplate['id'], extraAttribute)
        #层叠数
        if itemTemplate['stack'] <> -1:
            info['stack'] = 10
        else:
            info['stack'] = 1
        return info

    def getShopItemExtraAttrCount(self, shopInfo):
        '''得到商店物品附加属性数量'''
        characterLevel = self._owner.level.getLevel()

        cursor = connection.cursor()
        sql = "select countRatio from `shop_extra_attr_count_config` where type=%d and characterLevel=%d"\
            % (shopInfo['extraAttrCountConfigType'], characterLevel)
        cursor.execute(sql)
        countRatio = cursor.fetchone()['countRatio']
        cursor.close()
        ratios = countRatio.split(';')
        count = 0
        i = 0
        for ratio in ratios:
            i += 1
            ratio = int(ratio)
            r = random.randint(0, 100000)
            if r < ratio:
                count = len(ratios) - i + 1
                break
            else:
                continue
        return count

    def getShopItemExtraAttr(self, shopInfo):
        '''得到商店物品附加属性'''
        characterLevel = self._owner.level.getLevel()

        cursor = connection.cursor()
        sql = "select parameterMin,parameterMax from `shop_extra_attr_level_config` where type=%d and characterLevel=%d"\
            % (shopInfo['extraAttrLevelConfigType'], characterLevel)
        cursor.execute(sql)
        result = cursor.fetchone()
        min = result['parameterMin']
        max = result['parameterMax']
        r = random.randint(min, max)
        cursor.execute("select level from `exattribute_level` where value>=%d" % r)
        level = cursor.fetchone()['level']
        cursor.execute("select * from `extra_attributes` where level=%d" % level)
        tempAttributeList = cursor.fetchall()
        r1 = random.randint(0, len(tempAttributeList) - 1)
        attributeInfo = tempAttributeList[r1]

        attributeInfo['attributeEffects'] = []
        if attributeInfo['effects'] <> '-1' or attributeInfo['effects'] <> u'-1':
            effects = attributeInfo['effects'].split(';')
            for effect in effects:
                effect = int(effect)
                description = loader.getById('effect', effect, ['description'])['description']
                attributeInfo['attributeEffects'].append(description)
        else:
            script = attributeInfo['script']
            script = util.parseScript(script)
            attributeInfo['attributeEffects'].append(script)

        return attributeInfo

    def getShopItemPrice(self, itemTemplateId, extraAttribute):
        '''获取商店物品的购买价格'''
        sellPrice = loader.getById('item_template', itemTemplateId, ['buyingRateCoin'])['buyingRateCoin']
        extraAttributes = eval('[' + extraAttribute + ']')
        for extraAttrId in extraAttributes:
            extraAttrId = int(extraAttrId)
            isValidExtraAttrID = loader.getById('extra_attributes', extraAttrId, ['id'])
            if((extraAttrId != -1) and isValidExtraAttrID):
                eAttribute = loader.getById('extra_attributes', extraAttrId, ['level'])
                cursor = connection.cursor()
                cursor.execute("select price from exattribute_level where level=%d" % eAttribute['level'])
                value = cursor.fetchone()
                cursor.close()
                sellPrice += int(value['price'])
        return sellPrice
