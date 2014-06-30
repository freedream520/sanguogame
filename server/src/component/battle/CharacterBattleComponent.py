#coding:utf8
'''
Created on 2010-4-11

@author: zhaoxionghui
'''

from component.Component import Component
from util.DataLoader import loader
from util import dbaccess, util

from net.MeleeSite import pushMessage

from twisted.internet import reactor
from twisted.python import log
import datetime
import random
import math

reactor = reactor

EFFECT_START_AT_ATTACKING = 1
EFFECT_START_AFTER_ATTACK = 2
EFFECT_START_BEFORE_ATTACK = 3
EFFECT_START_AFTER_ATTACKED = 4
EFFECT_START_AT_SECOND_START = 5
EFFECT_START_AT_SECOND_OVER = 6
EFFECT_START_AT_END_BATTLE = 7

def _getEffect(id):
    effect = loader.getById('effect', id, '*')
    if not effect:
        print "No Effect With ID %d in effect.csv" % id
        return None
    return effect

def respondAllProgressingEffects(fighter_owner, figther_enemy):
    return
    ''' 响应所有进行中效果  '''
    owner = fighter_owner
    opponent = figther_enemy
    for effect in owner['effects']:
        if (effect['isResponded'] and effect['isLoopRespond']):
            try:
                exec(effect['script'])
            except Exception, e:
                print e

def respondEffects(effecttype, fighter_owner, figther_enemy, timePos):
    ''' 响应效果  '''
    '''    
        effecttype: ( 效果响应方式)
                    1:从攻击回合开始时响应
                    2:从攻击回合结束时响应
                    3:从收到攻击前响应
                    4:从收到攻击后响应
                    5:从当前秒开始前响应
                    6:从当前秒结束后响应
                    7:从战斗结束领取奖励时响应     
    '''
    owner = fighter_owner
    opponent = figther_enemy
    hpmpdelta = []
#    base1 = owner.copy()
#    base2 = opponent.copy()
    for effect in fighter_owner['effects']:
        if effect['respondType'] == effecttype:
            if effecttype == EFFECT_START_AFTER_ATTACKED:
                effect['aidertime'] = effect['typeAiderTime']
            if ((not effect['isResponded']) or (effect['isLoopRespond'])):
                delta1 = owner.copy()
                delta2 = opponent.copy()
                try:
                    ownerHp = util.objectCopy(owner['hp'])
                    ownerMp = util.objectCopy(owner['mp'])
                    opponentHp = util.objectCopy(opponent['hp'])
                    opponentMp = util.objectCopy(opponent['mp'])

                    exec(effect['script'])

                    elm = {'time':timePos, 'defenser':figther_enemy['id'],
                           'ownerHpDelta':owner['hp'] - ownerHp, 'ownerMpDelta':owner['mp'] - ownerMp, \
                           'opponentHpDelta':opponent['hp'] - opponentHp, 'opponentMpDelta':opponent['mp'] - opponentMp}
                    hpmpdelta.append(elm)
                except Exception, e:
                    print e
                for k in owner.keys():
                    __typeK = type(owner[k])
                    if __typeK is int or __typeK is long or __typeK is float:
                        if k != 'id':
                            delta1[k] = owner[k] - delta1[k]
                for k in opponent.keys():
                    __typeK = type(opponent[k])
                    if __typeK is int or __typeK is long or __typeK is float:
                        if k != 'id':
                            delta2[k] = opponent[k] - delta2[k]
                effect['isResponded'] = True
                effect['delta'] = (delta1, delta2)
    return hpmpdelta

