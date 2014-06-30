#coding:utf8
'''
Created on 2009-12-3

@author: wudepeng
'''

class BasePackage(object):
    '''
    base package object
    '''


    def __init__(self, width = 14, height = 4):
        '''
        Constructor
        '''
        self._width = width  #宽度
        self._height = height #高度
        self._items = [] #放置物品列表

    def getWidth(self):
        return self._width

    def setWidth(self, width):
        self._width = width

    def getHeight(self):
        return self._height

    def setHeight(self, height):
        self._height = height

    def getItems(self):
        return self._items

    def setItems(self, items):
        self._items = items

    def getOneRecordByPosition(self, position):
        for item in self._items:
            if item[0] == position:
                return item
        return None

    def getItemByPosition(self, position):
        '''根据坐标得到物品'''
        def rect(v, w, h):
            ret = []
            for i in range(v[0], v[0] + w):
                for j in range(v[1], v[1] + h):
                    value = [i, j]
                    ret.append(value)
            return ret
        for item in self._items:
            if position in rect(item[0], item[1].pack.getWidth(), item[1].pack.getHeight()):
                return item[1]
        return None

    def putItemByPosition(self, position, itemComponent):
        '''根据位置放置物品'''
        self._items.append([position, itemComponent])

    def findSparePositionForItem(self, itemWidth, itemHeight):
        '''寻找包裹栏中可以放置物品的位置'''
        grids = self._width * self._height
        for k in range(0, grids):
            i = k % self._width
            j = k / self._width
            position = [i, j]
            if position[0] + itemWidth > self._width:#超过package宽度边界
                continue
            if position[1] + itemHeight > self._height:#超过package高度边界
                continue
            result = self.scanItemGrids(position, itemWidth, itemHeight)
            if result:
                return [i, j]
            else:
                continue
        return [-1, -1]

    def canPutItem(self, toPosition, formerPosition):
        '''该position上能否放置物品
        @param toPosition: 目标位置
        @param formerPosition: 原来的位置
        '''
        if toPosition == formerPosition:
            return False
        dragItem = self.getItemByPosition(formerPosition)
        dragWidth = dragItem.pack.getWidth()
        dragHeight = dragItem.pack.getHeight()

        if toPosition[1] + dragHeight > self._height:#超过package高度边界
            return False
        if toPosition[0] + dragWidth > self._width:#超过package宽度边界
            return False

        return self.scanItemGrids(toPosition, dragWidth, dragHeight, dragItem)

    def scanItemGrids(self, toPosition, dragWidth, dragHeight, dragItem = None):
        '''
                    遍历物品占据的格子顶点，判断是否有物品占据;True:没有物品占据
        '''
#        class Point:
#                def __init__(self, x, y):
#                    self.x = x
#                    self.y = y
#
#        class Rect:
#
#            def __init__(self, x, y , width, height):
#                self.topLeft = Point(x, y)
#                self.topRight = Point(x + width, y)
#                self.buttomLeft = Point(x, y + height)
#                self.buttomRight = Point(x + width, y + height)
#
#        dstRect = Rect(toPosition[0], toPosition[1], dragWidth, dragHeight)
        for elm in self._items:
            position = elm[0]
            if type(elm[1]) == dict:#商店物品不是itemComponent形式
                width = elm[1]['itemTemplateInfo']['width']
                height = elm[1]['itemTemplateInfo']['height']
            else:
                width = elm[1].pack.getWidth()
                height = elm[1].pack.getHeight()
#            遍历物品占据的格子顶点，判断是否和栏中其他物品地点重合
            for i in range(position[0], position[0] + width):
                for j in range(position[1], position[1] + height):#遍历栏中物品所占格子
                    if dragItem:
                        if elm[1] == dragItem:
                            continue
                    for m in range(toPosition[0], toPosition[0] + dragWidth):
                        for n in range(toPosition[1], toPosition[1] + dragHeight):#遍历拖到当前位置物品所占格子
                            if [i, j] == [m, n]:
                                return False

#            srcRect = Rect(position[0], position[1], width, height)
#
#            ret = \
#            srcRect.topLeft.x <= dstRect.topLeft.x < srcRect.topRight.x and srcRect.topLeft.y <= dstRect.topLeft.y < srcRect.buttomLeft.y or \
#            srcRect.topLeft.x <= dstRect.topRight.x < srcRect.topRight.x and srcRect.topLeft.y <= dstRect.topRight.y < srcRect.buttomLeft.y or \
#            srcRect.topLeft.x <= dstRect.buttomLeft.x < srcRect.topRight.x and srcRect.topLeft.y <= dstRect.buttomLeft.y < srcRect.buttomLeft.y or \
#            srcRect.topLeft.x <= dstRect.buttomRight.x < srcRect.topRight.x and srcRect.topLeft.y <= dstRect.buttomRight.y < srcRect.buttomLeft.y
#            return not ret
        return True

    def canMergeItem(self, toPosition, formerPosition):
        '''
                     能否合并物品
        @param toPosition: 目标位置
        @param formerPosition: 原来的位置            
        '''
        dragItem = self.getItemByPosition(formerPosition)
        destItem = self.getItemByPosition(toPosition)
        if not destItem :
            return True
        destItemTemplate = destItem.baseInfo.getItemTemplate()
        dragItemTemplate = dragItem.baseInfo.getItemTemplate()
        if dragItem is destItem:
            return True
        if destItemTemplate['stack'] == -1:
            return False
        if destItemTemplate['id'] <> dragItemTemplate['id']:
            return False
        return True

class Package(BasePackage):
    '''
    package object
    '''
    def __init__(self, width, height):
        BasePackage.__init__(self, width , height)

class TempPackage(BasePackage):
    '''
    tempPackage object
    '''
    def __init__(self, width, height):
        BasePackage.__init__(self, width, height)


    def isTempPackageFull(self):
        ''' 判断临时包裹是否已满'''
        grids = [
                 [0, 0], [2, 0], [4, 0], [6, 0], [8, 0],
                 [0, 4], [2, 4], [4, 4], [6, 4], [8, 4]
                 ]
        for grid in grids:
            item = self.getItemByPosition(grid)
            if not item:
                return False, grid
        return True, None

class ShopPackage(BasePackage):
    '''
    shop package
    '''
    def __init__(self, width, height):
        BasePackage.__init__(width, height)

class TradePackage(BasePackage):
    '''
    trade package
    '''
    def __init__(self, width, height):
        BasePackage.__init__(width, height)

class WarehousePackage(BasePackage):
    '''
    WarehousePackage object
    '''
    def __init__(self, width, height):
        BasePackage.__init__(self, width , height)

class ForgingPakcage(BasePackage):
    '''
    ForgingPakcage object
    '''
    def __init__(self, width, height):
        BasePackage.__init__(self, width , height)

class DealPackage1(BasePackage):
    '''
    DealPackage1 object
    '''
    def __init__(self, width, height):
        BasePackage.__init__(self, width , height)

class DealPackage2(BasePackage):
    '''
    DealPackage2 object
    '''
    def __init__(self, width, height):
        BasePackage.__init__(self, width , height)
