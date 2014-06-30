#coding:utf8
'''
Created on 2009-12-1


'''

from component.baseinfo.CharacterBaseInfoComponent import CharacterBaseInfoComponent
from component.attribute.CharacterAttributeComponent import CharacterAttributeComponent
from component.battle.CharacterBattleComponent import CharacterBattleComponent
from component.camp.CharacterCampComponent import CharacterCampComponent
from component.dialog.CharacterDialogComponent import CharacterDialogComponent
from component.dropping.CharacterDroppingComponent import CharacterDroppingComponent
from component.effect.CharacterEffectComponent import CharacterEffectComponent
from component.balloon.CharacterBalloonComponent import CharacterBalloonComponent
from component.finance.CharacterFinanceComponent import CharacterFinanceComponent
from component.friend.CharacterFriendComponent import CharacterFriendComponent
from component.instance.CharacterInstanceComponent import CharacterInstanceComponent
from component.level.CharacterLevelComponent import CharacterLevelComponent
from component.mail.CharacterMailComponent import CharacterMailComponent
from component.pack.CharacterPackComponent import CharacterPackComponent
from component.practice.CharacterPracticeComponent import CharacterPracticeComponent
from component.profession.CharacterProfessionComponent import CharacterProfessionComponent
from component.quest.CharacterQuestComponent import CharacterQuestComponent
from component.skill.CharacterSkillComponent import CharacterSkillComponent
from component.trade.CharacterTradeComponent import CharacterTradeComponent
from component.shop.CharacterShopComponent import CharacterShopComponent
from component.team.CharacterTeamComponent import CharacterTeamComponent
from component.warehouse.CharacterWarehouseComponent import CharacterWarehouseComponent
from component.recruit.recruitComponent import RecruitComponent

from util import dbaccess
from util.DataLoader import loader, connection
#import random
#from MeleeSite import pushMessage
#from core.teamsManager import TeamsManager

def _getCommonbaseValues():
    ''' 得到通用的基础属性 '''
    values = {}
    values['isCharacter'] = False
    values['id'] = -1
    values['name'] = u" "
    values['level'] = 0
    values['image'] = u" "
    values['exp'] = 0
    values['weaponName'] = u"空手"
    values['attackDescribeGroup'] = 0
    values['hp'] = 0
    values['mp'] = 0
    values['maxHp'] = 0
    values['maxMp'] = 0
    values['speed'] = 0
    values['speedDesc'] = u" "
    values['maxAttack'] = 0
    values['minAttack'] = 0
    values['defense'] = 0
    values['hitRate'] = 0
    values['dodgeRate'] = 0
    values['criRate'] = 0
    values['bogeyRate'] = 0
    values['baseStr'] = 0
    values['baseDex'] = 0
    values['manualStr'] = 0
    values['manualDex'] = 0
    values['extraStr'] = 0
    values['extraDex'] = 0
    values['counts'] = 0
    values['abs_damage'] = 0
    values['damagePercent'] = 1
    values['startBattleSentence'] = u""
    values['criSentence'] = u""
    values['breSentence'] = u""
    values['criAndBreSentence'] = u""
    values['missSentence'] = u""
    values['beMissedSentence'] = u""
    values['beCrackedSentence'] = u""
    values['usingSkillSentence'] = u""
    values['winSentence'] = u""
    values['failSentence'] = u""
    values['scoreBonus'] = 0
    values['expBonus'] = 0
    values['coinBonus'] = 0
    values['goldBonus'] = 0
    values['dropItemId'] = 0
    values['activeSkillId'] = None
    values['activeSkill'] = None
    values['auxiliarySkills'] = None
    values['passiveSkills'] = None
    values['criCoefficient'] = 1.5

    values['skillName'] = u" "
    values['extraEffects'] = []
    values['_instance_'] = None

    values['growdex'] = 0
    values['growvit'] = 0
    values['growstr'] = 0

    return values

    values['maxAttack']
    values['minAttack']
    values['hitRate']
    values['level']
    values['criRate']
    values['bogeyRate']
    values['dodgeRate']
    values['speed']
    values['count']
    values['hp']
    values['maxHp']
    values['mp']
    values['maxMp']

class Character(object):
    '''
    抽象的角色对待
    '''
    def __init__(self, id, name):
        '''
               创建一个角色
        '''
        self.baseInfo = CharacterBaseInfoComponent(self, id, name)

    def getBaseID(self):
        return self.baseInfo.id

