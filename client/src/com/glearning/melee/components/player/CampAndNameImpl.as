package com.glearning.melee.components.player
{
	import mx.containers.HBox;
	import mx.controls.Image;
	import mx.controls.Label;

	public class CampAndNameImpl extends HBox
	{
		public var country:Image;
		public var nickname:Label;
		public function CampAndNameImpl()
		{
			super();
		}
		
		override public function set data(value:Object):void {
			super.data = value;
			if(country == null)
			  country = new Image();
			nickname.text = value.nickname;
			if (value.camp == '魏国') {
				country.source = 'images/sanGuo/team/wei.gif';		
			}else if(value.camp == '吴国'){
				country.source = 'images/sanGuo/team/wu.gif';	
			}else
			{
				country.source = 'images/sanGuo/team/shu.gif';	
			}
			
		}
		
	}
}