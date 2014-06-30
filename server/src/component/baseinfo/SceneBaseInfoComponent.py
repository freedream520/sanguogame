#coding:utf8
'''
Created on 2009-12-1

@author: wudepeng
'''

from BaseInfoComponent import BaseInfoComponent
from DataLoader import loader

class SceneBaseInfoComponent(BaseInfoComponent):
    '''
        baseinfo component for Scene
    '''
    def __init__(self,owner,id,name,parentId=-1,regionId=-1,type=1,image=u"",description=u"",isBuild=1\
                 ,isShowInWorldMap=0,wExtentLeft=0,wExtentTop=0,extentLeft=0,extentTop=0):
        BaseInfoComponent.__init__(self,owner,id,name)
        self._parentId = parentId #地点父地点
        self._regionId = regionId #所属区域
        self._type = type #地点类型
        self._image = image #地图
        self._description = description #区域描述
        self._isBuild = isBuild #地点是否创建
        self._isShowInWorldMap = isShowInWorldMap #是否显示在世界地图中
        self._wExtentLeft = wExtentLeft #世界地图x坐标
        self._wExtentTop = wExtentTop #世界地图y坐标
        self._extentLeft = extentLeft #图片和可选区域 左上角 x轴坐标
        self._extentTop = extentTop #图片和可选区域 左上角 y轴坐标
        
    def getParentId(self):
        return self._parentId
    
    def setParentId(self,parentId):
        self._parentId = parentId
    
    def getRegionId(self):
        return self._regionId
    
    def setRegionId(self,regionId):
        self._regionId = regionId
    
    def getType(self):
        return self._type
    
    def setType(self,type):
        self._type = type
    
    def getImage(self):
        return self._image
    
    def setImage(self,image):
        self._image = image
    
    def getDescription(self):
        return self._description
    
    def setDescription(self,description):
        self._description = description
    
    def isBuild(self):
        return self._isBuild
    
    def setIsBuild(self,isBuild):
        self._isBuild = isBuild
    
    def getIsShowInWorldMap(self):
        return self._isShowInWorldMap
    
    def setIsShowInWorldMap(self,isShowIn):
        self._isShowInWorldMap = isShowIn
        
    def getWExtentLeft(self):
        return self._wExtentLeft
    
    def setWextentLeft(self,wLeft):
        self._wExtentLeft = wLeft
        
    def getWExtentTop(self):
        return self._wExtentTop
    
    def setWExtentTop(self,wTop):
        self._wExtentTop = wTop
        
    def getExtentLeft(self):
        return self._extentLeft
    
    def setExtentLeft(self,extentLeft):
        self._extentLeft = extentLeft
        
    def getExtentTop(self):
        return self._extentTop
    
    def setExtentTop(self,extentTop):
        self._extentTop = extentTop
        