class PlayerCharacter(Character):

    def __init__(self, id, name = None, message = None):
        Character.__init__(self, id, name)
        self.attribute = CharacterAttributeComponent(self)
        self.battle = CharacterBattleComponent(self)
        self.camp = CharacterCampComponent(self)
        self.dialog = CharacterDialogComponent(self)
        self.dropping = CharacterDroppingComponent(self)
        self.effect = CharacterEffectComponent(self)
        self.balloon = CharacterBalloonComponent(self)
        self.finance = CharacterFinanceComponent(self)
        self.friend = CharacterFriendComponent(self)
        self.instance = CharacterInstanceComponent(self)
        self.level = CharacterLevelComponent(self)
        self.mail = CharacterMailComponent(self)
        self.warehouse = CharacterWarehouseComponent(self)
        self.pack = CharacterPackComponent(self)
        self.practice = CharacterPracticeComponent(self)
        self.profession = CharacterProfessionComponent(self)
        self.quest = CharacterQuestComponent(self)
        self.skill = CharacterSkillComponent(self)
        self.trade = CharacterTradeComponent(self)
        self.shop = CharacterShopComponent(self)
        self.teamcom = CharacterTeamComponent(self)
        self.recruitcom = RecruitComponent(self)
        if name is None:
            data = dbaccess._queryPlayerInfo(id)
            self.initPlayer(data)
        self.timeOnLineSinceLastSync = 0
        self.timeOnLine = 0
        self.listenTimeOut = 3000
        clientID = None
        try:
            clientID = message.response_msg.body.clientId
        except:
            pass
        self.clientId = clientID
        self.delta = None

    def initPlayer(self, data):
        '''初始化玩家信息'''
        self.baseInfo.setType(data[1])
        self.baseInfo.setNickName(data[3])
        self.baseInfo.setPortrait(data[4])
        self.baseInfo.setDescription(data[33])
        self.baseInfo.setStatus(data[18])
        self.baseInfo.setTown(data[29])
        self.baseInfo.setLocation(data[28])
        self.baseInfo.setPassword(data[39])
        self.baseInfo.setGender(data[40])

        self.level.setLevel(data[6])
        self.level.setExp(data[17])
        self.level.setTwiceExp(data[37])

        self.attribute.setBaseStr(data[7])
        self.attribute.setBaseVit(data[8])
        self.attribute.setBaseDex(data[9])
        self.attribute.setManualStr(data[10])
        self.attribute.setManualVit(data[11])
        self.attribute.setManualDex(data[12])
        self.attribute.setSparePoint(data[13])
        self.attribute.setHp(data[14])
        self.attribute.setMp(data[15])
        self.attribute.setEnergy(data[16])

        self.finance.setCoupon(data[30])
        self.finance.setCoin(data[31])
        self.finance.setGold(data[32])

        self.camp.setCamp(data[21])

        self.profession.setProfessionPosition(data[22])
        self.profession.setProfession(data[23])
        self.profession.setProfessionStage(data[24])
        if data[5] != -1:
            balloon = dbaccess.getPlayerBalloonInfo(data[5])
            self.balloon.setId(data[5])
            self.balloon.setStartBattleSentence(balloon[1])
            self.balloon.setCriSentence(balloon[2])
            self.balloon.setBreSentence(balloon[3])
            self.balloon.setCriAndBreSentence(balloon[4])
            self.balloon.setMissSentence(balloon[5])
            self.balloon.setBeMissedSentence(balloon[6])
            self.balloon.setBeCrackedSetence(balloon[7])
            self.balloon.setUsingSkillSentence(balloon[8])
            self.balloon.setWinSentence(balloon[9])
            self.balloon.setFailSentence(balloon[10])

        if data[25] != -1:
            self.skill.setActiveSkill(data[25])
        if data[26]:
            auxiSkills = eval("[" + data[26] + "]")
            for skill in auxiSkills:
                skill = int(skill)
                if skill == -1:
                    auxiSkills = []
                    break
            self.skill.setAuxiliarySkills(auxiSkills)
        if data[27]:
            passiveSkills = eval("[" + data[27] + "]")
            for skill in passiveSkills:
                skill = int(skill)
                if skill == -1:
                    passiveSkills = []
                    break
            self.skill.setPassiveSkills(passiveSkills)
        if data[34]:
            self.friend.setFriendCount(data[34])
        self.instance.setEnterInstanceCount(data[36])
        self.dropping.setDropCoefficient(data[37])
        self.teamcom.setMyTeam(data[43])
        self.warehouse.setWarehouses(data[41])
        self.warehouse.setDeposit(data[42])
        self.recruitcom.init(data[44])
        self.refreshInfectionOfSkill()

    def refreshInfectionOfSkill(self):
        return
        owner = self.getCommonValues()
        bak1 = owner.copy()
        delta = owner.copy()
        learnedSkills = dbaccess.getLearnedSkills(self.baseInfo.id)
        if not learnedSkills or len(learnedSkills) == 0:
            return
        for skill in learnedSkills:
            skillId = skill[2]
            skillInfo = loader.getById('skill', skillId, '*')
            if skillInfo['type'] != 3:
                continue
            for effect in skillInfo['addEffect'].split(';'):
                if int(effect) != -1:
                    effectInfo = loader.getById('effect', int(effect), '*')
                    script = effectInfo['script']
                    try:
                        exec (script)
                    except Exception as e:
                        print "error", e
        if bak1 == owner:
            return None
        for k in owner.keys():
            __typeK = type(owner[k])
            if __typeK is int or __typeK is long or __typeK is float:
                delta[k] = owner[k] - bak1[k]
            elif __typeK is list:
                delta[k] = []
            elif __typeK is dict:
                delta[k] = {}
            elif __typeK is str or __typeK is unicode:
                delta[k] = ''
            else:
                print 'extra Type', __typeK
        data = dbaccess._queryPlayerInfo(self.baseInfo.id)
        self.attribute.setManualStr(data[10] + delta['growstr'])
        self.attribute.setManualVit(data[11] + delta['growvit'])
        self.attribute.setManualDex(data[12] + delta['growdex'])
        self.delta = delta

    def update(self, delta):
        self.timeOnLine += delta

    def refresh(self):
        effects = list(self.effect._invisibleEffects)