def updateCharacterAttr(myself, enemy, battleType, battleResult):
    def updateCharacter(body):
        if int(body['hp']) <= 0:
            status = 5# "死亡"
        else:
            status = 1#"正常"
        try:
            assert status == body['status']
        except Exception as e:
            log.msg(str(e))

        body['_instance_'].baseInfo.setStatus(status)

        gold = body['_instance_'].finance.getGold()
        coin = body['_instance_'].finance.getCoin()
        exp = body['_instance_'].level.getExp()

        if battleType == 1 or battleType == 2:
            if body['id'] in battleResult['winner']:
                if body['hp'] <= 0:
                    dbaccess.updatePlayerInfo(
                        int(body['id']),
                        {
                            'status':1,
                            'hp' : 1,
                            'mp' : body['mp'],
                            'gold' : gold + int(battleResult['goldBonus']),
                            'coin' : coin + int(battleResult['coinBonus']),
                            'exp':exp + battleResult['expBonus'],
                        }
                    )
                else:
                    dbaccess.updatePlayerInfo(
                        int(body['id']),
                        {
                            'status':status,
                            'hp' : body['hp'],
                            'mp' : body['mp'],
                            'gold' : gold + int(battleResult['goldBonus']),
                            'coin' : coin + int(battleResult['coinBonus']),
                            'exp':exp + battleResult['expBonus'],
                        }
                    )
            else:
                dbaccess.updatePlayerInfo(
                        int(body['id']),
                        {
                            'status':status,
                            'hp' : body['hp'],
                            'mp' : body['mp'],
                        }
                )

    if myself['isCharacter']:
        updateCharacter(myself)

    if enemy['isCharacter']:
        updateCharacter(enemy)

