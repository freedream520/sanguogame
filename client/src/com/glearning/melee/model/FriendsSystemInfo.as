package com.glearning.melee.model
{
	public class FriendsSystemInfo
	{
		public static function get instance():FriendsSystemInfo
		{
			if (!_instance)
				_instance = new FriendsSystemInfo();
			
			return _instance;
		}
		  
		private static var _instance:FriendsSystemInfo = null;
		
		public function FriendsSystemInfo()
		{
		}
		
		private var _friendsListData:Array = new Array();
		[Bindable]
		public function get friendsListData():Array{
			return _friendsListData;
		}
		public function set friendsListData(value:Array):void{
			_friendsListData = value;
		}
		
		private var _blackListData:Array = new Array();
		[Bindable]
		public function get blackListData():Array{
			return _blackListData;
		}
		public function set blackListData(value:Array):void{
			_blackListData = value;
		}

	}
}