#        print effects

    def sync(self):
        self.timeOnLineSinceLastSync = self.timeOnLine

    def isOnLine(self):
        return self.timeOnLine - self.timeOnLineSinceLastSync < self.listenTimeOut

    def getBaseID(self):
        return self.baseInfo.id

    def archiveInfo(self):
        '''保存玩家离线前的状态'''
        pass

    def updateData(self, commit = False):
        if commit:
            pass
        else:
            data = dbaccess._queryPlayerInfo(self.baseInfo.id)
            self.initPlayer(data)

    def getType(self):
        return 1

    def checkClientID(self, message):
        id = None
        try:
            id = message.response_msg.body.clientId
        except:
            pass
        return self.clientId == id

    def addEffect(self, effect):
        pass

    def removeEffect(self, effect):
        pass

    def getCommonValues_delta(self):
        values = self.getCommonValues()
#        if self.delta:
#            for k in values.keys():
#                _type = type(values[k])
#                if _type is int or _type is float or _type is long:
#                    print k , values[k], self.delta[k], type(values[k]), type(self.delta[k])
#                    values[k] += self.delta[k]
        return values


    def getCommonValues(self):
        values = _getCommonbaseValues()
        values['isCharacter'] = True
        values['id'] = self.baseInfo.id

        values['name'] = self.baseInfo.getName()
        values['level'] = self.level.getLevel()
        values['image'] = self.baseInfo.getPortrait()
        values['exp'] = self.level.getExp()
        values['professionName'] = self.profession.getProfessionName()
        values['professionStage'] = self.profession.getProfessionStageName()
        values['figure'] = self.profession.getProfessionFigure()

        weaponName = self.pack.getWeaponName()
        if weaponName:
            values['weaponName'] = weaponName
        else:
            values['weaponName'] = u"空手"

        weaponType = self.pack.getWeaponType()
        if weaponType:
            values['attackDescribeGroup'] = weaponType

        values['hp'] = self.attribute.getHp()
        values['mp'] = self.attribute.getMp()
        values['maxHp'] = self.attribute.getMaxHp(self.profession.getProfession(), self.baseInfo.id, self.level.getLevel())
        values['maxMp'] = self.attribute.getMaxMp(self.profession.getProfession(), self.baseInfo.id, self.level.getLevel())

        values['baseStr'] = self.attribute.getBaseStr()
        values['baseDex'] = self.attribute.getBaseDex()
        values['manualStr'] = self.attribute.getManualStr()
        values['manualDex'] = self.attribute.getManualDex()
        values['extraStr'] = self.attribute.getExtraStr()
        values['extraDex'] = self.attribute.getExtraDex()

        values['speed'] = self.attribute.getCurrSpeed()
        values['speedDesc'] = self.attribute.getCurrSpeedDescription(values['speed'])
        values['defense'] = self.attribute.getCurrDefense()

        values['hitRate'] = self.attribute.getHit()
        values['criRate'] = self.attribute.getCri()
        values['bogeyRate'] = self.attribute.getBre()

        promotiondodgerate = (int(values['baseDex']) + int(values['manualDex']) + int(values['extraDex'])) * self.getProfessionNum(self.profession.getProfession(), 2, 2)
        values['dodgeRate'] = self.attribute.getMiss() + promotiondodgerate

        promotionstr = (int(values['baseStr']) + int(values['manualStr']) + int(values['extraStr'])) * self.getProfessionNum(self.profession.getProfession())
        promotiondex = (int(values['baseDex']) + int(values['manualDex']) + int(values['extraDex'])) * self.getProfessionNum(self.profession.getProfession(), 2)

        values['maxAttack'] = self.attribute.getCurrDamage()['maxDamage'] + promotionstr + promotiondex
        values['minAttack'] = self.attribute.getCurrDamage()['minDamage'] + promotionstr + promotiondex
        values['abs_damage'] = self.attribute.getDamage()
        values['damagePercent'] = self.attribute.getDamagePercent()

        values['startBattleSentence'] = self.balloon.getStartBattleSentence()
        values['criSentence'] = self.balloon.getCriSentence()
        values['breSentence'] = self.balloon.getBreSentence()
        values['balloonBreSentence'] = self.balloon.getCriAndBreSentence()
        values['missSentence'] = self.balloon.getMissSentence()
        values['beMissedSentence'] = self.balloon.getBeMissedSentence()
        values['beCrackedSentence'] = self.balloon.getBeCrackedSetence()
        values['usingSkillSentence'] = self.balloon.getUsingSkillSentence()
        values['winSentence'] = self.balloon.getWinSentence()
        values['failSentence'] = self.balloon.getFailSentence()

        if  self.skill.getActiveSkill() > 0:
            values['activeSkillId'] = self.skill.getActiveSkill()
            values['activeSkill'] = loader.getById('skill', values['activeSkillId'], '*')
            values['skillName'] = values['activeSkill']['name']
        else:
            values['activeSkill'] = None
        values['auxiliarySkills'] = self.skill.getAuxiliarySkills()
        values['passiveSkills'] = self.skill.getPassiveSkills()

        values['extraEffects'] = list(self.effect.getSkillEffects())
        values['extraEffects'].extend(self.effect.getCurrentEffects())
        values['extraEffects'].extend(self.effect.getInvisibleEffects())
        values['_instance_'] = self
        return values

    def _updateCommonValues(self, **argv):
        if len(argv) == 0:
            return self.getCommonValues()
        for k, v in argv.items():
            k, v

    def getProfessionNum(self, professionid, type1 = 1, type2 = 1):
        '''type1: 1：力量 2：灵巧  3：体质 '''
        '''type2: 1：攻击 2：闪避  3：体力  4：法力 '''
        '''professionid  职业id'''
        num = 0
        if type1 == 1:
            if professionid == 1 or professionid == 2 : #格斗与炼金
                num = 0.002
            elif professionid == 3 or professionid == 4: #忍者与杀手
                num = 0.001
            elif professionid == 5 or professionid == 6: #忍者与杀手
                num = 0.003
            elif professionid == 0: #没职业的
                num = 0.001
        elif type1 == 2:
            if type2 == 1:
                if professionid == 1 or professionid == 2 : #格斗与炼金
                    num = 0.002
                elif professionid == 3 or professionid == 4: #忍者与杀手
                    num = 0.003
                elif professionid == 5 or professionid == 6: #海盗与护卫
                    num = 0.001
                elif professionid == 0: #没职业的
                    num = 0.001
            elif type2 == 2:
                if professionid == 0: #没职业的
                    num = 0.001
                else:
                    num = 0.0012
        elif type1 == 3 :
            num = 0.01
        return num

