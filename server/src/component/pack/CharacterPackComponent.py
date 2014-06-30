#coding:utf8

'''
Created on 2009-12-2

@author: wudepeng
'''
from net.MeleeSite import pushMessage
from component.Component import Component
from component.pack.Package import Package, TempPackage, WarehousePackage, DealPackage2, DealPackage1, ForgingPakcage
from core.Item import Item
from util.DataLoader import loader
from util import dbaccess
import random

class CharacterPackComponent(Component):
    '''
    pack component for character
    '''

    #装备栏中装备位置编号（item的bodytype，装备在身体的部位）
    HEADER = 0 #头部（帽子）
    BODY = 1 #身体（上衣）
    BELT = 2 #腰带
    TROUSERS = 3 #下装
    SHOES = 4 #鞋子
    BRACER = 5 #护腕
    CLOAK = 6 #披风
    NECKLACE = 7 #项链
    WAIST = 8 #腰饰
    WEAPON = 9 #武器

    def __init__(self, owner):
        '''
        Constructor
        '''
        Component.__init__(self, owner)
        self._package = None #包裹栏
        self.setPackage()
        self._tempPackage = None #临时包裹栏
        self.setTempPackage()
        self._equipmentSlot = [] #装备栏
        self.setEquipment()
        self._warehousePackage = None
        self._warehouseItems = [] #仓库栏
        self._warehousePage = 0 #第几个仓库
        self.setWarehousePackage()
        self.setWarehousePackageItems(0)
        self._forgingPakcage = None #锻造包
#        self._dealPackage1 = None #我的交易栏
#        self._dealPackage2 = None #对方的交易栏

    def setForgingPackage(self):
        self._forgingPakcage = ForgingPakcage(6, 6)
        items = dbaccess.getForgingPackage(self._owner.baseInfo.id)
        itemsInfo = self.formateItemForClient(items)
        for itemInfo in itemsInfo:
            item = self.wrapItemComponentForInitPackage(itemInfo)
            self._forgingPakcage.putItemByPosition(itemInfo['position'], item)
        items = self._forgingPakcage.getItems()
        return self.getPackageItemDetails(items)

    def setSyntheticItem(self):
        items = self._forgingPakcage.getItems()
        items = self.getPackageItemDetails(items)
        syntheticItems = []
        upgradeItems = []
        for item in items:
            if item['itemTemplateInfo']['type'] < 1000000 and item['itemTemplateInfo']['type'] != 100:
                syntheticItems.append(item)
            if item['itemTemplateInfo']['type'] == 100:
                upgradeItems.append(item)
        if len(syntheticItems) > 1  and len(upgradeItems) > 0:
            return {'result':False, 'reason':u'只能放置一件物品！'}
        elif len(syntheticItems) == 0  and len(upgradeItems) > 0:
            return {'result':False, 'reason':u'请放置一件物品！'}
        elif len(upgradeItems) == 0:
            return {'result':False, 'reason':u'请放置升级物品！'}


        if syntheticItems[0]['itemLevel'] < 9:
            probabilitys, degrade = self.probability(int(syntheticItems[0]['itemLevel']))
            dbaccess.deleteUpgradeItem(int(upgradeItems[0]['itemId']), upgradeItems[0]['stack'])
        else:
            return {'result':False, 'reason':u'此装备无法再升级！'}

        if random.randint(0, 100) <= probabilitys:
            dbaccess.updataForgingPackage(int(syntheticItems[0]['itemId']), int(syntheticItems[0]['itemLevel'] + 1))
            return {'result':True, 'reason':u'恭喜您！升级成功！', 'data':self.setForgingPackage()}
        else:
            dbaccess.updataForgingPackage(int(syntheticItems[0]['itemId']), degrade)
            return {'result':True, 'reason':u'很遗憾！升级失败！', 'data':self.setForgingPackage()}



    def probability(self, idx):
        '''装备升级的几率 和失败等级'''
        if idx == 1 or idx == 2 or idx == 3:
            return 100, idx + 1;
        elif idx == 4 :
            return 90, 3;
        elif idx == 5:
            return 80, 4;
        elif idx == 6:
            return 70, 5;
        elif idx == 7:
            return 50, 1;
        elif idx == 8:
            return 30, 1;

