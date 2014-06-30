package com.glearning.melee.model
{
	public class CityInfo
	{
		//城市中要用到
		public static function get instance():CityInfo
		{
			if (!_instance)
				_instance = new CityInfo();
			
			return _instance;
		}
		  
		private static var _instance:CityInfo = null;
		public function CityInfo()
		{
		}

		//当前城市名字
		private var _cityName:String = "";
		[Bindable]
		public function get cityName():String {
			return _cityName;
		}
		public function set cityName(value:String):void {
			_cityName = value;
		}
		
		//城市的阵营
		private var _cityFaction:String = "";
		[Bindable]
		public function get cityFaction():String {
			return _cityFaction;
		}
		public function set cityFaction(value:String):void {
			_cityFaction = value;
		}
		
		//城市中设施列表
		private var _facilityList:Array = null;
		[Bindable]
		public function get facilityList():Array{
			return _facilityList;
		}
		public function set facilityList(value:Array):void{
			_facilityList = value;
		}
		
		//城市图片
		private var _cityImg:String = "";
		[Bindable]
		public function get cityImg():String{
			return _cityImg;
		}
		public function set cityImg(value:String):void{
			_cityImg = value;
		}
	}
}