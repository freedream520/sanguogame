/*
Navicat MySQL Data Transfer
Source Host     : 192.168.1.17:3306
Source Database : melee
Target Host     : 192.168.1.17:3306
Target Database : melee
Date: 2010-05-11 17:28:46
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for active_reward_quest
-- ----------------------------
DROP TABLE IF EXISTS `active_reward_quest`;
CREATE TABLE `active_reward_quest` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) NOT NULL COMMENT '玩家id',
  `questTemplateId` int(11) NOT NULL COMMENT '任务模版id',
  `isFinish` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否完成',
  `createTime` datetime NOT NULL COMMENT '开始时间',
  `isLock` tinyint(4) DEFAULT '0' COMMENT '是否锁定',
  `sequence` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of active_reward_quest
-- ----------------------------

-- ----------------------------
-- Table structure for balloon
-- ----------------------------
DROP TABLE IF EXISTS `balloon`;
CREATE TABLE `balloon` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `startBattleSentence` varchar(255) NOT NULL DEFAULT 'b=1;c=#F15F59 f=10;我我我;',
  `criSentence` varchar(255) NOT NULL DEFAULT 'b=1;c=#F15F59 f=10;这拳够你受的;',
  `breSentence` varchar(255) NOT NULL DEFAULT 'b=1;c=#F15F59 f=10;这下够你受的！;',
  `criAndbreSentence` varchar(255) NOT NULL DEFAULT 'b=1;c=#F15F59 f=10;这拳够你受的！;',
  `missSentence` varchar(255) NOT NULL DEFAULT 'b=1;c=#F15F59 f=10;才不会被你打中。;',
  `beMissedSentence` varchar(255) NOT NULL DEFAULT 'b=1;c=#F15F59 f=10;竟然被闪开了。;',
  `beCrackedSentence` varchar(255) NOT NULL DEFAULT 'b=1;c=#F15F59 f=10;好疼！;',
  `usingSkillSentence` varchar(255) NOT NULL DEFAULT 'b=1;c=#F15F59 f=10;[技]！;',
  `WinSentence` varchar(255) NOT NULL DEFAULT 'b=1;c=#F15F59 f=10;我是要成为王的男人。;',
  `failSentence` varchar(255) NOT NULL DEFAULT 'b=1;c=#F15F59 f=10;不能在这倒下...;',
  `characterId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of balloon
-- ----------------------------
INSERT INTO `balloon` VALUES ('4', 'b=111;c=#000000 f=16;一决高下吧！', 'b=611;c=#fc2603 f=18;受死吧！', 'b=611;c=#fc2603 f=18;拿命来！', 'b=611;c=#fc2603 f=16;结束了！', 'b=511;c=#000000 f=18;怎么会这样！', 'b=111;c=#000000 f=16;你这是白费力气！', 'b=311;c=#ca0ae6 f=16;这点伤不算什么。', 'b=611;c=#000000 f=18;[技]！', 'b=611;c=#F15F59 f=14;胜利是属于我的。', 'b=611;c=#F15F59 f=14;大业未成，我还不能死...', null);
INSERT INTO `balloon` VALUES ('5', 'b=111;c=#000000 f=16;特来与你一战。', 'b=611;c=#fc2603 f=18;直取要害！', 'b=611;c=#fc2603 f=18;叫你防不胜防！', 'b=611;c=#fc2603 f=16;趁早束手就擒吧！', 'b=511;c=#000000 f=18;我竟然会失手吗？', 'b=111;c=#000000 f=16;没用的~', 'b=311;c=#ca0ae6 f=16;槽糕...', 'b=611;c=#000000 f=18;[技]！', 'b=611;c=#F15F59 f=14;胜负已分。', 'b=611;c=#F15F59 f=14;我一定会卷土重来的。', null);
INSERT INTO `balloon` VALUES ('6', 'b=111;c=#000000 f=16;没办法，就与你一战。', 'b=611;c=#fc2603 f=18;不出所料！', 'b=611;c=#fc2603 f=18;哈哈哈哈！', 'b=611;c=#fc2603 f=16;就以这击定胜负。', 'b=511;c=#000000 f=14;失策了......', 'b=111;c=#000000 f=14;趁早放弃吧。', 'b=311;c=#ca0ae6 f=14;必须重新安排策略...', 'b=611;c=#000000 f=18;看我的[技]吧！', 'b=611;c=#F15F59 f=14;这个胜利早已在计划之中。', 'b=611;c=#F15F59 f=14;暂且撤退吧...', null);
INSERT INTO `balloon` VALUES ('20', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '1');
INSERT INTO `balloon` VALUES ('21', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '2');
INSERT INTO `balloon` VALUES ('22', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '3');
INSERT INTO `balloon` VALUES ('23', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '4');
INSERT INTO `balloon` VALUES ('24', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '5');
INSERT INTO `balloon` VALUES ('25', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '6');
INSERT INTO `balloon` VALUES ('26', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '7');
INSERT INTO `balloon` VALUES ('27', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '8');
INSERT INTO `balloon` VALUES ('28', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '9');
INSERT INTO `balloon` VALUES ('29', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '10');
INSERT INTO `balloon` VALUES ('30', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '11');
INSERT INTO `balloon` VALUES ('31', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '12');
INSERT INTO `balloon` VALUES ('32', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '13');
INSERT INTO `balloon` VALUES ('33', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '14');
INSERT INTO `balloon` VALUES ('34', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '15');
INSERT INTO `balloon` VALUES ('35', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '16');
INSERT INTO `balloon` VALUES ('36', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '17');
INSERT INTO `balloon` VALUES ('37', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '18');
INSERT INTO `balloon` VALUES ('38', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '19');
INSERT INTO `balloon` VALUES ('39', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '20');
INSERT INTO `balloon` VALUES ('40', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '21');
INSERT INTO `balloon` VALUES ('41', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '22');
INSERT INTO `balloon` VALUES ('42', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '23');
INSERT INTO `balloon` VALUES ('43', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '24');
INSERT INTO `balloon` VALUES ('44', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '25');
INSERT INTO `balloon` VALUES ('45', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '26');
INSERT INTO `balloon` VALUES ('46', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '27');
INSERT INTO `balloon` VALUES ('47', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '28');
INSERT INTO `balloon` VALUES ('48', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '29');
INSERT INTO `balloon` VALUES ('49', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '30');
INSERT INTO `balloon` VALUES ('50', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '31');
INSERT INTO `balloon` VALUES ('51', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '32');
INSERT INTO `balloon` VALUES ('52', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '33');
INSERT INTO `balloon` VALUES ('53', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '34');
INSERT INTO `balloon` VALUES ('54', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '35');
INSERT INTO `balloon` VALUES ('55', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '36');
INSERT INTO `balloon` VALUES ('56', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '37');
INSERT INTO `balloon` VALUES ('57', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '38');
INSERT INTO `balloon` VALUES ('58', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '39');
INSERT INTO `balloon` VALUES ('59', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '40');
INSERT INTO `balloon` VALUES ('60', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '41');
INSERT INTO `balloon` VALUES ('61', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '42');
INSERT INTO `balloon` VALUES ('62', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '43');
INSERT INTO `balloon` VALUES ('63', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '44');
INSERT INTO `balloon` VALUES ('64', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '45');
INSERT INTO `balloon` VALUES ('65', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '46');
INSERT INTO `balloon` VALUES ('66', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '47');
INSERT INTO `balloon` VALUES ('67', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '48');
INSERT INTO `balloon` VALUES ('68', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '49');
INSERT INTO `balloon` VALUES ('69', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '50');
INSERT INTO `balloon` VALUES ('70', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '51');
INSERT INTO `balloon` VALUES ('71', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '52');
INSERT INTO `balloon` VALUES ('72', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '53');
INSERT INTO `balloon` VALUES ('73', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '54');
INSERT INTO `balloon` VALUES ('74', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '55');
INSERT INTO `balloon` VALUES ('75', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '56');
INSERT INTO `balloon` VALUES ('76', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '57');
INSERT INTO `balloon` VALUES ('77', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '58');
INSERT INTO `balloon` VALUES ('78', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '59');
INSERT INTO `balloon` VALUES ('79', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '60');
INSERT INTO `balloon` VALUES ('80', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '61');
INSERT INTO `balloon` VALUES ('81', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '62');
INSERT INTO `balloon` VALUES ('82', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '63');
INSERT INTO `balloon` VALUES ('83', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '64');
INSERT INTO `balloon` VALUES ('84', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '65');
INSERT INTO `balloon` VALUES ('85', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '66');
INSERT INTO `balloon` VALUES ('86', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '67');
INSERT INTO `balloon` VALUES ('87', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '68');
INSERT INTO `balloon` VALUES ('88', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '69');
INSERT INTO `balloon` VALUES ('89', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '70');
INSERT INTO `balloon` VALUES ('90', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '71');
INSERT INTO `balloon` VALUES ('91', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '72');
INSERT INTO `balloon` VALUES ('92', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '73');
INSERT INTO `balloon` VALUES ('93', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '74');
INSERT INTO `balloon` VALUES ('94', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '75');
INSERT INTO `balloon` VALUES ('95', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '76');
INSERT INTO `balloon` VALUES ('96', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '77');
INSERT INTO `balloon` VALUES ('97', 'b=1;c=#F15F59 f=10;我我我;', 'b=1;c=#F15F59 f=10;这拳够你受的;', 'b=1;c=#F15F59 f=10;这下够你受的！;', 'b=1;c=#F15F59 f=10;这拳够你受的！;', 'b=1;c=#F15F59 f=10;才不会被你打中。;', 'b=1;c=#F15F59 f=10;竟然被闪开了。;', 'b=1;c=#F15F59 f=10;好疼！;', 'b=1;c=#F15F59 f=10;[技]！;', 'b=1;c=#F15F59 f=10;我是要成为王的男人。;', 'b=1;c=#F15F59 f=10;不能在这倒下...;', '78');

-- ----------------------------
-- Table structure for battle_event
-- ----------------------------
DROP TABLE IF EXISTS `battle_event`;
CREATE TABLE `battle_event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `battleRecord` int(11) NOT NULL,
  `second` int(11) NOT NULL DEFAULT '0' COMMENT '当前秒数',
  `type` int(11) NOT NULL DEFAULT '1' COMMENT '1.战斗开始事件 2.战斗结束事件 3.攻击事件 4.主动技能事件 5.效果获得事件 6.效果消失事件 7.效果触发事件',
  `originator` int(11) DEFAULT '-1' COMMENT '发起者',
  `content` text COMMENT '内容（）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of battle_event
-- ----------------------------

-- ----------------------------
-- Table structure for battle_item_bonus
-- ----------------------------
DROP TABLE IF EXISTS `battle_item_bonus`;
CREATE TABLE `battle_item_bonus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `battleRecordId` int(11) DEFAULT NULL COMMENT '战斗记录',
  `itemId` int(11) DEFAULT NULL COMMENT '奖励物品id',
  `count` int(11) DEFAULT '0' COMMENT '数量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of battle_item_bonus
-- ----------------------------

-- ----------------------------
-- Table structure for battle_record
-- ----------------------------
DROP TABLE IF EXISTS `battle_record`;
CREATE TABLE `battle_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `battleTime
battleTime` datetime DEFAULT NULL COMMENT '战斗时间',
  `duration` int(11) DEFAULT NULL COMMENT '持续时间',
  `battleType` int(11) DEFAULT '1' COMMENT '战斗类型  1.野外战斗  2.副本战斗 3.决斗',
  `party1Id` varchar(50) DEFAULT '1' COMMENT '攻击角色1编号 = 1',
  `party2Id` varchar(50) DEFAULT '1' COMMENT '攻击角色2编号 = 1',
  `winnerId` varchar(50) DEFAULT '1' COMMENT '胜利角色编号=1',
  `scoreBonus` int(11) DEFAULT '0' COMMENT '分数奖励值=0',
  `expBonus` int(11) DEFAULT '0' COMMENT '经验奖励值=0',
  `coinBonus` int(11) DEFAULT '0' COMMENT '铜币奖励值=0',
  `goldBonus` int(11) DEFAULT '0' COMMENT '黄金奖励值=0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of battle_record
-- ----------------------------

-- ----------------------------
-- Table structure for battle_record2
-- ----------------------------
DROP TABLE IF EXISTS `battle_record2`;
CREATE TABLE `battle_record2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playerId` int(11) DEFAULT NULL COMMENT '玩家Id',
  `data` longtext COMMENT '战斗数据',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of battle_record2
-- ----------------------------

-- ----------------------------
-- Table structure for characte_shop
-- ----------------------------
DROP TABLE IF EXISTS `characte_shop`;
CREATE TABLE `characte_shop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shopId` int(11) DEFAULT NULL COMMENT '商店id',
  `characterId` int(11) DEFAULT NULL COMMENT '玩家id',
  `enterTime` datetime DEFAULT NULL COMMENT '进入时间',
  `seed` varchar(255) DEFAULT NULL COMMENT '产生物品列表的种子',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of characte_shop
-- ----------------------------

-- ----------------------------
-- Table structure for character
-- ----------------------------
DROP TABLE IF EXISTS `character`;
CREATE TABLE `character` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '玩家类型（0普通玩家1VIP）',
  `name` varchar(100) NOT NULL COMMENT '玩家姓名',
  `nickName` varchar(100) DEFAULT NULL COMMENT '昵称',
  `portrait` varchar(200) DEFAULT NULL COMMENT '人物头像',
  `balloonId` int(11) DEFAULT '5' COMMENT '气泡话语id',
  `level` int(11) DEFAULT '1' COMMENT '等级',
  `baseStr` float(20,0) DEFAULT '10' COMMENT '系统根据玩家职业赋予玩家的基础力量点数',
  `baseVit` float(20,0) DEFAULT '10' COMMENT '系统根据玩家职业赋予玩家的基础体质点数',
  `baseDex` float(20,0) DEFAULT '10' COMMENT '系统根据玩家职业赋予玩家的基础灵巧点数',
  `manualStr` int(11) DEFAULT '0' COMMENT '自定义加在力量上的点数',
  `manualVit` int(11) DEFAULT '0' COMMENT '自定义加在体质上的点数',
  `manualDex` int(11) DEFAULT '0' COMMENT '自定义加在灵巧上的点数',
  `sparePoint` int(11) DEFAULT '0' COMMENT '剩余属性点数',
  `hp` int(11) DEFAULT '100' COMMENT '当前生命值 = 100',
  `mp` int(11) DEFAULT '100' COMMENT '当前法力值 = 100',
  `energy` int(32) DEFAULT '200' COMMENT '当前活力',
  `exp` int(11) DEFAULT '0' COMMENT '当前经验值',
  `status` int(11) DEFAULT '1' COMMENT '状态: 1:正常 2:修炼中 3:训练中 4:战斗中 5:死亡 6:卖艺中 = 1',
  `transStatus` varchar(255) DEFAULT '正常' COMMENT '玩家的交易状态 = 正常',
  `pkStatus` tinyint(4) DEFAULT '0' COMMENT 'PK: 0:和平 1:杀戮 = 0',
  `camp` int(11) DEFAULT '5' COMMENT '阵营=5 新手',
  `professionPosition` int(11) DEFAULT '0' COMMENT '位职',
  `profession` int(11) DEFAULT '7' COMMENT '职业: 1:格斗 2:炼金 3:杀手 4:忍者 5:护卫 6:海盗 7:新手 = 7',
  `professionStage` int(11) DEFAULT '1' COMMENT '职业阶段=1',
  `activeSkill` int(11) DEFAULT '-1' COMMENT '主动技能',
  `auxiliarySkills` varchar(255) DEFAULT NULL COMMENT '辅助技能组',
  `passiveSkills` varchar(255) DEFAULT NULL COMMENT '被动技能组',
  `location` int(11) DEFAULT '501' COMMENT '当前所处地点 = 1',
  `town` int(11) DEFAULT '501' COMMENT '当前所处城镇 = 1',
  `coupon` int(11) DEFAULT '500' COMMENT '礼券=500',
  `coin` int(11) DEFAULT '10000' COMMENT '铜币=10000',
  `gold` int(11) DEFAULT '0' COMMENT '金黄',
  `pronouncement` varchar(255) DEFAULT NULL COMMENT '个人宣言',
  `friendCount` int(11) DEFAULT '20' COMMENT '玩家拥有好友数量上限（仇敌数量）<=100',
  `isNewPlayer` tinyint(4) DEFAULT '1' COMMENT '是否是新玩家=1',
  `enterInstanceCount` int(11) DEFAULT '0' COMMENT '每天进入副本次数,最大为2',
  `twiceExp` int(4) DEFAULT '1' COMMENT '修炼双倍经验值的几率',
  `dropCoefficient` int(11) DEFAULT '100000' COMMENT '掉落的附加属性几率修正',
  `password` varchar(255) DEFAULT '',
  `gender` int(11) DEFAULT '1' COMMENT '1男 2女',
  `warehouses` int(11) DEFAULT '1' COMMENT '玩家的仓库数量',
  `deposit` int(11) DEFAULT '0' COMMENT '玩家的存款',
  `teamID` int(11) DEFAULT '0' COMMENT '玩家队伍信息,为0表示自由状态，其他为队伍的ID值',
  `recruitmembers` text COMMENT '招募',
  `newPlayerQuest` int(11) DEFAULT '1',
  `isKilledMonster` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of character
-- ----------------------------

-- ----------------------------
-- Table structure for character_duel
-- ----------------------------
DROP TABLE IF EXISTS `character_duel`;
CREATE TABLE `character_duel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT NULL COMMENT '玩家id',
  `winCount` int(11) DEFAULT NULL COMMENT '胜利次数',
  `loseCount` int(11) DEFAULT NULL COMMENT '失败次数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of character_duel
-- ----------------------------

-- ----------------------------
-- Table structure for character_friend
-- ----------------------------
DROP TABLE IF EXISTS `character_friend`;
CREATE TABLE `character_friend` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT NULL COMMENT '家玩id',
  `playerId` int(11) DEFAULT '-1' COMMENT '联关玩家id',
  `type` int(11) DEFAULT '1' COMMENT '关系类型  1.好友  2.仇敌',
  `isSheildedMail` int(11) DEFAULT '0' COMMENT '是否屏蔽邮件 0.不屏蔽邮件 1.屏蔽',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of character_friend
-- ----------------------------

-- ----------------------------
-- Table structure for character_instance
-- ----------------------------
DROP TABLE IF EXISTS `character_instance`;
CREATE TABLE `character_instance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT NULL COMMENT '玩家id',
  `instanceId` int(11) DEFAULT '0' COMMENT '副本id',
  `instanceLayerId` int(11) DEFAULT '0' COMMENT '副本进度层地点id',
  `isLock` tinyint(4) DEFAULT '0' COMMENT '是否锁定,0:未锁定,1锁定',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of character_instance
-- ----------------------------

-- ----------------------------
-- Table structure for character_lobby
-- ----------------------------
DROP TABLE IF EXISTS `character_lobby`;
CREATE TABLE `character_lobby` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) NOT NULL COMMENT '玩家id',
  `startTime` datetime DEFAULT NULL COMMENT '大厅操作开始时间',
  `finishTime` datetime DEFAULT NULL COMMENT '结束时间',
  `isDoubleBonus` int(11) NOT NULL DEFAULT '0' COMMENT '否是是双倍奖励',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of character_lobby
-- ----------------------------

-- ----------------------------
-- Table structure for character_practice
-- ----------------------------
DROP TABLE IF EXISTS `character_practice`;
CREATE TABLE `character_practice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT NULL COMMENT '玩家id',
  `monsterId` int(11) DEFAULT '-1' COMMENT '怪物id',
  `countHit` int(11) DEFAULT '0' COMMENT '总共修炼数量',
  `startTime` datetime DEFAULT NULL COMMENT '开始时间',
  `finishTime` datetime DEFAULT NULL COMMENT '结束时间',
  `singleExpBonus` int(11) DEFAULT '0' COMMENT '当个怪物修炼的经验奖励',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of character_practice
-- ----------------------------

-- ----------------------------
-- Table structure for character_quest_room
-- ----------------------------
DROP TABLE IF EXISTS `character_quest_room`;
CREATE TABLE `character_quest_room` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT NULL,
  `enterTime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of character_quest_room
-- ----------------------------

-- ----------------------------
-- Table structure for character_rest
-- ----------------------------
DROP TABLE IF EXISTS `character_rest`;
CREATE TABLE `character_rest` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT '-1' COMMENT '玩家id',
  `napCount` int(11) DEFAULT '0' COMMENT '当天小憩次数',
  `lightSleepCount` int(11) DEFAULT '0' COMMENT '当天浅睡次数',
  `peacefulSleepCount` int(11) DEFAULT '0' COMMENT '当天安眠次数',
  `spoorCount` int(11) DEFAULT '0' COMMENT '当天酣睡次数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of character_rest
-- ----------------------------

-- ----------------------------
-- Table structure for character_shop
-- ----------------------------
DROP TABLE IF EXISTS `character_shop`;
CREATE TABLE `character_shop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shopId` int(11) DEFAULT NULL COMMENT '商店id',
  `characterId` int(11) DEFAULT NULL COMMENT '玩家id',
  `enterTime` datetime DEFAULT NULL COMMENT '进入时间',
  `seed` varchar(255) DEFAULT NULL COMMENT '产生物品列表的种子',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of character_shop
-- ----------------------------

-- ----------------------------
-- Table structure for character_skill
-- ----------------------------
DROP TABLE IF EXISTS `character_skill`;
CREATE TABLE `character_skill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT NULL COMMENT '玩家id',
  `skillId` int(11) DEFAULT NULL COMMENT '技能id',
  `skillLevel` int(11) DEFAULT NULL COMMENT '技能级别',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of character_skill
-- ----------------------------

-- ----------------------------
-- Table structure for character_skill_settings
-- ----------------------------
DROP TABLE IF EXISTS `character_skill_settings`;
CREATE TABLE `character_skill_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT NULL COMMENT '用户ID',
  `warriorSkillId` int(11) DEFAULT '0' COMMENT '对抗勇士的技能ID',
  `guardianSkillId` int(11) DEFAULT '0' COMMENT '对抗卫士技能ID',
  `samuraiSkillId` int(11) DEFAULT '0' COMMENT '对抗武士技能ID',
  `toShiSkillId` int(11) DEFAULT '0' COMMENT '对抗使士技能ID',
  `advisersSkillId` int(11) DEFAULT '0' COMMENT '对抗谋士技能ID',
  `warlockSkillId` int(11) DEFAULT '0' COMMENT '对抗术士技能ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of character_skill_settings
-- ----------------------------

-- ----------------------------
-- Table structure for deal_package
-- ----------------------------
DROP TABLE IF EXISTS `deal_package`;
CREATE TABLE `deal_package` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of deal_package
-- ----------------------------

-- ----------------------------
-- Table structure for deal_record
-- ----------------------------
DROP TABLE IF EXISTS `deal_record`;
CREATE TABLE `deal_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `startId` int(11) DEFAULT NULL COMMENT '发起方id',
  `receiverId` int(11) DEFAULT NULL COMMENT '接收方id',
  `status` varchar(255) DEFAULT NULL COMMENT '交易状态',
  `comment` varchar(255) DEFAULT NULL COMMENT '交易信息',
  `startTime` datetime DEFAULT NULL COMMENT '交易发起时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of deal_record
-- ----------------------------

-- ----------------------------
-- Table structure for effect_instance
-- ----------------------------
DROP TABLE IF EXISTS `effect_instance`;
CREATE TABLE `effect_instance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) NOT NULL,
  `effectId` int(11) NOT NULL,
  `effectGroupId` int(11) NOT NULL DEFAULT '0',
  `effectLevel` int(11) NOT NULL DEFAULT '1',
  `startTime` datetime NOT NULL COMMENT '开始时间',
  `triggerType` int(11) NOT NULL DEFAULT '0' COMMENT '1: 道具触发\n2: 技能触发\n',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of effect_instance
-- ----------------------------

-- ----------------------------
-- Table structure for equipment_slot
-- ----------------------------
DROP TABLE IF EXISTS `equipment_slot`;
CREATE TABLE `equipment_slot` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT NULL COMMENT '玩家id',
  `header` int(11) DEFAULT '-1' COMMENT '装备槽头部的物品id，-1为没有',
  `body` int(11) DEFAULT '-1' COMMENT '身体（上衣）',
  `belt` int(11) DEFAULT '-1' COMMENT '腰带部位',
  `trousers` int(11) DEFAULT '-1' COMMENT '下装部位',
  `shoes` int(11) DEFAULT '-1' COMMENT '鞋子部位',
  `bracer` int(11) DEFAULT '-1' COMMENT '护腕部位',
  `cloak` int(11) DEFAULT '-1' COMMENT '披风部位',
  `necklace` int(11) DEFAULT '-1' COMMENT '项链部位',
  `waist` int(11) DEFAULT '-1' COMMENT '腰饰部位',
  `weapon` int(11) DEFAULT '-1' COMMENT '武器部位',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of equipment_slot
-- ----------------------------

-- ----------------------------
-- Table structure for figure
-- ----------------------------
DROP TABLE IF EXISTS `figure`;
CREATE TABLE `figure` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `startBattleSentence` varchar(255) NOT NULL DEFAULT '/b=1 /c=F15F59 /f=10 /d=1 /t=2000`我要揍飞你！',
  `criSentence` varchar(255) NOT NULL DEFAULT '/b=1 /c=F15F59 /f=12 /t=2000`这拳够你受的！',
  `breSentence` varchar(255) NOT NULL DEFAULT '/b=1 /c=F15F59 /f=12 /t=2000`这下够你受的！',
  `criAndbreSentence` varchar(255) NOT NULL DEFAULT '/b=1 /c=F15F59 /f=12 /t=2000`这拳够你受的！',
  `missSentence` varchar(255) NOT NULL DEFAULT '/b=1 /c=F15F59 /f=10 /t=2000`才不会被你打中。',
  `beMissedSentence` varchar(255) NOT NULL DEFAULT '/b=1 /c=F15F59 /f=10 /t=2000`竟然被闪开了。',
  `beCrackedSentence` varchar(255) NOT NULL DEFAULT '/b=1 /c=F15F59 /f=12 /t=2000`好疼！',
  `usingSkillSentence` varchar(255) NOT NULL DEFAULT '/b=1 /c=F15F59 /f=12 /t=2000`[技]！',
  `WinSentence` varchar(255) NOT NULL DEFAULT '/b=1 /c=F15F59 /f=10 /t=2000`我是要成为王的男人。',
  `failSentence` varchar(255) NOT NULL DEFAULT '/b=1 /c=F15F59 /f=10 /t=2000`不能在这倒下...',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of figure
-- ----------------------------

-- ----------------------------
-- Table structure for forging_package
-- ----------------------------
DROP TABLE IF EXISTS `forging_package`;
CREATE TABLE `forging_package` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT NULL COMMENT '玩家Id',
  `itemId` int(11) DEFAULT NULL COMMENT '物品id',
  `position` varchar(255) DEFAULT NULL COMMENT '当前位置',
  `stack` int(11) DEFAULT NULL COMMENT '当前叠加数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of forging_package
-- ----------------------------

-- ----------------------------
-- Table structure for friend
-- ----------------------------
DROP TABLE IF EXISTS `friend`;
CREATE TABLE `friend` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT NULL COMMENT '玩家id',
  `otherId` int(11) DEFAULT NULL COMMENT '另一玩家',
  `isFriendly` tinyint(4) DEFAULT '1' COMMENT '是否是友好的（0黑名单；1友好）',
  `isShieldMail` tinyint(4) DEFAULT '0' COMMENT '是否屏蔽邮件',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of friend
-- ----------------------------

-- ----------------------------
-- Table structure for item
-- ----------------------------
DROP TABLE IF EXISTS `item`;
CREATE TABLE `item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) NOT NULL COMMENT '玩家id',
  `itemTemplateId` int(11) DEFAULT NULL COMMENT '物品模版id',
  `selfExtraAttributeId` varchar(255) DEFAULT '-1' COMMENT '自身附加属性，-1为没有',
  `dropExtraAttributeId` varchar(255) DEFAULT '-1' COMMENT '掉落附加属性（包含掉落、商店刷出）',
  `isBound` int(4) DEFAULT '0' COMMENT '备装绑定状态:0:未绑定,1未绑定:已绑定 = 0',
  `itemLevel` int(11) DEFAULT '1' COMMENT '物品的等级',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of item
-- ----------------------------

-- ----------------------------
-- Table structure for mail
-- ----------------------------
DROP TABLE IF EXISTS `mail`;
CREATE TABLE `mail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `senderId` int(11) DEFAULT '-1' COMMENT '发送邮件的角色ID  当为-1时,将认为是一封由系统产生的邮件,将由type字段提供支持 = -1',
  `receiverId` int(11) DEFAULT NULL COMMENT '接受人id',
  `type` int(11) DEFAULT '2' COMMENT '邮件的类型（1.系统信函  2.玩家信函  3.交易信函 4.系统公告 = 2',
  `content` longtext COMMENT '邮件的内容',
  `isReaded` tinyint(4) DEFAULT '0' COMMENT '是否已经读=0',
  `sendTime` datetime DEFAULT NULL COMMENT '发送时间',
  `systemType` int(11) DEFAULT '0' COMMENT '0.普通系统信函 1.组队系统信函  ',
  `reference` varchar(255) DEFAULT NULL COMMENT '引用邮件内容',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of mail
-- ----------------------------

-- ----------------------------
-- Table structure for newplayer_quest
-- ----------------------------
DROP TABLE IF EXISTS `newplayer_quest`;
CREATE TABLE `newplayer_quest` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` char(255) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `coin` int(11) DEFAULT NULL,
  `exp` int(11) DEFAULT NULL,
  `coupon` int(11) DEFAULT NULL,
  `type` char(255) DEFAULT '新手任务',
  `npcTalk` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of newplayer_quest
-- ----------------------------
INSERT INTO `newplayer_quest` VALUES ('1', '三国之旅', '前往<font color=\'#ff0000\'>议事大厅</font>和南华星君交谈', '5000', '10', '0', '新手任务', '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;欢迎来到三国。我是谁？只是个普通的小老头啦。小老头儿看到很多新来的年轻人有点不知所措，出来给新来的朋友上几课。&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如今天下可不太平，到处兵荒马乱的，想出人头地可不容易啊。我会教你几招，让你轻松上路。&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;请来<font color=\'#ff0000\'>议事大厅</font>和我<font color=\'#ff0000\'>交谈</font>');
INSERT INTO `newplayer_quest` VALUES ('2', '职业选择', '选择一个职业', '0', '80', '0', '新手任务', null);
INSERT INTO `newplayer_quest` VALUES ('3', '装备武器', '打开角色界面，将装备栏里的武器装备起来', '0', '150', '0', '新手任务', null);
INSERT INTO `newplayer_quest` VALUES ('4', '提升实力', '在角色界面中，选择一个人物属性加点', '0', '50', '0', '新手任务', null);
INSERT INTO `newplayer_quest` VALUES ('5', '冒险诀窍', '点击任务按钮，点击<font color=\'#ff0000\'>可接任务</font>，查看是否有可接任务', '0', '60', '0', '新手任务', null);
INSERT INTO `newplayer_quest` VALUES ('6', '购买武器', '前往<font color=\'#ff0000\'>武器店</font>，跟武器店老板交谈', '0', '2000', '0', '新手任务', null);
INSERT INTO `newplayer_quest` VALUES ('7', '购买防具', '前往<font color=\'#ff0000\'>防具店</font>，和防具店老板交谈', '0', '1500', '0', '新手任务', null);
INSERT INTO `newplayer_quest` VALUES ('8', '购买杂货', '前往<font color=\'#ff0000\'>杂货店</font>，和杂货店老板交谈', '0', '1500', '0', '新手任务', null);
INSERT INTO `newplayer_quest` VALUES ('9', '赏金猎人', '前往<font color=\'#ff0000\'>赏金组织</font>，和赏金猎人交谈', '2000', '2000', '0', '新手任务', null);
INSERT INTO `newplayer_quest` VALUES ('10', '品尝美食', '打开角色界面，使用物品栏里的食物', '0', '3000', '0', '新手任务', null);
INSERT INTO `newplayer_quest` VALUES ('11', '战斗方法', '点击<font color=\'#00EC00\'>出口</font>，前往<font color=\'#00EC00\'>广宗</font>-<font color=\'#00EC00\'>小树林</font>，杀死一个<font color=\'#9F35FF\'>黄巾侦查兵</font>，然后回城向南华星君交付任务', '0', '3400', '0', '新手任务', null);
INSERT INTO `newplayer_quest` VALUES ('12', '熟悉战斗', '点击<font color=\'#00EC00\'>出口</font>，前往<font color=\'#00EC00\'>广宗</font>-<font color=\'#00EC00\'> 陈家村</font>，杀死一个<font color=\'#9F35FF\'>黄巾力士</font>，然后回城向南华星君交付任务', '1000', '4000', '0', '新手任务', null);
INSERT INTO `newplayer_quest` VALUES ('13', '考验', '点击<font color=\'#00EC00\'>出口</font>，前往<font color=\'#00EC00\'>广宗</font>-<font color=\'#00EC00\'> 黄巾营帐</font>，杀死一个<font color=\'#9F35FF\'>黄巾伍长</font>，然后回城向南华星君交付任务', '7000', '7000', '0', '新手任务', null);
INSERT INTO `newplayer_quest` VALUES ('14', '学习技能', '点击角色按钮进入角色界面，找到技能按钮，进入技能界面学习技能并装备技能', '0', '3000', '0', '新手任务', null);
INSERT INTO `newplayer_quest` VALUES ('15', '临别礼物', '前往<font color=\'#ff0000\'>议事大厅</font>和南华星君交谈', '0', '3000', '0', '新手任务', null);
INSERT INTO `newplayer_quest` VALUES ('16', '未来之路', '前往<font color=\'#ff0000\'>议事大厅</font>和南华星君交谈', '0', '2000', '0', '新手任务', null);

-- ----------------------------
-- Table structure for package
-- ----------------------------
DROP TABLE IF EXISTS `package`;
CREATE TABLE `package` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT NULL COMMENT '玩家id',
  `itemId` int(11) DEFAULT NULL COMMENT '对应玩家包裹栏中物品id',
  `position` varchar(11) DEFAULT NULL COMMENT '当前位置',
  `stack` int(11) DEFAULT '1' COMMENT '当前叠加数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of package
-- ----------------------------

-- ----------------------------
-- Table structure for pc_recruit_npc
-- ----------------------------
DROP TABLE IF EXISTS `pc_recruit_npc`;
CREATE TABLE `pc_recruit_npc` (
  `id` int(11) NOT NULL,
  `usrid` int(11) DEFAULT NULL,
  `recruitmembers` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pc_recruit_npc
-- ----------------------------

-- ----------------------------
-- Table structure for quest_goal_progress
-- ----------------------------
DROP TABLE IF EXISTS `quest_goal_progress`;
CREATE TABLE `quest_goal_progress` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `questRecordId` int(11) DEFAULT NULL COMMENT '任务id',
  `questGoalId` int(11) DEFAULT NULL COMMENT '任务目标id',
  `killMonsterCount` int(11) DEFAULT '0' COMMENT '已经杀死怪物数量  = 0',
  `collectItemCount` int(11) DEFAULT '0' COMMENT '收集道具数量 = 0',
  `hasTalkedtoNPC` int(4) DEFAULT '0' COMMENT '是否已经和关键npc对话过 = 0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of quest_goal_progress
-- ----------------------------

-- ----------------------------
-- Table structure for quest_record
-- ----------------------------
DROP TABLE IF EXISTS `quest_record`;
CREATE TABLE `quest_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `questtemplateId` int(11) NOT NULL COMMENT '任务实例的id = -1',
  `characterId` int(11) NOT NULL,
  `applyTime` datetime NOT NULL,
  `finishTime` datetime DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '0未完成 1已完成',
  `itemBonus` int(11) NOT NULL DEFAULT '-1' COMMENT '奖励物品id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of quest_record
-- ----------------------------

-- ----------------------------
-- Table structure for quest_temp_item
-- ----------------------------
DROP TABLE IF EXISTS `quest_temp_item`;
CREATE TABLE `quest_temp_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT '0' COMMENT '玩家ID',
  `questTemplateId` int(11) DEFAULT '0' COMMENT '赏金任务ID',
  `itemID` int(11) DEFAULT '0' COMMENT '物品id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of quest_temp_item
-- ----------------------------

-- ----------------------------
-- Table structure for register
-- ----------------------------
DROP TABLE IF EXISTS `register`;
CREATE TABLE `register` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of register
-- ----------------------------

-- ----------------------------
-- Table structure for team
-- ----------------------------
DROP TABLE IF EXISTS `team`;
CREATE TABLE `team` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '队伍ID',
  `member1` int(11) DEFAULT '0',
  `member1Type` int(11) DEFAULT '1' COMMENT '员成1类型 1.玩家  2.npc',
  `member2` int(11) DEFAULT '0',
  `member2Type` int(11) DEFAULT '1',
  `member3` int(11) DEFAULT '0',
  `member3Type` int(11) DEFAULT '1',
  `leader` int(11) DEFAULT NULL COMMENT '队长',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of team
-- ----------------------------

-- ----------------------------
-- Table structure for temporary_package
-- ----------------------------
DROP TABLE IF EXISTS `temporary_package`;
CREATE TABLE `temporary_package` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT NULL COMMENT '玩家id',
  `itemId` int(11) DEFAULT NULL COMMENT '物品id',
  `position` varchar(255) DEFAULT NULL COMMENT '当前位置',
  `stack` int(11) DEFAULT NULL COMMENT '当前叠加数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of temporary_package
-- ----------------------------

-- ----------------------------
-- Table structure for warehouse_package
-- ----------------------------
DROP TABLE IF EXISTS `warehouse_package`;
CREATE TABLE `warehouse_package` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT NULL COMMENT '玩家ID',
  `itemId` int(11) DEFAULT NULL COMMENT '对应玩家仓库中物品id',
  `position` varchar(11) DEFAULT NULL COMMENT '前当位置',
  `stack` int(11) DEFAULT NULL COMMENT '当前叠加数',
  `packageCounts` int(11) DEFAULT NULL COMMENT '存放在第几个仓库里',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of warehouse_package
-- ----------------------------