#if k == 'maxAttack' or\
#                        k == 'minAttack' or\
#                        k == 'hitRate' or\
#                        k == 'criRate' or\
#                        k == 'bogeyRate' or\
#                        k == 'dodgeRate' or\
#                        k == 'speed' or\
#                        k == 'count' or\
#                        k == 'hp' or\
#                        k == 'mp' :
class CharacterBattleComponent(Component):
    '''
    battle component for character
    '''

    __SAVEDATA2DB__ = True

    #1.战斗开始事件 2.战斗结束事件 3.攻击事件 4.主动技能事件 5.效果获得事件 6.效果消失事件 7.效果触发事件

    BATTLE_START = 1
    BATTLE_FINISH = 2
    BATTLE_ATTACK = 3
    BATTLE_ACTIVESKILL = 4
    BATTLE_GETEFFECT = 5
    BATTLE_LOSEEFFECT = 6
    BATTLE_EFFECTSTART = 7

    def __init__(self, owner):
        '''
        Constructor
        '''
        Component.__init__(self, owner)
        self.fighter_owner = None
        self.fighter_enemy = None
        self.skillDelta = None

    def getPkStatus(self, pkStatusCode):
        '''得到pk状态'''
        if(pkStatusCode == 0):
            return '和平'
        elif(pkStatusCode == 1):
            return '杀戮'
        else:
            return '和平'

    def initBattleInfo(self, enemy, battleType, timeLimit = 360):
        '''battleType 1,野外战斗；2，副本战斗；3，决斗'''
        self.fighter_owner = self._owner.getCommonValues_delta()
        self.fighter_enemy = enemy.getCommonValues_delta()

        if self.__SAVEDATA2DB__:
            pass

        if battleType == 1 or battleType == 2:
            if battleType == 1:
                self._owner.attribute.setEnergy(self._owner.attribute.getEnergy() - 1)
            dbaccess.updatePlayerInfo(self._owner.baseInfo.id, {'status':4, 'energy':self._owner.attribute.getEnergy()})
            #dbaccess.updatePlayerInfo(self._owner.baseInfo.id, {'energy':self._owner.attribute.getEnergy()})
            self._owner.baseInfo.setStatus(4)

        #当决斗时，双方皆从满血满魔状态开始
        if battleType == 3:
            self.fighter_enemy["hp"] = self.fighter_enemy["maxHp"]
            self.fighter_owner["hp"] = self.fighter_owner["maxHp"]
            self.fighter_enemy["mp"] = self.fighter_enemy["maxMp"]
            self.fighter_owner["mp"] = self.fighter_owner["maxMp"]
        #计算等级差
        level_diffence = self.fighter_owner["level"] - self.fighter_enemy["level"]
        flag = 1
        delta = 0
        if level_diffence < 0:
            flag = -1
            level_diffence = -level_diffence
        if level_diffence == 0:
            delta = 0
        elif level_diffence <= 1:
            delta = -0.1
        elif level_diffence <= 5:
            delta = -0.2
        elif level_diffence <= 10:
            delta = -0.3
        elif level_diffence <= 16:
            delta = -0.4
        elif level_diffence <= 25:
            delta = -0.5
        else:
            delta = -0.6
        #设定根据等级差带来的影响，这里只影响攻击力和防御力
        if flag > 0:
            self.fighter_enemy["defense"] *= 1 + delta
            self.fighter_enemy["maxAttack"] *= 1 + delta
            self.fighter_enemy["minAttack"] *= 1 + delta
        else:
            self.fighter_owner["defense"] *= 1 + delta
            self.fighter_owner["maxAttack"] *= 1 + delta
            self.fighter_owner["minAttack"] *= 1 + delta

        #增加角色附加记录
        def addExtraProperties(body):
            body['lastAttackTime'] = 0
            body['status'] = 4
            #body['activeSkill'] = None
            body['effects'] = []
            body['damage'] = 0
            body['attackStatus'] = [0]
            body['attackSentence'] = body['startBattleSentence']
            body['skillName'] = ''
            body['_lastfight_first'] = False
            body['_win_battle_'] = False

        addExtraProperties(self.fighter_enemy)
        addExtraProperties(self.fighter_owner)

        eventList = []
        fighter = self.fighter_owner.copy()
        fighter['name'] = self.fighter_owner['_instance_'].baseInfo.getNickName()
        eventList.append([0, CharacterBattleComponent.BATTLE_START, -1, [[fighter], [self.fighter_enemy.copy()], str(datetime.datetime.now())]])
        for k in self.fighter_owner["extraEffects"]:
            effect = _getEffect(k[2])
            if effect:
                c1, c2 = self.getEffect(self.fighter_owner, effect)
                eventList.append(c1)
                eventList.append(c2)
        for k in self.fighter_enemy["extraEffects"]:
            effect = _getEffect(k[2])
            if effect:
                c1, c2 = self.getEffect(self.fighter_enemy, effect)
                eventList.append(c1)
                eventList.append(c2)

        return eventList

    @staticmethod
    def getEffect(player, effect, effectTime = 0, skillid = -1):
        content1 = []
        content2 = []
        if effect:
            effect['skillid'] = skillid
            #effect['partyid'] = skillid['id']
            #effect['partyname'] = skillid['baseValues']['name']
            effect['time'] = effectTime
            effect['isResponded'] = False
            effect['typeAiderTime'] = effect['aidertime']
            player['effects'].append(effect)
            ownerGetFx = effect['ownerGetFx'].split(';')
            ownerGetFxDelay = effect['ownerGetFxDelay'].split(';')
            opponentGetFx = effect['opponentGetFx'].split(';')
            opponentGetFxDelay = effect['opponentGetFxDelay'].split(';')
            content1.append({'owner':int(player['id']), 'ownerGetFx':ownerGetFx, 'opponentGetFx':opponentGetFx,
                             'ownerGetFxDelay':ownerGetFxDelay, 'opponentGetFxDelay':opponentGetFxDelay})

            ownerRunFx = effect['ownerRunFx'].split(';')
            ownerRunFxDelay = effect['ownerRunFxDelay'].split(';')
            opponentRunFx = effect['opponentRunFx'].split(';')
            opponentRunFxDelay = effect['opponentRunFxDelay'].split(';')
            content2.append({'owner':int(player['id']), 'ownerRunFx':ownerRunFx, 'ownerRunFxDelay':ownerRunFxDelay,
                             'opponentRunFx':opponentRunFx, 'opponentRunFxDelay':opponentRunFxDelay})
        return  [effectTime, CharacterBattleComponent.BATTLE_GETEFFECT, int(player['id']), content1], \
                [effectTime, CharacterBattleComponent.BATTLE_EFFECTSTART, int(player['id']), content2]

    @staticmethod
    def loseEffect(body, defenser, timePos):
        ''' 刷新技能列表,增加技能效果消失事件 '''
        removeEffects = []

        for effect in body['effects']:
            if effect['type'] == 1:
                if ((effect['timeDuration'] < 0) and (effect['boutDuration'] < 0)) or effect['isResponded']:
                    removeEffects.append(effect)
            if effect['disPlayMode'] == 2:
                if ((effect['aidertime'] < 0) and (effect['boutDuration'] < 0)):
                    effect['isResponded'] = False
                    effect['aidertime'] = effect['typeAiderTime']

        ret = []
        for effect in removeEffects:
            body['effects'].remove(effect)
