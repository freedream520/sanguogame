package com.glearning.melee.components.prompts
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.battle.BattleComponent;
	import com.glearning.melee.model.MySelf;
	import flash.utils.clearTimeout;
	import flash.events.MouseEvent;
	import mx.core.Application;
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.managers.PopUpManager;
	
	public class BattleTipImpl extends Canvas
	{
		public var tipInfo:Label;
		public var watchBattle:LinkButton;
		public var cancel:LinkButton;
		public var closeButton:LinkButton;
		
		public function BattleTipImpl()
		{
			super();
		}
		
		public function init():void
		{
			tipInfo.text = '你已处于战斗中状态';
			cancel.addEventListener(MouseEvent.CLICK,closeWindow);
			watchBattle.addEventListener(MouseEvent.CLICK,watchBattleWindow);
		}
		
		public function watchBattleWindow(e:MouseEvent):void
		{
			PopUpManager.removePopUp(this);
			if(MySelf.instance.status == '正常'){
				collection.errorEvent('战斗已结束！',null);
				return;
			}
			if(collection.battleWindow==null){
				//clearTimeout(collection.battleTimeOut);
				collection.isPopupBattle = false;
				collection.battleWindow = new BattleComponent();
				Application.application.addChild(collection.battleWindow);
			}else{
					collection.battleWindow.visible = true;
			}
		}
		
		public function closeWindow(e:MouseEvent):void
		{
			PopUpManager.removePopUp(this);
		}
		
	}
}