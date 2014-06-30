package com.glearning.melee.model
{
	public class WorldMapInfo
	{
		//世界地图中要用到
		public static function get instance():WorldMapInfo
		{
			if (!_instance)
				_instance = new WorldMapInfo();
			
			return _instance;
		}
		  
		private static var _instance:WorldMapInfo = null;
		public function WorldMapInfo()
		{
		}
		
		//人物所在X位置
		private var _playerX:int = 0;
		[Bindable]
		public function get playerX():int{
			return _playerX;
		}
		public function set playerX(value:int):void{
			_playerX = value;
		}
		
		//人物所在Y位置
		private var _playerY:int = 0;
		[Bindable]
		public function get playerY():int{
			return _playerY;
		}
		public function set playerY(value:int):void{
			_playerY = value;
		}

	}
}