#            self.saveEffectProcess( effect, True )
#            body['activeSkill'] = None
            content = []
            ownerLoseFx = effect['ownerLoseFx'].split(';')
            ownerLoseFxDelay = effect['ownerLoseFxDelay'].split(';')
            opponentLoseFx = effect['opponentLoseFx'].split(';')
            opponentLoseFxDelay = effect['opponentLoseFxDelay'].split(';')
            content.append({'owner':int(body['id']), 'ownerLoseFx':ownerLoseFx, 'ownerLoseFxDelay':ownerLoseFxDelay, \
                            'opponentLoseFx':opponentLoseFx, 'opponentLoseFxDelay':opponentLoseFxDelay})
            ret.append([timePos, CharacterBattleComponent.BATTLE_LOSEEFFECT, int(body['id']), content])
            if effect.has_key('delta'):
                selfdelta = effect['delta'][0]
                defenserd = effect['delta'][1]
                if selfdelta['id'] == body['id'] and defenserd['id'] == defenser['id']:
                    for k in selfdelta.keys():
                        __type = type(selfdelta[k])
                        if __type is int or __type is long or __type is float:
                            if k != 'id':
                                body[k] = body[k] - selfdelta[k]
                    for k in defenserd.keys():
                        __type = type(defenserd[k])
                        if __type is int or __type is long or __type is float:
                            if k != 'id':
                                defenser[k] = defenser[k] - defenserd[k]
                else:
                    log.msg("Error, delta ID is Not assign body's id")
            #print timePos, body['id'], body['isCharacter']
        return ret

    def goFight(self, second):
        owner_attacktime = int (self.fighter_owner['lastAttackTime'] + self.fighter_owner['speed'])
        enemy_attacktime = int (self.fighter_enemy['lastAttackTime'] + self.fighter_enemy['speed'])

        attacker, defenser = None, None
        retEvent = []
        retDelta = []

        def canProcessSkill(attacker):
            skill = attacker['activeSkill']
            if not skill:
                return False
            weapon = skill['weapon']
            charweapon = self._owner.pack.getWeaponType()
            if charweapon == None:
                return False
            if weapon != charweapon:
                return False
            r = random.randint(0, 100000)
            if r > skill['useRate'] :
                return False
            if attacker['mp'] < skill['useMp']:
                return False
#            skillProgressList[ self.duration ] = 1

            skillswf = repr(skill['name'])
            skillswf = skillswf[2:-1]
            attacker['skillName'] = skillswf.replace("\\", "")

            return True

        def attack(attacker, defenser, attackTimePos, rec = False):
            resultEvent = []
            resultDelta = []
            attacker["lastAttackTime"] = attackTimePos
            attacker["_lastfight_first"] = True
            defenser["_lastfight_first"] = False
            #=========================================
            damageType = 0
            damage = 0
            attacker['attackStatus'] = [0]
            attacker['attackSentence'] = u''
            defenser['attackStatus'] = [0]
            defenser['attackSentence'] = u''
            if canProcessSkill(attacker):
                ''' 进行一次技能  '''
                '''增加技能'''
                skill = attacker['activeSkill']
                if skill['useMp'] > 0:
                    attacker['mp'] = attacker['mp'] - skill['useMp']
                skillinfo = {'id' : skill['id'], 'name' : skill['name'], 'time' : attackTimePos,
                             'partyName' : attacker['name'], 'effectId'  : skill['addEffect'].split(';'), }
                '''增加技能获得事件'''
                usingSkillSentence = util.replaceWords('技', skill['name'], attacker['usingSkillSentence'])
                content = {'deltaMp':skill['useMp'],
                           'usingSkillSentence': usingSkillSentence,
#                           'party1Hp':int(self.fighter_owner['hp']), #
#                           'party1Mp':int(self.fighter_owner['mp']), #
#                           'party2Hp':int(self.fighter_enemy['hp']), #
#                           'party2Mp':int(self.fighter_enemy['mp']), #
                           }
                resultEvent.append([attackTimePos, CharacterBattleComponent.BATTLE_ACTIVESKILL, int(attacker['id']), content])
                '''增加技能效果获得、触发事件'''
                for effectId in skillinfo['effectId']:
                    effect = _getEffect(effectId)
                    if effect:
                        c1, c2 = CharacterBattleComponent.getEffect(attacker, effect, attackTimePos, skillinfo['id'])
                        resultEvent.append(c1)
                        resultEvent.append(c2)
                resultDelta += respondEffects(EFFECT_START_AT_ATTACKING, attacker, defenser, attackTimePos)
            hitRate = (95 + attacker['hitRate'] - defenser['dodgeRate'])
            r = random.uniform(0, 100)
            if r <= hitRate:
