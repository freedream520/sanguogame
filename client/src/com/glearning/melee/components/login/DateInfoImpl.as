package com.glearning.melee.components.login
{
	import mx.containers.HBox;
	import mx.controls.Label;

	public class DateInfoImpl extends HBox
	{
		public var dateInfo:Label;
		
		public function DateInfoImpl()
		{
			super();
		}
		
		override public function set data(value:Object):void {
			super.data = value;			
			dateInfo.text = data.date;
		}
		
	}
}