class Monster(Character):

    TotalSeed = 100000.0

    def __init__(self, id, name = None):
        Character.__init__(self, id, name)
#        self.attribute = CharacterAttributeComponent(self)
#        self.battle = CharacterBattleComponent(self)
#        self.camp = CharacterCampComponent(self)
#        self.dropping = CharacterDroppingComponent(self)
#        self.effect = CharacterEffectComponent(self)
#        self.balloon = CharacterBalloonComponent(self)
#        self.level = CharacterLevelComponent(self)
#        self.skill = CharacterSkillComponent(self)
        data = loader.getById('npc', id, '*')
        if data:
            self.initialise(data)

    def initialise(self, data):
        levelgroup = data['levelGroup'].split(';')
        encounteroddgroup = data['encounterOddGroup'].split(';')
        dropitemidgroup = data['dropItemIdGroup'].split(';')
        levelQueue = []

        assert len(levelgroup) == len(encounteroddgroup) == len(dropitemidgroup)

        last_probability = 0
        for i in range(len(levelgroup)):
            levelMap = {}
            encounterodd_S = int(encounteroddgroup[i]) / self.TotalSeed
            levelMap["level"] = int(levelgroup[i])
            levelMap["dropItemId"] = int(dropitemidgroup[i])
            this_probability = 1 - last_probability
            probability = this_probability * encounterodd_S
            levelMap['probability'] = probability
            last_probability = last_probability + probability
            levelQueue.append(levelMap)

        monster_group_id = data['monsterGroupId']
        def RandomAssignment(queue):
            lst = []
            down = 0
            up = 0
            for item in queue:
                down = up
                up += item["probability"]
                assert up <= 1
                lst.append((item, down, up))
            import random
            randomnumber = random.random()
            for i in lst:
                if i[1] <= randomnumber < i[2]:
                    return i[0]
        element = RandomAssignment(levelQueue)
        monster_level = element['level']
        monster_dropitem_id = element['dropItemId']

        cursor = connection.cursor()
        cursor.execute("select * from `monster_instance` where groupId=%d and level=%d" % (monster_group_id, monster_level))
        monsters = cursor.fetchall()
        cursor.close()
        if(len(monsters) <= 0):
            raise Exception('没有找到怪物实例')
            return None
        monster_instance = monsters[0]
        self._details = _getCommonbaseValues()
        self._details['isCharacter'] = self.getType() == 1
        self._details['id'] = data['id']
        self._details['name'] = data['name']
        self._details['level'] = monster_level
        self._details['image'] = data['image']
        self._details['professionName'] = ''
        self._details['figure'] = monster_instance['figure']

        self._details['hp'] = int(monster_instance['hp'])
        self._details['mp'] = int(monster_instance['mp'])

        self._details['maxHp'] = int(monster_instance['hp'])
        self._details['maxMp'] = int(monster_instance['mp'])

        self._details['speed'] = int(monster_instance['speed'])
        #self._details['speedDesc'] = self._owner.attribute.getCurrSpeedDescription(self._details['speed'])
        self._details['maxAttack'] = int(monster_instance['maxAttack'])
        self._details['minAttack'] = int(monster_instance['minAttack'])
        self._details['defense'] = int(monster_instance['defense'])

        self._details['hitRate'] = monster_instance['hitRate']
        self._details['dodgeRate'] = monster_instance['dodgeRate']
        self._details['criRate'] = monster_instance['criRate']
        self._details['bogeyRate'] = monster_instance['bogeyRate']

        self._details['startBattleSentence'] = data['startBattleSentence']
        self._details['criSentence'] = data['criSentence']
        self._details['breSentence'] = data['breSentence']
        self._details['criAndBreSentence'] = data['criAndbreSentence']
        self._details['missSentence'] = data['missSentence']
        self._details['beMissedSentence'] = data['beMissedSentence']
        self._details['beCrackedSentence'] = data['beCrackedSentence']
        self._details['usingSkillSentence'] = data['usingSkillSentence']
        self._details['winSentence'] = data['winSentence']
        self._details['failSentence'] = data['failSentence']

        self._details['expBonus'] = monster_instance['expBonus']
        self._details['coinBonus'] = monster_instance['coinBonus']
        self._details['goldBonus'] = monster_instance['goldBonus']
        self._details['dropItemId'] = monster_dropitem_id
        self._details['_instance'] = self


        #self._base = values.copy()
        #-------------------------------------------------------------

#    def getBaseDetails(self):
#        return self._details.copy()

    def getBaseID(self):
        return self.baseInfo.id

    def getCommonValues(self):
        return self._details

    def getCommonValues_delta(self):
        return self.getCommonValues()

    def updateData(self, commit = False):
        if commit:
            pass
        else:
            pass

    def getType(self):
        return 3











