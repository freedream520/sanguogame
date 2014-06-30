#coding:utf8
'''
Created on 2009-12-2

@author: wudepeng
'''

from component.Component import Component 
from util.DataLoader import loader,connection

class ItemFinanceComponent(Component):
    '''
    finance component for item
    '''

    def __init__(self,owner,price=0):
        '''
        Constructor
        '''
        Component.__init__(self,owner)
          
    def getPrice(self):
        '''计算物品实际价格'''
        selfExtraAttributeId = self._owner.attribute.getSelfExtraAttribute()
        dropExtraAttributeId= self._owner.attribute.getDropExtraAttributes()
        sellPrice = self._owner.baseInfo.getItemTemplate()['buyingRateCoin']
        if (selfExtraAttributeId and selfExtraAttributeId!='-1' and selfExtraAttributeId!=-1):
            extraAttributes = eval('['+selfExtraAttributeId+']')
            for extraAttrId in extraAttributes:
                extraAttrId = int(extraAttrId)
                isValidExtraAttrID = loader.getById('extra_attributes', extraAttrId, ['id'])
                if((extraAttrId != -1) and isValidExtraAttrID):
                    value = self.getExtraAttributeValue(extraAttrId)
                    sellPrice += value
#            value = self.getExtraAttributeValue(selfExtraAttributeId)
#            sellPrice += value
        elif (dropExtraAttributeId and dropExtraAttributeId!='-1'):
            extraAttributes = eval('['+dropExtraAttributeId+']')
            for extraAttrId in extraAttributes:
                extraAttrId = int(extraAttrId)
                isValidExtraAttrID = loader.getById('extra_attributes', extraAttrId, ['id'])
                if((extraAttrId != -1) and isValidExtraAttrID):
                    value = self.getExtraAttributeValue(extraAttrId)
                    sellPrice += value
        return int(sellPrice/4)
    
    def getExtraAttributeValue(self,extraAttributeId):
        '''得到每个附加属性的价值'''
        eAttribute = loader.getById('extra_attributes', extraAttributeId, ['level'])
        cursor = connection.cursor()
        cursor.execute("select price from exattribute_level where level=%d"%eAttribute['level'])
        value = cursor.fetchone()
        cursor.close()
        return int(value['price'])
        