#                基础伤害
                damage = random.uniform(float(attacker['minAttack']), float(attacker['maxAttack']))
                damageType = 0
                #暴击伤害
                r = random.uniform(0, 100)
                if r <= attacker['criRate']:
                    damage = damage * 1.5
                    attacker['attackSentence'] = attacker['criSentence']
                    defenser['attackSentence'] = defenser['beCrackedSentence']
                    damageType = 1
                #破防伤害
                r = random.uniform(0, 100)
                if r <= attacker['bogeyRate']:
                    if damageType == 1 :
                        #破防加暴击
                        attacker['attackSentence'] = attacker['criAndBreSentence']
                        defenser['attackSentence'] = defenser['beCrackedSentence']
                        damageType = 3
                    else:
                        #破防
                        attacker['attackSentence'] = attacker['breSentence']
                        defenser['attackSentence'] = defenser['beCrackedSentence']
                        damageType = 2
                else:
                    #没破防
                    damage = damage - float(defenser['defense']) * 0.000215
            else:
                #为命中
                damage = 0

            if damage == 0:
                attacker['attackSentence'] = attacker['missSentence']
                defenser['attackSentence'] = defenser['beMissedSentence']
            if damage < 0:
                damage = 0

            #------------------------------------------------------------------
            if damage != 0:
                damage *= attacker['damagePercent']
                damage += attacker['abs_damage']
            attacker['damage'] = damage
            defenser['damage'] = damage
            if damage > 0:
                self.isdamage = True
                resultDelta += respondEffects(EFFECT_START_BEFORE_ATTACK, attacker , defenser, second)
            else:
                self.isdamage = False
            damage = int(defenser['damage'])

            attacker["hp"] = attacker["hp"]
            defenser["hp"] = defenser["hp"] - damage
            if defenser["hp"] < 0:
                defenser["hp"] = 0
            if self.isdamage:
                resultDelta += respondEffects(EFFECT_START_AFTER_ATTACKED, attacker , defenser, second)
                resultDelta += respondEffects(EFFECT_START_AFTER_ATTACKED, defenser, attacker, second)
            if rec:
                return resultEvent, resultDelta
            for attackCounts in range(0, int(attacker['counts'])):
                r1, r2 = attack(attacker, defenser, attackTimePos, True)
                resultEvent += r1
                resultDelta += r2
            attacker['counts'] = 0
            '''事件'''
            resultDelta += respondEffects(EFFECT_START_AFTER_ATTACK, attacker, defenser, second)
            for effect in attacker['effects']:
                effect['boutDuration'] = effect['boutDuration'] - 1
            for effect in defenser['effects']:
                effect['boutDuration'] = effect['boutDuration'] - 1

            '''保存攻击事件记录'''
            content = {'attack':attacker['attackSentence'],
                       'defense':defenser['attackSentence'],
                       'party1Hp':int(self.fighter_owner['hp']),
                       'party1Mp':int(self.fighter_owner['mp']),
                       'party2Hp':int(self.fighter_enemy['hp']),
                       'party2Mp':int(self.fighter_enemy['mp']),
                       'damageType':damageType,
                       }
            battleEvent = [attackTimePos, CharacterBattleComponent.BATTLE_ATTACK, attacker['id'], content]
            resultEvent.append(battleEvent)
            return resultEvent, resultDelta

        def checkState(attacker, defenser):
            if attacker["hp"] <= 0 or defenser["hp"] <= 0:
                return True
            return False

        if owner_attacktime <= second < enemy_attacktime:
            attacker, defenser = self.fighter_owner, self.fighter_enemy
            r1, r2 = attack(attacker, defenser, second)
            retEvent += r1
            retDelta += r2
        elif  enemy_attacktime <= second < owner_attacktime:
            attacker, defenser = self.fighter_enemy, self.fighter_owner
            r1, r2 = attack(attacker, defenser, second)
            retEvent += r1
            retDelta += r2
        else:
            if owner_attacktime == enemy_attacktime <= second :
                if self.fighter_enemy["_lastfight_first"] and not self.fighter_owner["_lastfight_first"]:
                    attacker, defenser = self.fighter_owner, self.fighter_enemy
                else:
                    attacker, defenser = self.fighter_enemy, self.fighter_owner
                r1, r2 = attack(attacker, defenser, second)
                bool = checkState(attacker, defenser)
                retEvent += r1
                retDelta += r2
                if bool:
                    return retEvent, retDelta
                r1, r2 = attack(defenser, attacker, second)
                bool = checkState(defenser, attacker)
                retEvent += r1
                retDelta += r2
        return retEvent, retDelta

    def battleStep(self, second):
        isBattleFinished = False
        stepResult = []
        hpmpdelta = []

        if not self.fighter_enemy["hp"] > 0 and self.fighter_owner["hp"] > 0:
            return stepResult, hpmpdelta, True

        stepResult += self.loseEffect(self.fighter_owner, self.fighter_enemy, second)
        stepResult += self.loseEffect(self.fighter_enemy, self.fighter_owner, second)

        respondAllProgressingEffects(self.fighter_owner, self.fighter_enemy)
        respondAllProgressingEffects(self.fighter_enemy, self.fighter_owner)

        if self.isdamage:
            hpmpdelta += respondEffects(EFFECT_START_AT_SECOND_START, self.fighter_owner, self.fighter_enemy, second)
            hpmpdelta += respondEffects(EFFECT_START_AT_SECOND_START, self.fighter_enemy, self.fighter_owner, second)
            self.isdamage = False

        r1, r2 = self.goFight(second)

        stepResult += r1
        hpmpdelta += r2

        hpmpdelta += respondEffects(EFFECT_START_AT_SECOND_OVER, self.fighter_owner, self.fighter_enemy, second)
        hpmpdelta += respondEffects(EFFECT_START_AT_SECOND_OVER, self.fighter_enemy, self.fighter_owner, second)

        for effect in self.fighter_enemy['effects']:
            if effect['disPlayMode'] == 2:
                effect['aidertime'] = effect['aidertime'] - 1000
            else:
                effect['timeDuration'] = effect['timeDuration'] - 1000

        for effect in self.fighter_owner['effects']:
            if effect['disPlayMode'] == 2:
                effect['aidertime'] = effect['aidertime'] - 1000
            else:
                effect['timeDuration'] = effect['timeDuration'] - 1000

        self.fighter_enemy['damage'] = 0
        self.fighter_owner['damage'] = 0

        if self.fighter_enemy["hp"] <= 0 or self.fighter_owner["hp"] <= 0:
            isBattleFinished = True

        return stepResult, hpmpdelta, isBattleFinished

    def fightTo(self, enemyNPC, battleType = 1, timeLimit = 360):
        self.isdamage = False
        result = self.initBattleInfo(enemyNPC, battleType)
        HPMPDelta = []
        overTime = 0
        for second in range(timeLimit):
            stepResult, hpmpdelta, isBattleFinished = self.battleStep(second)
            result += stepResult
            HPMPDelta += hpmpdelta
            if isBattleFinished:
                overTime = second
                break
        ''' 计算战果    '''
        battleResult = {}
        if isBattleFinished is False:
            battleResult['winner'] = [int(self.fighter_enemy["id"])]
            battleResult['loser'] = [int(self.fighter_owner["id"])]
            self.fighter_owner['status'] = 1
            self.fighter_enemy['status'] = 1
            self.fighter_enemy['_win_battle_'] = True
            overTime = timeLimit
        else:
            if int(self.fighter_enemy['hp']) <= 0:
                battleResult['winner'] = [int(self.fighter_owner["id"])]
                battleResult['loser'] = [int(self.fighter_enemy["id"])]
                self.fighter_enemy['status'] = 5
                self.fighter_owner['status'] = 1
                self.fighter_owner['_win_battle_'] = True
            else:
                battleResult['winner'] = [int(self.fighter_enemy["id"])]
                battleResult['loser'] = [int(self.fighter_owner["id"])]
                self.fighter_owner['status'] = 5
                self.fighter_enemy['status'] = 1
                self.fighter_enemy['_win_battle_'] = True

        if self.fighter_owner['id'] in battleResult['winner']:
            respondEffects(EFFECT_START_AT_END_BATTLE, self.fighter_owner, self.fighter_enemy, overTime)
        else:
            respondEffects(EFFECT_START_AT_END_BATTLE, self.fighter_enemy, self.fighter_owner, overTime)

        if self.fighter_owner['id'] in battleResult['winner']:
            self.fighter_owner['exp'] = self.fighter_owner['exp'] + int(self.fighter_enemy['expBonus'])
            battleResult['scoreBonus'] = self.fighter_enemy['scoreBonus']
            battleResult['expBonus'] = int(self.fighter_enemy['expBonus'] * self._owner.level.getTwiceExp())
            battleResult['coinBonus'] = self.fighter_enemy['coinBonus']
            battleResult['goldBonus'] = self.fighter_enemy['goldBonus']
        else:
            self.fighter_enemy['exp'] = self.fighter_enemy['exp'] + int(self.fighter_owner['expBonus'])
            battleResult['scoreBonus'] = self.fighter_owner['scoreBonus']
            battleResult['expBonus'] = int(self.fighter_owner['expBonus'] * self._owner.level.getTwiceExp())
            battleResult['coinBonus'] = self.fighter_owner['coinBonus']
            battleResult['goldBonus'] = self.fighter_owner['goldBonus']

        itemBonuses = []
        if battleResult['loser'][0] == self.fighter_enemy['id']:
            #更新当前任务目标进度(收集、杀怪),增加任务目标物品
            questItem = self._owner.quest.onSuccessKillOneMonster(int(self.fighter_enemy['id']))
            if questItem:
                itemTemplate = loader.getById('item_template', questItem[2], '*')
                bonusItem = {'itemName':itemTemplate['name'], 'amount':1, 'partyId':self.fighter_owner["id"]}
                itemBonuses.append(bonusItem)
            #增加战斗掉落物品
            self._owner.pack.setTempPackage()
