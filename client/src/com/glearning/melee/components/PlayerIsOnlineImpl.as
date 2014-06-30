package com.glearning.melee.components
{
	import mx.containers.HBox;
	import mx.controls.Image;

	public class PlayerIsOnlineImpl extends HBox
	{
		public var isOnline:Image;
		
		public function PlayerIsOnlineImpl()
		{
			super();
		}
	
  
		override public function set data(value:Object):void {
			super.data = value;
			if (value.isOnLine == true) {
				isOnline.source = 'images/sanGuo/icon-online.gif';
			} else {
				isOnline.source = 'images/sanGuo/icon-offline.gif';
			}
		}
	}
}