package com.glearning.melee.components
{
	import mx.containers.HBox;
	import mx.controls.Alert;
	import mx.controls.Image;

	public class ExChangeImpl extends HBox
	{
		public var exchange:Image;
		
		public function ExChangeImpl()
		{
			super();
		}
		override public function set data(value:Object):void {
			super.data = value;
			if(exchange == null)
			  exchange = new Image();
			exchange.source = 'images/business.gif';
		}
		
		public function playerExchange():void{
			Alert.show(data.id);
		}
	}
}