#            ret = self._owner.pack._tempPackage.isTempPackageFull()
#            if not ret[0]:
            ret = self._owner.dropping.getItemByDropping(self.fighter_enemy["dropItemId"])
            if ret is not None:
                item = ret[0]
                if item:
                    itemTemplate = ret[1]
                    self._owner.pack.putOneItemIntoTempPackage(item)
                    pushMessage(str(self._owner.baseInfo.id), 'newTempPackage')
                    bonusItem = {'itemName':itemTemplate['name'], 'amount':1, 'partyId':self.fighter_owner['id']}
                    itemBonuses.append(bonusItem)
        battleResult['itemBonuses'] = itemBonuses

        '''保存战斗结束事件记录'''#如果有组队时，给每个加id
        content = [{'id':self.fighter_owner['id'], 'battleResult':battleResult}]
        result.append([overTime, CharacterBattleComponent.BATTLE_FINISH, -1, content])

        reactor.callLater(
            math.ceil(overTime / 3),
            updateCharacterAttr,
            self.fighter_owner.copy(),
            self.fighter_enemy.copy(),
            battleType,
            battleResult,
        )

        data = {}
        data['battleType'] = battleType
        data['maxTime'] = timeLimit
        data['timeLimit'] = timeLimit
        data['battleEventProcessList'] = result
        data['MPHPDelta'] = HPMPDelta#记录每秒玩家双方hp/mp增量
        data['overTime'] = overTime
        data['winner'] = self.fighter_owner['_win_battle_'] and self.fighter_owner["id"] or self.fighter_enemy["id"]

        data_bak = data.copy()
        data_bak['owner_status'] = {'fighter':self.fighter_owner.copy(), 'enemy':self.fighter_enemy.copy(), 'battleType':battleType, 'battleResult':battleResult.copy()}

        if self.__SAVEDATA2DB__:
            reactor.callLater(0, dbaccess.saveBattleRecord, self._owner.baseInfo.id, data_bak)
        self.fighter_owner = None
        self.fighter_enemy = None

        return data

    def getResultDataForClient(self):
        result = dbaccess.getLastBattleRecord(self._owner.baseInfo.id)
        if result is None:
            dbaccess.updatePlayerInfo(self._owner.baseInfo.id, {'status':1, 'hp':1})
            return None
        data_bak = util.parsePickleStrToObject(result[2])
        data = data_bak.copy()
        del data['owner_status']
        user_data = data_bak['owner_status']
        battleTime = datetime.datetime.strptime(data['battleEventProcessList'][0][3][2], '%Y-%m-%d %H:%M:%S.%f')
        now = datetime.datetime.now()
        d = now - battleTime
        if d.days >= 1 or d.seconds >= data['overTime']:
            updateCharacterAttr(user_data['fighter'], user_data['enemy'], user_data['battleType'], user_data['battleResult'])
            return None

        delta = d.seconds
