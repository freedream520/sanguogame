package com.glearning.melee.model
{
	public class EffectInfo
	{
		public static function get instance():EffectInfo
		{
			if (!_instance)
				_instance = new EffectInfo();
			
			return _instance;
		}
		  
		private static var _instance:EffectInfo = null;
    
		public function EffectInfo()
		{
		}
		
		//技能效果数组
		private var _effectArray:Array;
		[Bindable]
		public function get effectArray():Array {
			return _effectArray;
		}
		public function set effectArray(value:Array):void {
			_effectArray = value;
		}
		
		//物品效果数组
		private var _itemEffectArray:Array;
		[Bindable]
		public function get itemEffectArray():Array {
			return _itemEffectArray;
		}
		public function set itemEffectArray(value:Array):void {
			_itemEffectArray = value;
		}
		
		//效果名
		private var _effectName:String;
		[Bindable]
		public function get effectName():String {
			return _effectName;
		}
		public function set effectName(value:String):void {
			_effectName = value;
		}
		
		//效果持续时间
		private var _effectTime:String;
		[Bindable]
		public function get effectTime():String {
			return _effectTime;
		}
		public function set effectTime(value:String):void {
			_effectTime = value;
		}

       //效果图标
       private var _effectIcon:String;
		[Bindable]
		public function get effectIcon():String {
			return _effectIcon;
		}
		public function set effectIcon(value:String):void {
			_effectIcon = value;
		}
	}
}