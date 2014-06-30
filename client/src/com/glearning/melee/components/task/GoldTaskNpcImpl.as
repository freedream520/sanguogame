package com.glearning.melee.components.task
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.ProcedureHall.ProcedureHallPanleComponent;
	import com.glearning.melee.components.newplayerquest.NpcGuideComponent;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.LinkButton;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class GoldTaskNpcImpl extends Canvas
	{
		public var npcTalk:Text;
		public var npcId:int;
		public var npcImage:String;
		public var talkButton:LinkButton;
		public var talkInfo:String;
		public var npcName:String
		public function GoldTaskNpcImpl()
		{
			super();
		}
		
		public function init():void
		{
			talkButton.addEventListener(MouseEvent.CLICK,showTaskPanel);
			glowTalk();
		}
		
		public function showTaskPanel(event:MouseEvent):void
		{
			
			if(MySelf.instance.isNewPlayer == 0)
			{				
				var npcTask:NpcTaskComponent = new NpcTaskComponent();
	            PopUpManager.addPopUp(npcTask,Application.application.canvas1,true);
	            PopUpManager.centerPopUp(npcTask);
	            npcTask.npcImage.source = npcImage;           
	            npcTask.npcId = npcId;            
	            npcTask.npcName.text = npcName ;
	            npcTask.closeButton.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(npcTask)});
	            var npcTaskList:NpcTaskListComponent = new NpcTaskListComponent();
	            npcTaskList.acceptInfo = talkInfo;
	            npcTaskList.npcId = npcId;
	            npcTask.npcTalkTask.addChild(npcTaskList);
			}else if(MySelf.instance.isNewPlayer == 1)
			{
				var npcGuide:NpcGuideComponent = new NpcGuideComponent();
				npcGuide.type = 0;			
				if(MySelf.instance.progress == 1 && talkButton.parent.parent is ProcedureHallPanleComponent)
				{
					npcGuide.finishGuide = '欢迎你来到这个世外桃源，年轻人。我从你的眼睛里能看出你的大志，你可以尽管在这里磨练一下，准备好应付外界的各种挑战，我相信总有一天你会成为真正的英雄。';
					PopUpManager.addPopUp(npcGuide,Application.application.canvas1,true);
					PopUpManager.centerPopUp(npcGuide);
					npcGuide.finish.addEventListener(MouseEvent.CLICK,function():void{RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onNewPlayerQuestInfo);
						       PopUpManager.removePopUp(npcGuide);});
				}else if(MySelf.instance.progress == 9 && talkButton.parent.parent is GoldTaskComponent)
				{
					npcGuide.finishGuide = '恩？请找事做？最近请出人头地的年轻人越来越多了嘛。也好，以后常来看看吧，完成的好自然有丰厚的奖励等着你。来，拿着这个，会对你有用的。';
					PopUpManager.addPopUp(npcGuide,Application.application.canvas1,true);
					PopUpManager.centerPopUp(npcGuide);
					npcGuide.npcImg.source = 'images/npc/shop170/ShangJin.jpg';
					npcGuide.npcName.text = '赏金猎人';
					npcGuide.finish.addEventListener(MouseEvent.CLICK,function():void{RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onNewPlayerQuestInfo);
						       PopUpManager.removePopUp(npcGuide);});
				}else if(MySelf.instance.progress == 11 && talkButton.parent.parent is ProcedureHallPanleComponent && MySelf.instance.isKilled ==1)
				{
					npcGuide.finishGuide = '年轻人有勇有谋，勇气可嘉，这里是给你的奖励';
					PopUpManager.addPopUp(npcGuide,Application.application.canvas1,true);
					PopUpManager.centerPopUp(npcGuide);				
					npcGuide.finish.addEventListener(MouseEvent.CLICK,function():void{RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onNewPlayerQuestInfo);
						       PopUpManager.removePopUp(npcGuide);});
				    RemoteService.instance.changePlayerHasKilledMonster(collection.playerId,0).addHandlers(onChangePlayerHasKilledMonster);
				}else if(MySelf.instance.progress == 12 && talkButton.parent.parent is ProcedureHallPanleComponent && MySelf.instance.isKilled ==1)
				{
					npcGuide.finishGuide = '你再次证明了你是个战斗好手，来，这是给你的奖励';
					PopUpManager.addPopUp(npcGuide,Application.application.canvas1,true);
					PopUpManager.centerPopUp(npcGuide);				
					npcGuide.finish.addEventListener(MouseEvent.CLICK,function():void{RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onNewPlayerQuestInfo);
						       PopUpManager.removePopUp(npcGuide);});
				    RemoteService.instance.changePlayerHasKilledMonster(collection.playerId,0).addHandlers(onChangePlayerHasKilledMonster);
				}else if(MySelf.instance.progress == 13 && talkButton.parent.parent is ProcedureHallPanleComponent && MySelf.instance.isKilled ==1)
				{
					npcGuide.finishGuide = '很好，你现在已经是一位有经验的武将了，这是给你的奖赏';
					PopUpManager.addPopUp(npcGuide,Application.application.canvas1,true);
					PopUpManager.centerPopUp(npcGuide);				
					npcGuide.finish.addEventListener(MouseEvent.CLICK,function():void{RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onNewPlayerQuestInfo);
						       PopUpManager.removePopUp(npcGuide);});
				    RemoteService.instance.changePlayerHasKilledMonster(collection.playerId,0).addHandlers(onChangePlayerHasKilledMonster);
				}else if(MySelf.instance.progress == 15 && talkButton.parent.parent is ProcedureHallPanleComponent)
				{
					npcGuide.finishGuide = '收拾行装准备起行吧。这里送你一把武器，用以防身';
					PopUpManager.addPopUp(npcGuide,Application.application.canvas1,true);
					PopUpManager.centerPopUp(npcGuide);				
					npcGuide.finish.addEventListener(MouseEvent.CLICK,function():void{RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onNewPlayerQuestInfo);
						       PopUpManager.removePopUp(npcGuide);});
				    if(MySelf.instance.profession == '勇士系' || MySelf.instance.profession == '卫士系')
				    {
				    	RemoteService.instance.sendNewPlayerThing(collection.playerId,2,2,4).addHandlers(onSendNewPlayerThing);
				    }else if(MySelf.instance.profession == '武士系' || MySelf.instance.profession == '侠士系')
				    {
				    	RemoteService.instance.sendNewPlayerThing(collection.playerId,52,2,4).addHandlers(onSendNewPlayerThing)
				    }else if(MySelf.instance.profession == '谋士系' || MySelf.instance.profession == '术士系')
				    {
				    	RemoteService.instance.sendNewPlayerThing(collection.playerId,102,2,4).addHandlers(onSendNewPlayerThing)
				    }
				}
			}
			
		}
	
		
		//新手指导
		public function onNewPlayerQuestInfo(event:ResultEvent,token:AsyncToken):void
		{
			RemoteService.instance.addReward(collection.playerId,event.result['data'][0][3],event.result['data'][0][5],event.result['data'][0][4]).addHandlers(onAddReward);
//		    talkButton.endEffect();
		}
		
		public function onSendNewPlayerThing(event:ResultEvent,token:AsyncToken):void
		{
			RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(collection.onLoadPlayerResult);
		}
		
		public function onChangePlayerHasKilledMonster(event:ResultEvent,token:AsyncToken):void
		{
			MySelf.instance.isKilled = 0;
		}
		
		public function onAddReward(event:ResultEvent,token:AsyncToken):void
		{
			RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(collection.onLoadPlayerResult);
			RemoteService.instance.changeQuestProgress(collection.playerId,MySelf.instance.progress+1).addHandlers(onChangeQuestProgress);
			MySelf.instance.progress = MySelf.instance.progress+1;
		
		}
		
		public function onChangeQuestProgress(event:ResultEvent,token:AsyncToken):void
		{
			Application.application.newPlayerQuestProgress(event.result.progress);
			Application.application.frashMiniTask();
		}
		
		//交谈闪烁
		public function glowTalk():void
		{
			if(MySelf.instance.isNewPlayer == 1)
			{
				if(MySelf.instance.progress == 1 || MySelf.instance.progress == 9 || MySelf.instance.progress == 11 ||
				   MySelf.instance.progress == 12 || MySelf.instance.progress == 13 || MySelf.instance.progress == 15
				   )
				{
//					talkButton.startEffect();
				}
			}
		}
	}
}