#    def setDealPackage(self,playerId):
#        self._dealPackage1 = DealPackage1(6,4)
#        self._dealPackage2 = DealPackage2(6,4)
#        items = dbaccess.getPlayerItemsInPackage(self._owner.baseInfo.id)
#        itemsInfo = self.formateItemForClient(items)
#        for itemInfo in itemsInfo:
#            item = self.wrapItemComponentForInitPackage(itemInfo)
#            self._dealPackage1.putItemByPosition(itemInfo['position'],item)
#            
#        items = dbaccess.getPlayerItemsInPackage(playerId)
#        itemsInfo = self.formateItemForClient(items)
#        for itemInfo in itemsInfo:
#            item = self.wrapItemComponentForInitPackage(itemInfo)
#            self._dealPackage2.putItemByPosition(itemInfo['position'],item)

    def setWarehousePackage(self):
        self._warehousePackage = WarehousePackage(6, 6)
        data = []
        self._warehouseItems = []
        for i in range(1, int(self._owner.warehouse.getWarehouses() + 1)):
            items = dbaccess.getWarehousePackage(self._owner.baseInfo.id, i)
            itemsInfo = self.formateItemForClient(items)
            pageData = []
            for itemInfo in itemsInfo:
                item = self.wrapItemComponentForInitPackage(itemInfo)
                self._warehousePackage.putItemByPosition(itemInfo['position'], item)
                pageData.append([itemInfo['position'], item])
            self._warehouseItems.append(pageData)
            warehouseItems = self._warehousePackage.getItems()
            self._warehousePackage._items = []
            data.append(self.getPackageItemDetails(warehouseItems))
        return data

    def setWarehousePackageItems(self, idx):
        self._warehousePackage._items = []
        self._warehousePage = idx
        for itemInfo in self._warehouseItems[idx]:
            self._warehousePackage.putItemByPosition(itemInfo[0], itemInfo[1])

    def getEquipment(self):
        return self._equipment

    def setEquipment(self):#[component,...,component] 
        self._equipmentSlot = []
        record = dbaccess.getDetailsInEquipmentSlot(self._owner.baseInfo.id)
        if len(record) == 0:
            self._equipmentSlot = [None, None, None, None, None, None, None, None, None, None]
            return
        for idx in range(0, len(record)):
            if idx < 2:
                continue
            if record[idx] == -1:
                self._equipmentSlot.append(None)
            else:
                itemInfo = dbaccess.getItemInfo(record[idx])
                if not itemInfo:
                    continue
                itemComponent = self.wrapItemComponentForInitSlotPackage(itemInfo)
                self._equipmentSlot.append(itemComponent)

    def getPackage(self):
        return self._package

    def setPackage(self):
        self._package = Package(14, 4)
        items = dbaccess.getPlayerItemsInPackage(self._owner.baseInfo.id)
        itemsInfo = self.formateItemForClient(items)
        for itemInfo in itemsInfo:
            item = self.wrapItemComponentForInitPackage(itemInfo)
            self._package.putItemByPosition(itemInfo['position'], item)

    def getTempPackage(self):
        return self._tempPackage

    def setTempPackage(self):
        self._tempPackage = TempPackage(5, 2)
        items = dbaccess.getPlayerItemsInTempPackage(self._owner.baseInfo.id)
        itemsInfo = self.formateItemForClient(items)
        for itemInfo in itemsInfo:
            item = self.wrapItemComponentForInitPackage(itemInfo)
            self._tempPackage.putItemByPosition(itemInfo['position'], item)

    def formateItemForClient(self, items):
        '''获取包裹蓝物品信息'''
        result = []
        for item in items:
            info = {}
            info['idInPackage'] = item[0]
            itemInfo = dbaccess.getItemInfo(item[1])
            info['position'] = eval("[" + item[2] + "]")
            info['stack'] = int(item[3])
            info['itemId'] = int(itemInfo[0])
            info['selfExtraAttributeId'] = itemInfo[3]
            info['dropExtraAttribute'] = itemInfo[4]
            info['isBound'] = int(itemInfo[5])
            info['itemTemplateInfo'] = loader.getById('item_template', itemInfo[2], '*')
            info['isEquiped'] = False
            info['itemLevel'] = int(itemInfo[6])
            result.append(info)
        return result

    def wrapItemComponentForInitPackage(self, itemInfo):
        '''初始化包裹蓝时，封装itemComponent对象'''
        item = Item(itemInfo['itemId'], itemInfo['itemTemplateInfo']['name'])
        item.baseInfo.setItemTemplate(itemInfo['itemTemplateInfo'])
        item.baseInfo.setItemLevel(int(itemInfo['itemLevel']))
        item.baseInfo.setIdInPackage(itemInfo['idInPackage'])
        item.binding.setType(itemInfo['itemTemplateInfo']['bind'])
        item.binding.setBound(itemInfo['isBound'])
        item.attribute.setSelfExtraAttribute(itemInfo['selfExtraAttributeId'])
        item.attribute.setDropExtraAttributes(itemInfo['dropExtraAttribute'])
        item.pack.setWidth(itemInfo['itemTemplateInfo']['width'])
        item.pack.setHeight(itemInfo['itemTemplateInfo']['height'])
        item.pack.setStack(itemInfo['stack'])
        return item

    def wrapItemComponentForInitSlotPackage(self, itemInfo):
        '''初始化装备栏时，封装itemComponent对象'''
        templateInfo = loader.getById('item_template', itemInfo[2], '*')
        item = Item(itemInfo[0], templateInfo['name'])
        item.baseInfo.setItemTemplate(templateInfo)
        item.baseInfo.setItemLevel(int(itemInfo[6]))
        item.binding.setType(templateInfo['bind'])
        item.binding.setBound(itemInfo[5])
        item.attribute.setSelfExtraAttribute(itemInfo[3])
        item.attribute.setDropExtraAttributes(itemInfo[4])
        item.pack.setWidth(templateInfo['width'])
        item.pack.setHeight(templateInfo['height'])
        item.pack.setStack(1)
        return item

    def formateSlotItemForClient(self):
        '''格式装备栏物品信息'''
        result = {}

        slotItemsInfo = self.getEquipmentSlotItemDetails()

        result['header'] = slotItemsInfo[0]
        result['body'] = slotItemsInfo[1]
        result['belt'] = slotItemsInfo[2]
        result['trousers'] = slotItemsInfo[3]
        result['shoes'] = slotItemsInfo[4]
        result['bracer'] = slotItemsInfo[5]
        result['cloak'] = slotItemsInfo[6]
        result['necklace'] = slotItemsInfo[7]
        result['waist'] = slotItemsInfo[8]
        result['weapon'] = slotItemsInfo[9]
        return result
#------------------------------------------------------------------------------------------------------------------------       
    def getItemsInPackage(self):
        '''获取玩家包裹栏中所有物品详细信息'''
        items = self._package.getItems()
        result = dbaccess.getPlayerItemsInTempPackage(self._owner.baseInfo.id)
        if result:
            pushMessage(str(self._owner.baseInfo.id), 'tempPackage')
        else:
            pushMessage(str(self._owner.baseInfo.id), 'closeTempPackage')
        return self.getPackageItemDetails(items)

    def getItemsInTempPackage(self):
        '''获取玩家临时包裹栏中所有物品详细信息'''
        items = self._tempPackage.getItems()
        return self.getPackageItemDetails(items)

    def getItemsInEquipSlot(self):
        '''获取装备栏中所有物品详细信息'''
        return self.getEquipmentSlotItemDetails()

    def getPackageItemDetails(self, items):
        '''
                        获取包裹栏及临时包裹栏中物品的详细信息（包括物品模版信息），以用于客户端使用
         @param items: 物品列表
        '''
        result = []
        for item in items:#itemComponent在items里的格式：[[position,itemCoponent],.....[..]]二维数组
            info = {}
            info['idInPackage'] = item[1].baseInfo.getIdInPackage()
            info = self.wrapSingleItemInfo(item[1], info)
            info['position'] = item[0]
            info['stack'] = item[1].pack.getStack()
            info['isEquiped'] = False
            result.append(info)
        return result

    def getEquipmentSlotItemDetails(self):
        '''
                        获取装备栏中物品的详细信息（包括物品模版信息），以用于客户端使用
         @param record: 玩家装备栏中物品列表
        '''
        result = []
        for idx in range(0, len(self._equipmentSlot)):
            info = {}
            if self._equipmentSlot[idx]:
                info = self.wrapSingleItemInfo(self._equipmentSlot[idx], info)
                info['isEquiped'] = True
            else:
                info = None
            result.append(info)
        return result

    def wrapSingleItemInfo(self, itemComponent, info):
        '''
                      封装单个物品的详细信息
        @param itemComponent: 物品组件对象
        '''
        if not itemComponent:
            return None
        itemTemplateInfo = itemComponent.baseInfo.getItemTemplate()
        info['itemLevel'] = itemComponent.baseInfo.getItemLevel()
        info['itemId'] = itemComponent.baseInfo.id
        info['bindType'] = itemComponent.binding.getBindTypeName()
        info['isBound'] = itemComponent.binding.getBound()
        info['isBoundDesc'] = itemComponent.binding.getCurrentBoundStatus()
        info['sellPrice'] = itemComponent.finance.getPrice()
