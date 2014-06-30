package com.glearning.melee.components
{
	import com.glearning.melee.components.battle.PlayerPKTipComponent;
	
	import mx.containers.HBox;

	import mx.controls.Image;

	import mx.managers.PopUpManager;
	import mx.core.Application;

	public class PlayerPKImpl extends HBox
	{
		public var playerPK:Image
		
		public function PlayerPKImpl()
		{
			super();
		}
		override public function set data(value:Object):void {
			super.data = value;
			if(playerPK == null)
			playerPK = new Image();
			playerPK.source = 'images/attack.gif';
		}
		
		public function PK():void{
			var pkTip:PlayerPKTipComponent = new PlayerPKTipComponent();
			PopUpManager.addPopUp(pkTip,Application.application.canvas1,true);
			PopUpManager.centerPopUp(pkTip);
		}
	}
}