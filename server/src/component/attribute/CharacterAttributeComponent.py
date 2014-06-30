#coding:utf8
'''
Created on 2009-12-1

@author: wudepeng
'''

from component.Component import Component
from util.DataLoader import loader
from util import dbaccess


class CharacterAttributeComponent(Component):
    '''
    attribute component for character
    '''


    def __init__(self, owner, baseStr = 19, baseVit = 19, baseDex = 19, manualStr = 0, manualVit = 0, manualDex = 0, \
                 sparePoint = 0, hp = 0, mp = 0, energy = 200):
        '''
        Constructor
        '''
        Component.__init__(self, owner)
        self._baseStr = baseStr  #系统根据玩家职业赋予玩家的基础力量点数
        self._baseVit = baseVit #系统根据玩家职业赋予玩家的基础体质点数
        self._baseDex = baseDex #系统根据玩家职业赋予玩家的基础灵巧点数
        self._manualStr = manualStr #自定义加在力量上的点数
        self._manualVit = manualVit #自定义加在体质上的点数
        self._manualDex = manualDex #自定义加在灵巧上的点数
        self._extraStr = 0  #被动技能力量点数
        self._extraDev = 0  #被动技能灵巧点数
        self._extraVit = 0  #被动技能体质点数
        self._sparePoint = sparePoint #剩余属性点数

        self._hp = hp #当前生命:
        self._mp = mp #目前的法力ֵ
        self._energy = energy #当前活力

        self._speed_rate = 1

    def getGrowthRate(self, professionId):
        '''成长率(力量、灵巧、体质)'''
        return [ self.profession.info['perLevelStr'], self.profession.info['perLevelDex'], self.profession.info['perLevelVit'] ]

    def getMaxHp(self, professionId, characterId, characterLevel):
        '''
                    计算当前最大HP
                    体力=(基础体力+(等级)*每级成长值)*(1+附加体力%)*(1+体质*0.01)+附加体力值)*(1+装备升级时附加体力%)
        '''
        percentMaxHp = 0.0
        skillMaxHp = 0.0
        self._professionId = professionId
        self._characterLevel = characterLevel
        valuse = self._owner.pack.getEquipmentSlot()
        data = loader.getById('profession', self._professionId, '*')
        basehp = data["baseHp"]
        perlevelhp = data["perLevelHp"]
        basevit = data["baseVit"]
        perlevelvit = data["perLevelVit"]
        extraVit = self.getExtraVit()
        level = self._characterLevel
        maxHp = (basehp + (level) * perlevelhp) * (1 + self.getCurrentVit(self._manualVit, level, basevit, perlevelvit, extraVit) * 0.01)

        maxHpList = getCharacterExtraAttributes(self._owner.baseInfo.id, "maxHp")
        maxHpPercentList = getCharacterExtraAttributes(self._owner.baseInfo.id, "maxHPercent")

        listLen = len(maxHpPercentList) #加体力%
        for i in range(0, listLen):
            percentMaxHp += maxHpPercentList[i] - 1
        percentMaxHp += 1
        maxHp *= percentMaxHp

        listLen = len(maxHpList) #加体力值
        for i in range(0, listLen):
            offsetMaxHp = maxHpList[i]
            maxHp += offsetMaxHp

        maxHp = int(maxHp * valuse) + int(maxHp)

        skillMaxHpList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'maxHp', '+')
        listLen = len(skillMaxHpList) #技能加体力
        for i in range(0, listLen):
            offsetMaxHp = skillMaxHpList[i]
            maxHp += offsetMaxHp


        skillMaxHpList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'maxHp', '*')
        listLen = len(skillMaxHpList) #技能加体力%
        for i in range(0, listLen):
            skillMaxHp += skillMaxHpList[i] - 1
        skillMaxHp += 1

        maxHp = int(maxHp * skillMaxHp)

        if self._hp > int(maxHp):
            dbaccess.updatePlayerInfo(characterId, {'hp':self._hp})
            self._hp = int(maxHp)

        return int(maxHp)

    def getMaxMp(self, professionId, characterId, characterLevel):
        '''
                    计算当前最大MP
                    法力=(基础法力+(等级)*每级成长值)*(1+附加法力%)*(1+体质*0.01)+附加法力值
        '''
        percentMaxMp = 0.0
        skillMaxMp = 0.0
        self._professionId = professionId
        self._characterLevel = characterLevel
        valuse = self._owner.pack.getEquipmentSlot()
        data = loader.getById('profession', self._professionId, '*')
        basemp = data["baseMp"]
        perlevelmp = data["perLevelMp"]
        basevit = data["baseVit"]
        perlevelvit = data["perLevelVit"]
        extraVit = self.getExtraVit()
        level = self._characterLevel
        maxMp = (basemp + (level) * perlevelmp) * (1 + self.getCurrentVit(self._manualVit, level, basevit, perlevelvit, extraVit) * 0.01)

        maxMpList = getCharacterExtraAttributes(self._owner.baseInfo.id, "maxMp")
        maxMpPercentList = getCharacterExtraAttributes(self._owner.baseInfo.id, "maxMPercent")

        listLen = len(maxMpPercentList) #加法力%
        for i in range(0, listLen):
            percentMaxMp = maxMpPercentList[i] - 1
        percentMaxMp += 1
        maxMp *= percentMaxMp

        listLen = len(maxMpList) #加法力值
        for i in range(0, listLen):
            offsetMaxMp = maxMpList[i]
            maxMp += offsetMaxMp

        maxMp = int(maxMp * valuse) + int(maxMp)

        skillMaxMpList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'maxHp', '+')
        listLen = len(skillMaxMpList) #技能加法力
        for i in range(0, listLen):
            offsetMaxMp = skillMaxMpList[i]
            maxMp += offsetMaxMp

        skillMaxMpList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'maxHp', '*')
        listLen = len(skillMaxMpList) #技能加法力%
        for i in range(0, listLen):
            skillMaxMp += skillMaxMpList[i] - 1
        skillMaxMp += 1
        maxMp = int(maxMp * skillMaxMp)

        if self._mp > int(maxMp):
            dbaccess.updatePlayerInfo(characterId, {'mp':self._mp})
            self._mp = int(maxMp)

        return int(maxMp)

    def getExtraVit(self):
        '''获取附加vit'''
        defaultVit = 0.0
        VitList = getCharacterExtraAttributes(self._owner.baseInfo.id, "extraVit")
        listLen = len(VitList)
        for i in range(0, listLen):
            offsetVit = VitList[i]
            defaultVit += offsetVit

        skillVitList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'growvit', '+')
        listLen = len(skillVitList) #技能加vit
        for i in range(0, listLen):
            offsetVit = skillVitList[i]
            defaultVit += offsetVit

        self._extraVit = int(defaultVit)
        return int(defaultVit)

    def getCurrentVit(self, manualVit, level, basevit, perlevelvit, extraVit):
        '''计算当前体质'''
        return level * perlevelvit + manualVit + basevit + extraVit

    def getExtraStr(self):
        '''获取附加Str'''
        defaultStr = 0.0
        strList = getCharacterExtraAttributes(self._owner.baseInfo.id, "extraStr")
        listLen = len(strList)
        for i in range(0, listLen):
            offsetStr = strList[i]
            defaultStr += offsetStr

        skillStrList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'growstr', '+')
        listLen = len(skillStrList) #技能加str
        for i in range(0, listLen):
            offsetStr = skillStrList[i]
            defaultStr += offsetStr

        self._extraStr = defaultStr
        return int(defaultStr)

    def getExtraDex(self):
        '''获取附加Dex'''
        defaultDex = 0.0
        DexList = getCharacterExtraAttributes(self._owner.baseInfo.id, "extraDex")
        listLen = len(DexList)
        for i in range(0, listLen):
            offsetDex = DexList[i]
            defaultDex += offsetDex

        skillDexList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'growdex', '+')
        listLen = len(skillDexList) #技能加dex
        for i in range(0, listLen):
            offsetDex = skillDexList[i]
            defaultDex += offsetDex

        self._extraDev = defaultDex

        return int(defaultDex)

    def getCurrSpeed(self):
        '''计算速度'''
        defaultSpeed = 8
        speed = defaultSpeed
        equipType = self._owner.pack.getWeaponType()
        if(equipType == long(1)):  #长刃
            defaultSpeed = 18
        elif(equipType == long(2)):  #拳套
            defaultSpeed = 14
        elif(equipType == long(4)):  #短刃
            defaultSpeed = 10
        speed = defaultSpeed
        profession = self._owner.profession.getProfession()
        if(equipType == long(4) and profession == 6):   #忍者
            speed += 2
        elif(equipType == long(2) and profession == 5):   #炼金
            speed += 2
        elif(equipType == long(1) and profession == 3):   #炼金
            speed += 2
        if(profession == 1):  #新手
            speed += 2

        skillSpeedList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'speed', '*')
        listLen = len(skillSpeedList) #技能加dex
        offsetSpeed = 0.0
        if listLen != 0:
            for i in range(0, listLen):
                offsetSpeed += skillSpeedList[i]
            speed *= offsetSpeed

        return int(speed * self._speed_rate)

    def getCurrSpeedDescription(self, speed):
        '''获取速度描述'''
        desc = ''
        if speed > 18:
            desc = '很慢'
        elif speed >= 18:
            desc = '慢'
        elif speed >= 16:
            desc = '略慢'
        elif speed >= 14:
            desc = '一般'
        elif speed >= 12:
            desc = '略快'
        elif speed >= 10:
            desc = '快'
        elif speed >= 8:
            desc = '非常快'
        else:
            desc = '无法想象的快'
        return desc

    def getCurrDefense(self):
        '''计算防御力'''
        temp = 0.0
        valuePercent = 0.0
        defaultDefense = 0
        skillDefense = 0.0
        defense = defaultDefense
        defensees = self._owner.pack.getItemDefenseInEquipSlot()
        if(len(defensees) > 0):
            for elm in defensees:
                defense += max(0, elm)
        defenseList = getCharacterExtraAttributes(self._owner.baseInfo.id, "defense")
        defensePercentList = getCharacterExtraAttributes(self._owner.baseInfo.id, "deFPercent")
        listLen = len(defenseList) #加防御力
        for i in range(0, listLen):
            offsetDefense = defenseList[i]
            defense += offsetDefense

        listLen = len(defensePercentList) #加防御力%
        for i in range(0, listLen):
            valuePercent += defensePercentList[i] - 1
        valuePercent += 1
        defense *= valuePercent

        skillDefenseList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'defense', '+')
        listLen = len(skillDefenseList) #技能加防御力
        for i in range(0, listLen):
            offsetDefense = skillDefenseList[i]
            defense += offsetDefense

        skillDefenseList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'defense', '*')
        listLen = len(skillDefenseList) #技能加防御力%
        for i in range(0, listLen):
            skillDefense += skillDefenseList[i] - 1
        skillDefense += 1

        defense *= skillDefense

        return int(defense)

    def getHit(self):
        '''获取Hit命中'''
        defaultHit = 1.0
        hitList = getCharacterExtraAttributes(self._owner.baseInfo.id, "hitrate")
        listLen = len(hitList)
        for i in range(0, listLen):
            offsetHit = hitList[i]
            defaultHit += offsetHit

        skillHitList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'hitrate', '+')
        listLen = len(skillHitList) #技能加命中
        for i in range(0, listLen):
            offsetHit = skillHitList[i]
            defaultHit += offsetHit

        return int(defaultHit)

    def getMiss(self):
        '''获取Miss躲避'''
        defaultMiss = 1.0
        missList = getCharacterExtraAttributes(self._owner.baseInfo.id, "dodgerate")
        listLen = len(missList)
        for i in range(0, listLen):
            offsetMiss = missList[i]
            defaultMiss += offsetMiss
        perleveldex2misspercent = loader.getById('profession', self._owner.profession.getProfession(), \
                                                  ['perLevelDex2MissPercent'])['perLevelDex2MissPercent']
        dex = self._manualDex + self._baseDex + self.getExtraDex()
        defaultMiss += (1 + perleveldex2misspercent * dex) * 1.0

        skillMissList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'dodgerate', '+')
        listLen = len(skillMissList) #技能加躲避
        for i in range(0, listLen):
            offsetMiss = skillMissList[i]
            defaultMiss += offsetMiss

        return int(defaultMiss)

    def getCri(self):
        '''获取Cri暴击'''
        defaultCri = 1.0
        CriList = getCharacterExtraAttributes(self._owner.baseInfo.id, "crirate")
        listLen = len(CriList)
        for i in range(0, listLen):
            offsetCri = CriList[i]
            defaultCri += offsetCri

        skillCriList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'crirate', '+')
        listLen = len(skillCriList) #技能加暴击
        for i in range(0, listLen):
            offsetCri = skillCriList[i]
            defaultCri += offsetCri

        return int(defaultCri)

    def getBre(self):
        '''获取Bre破防'''
        defaultBre = 1.0
        BreList = getCharacterExtraAttributes(self._owner.baseInfo.id, "bogeyrate")
        listLen = len(BreList)
        for i in range(0, listLen):
            offsetBre = BreList[i]
            defaultBre += offsetBre

        skillBreList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'bogeyrate', '+')
        listLen = len(skillBreList) #技能加破防
        for i in range(0, listLen):
            offsetBre = skillBreList[i]
            defaultBre += offsetBre

        return int(defaultBre)

    def getCurrDamage(self, extraStr = 0, extraDex = 0):
        '''计算攻击力范围'''
        id = self._owner.baseInfo.id
        maxPercent = 0.0
        minPercent = 0.0
        defaultMinDamage = 1
        defaultMaxDamage = 3
        skillMaxAttack = 0.0
        skillMinAttack = 0.0
        profession = loader.getById('profession', self._owner.profession.getProfession(), ['perLevelStr2DamagePercent', 'perLevelDex2DamagePercent'])
        strValue = int(self._baseStr + self._manualStr + self.getExtraStr())
        dexValue = int(self._baseDex + self._manualDex + self.getExtraDex())
        pointAddPercent = strValue * profession["perLevelStr2DamagePercent"]
        pointAddPercent += dexValue * profession["perLevelDex2DamagePercent"]

        minDamage = defaultMinDamage * (pointAddPercent + defaultMinDamage)
        maxDamage = defaultMaxDamage * (pointAddPercent + defaultMinDamage)

        mfMaxDamageList = getCharacterExtraAttributes(id, "maxAttack")
        mfMinDamageList = getCharacterExtraAttributes(id, "minAttack")
        mfMaxDamagePercentList = getCharacterExtraAttributes(id, "maxAPercent")
        mfMinDamagePercentList = getCharacterExtraAttributes(id, "minAPercent")
        listLen = len(mfMaxDamageList) #加攻击力
        for i in range(0, listLen):
            offsetMaxDamage = mfMaxDamageList[i]
            offsetMinDamage = mfMinDamageList[i]
            minDamage += offsetMinDamage
            maxDamage += offsetMaxDamage

        listLens = len(mfMaxDamagePercentList) #加攻击力%
        for i in range(0, listLens):
            maxPercent += mfMaxDamagePercentList[i] - 1
            minPercent += mfMinDamagePercentList[i] - 1

        maxPercent += 1
        minPercent += 1
        minDamage *= maxPercent
        maxDamage *= minPercent

        #计算武器攻击力            
        weapon = self._owner.pack.getWeaponId()
        if weapon == -1:
            return {"minDamage":minDamage, "maxDamage":maxDamage}
        weaponTemplateId = dbaccess.getItemTemplate(weapon)
        weaponItem = loader.getById('item_template', weaponTemplateId, ['minDamage', 'maxDamage'])
        if(weaponItem):
            info = dbaccess.getItemInfo(weapon)
            newMinDamage = int(weaponItem["minDamage"] * 0.03 * (info[6] - 1))
            newMaxDamage = int(weaponItem["maxDamage"] * 0.03 * (info[6] - 1))
            minDamage = (defaultMinDamage + weaponItem["minDamage"] + newMinDamage) * (pointAddPercent + defaultMinDamage)
            maxDamage = (defaultMaxDamage + weaponItem["maxDamage"] + newMaxDamage) * (pointAddPercent + defaultMinDamage)


        skillMaxAttackList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'maxAttack', '+')
        skillMinAttackList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'minAttack', '+')
        listLen = len(skillMaxAttackList) #技能加攻击力
        for i in range(0, listLen):
            offsetMaxDamage = skillMaxAttackList[i]
            offsetMinDamage = skillMinAttackList[i]
            minDamage += offsetMinDamage
            maxDamage += offsetMaxDamage

        skillMaxAttackList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'maxAttack', '*')
        skillMinAttackList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'minAttack', '*')
        listLen = len(skillMaxAttackList) #技能加攻击力%
        for i in range(0, listLen):
            skillMaxAttack += skillMaxAttackList[i] - 1
            skillMinAttack += skillMinAttackList[i] - 1
        skillMaxAttack += 1
        skillMinAttack += 1
        minDamage *= skillMinAttack
        maxDamage *= skillMaxAttack

        return {"minDamage":minDamage, "maxDamage":maxDamage}

    def getDamage(self):
        '''被动技能伤害加成'''
        damage = 0
        skillDamageList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'damage', '+')
        listLen = len(skillDamageList)
        for i in range(0, listLen):
            offsetDamage = skillDamageList[i]
            damage += offsetDamage

        return damage


    def getDamagePercent(self):
        '''被动技能伤害加成%'''
        damage = 1
        skillDamageList = self.getPassiveSkillsEffects(self._owner.baseInfo.id, 'damage', '*')
        listLen = len(skillDamageList)
        for i in range(0, listLen):
            damage += skillDamageList[i]

        return damage

    def addAttributePoint(self, type, all):
        '''玩家属性加点'''
        characterId = self._owner.baseInfo.id
        point = 0
        if self._sparePoint <= 0:
            return {'result':False}
        if all == 0:
            self._sparePoint -= 1
            if type == 'manualStr':
                self._manualStr += 1
                dbaccess.updatePlayerInfo(characterId, {'sparePoint':self._sparePoint, type:self._manualStr})
                point = self._manualStr
            elif type == 'manualVit':
                self._manualVit += 1
                dbaccess.updatePlayerInfo(characterId, {'sparePoint':self._sparePoint, type:self._manualVit})
                point = self._manualVit
            elif type == 'manualDex':
                self._manualDex += 1
                dbaccess.updatePlayerInfo(characterId, {'sparePoint':self._sparePoint, type:self._manualDex})
                point = self._manualDex
        elif all == 1:
            if type == "manualStr":
                self._manualStr += self._sparePoint
                dbaccess.updatePlayerInfo(characterId, {'sparePoint':0 , type:self._manualStr})
                point = self._manualStr
            elif type == "manualVit":
                self._manualVit += self._sparePoint
                dbaccess.updatePlayerInfo(characterId, {'sparePoint':0 , type:self._manualVit})
                point = self._manualVit
            elif type == "manualDex":
                self._manualDex += self._sparePoint
                dbaccess.updatePlayerInfo(characterId, {'sparePoint':0 , type:self._manualDex})
                point = self._manualDex
            self._sparePoint = 0

        return{'result':True, 'sparePoint':self._sparePoint, 'type':type, 'point':point}

    def reassginAttributePoint(self, payType, payNum):
        '''玩家属性洗点'''
        id = self._owner.baseInfo.id
        if payType == 'gold':
            gold = self._owner.finance.getGold()
            if payNum > gold:
                return {'result':False, 'reason':'not have enough gold'}
            self._owner.finance.setGold(gold - payNum)
            dbaccess.updatePlayerInfo(id, {'gold':gold - payNum})
        elif payType == 'coupon':
            coupon = self._owner.finance.getCoupon()
            if payNum > coupon:
                return {'result':False, 'reason':'not have enough coupon'}
            self._owner.finance.setCoupon(coupon - payNum)
            dbaccess.updatePlayerInfo(id, {'coupon':coupon - payNum})
        else:
            return {'result':False, 'reason':'pay param is wrong'}
        point = self._sparePoint + self._manualStr + self._manualDex + self._manualVit
        dbaccess.updatePlayerInfo(id, {'sparePoint':point, 'manualStr':0, 'manualVit':0, 'manualDex':0})
        self._sparePoint = point
        self._manualStr = 0
        self._manualDex = 0
        self._manualVit = 0
        return {'result':True, 'sparePoint':point, 'manualStr':0, 'manualVit':0, 'manualDex':0}

    def updateEnergy(self, point):
        '''修改活力'''
        energy = self._owner.attribute.getEnergy()
        if energy + point > 200:
            energy = 200
        elif energy + point < 0:
            energy = 0
        else:
            energy += point
        dbaccess.updatePlayerInfo(self._owner.baseInfo.id, {'energy':energy})
        self._owner.attribute.setEnergy(energy)
        return energy

    def reliveInCurrentPlace(self, coinNum):
        '''原地复活'''
        id = self._owner.baseInfo.id
        profession = self._owner.profession.getProfession()
        level = self._owner.level.getLevel()

        coin = self._owner.finance.getCoin() - coinNum
        if coin < 0:
            return {'result':False, 'reason':u'您的铜币量不足'}
        hp = self.getMaxHp(profession, id, level) / 2
        mp = self.getMp()
        status = 1
        gold = self._owner.finance.getGold()
        coupon = self._owner.finance.getCoupon()
        attrs = {'status':status, 'coin':coin, 'hp':hp}
        dbaccess.updatePlayerInfo(id, attrs)

        self._owner.attribute.setHp(hp)
        self._owner.baseInfo.setStatus(status)
        self._owner.finance.setCoin(coin)

        return{'result':True, 'data':{'hp':hp, 'mp':mp, 'coin':coin, 'gold':gold, \
                                     'coupon':coupon, 'status':u'正常', 'type':1}}

    def reliveInTown(self):
        '''回城复活'''
        id = self._owner.baseInfo.id

        coin = self._owner.finance.getCoin()
        hp = 1
        mp = self.getMp()
        status = 1
        gold = self._owner.finance.getGold()
        coupon = self._owner.finance.getCoupon()

        attrs = {'hp':hp, 'mp':mp, 'status':status}
        dbaccess.updatePlayerInfo(id, attrs)
        self._owner.attribute.setHp(hp)
        self._owner.baseInfo.setStatus(status)

        return {'result':True, 'data':{'hp':hp, 'mp':mp, 'coin':coin, 'gold':gold, \
                                     'coupon':coupon, 'status':u'正常', 'type':2}}

    def reliveOnUsingGold(self, payType, payNum):
        '''黄金复活'''
        id = self._owner.baseInfo.id
        profession = self._owner.profession.getProfession()
        level = self._owner.level.getLevel()

        gold = self._owner.finance.getGold()
        coupon = self._owner.finance.getCoupon()
        if payType == 'gold':
            gold -= payNum
            if gold < 0:
                return {'result':False, 'reason':u'您的黄金量不足'}
        elif payType == 'coupon':
            coupon -= payNum
            if coupon < 0:
                return {'result':False, 'reason':u'您的礼券量不足'}
        coin = self._owner.finance.getCoin()
        hp = self.getMaxHp(profession, id, level)
        mp = self.getMaxMp(profession, id, level)
        status = 1

        attrs = {'gold':gold, 'coupon':coupon, 'status':status, \
                 'hp':hp, 'mp':mp}
        dbaccess.updatePlayerInfo(id, attrs)
        self._owner.attribute.setHp(hp)
        self._owner.attribute.setMp(mp)
        self._owner.baseInfo.setStatus(status)
        self._owner.finance.setGold(gold)
        self._owner.finance.setCoupon(coupon)

        return {'result':True, 'data':{'hp':hp, 'mp':mp, 'coin':coin, 'gold':gold, \
                                     'coupon':coupon, 'status':u'正常', 'type':3}}

    def doRest(self, type, payType, payNum):
        '''执行宿屋操作'''
        id = self._owner.baseInfo.id
        profession = self._owner.profession.getProfession()
        level = self._owner.level.getLevel()
        coin = self._owner.finance.getCoin()
        gold = self._owner.finance.getGold()
        coupon = self._owner.finance.getCoupon()
        hp = self.getHp()
        mp = self.getMp()
        energy = self.getEnergy()
        count = 0

        restRecord = dbaccess.getPlayerRestRecord(id)
        if type == 'meal':#用餐
            hp = self.getMaxHp(profession, id, level)
            mp = self.getMaxMp(profession, id, level)
            coin -= payNum
            if coin < 0:
                return {'result':False, 'reason':u'您的铜币量不足'}
            count = -1
            dbaccess.updatePlayerInfo(id, {'hp':hp, 'mp':mp, 'coin':coin})
        elif type == 'nap':#小憩
            energyDelta = payNum
            result = self._doSleep(2, payType, payNum, energy, energyDelta, gold, coupon, restRecord, type)
            if not result['result']:
                return result
            gold = result['data']['gold']
            coupon = result['data']['coupon']
            energy = result['data']['energy']
            count = 1 - (int(restRecord[2]) + 1)
            dbaccess.updatePlayerRestRecord(id, {'napCount':restRecord[2] + 1})
        elif type == 'lightSleep':#浅睡
            energyDelta = payNum
            result = self._doSleep(3, payType, payNum, energy, energyDelta, gold, coupon, restRecord, type)
            if not result['result']:
                return result
            gold = result['data']['gold']
            coupon = result['data']['coupon']
            energy = result['data']['energy']
            count = 1 - (int(restRecord[3]) + 1)
            dbaccess.updatePlayerRestRecord(id, {'lightSleepCount':restRecord[3] + 1})
        elif type == 'peacefulSleep':#安眠
            energyDelta = payNum
            result = self._doSleep(4, payType, payNum, energy, energyDelta, gold, coupon, restRecord, type)
            if not result['result']:
                return result
            gold = result['data']['gold']
            coupon = result['data']['coupon']
            energy = result['data']['energy']
            count = 1 - (int(restRecord[4]) + 1)
            dbaccess.updatePlayerRestRecord(id, {'peacefulSleepCount':restRecord[4] + 1})
        elif type == 'spoor':#酣睡
            energyDelta = payNum
            result = self._doSleep(5, payType, payNum, energy, energyDelta, gold, coupon, restRecord, type)
            if not result['result']:
                return result
            gold = result['data']['gold']
            coupon = result['data']['coupon']
            energy = result['data']['energy']
            count = 2 - (int(restRecord[5]) + 1)
            dbaccess.updatePlayerRestRecord(id, {'spoorCount':restRecord[5] + 1})

        self.setHp(hp)
        self.setMp(mp)
        self.setEnergy(energy)
        self._owner.finance.setCoin(coin)
        self._owner.finance.setGold(gold)
        self._owner.finance.setCoupon(coupon)

        return {'result':True, 'data':{'hp':hp, 'mp':mp, 'energy':energy, 'gold':gold, \
                                      'coupon':coupon, 'coin':coin, 'type':type, 'count':count}}

    def _doSleep(self, index, payType, payNum, energy, energyDelta, gold, coupon, restRecord, type):
        id = self._owner.baseInfo.id
        if payType == 'gold':
            gold -= payNum
            if gold < 0:
                return {'result':False, 'reason':u'您的黄金量不足'}
            if type == 'spoor':
                if restRecord[index] >= 2:
                    return {'result':False, 'reason':u'您今天不能此操作'}
            else:
                if restRecord[index] >= 1:
                    return {'result':False, 'reason':u'您今天不能此操作'}
            energy += energyDelta
            if energy > 200:
                return {'result':False, 'reason':u'您的活力已达上限'}
            dbaccess.updatePlayerInfo(id, {'energy':energy, 'gold':gold})
        else:
            coupon -= payNum
            if coupon < 0:
                return {'result':False, 'reason':u'您的礼券量不足'}
            energy += energyDelta
            if energy > 200:
                return {'result':False, 'reason':u'您的活力已达上限'}
            dbaccess.updatePlayerInfo(id, {'energy':energy, 'coupon':coupon})
        return {'result':True, 'data':{'gold':gold, 'coupon':coupon, 'energy':energy}}

    def getBaseStr(self):
        return self._baseStr

    def setBaseStr(self, str):
        self._baseStr = str

    def getBaseVit(self):
        return self._baseVit

    def setBaseVit(self, vit):
        self._baseVit = vit

    def getBaseDex(self):
        return self._baseDex

    def setBaseDex(self, dex):
        self._baseDex = dex

    def getManualStr(self):
        return self._manualStr

    def setManualStr(self, manualStr):
        self._manualStr = manualStr

    def getManualVit(self):
        return self._manualVit

    def setManualVit(self, manualVit):
        self._manualVit = manualVit

    def getManualDex(self):
        return self._manualDex

    def setManualDex(self, manualDex):
        self._manualDex = manualDex

    def setExtraStr(self, str):
        self._extraStr = str

    def setExtraDex(self, dex):
        self._extraDev = dex

    def getHp(self):
        return self._hp

    def setHp(self, hp):
        self._hp = hp

    def getMp(self):
        return self._mp

    def setMp(self, mp):
        self._mp = mp

    def getEnergy(self):
        return self._energy

    def setEnergy(self, energy):
        self._energy = energy >= 0 and energy or 0

    def getSparePoint(self):
        return self._sparePoint

    def setSparePoint(self, sparePoint):
        self._sparePoint = sparePoint

    def getPassiveSkillsEffects(self, characterId, keyName, type):
        '''得到玩家被动技能效果'''
        effects = []
        learnedSkills = dbaccess.getLearnedSkills(characterId)
        if not learnedSkills or len(learnedSkills) == 0:
            return effects
        for skill in learnedSkills:
            skillId = skill[2]
            skillInfo = loader.getById('skill', skillId, '*')
            if skillInfo['type'] != 3:
                continue
            for effect in skillInfo['addEffect'].split(';'):
                if int(effect) != -1:
                    effectInfo = loader.getById('effect', int(effect), '*')
                    script = effectInfo['script'].split(";")
                    for list in script:
                        if list.find('owner') <> -1:
                            if list.find(keyName) <> -1:
                                if list.find(type) <> -1:
                                    elments = list.split('=')
                                    if elments[1].find('owner') <> -1:
                                        if elments[1].find('extraStr') <> -1:
                                            effectStr = elments[1].split(']')
                                            if effectStr[1].find('*') <> -1:
                                                extraStr = effectStr[1].split('*')
                                                if extraStr[1].find('+') <> -1:
                                                    extraStr = effectStr[1].split('+')
                                                    valuePercent = str(extraStr[0]).strip()
                                                    value = str(extraStr[1]).strip()
                                                    valuePercent = self._extraStr * valuePercent
                                                    valuePercent = valuePercent + value
                                                    effects.append(float(valuePercent))
                                                else:
                                                    valuePercent = str(extraStr[1]).strip()
                                                    valuePercent = self._extraStr * valuePercent
                                                    effects.append(float(valuePercent))
                                        elif elments[1].find('extraDex') <> -1:
                                            effectDex = elments[1].split(']')
                                            if effectDex[1].find('*') <> -1:
                                                extraDex = effectDex[1].split('*')
                                                if effectDex[1].find('+') <> -1:
                                                    extraDex = effectDex[1].split('+')
                                                    valuePercent = str(extraStr[0]).strip()
                                                    value = str(extraDex[1]).strip()
                                                    valuePercent = self._extraStr * valuePercent
                                                    valuePercent = valuePercent + value
                                                    effects.append(float(valuePercent))
                                                else:
                                                    valuePercent = str(extraDex[1]).strip()
                                                    valuePercent = self._extraDex * valuePercent
                                                    effects.append(float(valuePercent))
                                    else:
                                        value = str(elments[1]).strip()
                                        effects.append(float(value))
        return effects
