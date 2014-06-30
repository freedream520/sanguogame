package com.glearning.melee.components
{
	import mx.containers.HBox;
	import mx.controls.Image;

	public class PlayerCampImpl extends HBox
	{
		public var country:Image;
		
		public function PlayerCampImpl()
		{
			super();
		}
		
		override public function set data(value:Object):void {
			super.data = value;
			if(country == null)
			  country = new Image();
			if (value.camp == '魏') {
				country.source = 'images/sanGuo/team/wu.gif';		
			}else if(value.camp == '吴'){
				country.source = 'images/sanGuo/team/shu.gif';	
			}else
			{
				country.source = 'images/sanGuo/team/wei.gif';	
			}
			if(value.isLeader == true)
			    this.setStyle('borderColor','0xff0000');
			else
			    this.setStyle('borderColor','0x00EC00');
		}
		
	}
}