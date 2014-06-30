//战斗的数据
package com.glearning.melee.model
{
	import mx.events.IndexChangedEvent;
	
	public class BattleInfo
	{
		public static function get instance():BattleInfo
		{
			if (!_instance)
				_instance = new BattleInfo();
			
			return _instance;
		}
		  
		private static var _instance:BattleInfo = null;
		
		public function BattleInfo()
		{
		}
		
		//player1的ID
		public var _player1Id:int;
		[Bindable]
		public function get player1Id():int{
			return _player1Id;
		}
		public function set player1Id(value:int):void{
			_player1Id = value;
		}
		
		//player2的ID
		public var _player2Id:int;
		[Bindable]
		public function get player2Id():int{
			return _player2Id;
		}
		public function set player2Id(value:int):void{
			_player2Id = value;
		}

		//player1的名字
		public var _player1Name:String;
		[Bindable]
		public function get player1Name():String{
			return _player1Name;
		}
		public function set player1Name(value:String):void{
			_player1Name = value;
		}
		
		//player2的名字
		public var _player2Name:String;
		[Bindable]
		public function get player2Name():String{
			return _player2Name;
		}
		public function set player2Name(value:String):void{
			_player2Name = value;
		}
		
		//player1的头像
		public var _player1Img:String;
		[Bindable]
		public function get player1Img():String{
			return _player1Img;
		}
		public function set player1Img(value:String):void{
			_player1Img = value;
		}
		
		//player2的头像
		public var _player2Img:String;
		[Bindable]
		public function get player2Img():String{
			return _player2Img;
		}
		public function set player2Img(value:String):void{
			_player2Img = value;
		}
		
		//player1的等级
		public var _player1Level:int;
		[Bindable]
		public function get player1Level():int{
			return _player1Level;
		}
		public function set player1Level(value:int):void{
			_player1Level = value;
		}
		
		//player2的等级
		public var _player2Level:int;
		[Bindable]
		public function get player2Level():int{
			return _player2Level;
		}
		public function set player2Level(value:int):void{
			_player2Level = value;
		}
		
		//player1的职业
		public var _player1Profession:String;
		[Bindable]
		public function get player1Profession():String{
			return _player1Profession;
		}
		public function set player1Profession(value:String):void{
			_player1Profession = value;
		}
		
		//player2的职业
		public var _player2Profession:String;
		[Bindable]
		public function get player2Profession():String{
			return _player2Profession;
		}
		public function set player2Profession(value:String):void{
			_player2Profession = value;
		}
		
		//player1的职业阶级
		public var _player1ProfessionStage:String;
		[Bindable]
		public function get player1ProfessionStage():String{
			return _player1ProfessionStage;
		}
		public function set player1ProfessionStage(value:String):void{
			_player1ProfessionStage = value;
		}
		
		//player2的职业阶级
		public var _player2ProfessionStage:String;
		[Bindable]
		public function get player2ProfessionStage():String{
			return _player2ProfessionStage;
		}
		public function set player2ProfessionStage(value:String):void{
			_player2ProfessionStage = value;
		}
		
		//player1的技能
		public var _player1Skill:String;
		[Bindable]
		public function get player1Skill():String{
			return _player1Skill;
		}
		public function set player1Skill(value:String):void{
			_player1Skill = value;
		}
		
		//player2的技能
		public var _player2Skill:String;
		[Bindable]
		public function get player2Skill():String{
			return _player2Skill;
		}
		public function set player2Skill(value:String):void{
			_player2Skill = value;
		}
			
		//player1的技能信息
		public var _player1SkillInfo:Object;
		[Bindable]
		public function get player1SkillInfo():Object{
			return _player1SkillInfo;
		}
		public function set player1SkillInfo(value:Object):void{
			_player1SkillInfo = value;
		}
			
		//player2的技能信息
		public var _player2SkillInfo:Object;
		[Bindable]
		public function get player2SkillInfo():Object{
			return _player2SkillInfo;
		}
		public function set player2SkillInfo(value:Object):void{
			_player2SkillInfo = value;
		}
		
		//player1的HP
		public var _player1HP:int;
		[Bindable]
		public function get player1HP():int{
			return _player1HP;
		}
		public function set player1HP(value:int):void{
			_player1HP = value;
		}
		
		//player2的HP
		public var _player2HP:int;
		[Bindable]
		public function get player2HP():int{
			return _player2HP;
		}
		public function set player2HP(value:int):void{
			_player2HP = value;
		}
		
		//player1的最大HP
		public var _player1MaxHP:int;
		[Bindable]
		public function get player1MaxHP():int{
			return _player1MaxHP;
		}
		public function set player1MaxHP(value:int):void{
			_player1MaxHP = value;
		}
		
		//player2的最大HP
		public var _player2MaxHP:int;
		[Bindable]
		public function get player2MaxHP():int{
			return _player2MaxHP;
		}
		public function set player2MaxHP(value:int):void{
			_player2MaxHP = value;
		}
		
		//player1的MP
		public var _player1MP:int;
		[Bindable]
		public function get player1MP():int{
			return _player1MP;
		}
		public function set player1MP(value:int):void{
			_player1MP = value;
		}
		
		//player2的MP
		public var _player2MP:int;
		[Bindable]
		public function get player2MP():int{
			return _player2MP;
		}
		public function set player2MP(value:int):void{
			_player2MP = value;
		}
		
		//player1的最大MP
		public var _player1MaxMP:int;
		[Bindable]
		public function get player1MaxMP():int{
			return _player1MaxMP;
		}
		public function set player1MaxMP(value:int):void{
			_player1MaxMP = value;
		}
		
		//player2的最大MP
		public var _player2MaxMP:int;
		[Bindable]
		public function get player2MaxMP():int{
			return _player2MaxMP;
		}
		public function set player2MaxMP(value:int):void{
			_player2MaxMP = value;
		}
		
		//player1的基本信息
		public var _player1Info:Object;
		[Bindable]
		public function get player1Info():Object{
			return _player1Info;
		}
		public function set player1Info(value:Object):void{
			_player1Info = value;
		}
		
		//player2的基本信息
		public var _player2Info:Object;
		[Bindable]
		public function get player2Info():Object{
			return _player2Info;
		}
		public function set player2Info(value:Object):void{
			_player2Info = value;
		}
		
		//player1的队友信息
		public var _player1TeamInfo:Array;
		[Bindable]
		public function get player1TeamInfo():Array{
			return _player1TeamInfo;
		}
		public function set player1TeamInfo(value:Array):void{
			_player1TeamInfo = value;
		}
		
		//player2的队友信息
		public var _player2TeamInfo:Array;
		[Bindable]
		public function get player2TeamInfo():Array{
			return _player2TeamInfo;
		}
		public function set player2TeamInfo(value:Array):void{
			_player2TeamInfo = value;
		}
		
		//player1对话泡
		public var _player1Dialog:Array;
		[Bindable]
		public function get player1Dialog():Array{
			return _player1Dialog;
		}
		public function set player1Dialog(value:Array):void{
			_player1Dialog = value;
		}
		
		//player2对话泡
		public var _player2Dialog:Array;
		[Bindable]
		public function get player2Dialog():Array{
			return _player2Dialog;
		}
		public function set player2Dialog(value:Array):void{
			_player2Dialog = value;
		}
		
		//攻击过程
		public var _attackData:Array;
		[Bindable]
		public function get attackData():Array{
			return _attackData;
		}
		public function set attackData(value:Array):void{
			_attackData = value;
		}
		
		//战斗类型
		public var _battleType:String;
		[Bindable]
		public function get battleType():String{
			return _battleType;
		}
		public function set battleType(value:String):void{
			_battleType = value;
		}
		
		//战斗时间
		public var _battleTime:int = 360;
		[Bindable]
		public function get battleTime():int{
			return _battleTime;
		}
		public function set battleTime(value:int):void{
			_battleTime = value;
		}
		
		//战斗剩余时间
		public var _battleOverTime:int = 360;
		[Bindable]
		public function get battleOverTime():int{
			return _battleOverTime;
		}
		public function set battleOverTime(value:int):void{
			_battleOverTime = value;
		}
		
		//战斗结果
		public var _battleResult:Object;
		[Bindable]
		public function get battleResult():Object{
			return _battleResult;
		}
		public function set battleResult(value:Object):void{
			_battleResult = value;
		}
		
		//玩家的状态
		public var _playersStatus:Array;
		[Bindable]
		public function get playersStatus():Array{
			return _playersStatus;
		}
		public function set playersStatus(value:Array):void{
			_playersStatus = value;
		}
		
		//触发效果的增量
		public var _mphpDelta:Array;
		[Bindable]
		public function get mphpDelta():Array{
			return _mphpDelta;
		}
		public function set mphpDelta(value:Array):void{
			_mphpDelta = value;
		}
		
//		//物品奖励
//		public var _itemBonuses:Array;
//		[Bindable]
//		public function get itemBonuses():Array{
//			return _itemBonuses;
//		}
//		public function set itemBonuses(value:Array):void{
//			_itemBonuses = value;
//		}
	}
}