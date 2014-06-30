package com.glearning.melee.components.placepanel
{
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.LinkButton;
	import mx.controls.TextInput;

	public class SearchPlayerImpl extends Canvas
	{
		public var searchName:TextInput;
		public var search:LinkButton;
		public function SearchPlayerImpl()
		{
			super();
		}
		
		public function changeButtonSize(event:MouseEvent):void
		{
			search.y = 200;
			search.height = 41;
		}
		
		public function resetButtonSize(event:MouseEvent):void
		{
			search.y = 210;
			search.height = 31;
		}
	
	}
}