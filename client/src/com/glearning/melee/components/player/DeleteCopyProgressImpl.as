package com.glearning.melee.components.player
{
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.LinkButton;
	import mx.managers.PopUpManager;
	public class DeleteCopyProgressImpl extends Canvas
	{
		public var cancel:LinkButton;
		
		public function DeleteCopyProgressImpl()
		{
			super();
		}
		
		public function init():void
		{
			cancel.addEventListener(MouseEvent.CLICK,closePopUp);
		}
		
		public function closePopUp(event:MouseEvent):void
		{
			PopUpManager.removePopUp(this);
		}
		
	}
}