package com.glearning.melee.model
{
	public class SkillInfo
	{
	   public static function get instance():SkillInfo
		{
			if (!_instance)
				_instance = new SkillInfo();
			
			return _instance;
		}
		  
		 private static var _instance:SkillInfo = null;
      
		public function SkillInfo()
		{
		}
		
		 //技能ID
		private var _id:int=0;
		[Bindable]
		public function get id():int {
			return _id;
		}
		public function set id(value:int):void {
			_id = value;
		}
		
		//技能职业
		private var _skillProfession:int = 0;
		[Bindable]
		public function get skillProfession():int {
			return _skillProfession;
		}
		public function set skillProfession(value:int):void {
			_skillProfession = value;
		}

        //技能名字
        private var _skillName:String = "";
		[Bindable]
		public function get skillName():String {
			return _skillName;
		}
		public function set skillName(value:String):void {
			_skillName = value;
		}
		
		//技能图标
		private var _skillIcon:String = "";
		[Bindable]
		public function get skillIcon():String {
			return _skillIcon;
		}
		public function set skillIcon(value:String):void {
			_skillIcon = value;
		}
		
		//技能描述
		private var _skillDescription:String = "";
		[Bindable]
		public function get skillDescription():String {
			return _skillDescription;
		}
		public function set skillDescription(value:String):void {
			_skillDescription = value;
		}
		
		//技能武器
		private var _skillWeapon:int = 0;
		[Bindable]
		public function get skillWeapon():int {
			return _skillWeapon;
		}
		public function set skillWeapon(value:int):void {
			_skillWeapon = value;
		}
		
		//技能最大等级
		private var _skillMaxLevel:int = 0;
		[Bindable]
		public function get skillMaxLevel():int {
			return _skillMaxLevel;
		}
		public function set skillMaxLevel(value:int):void {
			_skillMaxLevel = value;
		}
		
		//技能当前等级
		private var _skillLevel:int = 0;
		[Bindable]
		public function get skillLevel():int {
			return _skillLevel;
		}
		public function set skillLevel(value:int):void {
			_skillLevel = value;
		}
		
		//技能耗蓝
		private var _skillUseMp:int = 0;
		[Bindable]
		public function get skillUseMp():int {
			return _skillUseMp;
		}
		public function set skillUseMp(value:int):void {
			_skillUseMp = value;
		}
		
		//技能类型
		private var _skillType:int = 0;
		[Bindable]
		public function get skillType():int {
			return _skillType;
		}
		public function set skillType(value:int):void {
			_skillType = value;
		}
		
		//技能触发几率
		private var _skillRate:int = 0;
		[Bindable]
		public function get skillRate():int {
			return _skillRate;
		}
		public function set skillRate(value:int):void {
			_skillRate = value;
		}
		
		//技能所需人物等级
		private var _skillLevelRequire:int = 0;
		[Bindable]
		public function get skillLevelRequire():int {
			return _skillLevelRequire;
		}
		public function set skillLevelRequire(value:int):void {
			_skillLevelRequire = value;
		}
		
		//技能列表
		private var _skillCurrentArray:Array;
		[Bindable]
		public function get skillCurrentArray():Array {
			return _skillCurrentArray;
		}
		public function set skillCurrentArray(value:Array):void {
			_skillCurrentArray = value;
		}
		
		//技能需求等级
		private var _skillProfessionStageRequire:int;
		[Bindable]
		public function get skillProfessionStageRequire():int {
			return _skillProfessionStageRequire;
		}
		public function set skillProfessionStageRequire(value:int):void {
			_skillProfessionStageRequire = value;
		}
		
		//技能花费
		private var _skillUseCoin:int;
		[Bindable]
		public function get skillUseCoin():int {
			return _skillUseCoin;
		}
		public function set skillUseCoin(value:int):void {
			_skillUseCoin = value;
		}
		
		//产生效果
		private var _skillAddEffect:String;
		[Bindable]
		public function get skillAddEffect():String {
			return _skillAddEffect;
		}
		public function set skillAddEffect(value:String):void {
			_skillAddEffect = value;
		}
		
		//产生效果几率
		private var _skillAddEffectRate:int;
		[Bindable]
		public function get skillAddEffectRate():int {
			return _skillAddEffectRate;
		}
		public function set skillAddEffectRate(value:int):void {
			_skillAddEffectRate = value;
		}
		
		//攻击力
		private var _skillAttackDamage:String;
		[Bindable]
		public function get skillAttackDamage():String {
			return _skillAttackDamage;
		}
		public function set skillAttackDamage(value:String):void {
			_skillAttackDamage = value;
		}
		
		//技能对抗
		private var _skillRemoveEffect:String;
		[Bindable]
		public function get skillRemoveEffect():String {
			return _skillRemoveEffect;
		}
		public function set skillRemoveEffect(value:String):void {
			_skillRemoveEffect = value;
		}
		
		//技能对抗几率
		private var _skillRemoveEffectRate:String;
		[Bindable]
		public function get skillRemoveEffectRate():String {
			return _skillRemoveEffectRate;
		}
		public function set skillRemoveEffectRate(value:String):void {
			_skillRemoveEffectRate = value;
		}
		
		//技能所有信息
		private var _skillObj:Object;
		[Bindable]
		public function get skillObj():Object {
			return _skillObj;
		}
		public function set skillObj(value:Object):void {
			_skillObj = value;
		}
		
	}
}