#        info['extraAttributeList'] = []#{'name':'','value':''}
        info['extraAttributeList'] = itemComponent.attribute.getExtraAttributeList()
#        info['effect'] = itemComponent.effect.getItemEffect()
        info['name'] = itemComponent.baseInfo.getName()
        info['from'] = "Character"
        info['itemTemplateInfo'] = itemTemplateInfo

        professionRequire = info['itemTemplateInfo']['professionRequire']
        if info['itemTemplateInfo']['type'] < 1000000:
            if info['itemTemplateInfo']['type'] < 10:
                maxDamage = info['itemTemplateInfo']['maxDamage'] * 0.03 * (itemComponent.baseInfo.getItemLevel() - 1)
                minDamage = info['itemTemplateInfo']['minDamage'] * 0.03 * (itemComponent.baseInfo.getItemLevel() - 1)
                info['itemTemplateInfo']['maxDamage'] += int(maxDamage)
                info['itemTemplateInfo']['minDamage'] += int(minDamage)
        if professionRequire > 0:
            info['professionRequireName'] = loader.getById('profession', professionRequire, ['name'])['name']
        else:
            info['professionRequireName'] = u'无职业需求'

        return info

    def getItemDefenseInEquipSlot(self):
        '''获取装备槽中物品的防御值'''
        result = []
        for elm in self._equipmentSlot:
            if not elm:#该位置无装备
                defense = 0
                result.append(defense)
                continue
            if elm.baseInfo.getItemTemplate()['id'] == -1:
                defense = 0
            else:
                defense = elm.baseInfo.getItemTemplate()['defense']
            result.append(defense)
        return result

    def getWeaponId(self):
        '''获取武器的id'''
        if not self._equipmentSlot[9]:
            return - 1
        return self._equipmentSlot[9].baseInfo.id

    def getWeaponTemplateId(self):
        '''武器模版id'''
        if self._equipmentSlot[9]:
            return self._equipmentSlot[9].baseInfo.getItemTemplate()['id']
        else:
            return - 1

    def getWeaponName(self):
        '''获取装备的武器的名字'''
        weaponTemplateId = self.getWeaponTemplateId()
        if weaponTemplateId == -1:
            return u'没有装备武器'
        itemName = loader.getById('item_template', weaponTemplateId, ['name'])['name']
        assert(itemName)
        return itemName

    def getWeaponType(self):
        '''获取装备的武器的类型'''
        weaponTemplateId = self.getWeaponTemplateId()
        if weaponTemplateId == -1:
            return u'没有装备武器'
        return loader.getById('item_template', weaponTemplateId, ['type'])['type']

    def getEquipmentSlot(self):
        '''除武器的其他装备'''
        valuse = 0
        for i in range(0, 9):
            if  self._equipmentSlot[i]:
                info = dbaccess.getItemInfo(self._equipmentSlot[i].baseInfo.id)
                valuse += (info[6] - 1) * 0.005
        return valuse

    def putOneItemIntoPackage(self, itemId, position, stack):
        '''放置一个物品到包裹栏中'''
        position = str(position[0]) + ',' + str(position[1])
        dbaccess.insertRecordInPackage([0, self._owner.baseInfo.id, itemId, position, stack])

    def putOneItemIntoTempPackage(self, item, stack = 1):
        '''
                    放置一个物品到临时包裹栏中
        @param item: 物品
        '''
        self.setTempPackage()
        self.setPackage()
        if item:
            ret = self._tempPackage.isTempPackageFull()
            if not ret[0]:
                position = ret[1]
                position = str(position[0]) + "," + str(position[1])
                dbaccess.insertRecordInTempPackage([0, self._owner.baseInfo.id, item[0], position, stack])
                self.setTempPackage()
            else:#如果临时包裹栏已满，算成铜币，加到玩家身上
                itemTemplateId = item[2]
                itemTemplateInfo = loader.getById('item_template', itemTemplateId, '*')
                if not itemTemplateInfo:
                    return
                itemName = itemTemplateInfo['name']
                itemComponent = Item(item[0], itemName)
                itemComponent.baseInfo.setItemTemplate(itemTemplateInfo)
                price = itemComponent.finance.getPrice()
                dbaccess.deleteItem(item[0], int(self._owner.baseInfo.id))
                dbaccess.updatePlayerInfo(self._owner.baseInfo.id, {'coin':self._owner.finance.getCoin() + price})
                self._owner.finance.setCoin(self._owner.finance.getCoin() + price)
        
    def isValidPositionInPackage(self, position, formerPosition, package):
        if package == 'package':
            return self._package.canPutItem(position, formerPosition)
        else:
            pass

    def mergeItem(self, packageType, stack, toPosition, formerPosition):
        '''
                      合并物品
        @param packageType: "package":包裹栏,"temporary"：临时包裹栏
        @param stack: 当前所移动物品的层叠数
        @param toPosition: 当前所要合并到的物品(组）位置
        @param formerPosition: 当前所移动物品（组）位置
        '''
        if packageType == 'package':
            if not self._package.canMergeItem(toPosition, formerPosition):
                return {'result':False, 'reason':u'不能合并'}
            destItem = self._package.getItemByPosition(toPosition)
            dragItem = self._package.getItemByPosition(formerPosition)
        elif packageType == 'temporary_package':
            if not self._tempPackage.canMergeItem(toPosition, formerPosition):
                return {'result':False, 'reason':u'不能合并'}
            destItem = self._tempPackage.getItemByPosition(toPosition)
            dragItem = self._tempPackage.getItemByPosition(formerPosition)
        elif packageType == 'warehouse_package':
            if not self._warehousePackage.canMergeItem(toPosition, formerPosition):
                return {'result':False, 'reason':u'不能合并'}
            destItem = self._warehousePackage.getItemByPosition(toPosition)
            dragItem = self._warehousePackage.getItemByPosition(formerPosition)
        elif packageType == 'forging_package':
            if not self._forgingPakcage.canMergeItem(toPosition, formerPosition):
                return {'result':False, 'reason':u'不能合并'}
            destItem = self._forgingPakcage.getItemByPosition(toPosition)
            dragItem = self._forgingPakcage.getItemByPosition(formerPosition)
        destStack = destItem.pack.getStack()
        dragStack = dragItem.pack.getStack()
        dragBaseInfoStack = dragItem.baseInfo.getItemTemplate()['stack']
        if (destStack + dragStack) > dragBaseInfoStack:
            return {'result':False, 'reason':u'物品只能合并' + dragBaseInfoStack.__str__() + u'个'}
        dragItemId = dragItem.baseInfo.id#移动的物品（组）的物品Id
        destIdInPackage = destItem.baseInfo.getIdInPackage()
        dragIdInPackage = dragItem.baseInfo.getIdInPackage()
        result = dbaccess.mergeItemsForSameItemId(stack, packageType, dragItemId, destIdInPackage, dragIdInPackage)
        destItem.pack.setStack(destStack + stack)
        if packageType == 'package':
            self._package.getItems().remove([formerPosition, dragItem])
        elif packageType == 'temporary_package':
            self._tempPackage.getItems().remove(dragItem)
        elif packageType == 'warehouse_package':
            self._warehousePackage.getItems().remove([formerPosition, dragItem])
        elif packageType == 'forging_package':
            self._forgingPakcage.getItems().remove([formerPosition, dragItem])
        return {'result':result, 'spareCount':0, 'isMerge':True, 'dragId':dragIdInPackage, 'destId':destIdInPackage, \
                'currentDestStack':destItem.pack.getStack(), 'currentPosition':toPosition, 'newSplitRecord':None, \
                'isSlotPackage':False}

    def splitItem(self, splitIn, splitTo, splitToPosition, splitPosition, splitStack):
        '''
                      拆分物品
        @param splitIn: 在什么栏中拆分
        @param splitTo: 拆分到什么栏中
        @param splitToPosition: 拆分到栏中的格子位置(格子坐标数组)
        @param splitPosition: 当前拆分的位置
        @param splitStack: 所要拆分的层叠数
        '''
        item = None
        if splitIn == 'package':
            item = self._package.getItemByPosition(splitPosition)
            dragWidth = item.baseInfo.getItemTemplate()['width']
            dragHeight = item.baseInfo.getItemTemplate()['height']
            if not self._package.scanItemGrids(splitToPosition, dragWidth, dragHeight, item):
                return {'result':False, 'reason':u'已经有物品了'}
        elif splitIn == 'temporary_package':
            item = self._tempPackage.getItemByPosition(splitPosition)
        elif splitIn == 'warehouse_package':
            item = self._warehousePackage.getItemByPosition(splitPosition)
            dragWidth = item.baseInfo.getItemTemplate()['width']
            dragHeight = item.baseInfo.getItemTemplate()['height']
            if not self._warehousePackage.scanItemGrids(splitToPosition, dragWidth, dragHeight, item):
                return {'result':False, 'reason':u'已经有物品了'}
        elif splitIn == 'forging_package':
            item = self._forgingPakcage.getItemByPosition(splitPosition)
            dragWidth = item.baseInfo.getItemTemplate()['width']
            dragHeight = item.baseInfo.getItemTemplate()['height']
            if not self._forgingPakcage.scanItemGrids(splitToPosition, dragWidth, dragHeight, item):
                return {'result':False, 'reason':u'已经有物品了'}
        itemId = item.baseInfo.id
        packageItemId = item.baseInfo.getIdInPackage()
        itemStack = int(item.pack.getStack())
        itemStack -= splitStack
        item.pack.setStack(itemStack)
        splitToPosition = str(splitToPosition[0]) + "," + str(splitToPosition[1])
        insertProps = [0, self._owner.baseInfo.id, itemId, splitToPosition, splitStack]
        itemInstance = dbaccess.getItemInfo(itemId)#用于插入向包裹栏新的记录
        ret = dbaccess.splitItemsOnOperateDB(itemStack, insertProps, splitIn, splitTo, packageItemId, itemInstance, self._warehousePage + 1)
        #只在package中拆分
        ret = self.wrapNewRecordInPackage(ret)
        self.setPackage()
        self.refreshPackageByType(splitIn)
        return ret

    def movePackItem(self, position, formerPosition, packageType, splitTo, stack):
        '''移动栏中的物品'''
        if packageType == 'warehouse_package':
            dragItem = self._warehousePackage.getItemByPosition(formerPosition)
        elif packageType == 'package':
            dragItem = self._package.getItemByPosition(formerPosition)
        elif packageType == 'forging_package':
            dragItem = self._forgingPakcage.getItemByPosition(formerPosition)
        if not dragItem:
            return {'result':False, 'reason':u'此物品不存在'}
        
        if position == formerPosition:
            return {'result':False, 'reason':u'您没有移动物品'}
        #拆分
        if dragItem.pack.getStack() > 1 and stack < dragItem.pack.getStack():
            return self.splitItem(packageType, splitTo, position, formerPosition, stack)

        #合并
        if packageType == 'warehouse_package':
            if not self._warehousePackage.canMergeItem(position, formerPosition):
                if dragItem.baseInfo.getItemTemplate()["id"] != self._warehousePackage.getItemByPosition(position).baseInfo.getItemTemplate()["id"]:
                    return {'result':False, 'reason':u'目标位置已经有物品'}
                return {'result':False, 'reason':u'不能合并'}
            destItem = self._warehousePackage.getItemByPosition(position)
        elif packageType == 'package':
            if not self._package.canMergeItem(position, formerPosition):
                if dragItem.baseInfo.getItemTemplate()["id"] != self._package.getItemByPosition(position).baseInfo.getItemTemplate()["id"]:
                    return {'result':False, 'reason':u'目标位置已经有物品'}
                return {'result':False, 'reason':u'不能合并'}
            destItem = self._package.getItemByPosition(position)
        elif packageType == 'forging_package':
            if not self._forgingPakcage.canMergeItem(position, formerPosition):
                if dragItem.baseInfo.getItemTemplate()["id"] != self._forgingPakcage.getItemByPosition(position).baseInfo.getItemTemplate()["id"]:
                    return {'result':False, 'reason':u'目标位置已经有物品'}
                return {'result':False, 'reason':u'不能合并'}
            destItem = self._forgingPakcage.getItemByPosition(position)

        if dragItem is destItem:
            destItem = None
        if destItem:
            destTemplate = destItem.baseInfo.getItemTemplate()
            dragTemplate = dragItem.baseInfo.getItemTemplate()
            if destTemplate['stack'] <> -1:
                if destTemplate['id'] == dragTemplate['id']:
                    return self.mergeItem(packageType, stack, position, formerPosition)
        #移动            
        idInPackage = -1
        if packageType == 'package':
            if not self._package.canPutItem(position, formerPosition):
                return {'result':False, 'reason':'不能移动，已经有物品或已经出界了'}
            idInPackage = self._package.getItemByPosition(formerPosition).baseInfo.getIdInPackage()
        elif packageType == "temporary_package":
