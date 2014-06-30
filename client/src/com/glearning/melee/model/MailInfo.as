package com.glearning.melee.model
{
	public class MailInfo
	{
		public static function get instance():MailInfo
		{
			if (!_instance)
				_instance = new MailInfo();
			
			return _instance;
		}
		  
		private static var _instance:MailInfo = null;
		
		public function MailInfo()
		{
		}

		//系统信函
		private var _systemMailData:Array = new Array();
		[Bindable]
		public function get systemMailData():Array{
			return _systemMailData;
		}
		public function set systemMailData(value:Array):void{
			_systemMailData = value;
		}
		
		//系统公告
		private var _announcementData:Array = new Array();
		[Bindable]
		public function get announcementData():Array{
			return _announcementData;
		}
		public function set announcementData(value:Array):void{
			_announcementData = value;
		}
		
		//玩家信函
		private var _playerMailData:Array = new Array();
		[Bindable]
		public function get playerMailData():Array{
			return _playerMailData;
		}
		public function set playerMailData(value:Array):void{
			_playerMailData = value;
		}
		
		//所有信函
		private var _allMailData:Array = new Array();
		[Bindable]
		public function get allMailData():Array{
			return _allMailData;
		}
		public function set allMailData(value:Array):void{
			_allMailData = value;
		}
	}
}