#        split data
#        bepl = data['battleEventProcessList']
#        index = 0
#        content = None
#        set = False
#        for i in range(len(bepl)):
#            if bepl[i][0] > delta and bepl[i][1] == CharacterBattleComponent.BATTLE_ATTACK:
#                index = i
#                set = True
#        if set and index != 0:
#            content = bepl[index][3]
#            first = bepl[0]
#            end = bepl[index:-1]
#            #[0, CharacterBattleComponent.BATTLE_START, -1, [[fighter], [self.fighter_enemy.copy()], str(datetime.datetime.now())]
#            first[3][0][0]['hp'] = content['party1Hp']
#            first[3][1][0]['hp'] = content['party2Hp']
#            first[3][0][0]['mp'] = content['party1Mp']
#            first[3][1][0]['mp'] = content['party2Mp']
#            data['battleEventProcessList'] = first + end
        data['maxTime'] -= delta * 3
        return data

    def getResultDataForClient2(self):
        '''返回给客户端当前开始时刻后的战斗数据'''
        data = {}

        battleRecord = dbaccess.getPlayerLastBattleRecord(self._owner.baseInfo.id)
        battelEventList = dbaccess.getBattleEventsByRecord(battleRecord[0])
        battleTime = battleRecord[1]
        now = datetime.datetime.now()
        delta = now.minute * 60 + now.second - (battleTime.minute * 60 + battleTime.second)
        data['battleEventProcessList'] = []
        for i in range(len(battelEventList) - 1):
            if delta * 3 <= battelEventList[i][0]:
                data['battleEventProcessList'] = list(battelEventList[i:])
                data['battleEventProcessList'].insert(0, battelEventList[0])
                break
        eventList = []
        flag = False
        for i in range(0, len(data['battleEventProcessList'])):
            event = list(data['battleEventProcessList'][i])
            event[0] = int(event[0])
            event[1] = int(event[1])
            event[2] = int(event[2])
            event[3] = util.parsePickleStrToObject(event[3])
            eventList.append(event)
            while(True):
                if flag:
                    break
                if type(event[3]) <> type({}):
                    break
                if event[3].has_key('party1Hp'):
                    firstEvent = list(eventList[0])
                    firstEvent[3][0][0]['hp'] = int(event[3]['party1Hp'])
                    firstEvent[3][0][0]['mp'] = int(event[3]['party1Mp'])
                    firstEvent[3][1][0]['hp'] = int(event[3]['party2Hp'])
                    firstEvent[3][1][0]['mp'] = int(event[3]['party2Mp'])
                    flag = True
                    break
                else:
                    pass
        data['battleEventProcessList'] = eventList

        #        HPMPDeltaList = []
        #        for i in range(0,len(HPMPDeltaList)):
        #            if delta<= self.HPMPDeltaList[i]['time']:
        #                data['MPHPDelta'] = HPMPDeltaList[i:]
        #                break
        data['battleType'] = battleRecord[3]
        if self._owner.team.isTeamMember():
            data['maxTime'] = 1800 - delta * 3
            data['timeLimit'] = 1800
        else:
            data['maxTime'] = 360 - delta * 3
            data['timeLimit'] = 360

        return data
