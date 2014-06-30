#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''

from component.Component import Component
from util import dbaccess
from util.DataLoader import loader

class CharacterInstanceComponent(Component):
    '''
    instance component for character
    '''


    def __init__(self, owner):
        '''
        Constructor
        '''
        Component.__init__(self, owner)
        self.MAXENTERCOUNT = 2
        self._enterInstanceCount = 0
        self._instanceId = -1 #副本记录副本id
        self._instanceName = u"" #副本记录副本名称
        self._instancePlaceId = -1 #副本记录副本地点id
        self._instancePlaceName = u"" #副本记录副本地点名称
        self._isInstanceLocked = False #副本记录是否锁定
        self._instanceLayers = []#存放当前副本所有层
        self.init()

    def init(self):
        id = self._owner.baseInfo.id
        record = dbaccess.getPlayerInstanceProgressRecord(id)
        if record:
            if record[2] != 0:
                self._instanceId = record[2]
                instanceInfo = loader.get('instance', 'entryPlace', record[2], ['layers'])[0]
                self._instanceName = loader.getById('place', record[2], ['name'])['name']
                self._instancePlaceId = record[3]
                self._instancePlaceName = loader.getById('place', record[3], ['name'])['name']
                if record[4] == 0:
                    self._isInstanceLocked = False
                else:
                    self._isInstanceLocked = True
                places = loader.getById('instance_layer', instanceInfo['layers'], ['place'])['place'].split(';')
                for elm in places:
                    elm = int(elm)
                    self._instanceLayers.append(elm)

    def getEnterInstanceCount(self):
        return self._enterInstanceCount

    def setEnterInstanceCount(self, count):
        self._enterInstanceCount = count

    def getInstanceId(self):
        return self._instanceId

    def setInstanceId(self, instanceId):
        self._instanceId = instanceId

    def getInstanceName(self):
        return self._instanceName

    def setInstanceName(self, instanceName):
        self._instanceName = instanceName

    def getInstancePlaceId(self):
        return self._instancePlaceId

    def setInstancePlaceId(self, instancePlaceId):
        self._instancePlaceId = instancePlaceId

    def getInstancePlaceName(self):
        return self._instancePlaceName

    def setInstancePlaceName(self, instancePlaceName):
        self._instancePlaceName = instancePlaceName

    def getIsInstanceLocked(self):
        return self._isInstanceLocked

    def setInstanceLocked(self, isInstanceLocked):
        self._isInstanceLocked = isInstanceLocked

    def getInstanceLayers(self):
        return self._instanceLayers

    def setInstanceLayers(self, layers):
        self._instanceLayers = layers

    def getPlayerInstanceProgressInfo(self):
        '''获取玩家副本进度信息'''
        info = None
        if self._instanceId == -1:
            return info
        info = {}
        info['instanceName'] = self._instanceName
        info['instanceLayerName'] = self._instancePlaceName
        return info

    def updatePlayerInstanceProgressInfo(self, attrs):
        '''更新玩家副本进度信息'''
        id = self._owner.baseInfo.id
        if dbaccess.updatePlayerInstanceProgressRecord(attrs, id):
            self.init()
            if attrs.has_key('instancLayerId'):
                self._owner.baseInfo.setLocation(attrs['instanceLayerId'])
            return True
        else:
            return False

    def removePlayerInstanceProgressInfo(self):
        '''删除玩家副本进度信息'''
        id = self._owner.baseInfo.id
        if dbaccess.deletePlayerInstanceProgressRecord(id):
            location = loader.getById('place', self._instanceId, ['regionId'])['regionId']
            dbaccess.updatePlayerInfo(id, {'location':location})
            self._owner.baseInfo.setLocation(location)
            self._instanceId = -1
            self._instanceName = u""
            self._instancePlaceId = -1
            self._instancePlaceName = u""
            self._isInstanceLocked = False
            return True
        else:
            return False

    def enterInstance(self, placeId):
        '''进入副本'''
        id = self._owner.baseInfo.id
        energy = self._owner.attribute.getEnergy()
        location = placeId
        instanceId = self._instanceId
        instanceLayerId = self._instancePlaceId
        result = False
        status = self._owner.baseInfo.getStatus()
        if status != u'正常':
            return False, u"您已经处于" + status + u"状态"
        placeInfo = loader.getById('place', placeId, '*')
        if placeInfo['levelRequire'] > self._owner.level.getLevel():
            return False, u'您的级别不够，需要达到 %d 级才能进入' % placeInfo['levelRequire']
        if instanceId <> -1:
            if location <> instanceId:
                energy -= 10
                if energy < 0:
                    return False, u'活力不足'
                if self._enterInstanceCount >= self.MAXENTERCOUNT:
                    return False, u'今日进入副本次数已经达到两次,不可重新进入新副本'
                instanceLayers = loader.get('instance', 'entryPlace', location, ['layers'])[0]['layers']
                layers = loader.getById('instance_layer', instanceLayers, ['place'])['place']
                instanceLayerId = int(layers.split(';')[0])
                attrs = {'instanceId':location, 'instanceLayerId':instanceLayerId}
                result = dbaccess.updatePlayerInstanceProgressRecord(attrs, id)
                if result:
                    dbaccess.updatePlayerInfo(id, {'energy':energy, 'enterInstanceCount':self._enterInstanceCount + 1})
                    self.init()
            else:
                result = True
        else:
            layers = loader.get('instance', 'entryPlace', location, ['layers'])
            if len(layers) < 0:
                return False, u'没有相应的副本层'
            layers = layers[0]['layers']
            if layers:
                energy -= 10
                if energy < 0:
                    return False, u'活力不足'
                places = loader.getById('instance_layer', layers, ['place'])['place'].split(';')
                instanceLayerId = int(places[0])
                props = [0, id, location, instanceLayerId, 0]
                result = dbaccess.insertPlayerInstanceProgressRecord(props)
                if result:
                    dbaccess.updatePlayerInfo(id, {'energy':energy, 'enterInstanceCount':1})
                    self._enterInstanceCount = 1
                self.init()
            else:
                return False, u'没有相应的副本层'
        self._owner.attribute.setEnergy(energy)
        self._owner.baseInfo.setLocation(instanceLayerId)
        return result, ''