#            if not self._tempPackage.canPutItem(position, formerPosition):
#                return {'result':False,'reason':''}
            idInPackage = self._tempPackage.getItemByPosition(formerPosition).baseInfo.getIdInPackage()
        elif packageType == 'warehouse_package':
            if not self._warehousePackage.canPutItem(position, formerPosition):
                return {'result':False, 'reason':'不能移动，已经有物品或已经出界了'}
            idInPackage = self._warehousePackage.getItemByPosition(formerPosition).baseInfo.getIdInPackage()
        elif packageType == 'forging_package':
            if not self._forgingPakcage.canPutItem(position, formerPosition):
                return {'result':False, 'reason':'不能移动，已经有物品或已经出界了'}
            idInPackage = self._forgingPakcage.getItemByPosition(formerPosition).baseInfo.getIdInPackage()

        dbaccess.updateItemAttrsInPackages(packageType, int(idInPackage), {'position':str(position[0]) + ',' + str(position[1])})

        if packageType == 'package':
            self._package.getOneRecordByPosition(formerPosition)[0] = position
        elif packageType == 'temporary_package':
            self._package.getOneRecordByPosition(formerPosition)[0] = position
        elif packageType == 'warehouse_package':
            for item in self._warehouseItems:
                if item[0][1] == self._warehousePackage.getOneRecordByPosition(formerPosition)[1]:
                    item[0][0] = position
            self._warehousePackage.getOneRecordByPosition(formerPosition)[0] = position
        elif packageType == 'forging_package':
            self._forgingPakcage.getOneRecordByPosition(formerPosition)[0] = position

        return {'result':True, 'spareCount':0, 'isMerge':False, 'dragId':idInPackage, 'destId':idInPackage, \
                'currentDestStack':0, 'currentPosition':position, 'newSplitRecord':None, 'isSlotPackage':False}

    def moveItemFromOnePackageToAnother(self, fromPack, toPack, fromPosition, toPosition, stack):
        '''
                     从一个栏中向另一个栏中移动物品
        @param fromPack: 物品所在栏类型
        @param toPack: 移动目标栏类型
        @param fromPosition: 物品所在位子
        @param toPosition: 移到的位子
        @param stack: 移动的层叠数
        '''
        id = self._owner.baseInfo.id

        if fromPack == "package":
            moveItem = self._package.getItemByPosition(fromPosition)
        elif fromPack == 'temporary_package':
            moveItem = self._tempPackage.getItemByPosition(fromPosition)
        elif fromPack == 'equipment_slot':
            moveItem = self._equipmentSlot[fromPosition]#dict{'itemTemplateInfo':{}}
        elif fromPack == "warehouse_package":
            moveItem = self._warehousePackage.getItemByPosition(fromPosition)
        elif fromPack == 'forging_package':
            moveItem = self._forgingPakcage.getItemByPosition(fromPosition)
        if not moveItem:
            return {'result':False, 'reason':u'此物品不存在'}

        if toPack == 'package':
            #目标位置存在物品且与移动物品类型相同，执行合并
            if fromPack == 'equipment_slot':
                idInFromPack = fromPosition
                idInFromPack = self.traverseBodyType(idInFromPack)
                width = moveItem.baseInfo.getItemTemplate()['width']
                height = moveItem.baseInfo.getItemTemplate()['height']
                itemId = moveItem.baseInfo.id
            else:
                idInFromPack = moveItem.baseInfo.getIdInPackage()
                width = moveItem.pack.getWidth()
                height = moveItem.pack.getHeight()
                itemId = moveItem.baseInfo.id

            if toPosition == [-1, -1]:#从装备栏双击直接卸下，坐标
                toPosition = self._package.findSparePositionForItem(width, height)
                if toPosition == [-1, -1]:
                    return {'result':False, 'reason':u'包裹栏已满，无法卸下装备，需要整理包裹栏'}
            tempItem = self._package.getItemByPosition(toPosition)
            if tempItem:
                if tempItem.baseInfo.getItemTemplate() == moveItem.baseInfo.getItemTemplate():
                    if tempItem.baseInfo.getItemTemplate()['stack'] != -1:
                        if tempItem.pack.getStack() < tempItem.baseInfo.getItemTemplate()['stack']:
                            idInToPack = tempItem.baseInfo.getIdInPackage()
                            result = dbaccess.mergeItemFromAnother(fromPack, toPack, idInFromPack, idInToPack, stack)
                            self.refreshPackages(fromPack, toPack)
                            return result
                        else:
                            return {'result':False, 'reason':u'物品只能合并' + tempItem.baseInfo.getItemTemplate()['stack'].__str__() + u'个'}
                    else:
                        return {'result':False, 'reason':u'不能合并物品'}
            #执行移动增加物品   
            if self._package.scanItemGrids(toPosition, width, height):
                position = str(toPosition[0]) + "," + str(toPosition[1])
                props = [0, self._owner.baseInfo.id, itemId, position, stack]
