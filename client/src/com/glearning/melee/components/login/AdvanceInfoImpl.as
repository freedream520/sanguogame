package com.glearning.melee.components.login
{
	import mx.containers.HBox;
	import mx.controls.Label;

	public class AdvanceInfoImpl extends HBox
	{
		public var info:Label;
		
		public function AdvanceInfoImpl()
		{
			super();
		}
		
		override public function set data(value:Object):void {
			super.data = value;			
			info.text = data.title;
		}
		
	}
}