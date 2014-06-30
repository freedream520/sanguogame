package com.glearning.melee.components.chat
{
	import mx.containers.Canvas;
	import mx.controls.LinkButton;

	public class ChannelChangeImpl extends Canvas
	{
		public var channel:LinkButton;
		
		public function ChannelChangeImpl()
		{
			super();
		}
		
		override public function set data(value:Object):void {
			super.data = value;
			channel.styleName = value;
		}
		
	}
}