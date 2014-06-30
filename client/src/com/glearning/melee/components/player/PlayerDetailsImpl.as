package com.glearning.melee.components.player
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.friendsSystem.FriendsSystemComponent;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class PlayerDetailsImpl extends Canvas
	{
		public var profession:Label;
		public var camp:Label;
		public var showFB:LinkButton;
		public var deleteFB:LinkButton
		public var normalTip:NormalTipComponent;
		public var deleteCopyTip:DeleteCopyProgressComponent;
		public function PlayerDetailsImpl()
		{
			super();
		}
		
		public function init():void
		{
			showFB.addEventListener(MouseEvent.CLICK,clickForFB);
			deleteFB.addEventListener(MouseEvent.CLICK,clickForDeleteFB);
			for(var i:int = 0;i<MySelf.instance.allProfessionStages.length;i++)
			{				
				if(i==0)
				{
				   if(i == MySelf.instance.currentProfessionStageIndex as int)
			       profession.htmlText += "<font color='#ff0000'>"+MySelf.instance.allProfessionStages[i].toString()+"</font>";
			       else
			       {
			       profession.htmlText += MySelf.instance.allProfessionStages[i].toString();
			       }
			    }
			    else{
			    if(i == MySelf.instance.currentProfessionStageIndex as int)
			       profession.htmlText += "><font color='#ff0000'>"+MySelf.instance.allProfessionStages[i].toString()+"</font>";
			    else{
			    profession.htmlText += ">"+MySelf.instance.allProfessionStages[i].toString();
			    }
			    }
			    
			}
			
//			if(MySelf.instance.camp == 1){
//				camp.text = '魏国';
//			}else if(MySelf.instance.camp == 2){
//				camp.text = '蜀国';
//			}else if(MySelf.instance.camp == 3){
//				camp.text = '吴国';
//			}else if(MySelf.instance.camp == 9){
//				camp.text = '中立';
//			}else{
//				camp.text = '在野';
//			}
            changeCamp();
		}
		
		public function changeCamp():void
		{
			if(MySelf.instance.camp == 1){
				camp.text = '魏国';
			}else if(MySelf.instance.camp == 2){
				camp.text = '蜀国';
			}else if(MySelf.instance.camp == 3){
				camp.text = '吴国';
			}else if(MySelf.instance.camp == 9){
				camp.text = '中立';
			}else{
				camp.text = '在野';
			}
		}
		
		public function clickForFB(event:MouseEvent):void
		{
			RemoteService.instance.getPlayerInstanceProgress(collection.playerId).addHandlers(onGetPlayerInstanceProgress);
		}
		
		public function clickForDeleteFB(event:MouseEvent):void
		{
			deleteCopyTip = new DeleteCopyProgressComponent();		
			PopUpManager.addPopUp(deleteCopyTip,Application.application.canvas1,true);
			PopUpManager.centerPopUp(deleteCopyTip);
			deleteCopyTip.tipContent.width = 312;
			deleteCopyTip.tipContent.height = 104;
			deleteCopyTip.tipContent.htmlText = '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您的副本进度可以使您直接到达您上次副本冒险到达的关卡，每个角色同时只能保存一个副本进度\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如果您清楚您的副本进度则只能从头开始挑战\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您确定要清除您的副本进度吗？';
			deleteCopyTip.accept.addEventListener(MouseEvent.CLICK,function():void{RemoteService.instance.clearPlayerInstanceProgressInfo(collection.playerId).addHandlers(onClearInstance);});
		}
		
		public function onClearInstance(event:ResultEvent,token:AsyncToken):void
		{
			if(event.result.result == false)
			{
				normalTip = new NormalTipComponent();
				PopUpManager.addPopUp(normalTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(normalTip);
				normalTip.tipText.text = event.result.reason;		
			}
			else
			{
				normalTip = new NormalTipComponent();
				PopUpManager.addPopUp(normalTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(normalTip);
				normalTip.tipText.text = '清除副本成功';
				RemoteService.instance.enterPlace(collection.playerId,event.result['data'].location).addHandlers(collection.setEnterPlace);
			}
			normalTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normalTip);PopUpManager.removePopUp(deleteCopyTip)});
		}
		
		public function onGetPlayerInstanceProgress(event:ResultEvent,token:AsyncToken):void
		{
			if(event.result['data'].instanceProgressInfo == null)
			{
				normalTip = new NormalTipComponent();
				PopUpManager.addPopUp(normalTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(normalTip);
				normalTip.tipText.text = '您当前无副本进度记录';				
			}else
			{
				normalTip = new NormalTipComponent();
				PopUpManager.addPopUp(normalTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(normalTip);
				normalTip.tipText.htmlText = '您当前副本进度:<font color="#FF7575">'+event.result['data'].instanceProgressInfo.instanceName+'&nbsp;&nbsp;'+event.result['data'].instanceProgressInfo.instanceLayerName+'</font>';
			}
			normalTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normalTip);});
		}
		
		//打开好友系统界面
		public function openFriendsSystem():void{
			var friendsSystem:FriendsSystemComponent = new FriendsSystemComponent();
			PopUpManager.addPopUp(friendsSystem,Application.application.canvas1,true);
	        PopUpManager.centerPopUp(friendsSystem);
		}
	}
}