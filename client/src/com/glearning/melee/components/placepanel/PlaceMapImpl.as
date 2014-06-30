//吕忠涛
package com.glearning.melee.components.placepanel
{
	import com.glearning.melee.collections.LocationButton;
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.player.DeleteCopyProgressComponent;
	import com.glearning.melee.components.prompts.CustomerTooltipComponent;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.model.PlaceInfo;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.LinkButton;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.events.ToolTipEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class PlaceMapImpl extends Canvas
	{
		public var playerIcon:Image;
		public var instanceName:String;
		public var instanceId:int;
		public function PlaceMapImpl()
		{
			super();
			addEventListener(mx.events.FlexEvent.CREATION_COMPLETE, onUpdateComplete);
		}
		
		private function onUpdateComplete(e:Event):void {
			
		}
		
		//设置place场景
		public function setPlace(childs:Object):void{
			var children:int = this.getChildren().length -1
			for(children;children>=2;children--)
			{	
				this.removeChildAt(children);
			}
			for(var idx:Object in childs){

				if(childs[idx]['type'] == '区域' || childs[idx]['type'] == '副本'){
					PlaceInfo.instance.mapImg = childs[idx]['image'].toString();
				}
				var linkButton:LinkButton = LocationButton.createPlace(childs[idx]);
				linkButton.addEventListener(MouseEvent.CLICK, collection.enterPlace);
				addChild(linkButton);
			}
			
		}
		
		//placeMap地点事件
//		public function enterPlace(e:Event):void{
//			var placeId:int = e.currentTarget.id;
//			if(MySelf.instance.isTeamMember == false || (MySelf.instance.isLeader == true && MySelf.instance.isTeamMember == true)){
//				if(e.currentTarget.uid == 9000 && e.currentTarget.data == '地点')
//				{
//					RemoteService.instance.getInstanceStatus(collection.playerId,placeId).addHandlers(isEnterInstance);
//					instanceName = e.currentTarget.name;
//					instanceId = placeId;
//				}
//				else
//				{
//					RemoteService.instance.enterPlace(collection.playerId,placeId).addHandlers(collection.setEnterPlace);
//				}
//			}else{
//				
//			}
//		
//		}
		
//		public function isEnterInstance(event:ResultEvent,token:AsyncToken):void
//		{			
//			if(event.result == false)
//			{
//				var enterTip:DeleteCopyProgressComponent = new DeleteCopyProgressComponent();
//				PopUpManager.addPopUp(enterTip,Application.application.canvas1,true);
//				PopUpManager.centerPopUp(enterTip);
//				enterTip.tipContent.htmlText += '您是否确定要开始挑战'+instanceName+'?\n';
//				enterTip.tipContent.htmlText += '挑战副本需要消耗<font color="#FF7575">10</font>点活力和<font color="#FF7575">1</font>次副本挑战次数，如果您的活力或挑战次数不足则无法挑战\n';
//				enterTip.tipContent.htmlText += '注意：如果您保存有其他副本的进度，进入该副本会变为此副本的进度，原进度将会消失';
//				enterTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(enterTip);RemoteService.instance.enterInstance(collection.playerId,instanceId).addHandlers(onEnterInstance);});
//			}
//			else
//			{
//				var enterTip:DeleteCopyProgressComponent = new DeleteCopyProgressComponent();
//				PopUpManager.addPopUp(enterTip,Application.application.canvas1,true);
//				PopUpManager.centerPopUp(enterTip);
//				enterTip.tipContent.htmlText += '&nbsp;&nbsp;&nbsp;&nbsp;您保存有该副本的进度，使用此进度可以让您继续上次的进度挑战该副本，\n';
//				enterTip.tipContent.htmlText += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您是否想使用此进度?\n';
//				enterTip.tipContent.htmlText += '&nbsp;&nbsp;&nbsp;&nbsp;如果您想从头开始挑战，请在角色界面清除进度后再次挑战';
//				enterTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(enterTip);RemoteService.instance.enterInstance(collection.playerId,instanceId).addHandlers(onEnterInstance);});
//			}			
//		}
//		
//		public function onEnterInstance(event:ResultEvent,token:AsyncToken):void
//		{
//			if(event.result.result == false)
//			{
//				var normalTip:NormalTipComponent = new NormalTipComponent();
//				PopUpManager.addPopUp(normalTip,Application.application.canvas1,true);
//				PopUpManager.centerPopUp(normalTip);
//				normalTip.tipText.text = event.result.reason;			
//			}else
//			{
//				MySelf.instance.energy = event.result['data'].energy;
//				RemoteService.instance.enterPlace(collection.playerId,event.result['data'].layer).addHandlers(collection.setEnterPlace);
//			}
//		}
		
		public function directEnterInstance(event:ResultEvent,token:AsyncToken):void
		{
			RemoteService.instance.enterPlace(collection.playerId,event.result['data'].layer).addHandlers(collection.setEnterPlace);
		}

         public  function createCustomToolTip(event:ToolTipEvent):void {   
             var toolTip:CustomerTooltipComponent = new CustomerTooltipComponent();  
             toolTip.tip = event.target.name;             
             toolTip.init(7);
             event.toolTip = toolTip; 
         } 
		
	}
}