#-----------------------------------------------------------------以下是模块方法，不是组件成员方法---------------------------------------------------------------------------

def getCharacterExtraAttributes(characterId, keyName):
    '''得到玩家装备栏中物品附加属性列表'''
    extraAttributeList = []
    items = []
    item = None

    equipmentIds = dbaccess.getDetailsInEquipmentSlot(characterId)

    for idx in range(0, len(equipmentIds)):
        if idx == 0 or idx == 1:
            continue
        if equipmentIds[idx] <> -1:
            item = dbaccess.getSelfAndDropExtraAttr(equipmentIds[idx])
            items.append(item)
    if(len(items) > 0):
        for elm in items:
            if(elm[0] == '-1' and elm[1] == '-1'):  #no extraAttribute
                continue
            if(elm[0] != u'-1'):     #only one extraAttribute
                extraAtrributes = elm[0].split(",")
                for exAttributeId in extraAtrributes:
                    if(exAttributeId == ""):
                        continue
                    extraAtrribute = loader.getById('extra_attributes', exAttributeId, '*')
                    if(extraAtrribute):
                        extraList = extraAtrribute['script'].split(";")
                        for list in extraList:
                            if list.find(keyName) <> -1:
                                elments = list.split('=')
                                index = elments[1].find(';')
                                value = str(elments[1]).strip()
                                extraAttributeList.append(float(value))
            if(elm[1] != u'-1'):     #several extraAttributes
                extraAtrributes = elm[1].split(",")
                for exAttributeId in extraAtrributes:
                    if(exAttributeId == ""):
                        continue
                    extraAtrribute = loader.getById('extra_attributes', exAttributeId, '*')
                    if(extraAtrribute):
                        extraList = extraAtrribute['script'].split(";")
                        for list in extraList:
                            if list.find(keyName) <> -1:
                                elments = list.split('=')
                                index = elments[1].find(';')
                                value = str(elments[1]).strip()
                                extraAttributeList.append(float(value))
    return extraAttributeList

