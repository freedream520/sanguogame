package com.glearning.melee.components.battle
{
	import mx.containers.Canvas;
	import mx.managers.PopUpManager;

	public class PlayerPKTipImpl extends Canvas
	{
		public function PlayerPKTipImpl()
		{
			super();
		}
		
		//关闭
		public function close():void{
			PopUpManager.removePopUp(this);
		}
	}
}