#                idInFromPack = self.traverseBodyType(idInFromPack)
                result = dbaccess.moveItemFromOneToAnother(fromPack, toPack, idInFromPack, props, id)
                result = self.wrapNewRecordInPackage(result)
                self.refreshPackages(fromPack, toPack)
            else:
                result = {'result':False, 'reason':u'已经有物品了'}
        elif toPack == 'warehouse_package':
            if fromPack == 'equipment_slot':
                idInFromPack = fromPosition
                idInFromPack = self.traverseBodyType(idInFromPack)
                width = moveItem.baseInfo.getItemTemplate()['width']
                height = moveItem.baseInfo.getItemTemplate()['height']
                itemId = moveItem.baseInfo.id
            else:
               idInFromPack = moveItem.baseInfo.getIdInPackage()
               width = moveItem.pack.getWidth()
               height = moveItem.pack.getHeight()
               itemId = moveItem.baseInfo.id

            if toPosition == [-1, -1]:#从装备栏、包裹栏直接存入，坐标
                toPosition = self._warehousePackage.findSparePositionForItem(width, height)
                if toPosition == [-1, -1]:
                    return {'result':False, 'reason':u'仓库已满，无法存放装备，需要整理仓库'}
            tempItem = self._warehousePackage.getItemByPosition(toPosition)
            if tempItem:
                if tempItem.baseInfo.getItemTemplate() == moveItem.baseInfo.getItemTemplate():
                    if tempItem.baseInfo.getItemTemplate()['stack'] != -1:
                        if tempItem.pack.getStack() < tempItem.baseInfo.getItemTemplate()['stack']:
                            idInToPack = tempItem.baseInfo.getIdInPackage()
                            result = dbaccess.mergeItemFromAnother(fromPack, toPack, idInFromPack, idInToPack, stack)
                            self.refreshPackages(fromPack, toPack)
                            return result
                        else:
                            return {'result':False, 'reason':u'物品只能合并' + tempItem.baseInfo.getItemTemplate()['stack'].__str__() + u'个'}
                    else:
                        return {'result':False, 'reason':u'不能合并物品'}
            #执行移动增加物品   
            if self._warehousePackage.scanItemGrids(toPosition, width, height):
                position = str(toPosition[0]) + "," + str(toPosition[1])
                props = [0, self._owner.baseInfo.id, itemId, position, stack, self._warehousePage + 1]
