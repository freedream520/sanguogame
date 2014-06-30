package com.glearning.melee.model
{
	public class TaskInfo
	{
		public static function get instance():TaskInfo
		{
			if (!_instance)
				_instance = new TaskInfo();
			
			return _instance;
		}
		  
		 private static var _instance:TaskInfo = null;
      
		public function TaskInfo()
		{
		}
		
		//任务完成NPC
		private var _accepter:int=0;
		[Bindable]
		public function get accepter():int {
			return _accepter;
		}
		public function set accepter(value:int):void {
			_accepter = value;
		}
		
		//NPC对话
		private var _accepterDialog:String;
		[Bindable]
		public function get accepterDialog():String {
			return _accepterDialog;
		}
		public function set accepterDialog(value:String):void {
			_accepterDialog = value;
		}
		
		//阵营
		private var _campRequire:int=0;
		[Bindable]
		public function get campRequire():int {
			return _campRequire;
		}
		public function set campRequire(value:int):void {
			_campRequire = value;
		}

       //任务类型
       private var _category:String;
       [Bindable]
		public function get category():String {
			return _category;
		}
		public function set category(value:String):void {
			_category = value;
		}
		
		//金币奖励
		private var _coinBonus:int;
       [Bindable]
		public function get coinBonus():int {
			return _coinBonus;
		}
		public function set coinBonus(value:int):void {
			_coinBonus = value;
		}
		
		//任务描述
		private var _description:String;
       [Bindable]
		public function get description():String {
			return _description;
		}
		public function set description(value:String):void {
			_description = value;
		}
		
		//经验奖励
		private var _expBonus:int;
       [Bindable]
		public function get expBonus():int {
			return _expBonus;
		}
		public function set expBonus(value:int):void {
			_expBonus = value;
		}
		
		//任务模板id
		private var _id:int;
       [Bindable]
		public function get id():int {
			return _id;
		}
		public function set id(value:int):void {
			_id = value;
		}
		
		//最大等级需要
		private var _maxLevelRequire:int;
       [Bindable]
		public function get maxLevelRequire():int {
			return _maxLevelRequire;
		}
		public function set maxLevelRequire(value:int):void {
			_maxLevelRequire = value;
		}
		
		//最低等级需要
		private var _minLevelRequire:int;
       [Bindable]
		public function get minLevelRequire():int {
			return _minLevelRequire;
		}
		public function set minLevelRequire(value:int):void {
			_minLevelRequire = value;
		}
		
		//任务名称
		private var _name:String;
       [Bindable]
		public function get name():String {
			return _name;
		}
		public function set name(value:String):void {
			_name = value;
		}
		
		//职业需求
		private var _professionRequire:String;
       [Bindable]
		public function get professionRequire():String {
			return _professionRequire;
		}
		public function set professionRequire(value:String):void {
			_professionRequire = value;
		}
		
		//职业阶段需求
		private var _professionStageRequire:int;
       [Bindable]
		public function get professionStageRequire():int {
			return _professionStageRequire;
		}
		public function set professionStageRequire(value:int):void {
			_professionStageRequire = value;
		}
		
		//类型
		private var _type:int;
       [Bindable]
		public function get type():int {
			return _type;
		}
		public function set type(value:int):void {
			_type = value;
		}
		
		//任务提供者
		private var _provider:int;
       [Bindable]
		public function get provider():int {
			return _provider;
		}
		public function set provider(value:int):void {
			_provider = value;
		}
		
		//任务提供者对话
		private var _providerDialog:String;
       [Bindable]
		public function get providerDialog():String {
			return _providerDialog;
		}
		public function set providerDialog(value:String):void {
			_providerDialog = value;
		}
		
		//当前任务数组
		private var _taskArray:Array;
       [Bindable]
		public function get taskArray():Array {
			return _taskArray;
		}
		public function set taskArray(value:Array):void {
			_taskArray = value;
		}
		
		//任务目标
		private var _target:String;
       [Bindable]
		public function get target():String {
			return _target;
		}
		public function set target(value:String):void {
			_target = value;
		}
		
		//任务奖励
		private var _award:String;
       [Bindable]
		public function get award():String {
			return _award;
		}
		public function set award(value:String):void {
			_award = value;
		}
		
		
		
		//已接任务数量
		private var _taskNum:int = 0;
       [Bindable]
		public function get taskNum():int {
			return _taskNum;
		}
		public function set taskNum(value:int):void {
			_taskNum = value;
		}
	}
}