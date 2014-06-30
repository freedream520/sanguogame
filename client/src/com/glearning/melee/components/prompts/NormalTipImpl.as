package com.glearning.melee.components.prompts
{
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.managers.PopUpManager;

	public class NormalTipImpl extends Canvas
	{
		public var tipText:Label;
		public var accept:LinkButton;
		public var cancel:LinkButton;
		
		public function NormalTipImpl()
		{
			super();
		}
		
		public function close():void{
			PopUpManager.removePopUp(this);
		}
		
		//隐藏取消按钮 
		public function hideButton():void{
			cancel.visible = false;
			cancel.includeInLayout = false ;
		}
		
	}
}