#                idInFromPack = self.traverseBodyType(idInFromPack)
                result = dbaccess.moveItemFromOneToAnother(fromPack, toPack, idInFromPack, props, id)
                result = self.wrapNewRecordInPackage(result)
                self.refreshPackages(fromPack, toPack)
            else:
                result = {'result':False, 'reason':u'已经有物品了'}
        elif toPack == 'forging_package':
            if fromPack == 'equipment_slot':
                idInFromPack = fromPosition
                idInFromPack = self.traverseBodyType(idInFromPack)
                width = moveItem.baseInfo.getItemTemplate()['width']
                height = moveItem.baseInfo.getItemTemplate()['height']
                itemId = moveItem.baseInfo.id
            else:
                idInFromPack = moveItem.baseInfo.getIdInPackage()
                width = moveItem.pack.getWidth()
                height = moveItem.pack.getHeight()
                itemId = moveItem.baseInfo.id

            if toPosition == [-1, -1]:#从装备栏双击直接卸下，坐标
                toPosition = self._forgingPakcage.findSparePositionForItem(width, height)
                if toPosition == [-1, -1]:
                    return {'result':False, 'reason':u'包裹栏已满，无法卸下装备，需要整理包裹栏'}
            tempItem = self._forgingPakcage.getItemByPosition(toPosition)
            if tempItem:
                if tempItem.baseInfo.getItemTemplate() == moveItem.baseInfo.getItemTemplate():
                    if tempItem.baseInfo.getItemTemplate()['stack'] != -1:
                        if tempItem.pack.getStack() < tempItem.baseInfo.getItemTemplate()['stack']:
                            idInToPack = tempItem.baseInfo.getIdInPackage()
                            result = dbaccess.mergeItemFromAnother(fromPack, toPack, idInFromPack, idInToPack, stack)
                            self.refreshPackages(fromPack, toPack)
                            return result
                        else:
                            return {'result':False, 'reason':u'物品只能合并' + tempItem.baseInfo.getItemTemplate()['stack'].__str__() + u'个'}
                    else:
                        return {'result':False, 'reason':u'不能合并物品'}
            #执行移动增加物品   
            if self._forgingPakcage.scanItemGrids(toPosition, width, height):
                position = str(toPosition[0]) + "," + str(toPosition[1])
                props = [0, self._owner.baseInfo.id, itemId, position, stack]
