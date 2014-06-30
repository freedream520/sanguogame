package com.glearning.melee.components
{
	import mx.containers.HBox;
	import mx.controls.Image;

	public class PlayerCountryImpl extends HBox
	{
		public var country:Image;
		
		public function PlayerCountryImpl()
		{
			super();
		}
		
		
		
		override public function set data(value:Object):void {
			super.data = value;
			if (value.camp == '魏国') {
				country.source = 'images/sanGuo/placeplayer/WeiGuo.png';
			} else if(value.camp == '蜀国'){
				country.source = 'images/sanGuo/placeplayer/ShuGuo.png';
			}else
			{
				country.source = 'images/sanGuo/placeplayer/WuGuo.png';
			}
		}
		
	}
}