#                idInFromPack = self.traverseBodyType(idInFromPack)
                result = dbaccess.moveItemFromOneToAnother(fromPack, toPack, idInFromPack, props, id)
                result = self.wrapNewRecordInPackage(result)
                self.refreshPackages(fromPack, toPack)
            else:
                result = {'result':False, 'reason':u'已经有物品了'}
        elif toPack == 'equipment_slot':
            idInFromPack = moveItem.baseInfo.getIdInPackage()
            itemId = moveItem.baseInfo.id
            result, bodyType = self.canEquipItem(itemId, toPosition)
            if not result:
                return {'result':result, 'reason':bodyType}
            toPositionIndex = bodyType - 1
            toPosition = self.traverseBodyType(toPositionIndex)
            if not self._equipmentSlot[toPositionIndex]:
                dbaccess.weapEquipment(fromPack, idInFromPack, toPosition, itemId, id)
                self.setEquipment()
                self.setPackage()
                equipItem = self._equipmentSlot[toPositionIndex]
                newEquipInfo = self.wrapSingleItemInfo(equipItem, {})
                result = {'result':True, 'isSlotPackage':True, 'dragId':idInFromPack, toPosition:newEquipInfo}
            else:#只考虑包裹栏和装备栏之间的交换
                equipedItemId = self._equipmentSlot[toPositionIndex].baseInfo.id
                result = dbaccess.exchangeItem(fromPack, idInFromPack, fromPosition, toPosition, itemId, equipedItemId, id)
                newPackageItemId = result[0]
                self.setEquipment()
                self.setPackage()
                newPackageItem = dbaccess.getItemInPackage(newPackageItemId)
                itemInfo = self.formateItemForClient([newPackageItem])[0]
                packageItem = self.wrapItemComponentForInitPackage(itemInfo)
                packageItemInfo = self.wrapSingleItemInfo(packageItem, {})
                packageItemInfo['position'] = itemInfo['position']
                packageItemInfo['isEquiped'] = False
                packageItemInfo['idInPackage'] = itemInfo['idInPackage']
                equipItem = self._equipmentSlot[toPositionIndex]
                newEquipInfo = self.wrapSingleItemInfo(equipItem, {})
                newEquipInfo['isEquiped'] = True
                result = {'result':True, 'isExchange':True, 'dragId':idInFromPack, 'newItems':[newEquipInfo, packageItemInfo]}

        speed = self._owner.attribute.getCurrSpeed()
        speedDesc = self._owner.attribute.getCurrSpeedDescription(speed)
        result['speedDescription'] = speedDesc
        minDamage, maxDamage = self._owner.attribute.getCurrDamage()
        result['damage'] = [minDamage, maxDamage]
        result['defense'] = self._owner.attribute.getCurrDefense()

        return result

    def sellAllTempPackage(self):
        '''卖出临时包裹中所有物品'''
        id = self._owner.baseInfo.id
        coin = self._owner.finance.getCoin()
        cannotSellCount = 0
        itemSoldPosition = []
        items = self._tempPackage.getItems()
        if len(items) == 0:
            return {'result':False, 'reason':u'您的临时包裹中没有物品'}
        for item in items:
            itemComponent = item[1]
            trade = int(itemComponent.baseInfo.getItemTemplate()['trade'])
            if trade >= 4:
                cannotSellCount += 1
                continue
            sellPrice = itemComponent.finance.getPrice()
            coin += sellPrice
            dbaccess.deleteItemsInTemPackage(itemComponent.baseInfo.id, itemComponent.baseInfo.getIdInPackage(),id)
            itemSoldPosition.append(item[0])
#            items.remove(item)
        dbaccess.updatePlayerInfo(id, {'coin':coin})
        self.setTempPackage()
#        coin += self._owner.finance.getCoin()
        self._owner.finance.setCoin(coin)
        result = dbaccess.getPlayerItemsInTempPackage(self._owner.baseInfo.id)
        if not result:
            pushMessage(str(self._owner.baseInfo.id), 'closeTempPackage')
        return {'result':True, 'coin':coin, 'itemSoldPosition':itemSoldPosition, 'cannotSellCount':cannotSellCount}

    def sellPackageItem(self, itemId, packageType, count):
        '''卖出包裹蓝中的物品'''
        id = self._owner.baseInfo.id
        itemRecord = dbaccess.getItemInfo(itemId)
        if not itemRecord:
            return {'result':False, 'reason':u'此物品不存在'}
        itemTemplateInfo = loader.getById('item_template', itemRecord[2], '*')
        item = Item(itemId, itemTemplateInfo['name'])
        item.baseInfo.setItemTemplate(itemTemplateInfo)
        item.attribute.setSelfExtraAttribute(itemRecord[3])
        item.attribute.setDropExtraAttributes(itemRecord[4])
        trade = itemTemplateInfo['trade']

        bodyType = self.traverseBodyType(itemTemplateInfo['bodyType'] - 1)
        idInPackage = dbaccess.getIdFromPackagesByItemId(id, itemId, itemRecord[2], bodyType, packageType)

        if trade >= 4:
            return {'result':False, 'reason':u'物品不能出售'}
        else:
            price = item.finance.getPrice()
            price *= count
            coin = self._owner.finance.getCoin() + price
            self._owner.finance.setCoin(coin)
            dbaccess.deletePackageItem(idInPackage, itemId, packageType, bodyType, id)
            dbaccess.updatePlayerInfo(id, {'coin':coin})
            self.refreshPackageByType(packageType)
            result = {'result':True, 'data':{'idInPackage':idInPackage, 'coin':coin}}
            if packageType == 'equipment_slot':
                result['data']['isEquipmentSlot'] = True
            else:
                result['data']['isEquipmentSlot'] = False
            return result

    def useItem(self, itemId):
        '''使用物品'''
        id = self._owner.baseInfo.id
        level = self._owner.level.getLevel()

        itemRecord = dbaccess.getItemInfo(itemId)
        if not itemRecord:
            return {'result':False, 'reason':u'此物品不存在'}
        itemTemplateInfo = loader.getById('item_template', itemRecord[2], '*')
        item = Item(itemId, itemTemplateInfo['name'])
        item.baseInfo.setItemTemplate(itemTemplateInfo)

        if level < itemTemplateInfo['levelRequire']:
            return {'result':False, 'reason':u'您的等级不够，无法使用'}
        effects = itemTemplateInfo['addEffect'].split(';')
        if effects[0] == u'-1':
            return {'result':False, 'reason':u'物品没有任何效果'}
        for effectId in effects:
            effectId = int(effectId)
            effect = loader.getById('effect', effectId, '*')
            if not effect:
                return {'result':False, 'reason':u'无效果'}
            if effect['type'] == 1:#即时效果,立即使用,立即变更数值    
                hp, mp = self._owner.effect.calcImmeEffectForPlayer(effect)
                result = {'result':True, 'data':[u'瞬时效果', hp, mp]}
            elif effect['type'] == 2:#持续效果,写入状态表
                ret, reason = self._owner.effect.triggerEffect(effect, 1)
                if not ret :
                    result = {'result':ret, 'reason':reason}
                result = {'result':ret, 'data':[u'持久效果', self._owner.effect.getItemEffectsInfo()]}
            elif effect['type'] == 3:
                pass

            #删除物品记录/修改物品记录
            packageRecord = dbaccess.getItemInPackageByItemId(id, itemId)
            if packageRecord[4] > 1:
                stack = packageRecord[4] - 1
                dbaccess.updateRecordInPackage(packageRecord[0], {'stack':stack})
                result['count'] = stack
            else:
                dbaccess.deleteRecordInPackage(packageRecord[0], itemId)
                result['count'] = 0
            result['idInPackage'] = packageRecord[0]

            self.refreshPackageByType('package')

            return result


    def dropItem(self, itemId, packageType):
        '''丢弃物品'''
        id = self._owner.baseInfo.id

        itemRecord = dbaccess.getItemInfo(itemId)
        if not itemRecord:
            return {'result':False, 'reason':u'此物品不存在'}
        itemTemplateInfo = loader.getById('item_template', itemRecord[2], '*')

        bodyType = self.traverseBodyType(itemTemplateInfo['bodyType'] - 1)
        idInPackage = dbaccess.getIdFromPackagesByItemId(id, itemId, itemRecord[2], bodyType, packageType)
        dbaccess.deletePackageItem(idInPackage, itemId, packageType, bodyType, id)
        self.refreshPackageByType(packageType)

        result = {'result':True, 'data':{'idInPackage':idInPackage}}
        if packageType == 'equipment_slot':
            result['data']['isEquipmentSlot'] = True
        else:
            result['data']['isEquipmentSlot'] = False
        return result




    def wrapNewRecordInPackage(self, ret):
        '''组装栏中新增物品信息，返回给客户端'''
        itemInfo = self.formateItemForClient([ret['newSplitRecord']])[0]
        position = ret['newSplitRecord'][2].split(',')
        position[0] = int(position[0])
        position[1] = int(position[1])
        item = self.wrapItemComponentForInitPackage(itemInfo)
#        self._package.putItemByPosition(item,position)
        itemInfo = self.getPackageItemDetails([[position, item]])
        ret['newSplitRecord'] = itemInfo[0]
        return ret

    def canEquipItem(self, itemId, toPosition):
        '''能否装备物品'''
        level = self._owner.level.getLevel()
        templateId = dbaccess.getItemTemplate(itemId)
        info = loader.getById('item_template', templateId, ['bodyType', 'levelRequire', 'strRequire', 'dexRequire', 'vitRequire'])
        bodyType = info['bodyType']
        levelRequire = info['levelRequire']
        strRequire = info['strRequire']
        dexRequire = info['dexRequire']
        vitRequire = info['vitRequire']
        str = self._owner.attribute.getBaseStr() + self._owner.attribute.getManualStr()
        dex = self._owner.attribute.getBaseDex() + self._owner.attribute.getManualDex()
        vit = self._owner.attribute.getBaseVit() + self._owner.attribute.getManualVit()
        if bodyType == -1:
            return False, u'该物品不能装备'
        elif bodyType <> toPosition + 1:
            if toPosition == -1:
                pass
            else:
                return False, u'该位置不能装备'
        if level < levelRequire:
            return False, u'您当前的级别不够'
        if str < strRequire:
            return False, u'您当前的武勇不够'
        if vit < vitRequire:
            return False, u'您当前的体魄不够'
        if dex < dexRequire:
            return False, u'您当前的机警不够'

        return True, bodyType

    def checkTypeOfItemToEquip(self, itemId, equipPosition):
        '''检查要装备物品的类型，是否在该部位能装备'''
        templateId = dbaccess.getItemTemplate(itemId)
        bodyType = loader.getById('item_template', templateId, ['bodyType'])['bodyType']
        type = 0
        if equipPosition == u'header':
            type = self.HEADER
        elif equipPosition == u'body':
            type = self.BODY
        elif equipPosition == u'belt':
            type = self.BELT
        elif equipPosition == u'trousers':
            type = self.TROUSERS
        elif equipPosition == u'shoes':
            type = self.SHOES
        elif equipPosition == u'bracer':
            type = self.BRACER
        elif equipPosition == u'cloak':
            type = self.CLOAK
        elif equipPosition == u'necklace':
            type = self.NECKLACE
        elif equipPosition == u'waist':
            type = self.WAIST
        elif equipPosition == u'weapon':
            type = self.WEAPON
        if type == bodyType:
            return True
        else:
            return False

    def traverseBodyType(self, position):
        if position == self.HEADER:
            position = 'header'
        elif position == self.BODY:
            position = 'body'
        elif position == self.BELT:
            position = 'belt'
        elif position == self.TROUSERS:
            position = 'trousers'
        elif position == self.SHOES:
            position = 'shoes'
        elif position == self.BRACER:
            position = 'bracer'
        elif position == self.CLOAK:
            position = 'cloak'
        elif position == self.NECKLACE:
            position = 'necklace'
        elif position == self.WAIST:
            position = 'waist'
        elif position == self.WEAPON:
            position = 'weapon'
        return position

    def refreshPackages(self, fromPack, toPack):
        if fromPack == 'package':
            self.setPackage()
        elif fromPack == 'temporary_package':
            self.setTempPackage()
        elif fromPack == 'equipment_slot':
            self.setEquipment()
        elif fromPack == 'deal_package':
            pass
        elif fromPack == 'warehouse_package':
            self.setWarehousePackage()
            self.setWarehousePackageItems(self._warehousePage)
        elif fromPack == 'forging_package':
            self.setForgingPackage()

        if toPack == 'package':
            self.setPackage()
        elif toPack == 'tempoarry_package':
            self.setTempPackage()
        elif toPack == 'equipment_slot':
            self.setEquipment()
        elif toPack == 'deal_package':
            pass
        elif toPack == 'warehouse_package':
            self.setWarehousePackage()
            self.setWarehousePackageItems(self._warehousePage)
        elif toPack == 'forging_package':
            self.setForgingPackage()

    def refreshPackageByType(self, packageType):
        if packageType == 'package':
            self.setPackage()
        elif packageType == 'temporary_package':
            self.setTempPackage()
        elif packageType == 'equipment_slot':
            self.setEquipment()
        elif packageType == 'deal_package':
            pass
        elif packageType == 'warehouse_package':
            self.setWarehousePackage()
            self.setWarehousePackageItems(self._warehousePage)
        elif packageType == 'forging_package':
            self.setForgingPackage()

