package com.glearning.melee.components.placepanel
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.controls.DataGrid;
	import mx.controls.LinkButton;
	import mx.core.Application;
	import mx.effects.Parallel;
	import mx.effects.Resize;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class PlacePlayerListImpl extends Canvas
	{
		public var watchMore:LinkButton;
		public var searchPlayer:LinkButton;
		public var placePlayerTable:PlacePlayerInfoComponent;
		public var searchPlayerComponent:SearchPlayerComponent;
		public var playerList:DataGrid;
		public var teamList:Array;
        public var teamTable:DataGrid;
        public var leave:LinkButton;
        public var turn:LinkButton;
        public var isLeader:Boolean;
        public var teamInfo:Button;
        public var showTeamEffect:Parallel;
        public var teamInfoList:VBox;
        public var closeTeamEffect:Parallel;
        public var teamContainer:VBox;
        public var shrink:Resize;
        public var expand:Resize;
        public var searchPanel:SearchPlayerComponent;
		public function PlacePlayerListImpl()
		{
			super();
			teamList = new Array();
		}
		
		public function initTeamTable():void
		{
			RemoteService.instance.noticeTeamMemberToRefreshTeamList(collection.playerId).addHandlers(initializeTeamMember2);
		}
		
		public function initializeTeamMember2(event:ResultEvent,token:AsyncToken):void
		{
			if(event.result['data'].members.length != 0)
			 {
			 	showTeamInfo2(event.result['data'].members);
			 	teamInfo.visible = true;
			 }			   
			else
			{
				
				teamContainer.visible = false;
			}
			   
		}
		
		public function showTeamInfo2(array:Array):void
		{
			teamInfo.visible = true;
			teamList.splice(0);
			teamList = array;
			if(array.length != 0)
			{
				teamContainer.visible = true;
				for(var i:int =0;i<teamList.length;i++)
				{
					if(teamList[i].nickname == MySelf.instance.nickName && teamList[i].isLeader == true)
					{
						isLeader = true;
						leave.label = '解散';
						teamTable.dragEnabled = true;
						teamTable.dropEnabled = true;
						teamTable.dragMoveEnabled = true;
						break;
					}
					leave.label = '退队';
					isLeader = false;
					teamTable.dragEnabled = false;
					teamTable.dropEnabled = false;
					teamTable.dragMoveEnabled = false;
				}
			}else
			{
				teamContainer.visible = false;
			}
		
			teamTable.dataProvider = teamList;
		}
		
		public function ListAllPlayer(event:MouseEvent):void
		{
			placePlayerTable = new PlacePlayerInfoComponent();
			placePlayerTable.type = 'more';
			placePlayerTable.addEventListener(CloseEvent.CLOSE,function():void{PopUpManager.removePopUp(placePlayerTable)});			
			PopUpManager.addPopUp(placePlayerTable,this.parent,true);
			PopUpManager.centerPopUp(placePlayerTable);
		}
		
		public function SearchPlayer(event:MouseEvent):void
		{
			playerList.visible = false;
			teamContainer.visible = false;		
			if(searchPanel == null)
			{
				searchPanel = new SearchPlayerComponent();
			}
			addChild(searchPanel);
			trace(searchPanel.parent);
			searchPanel.x =20;
			searchPanel.y =47;
			searchPanel.closeButton.addEventListener(MouseEvent.CLICK,removeSearchHandler);
		}
		
		public function removeSearchHandler(event:MouseEvent):void
		{
			removeChild(searchPanel);
			playerList.visible = true;
		}
		
		public function transferTeamLeader(event:MouseEvent):void
		{
			trace(teamTable.selectedItem.id);
			RemoteService.instance.transferTeamLeaderPosition(collection.playerId,teamTable.selectedItem.id).addHandlers(onTransferTeamLeaderPosition);
		}
		
		//队长转让回调
		public function onTransferTeamLeaderPosition(event:ResultEvent,token:AsyncToken):void
		{
			if(event.result.result == false)
			{
			   var tempTip:NormalTipComponent = new NormalTipComponent();
			   PopUpManager.addPopUp(tempTip,Application.application.canvas1,true);
			   PopUpManager.centerPopUp(tempTip);
			   tempTip.tipText.text = event.result.reason;
			   tempTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tempTip);});
			   	
			}else
			{
				MySelf.instance.isLeader = false;
				initTeamTable();
			}
		}
		
		public function disbandTeam(event:MouseEvent):void
		{
			if(isLeader == true)
			RemoteService.instance.disbandTeam(collection.playerId).addHandlers(onDisbandTeam);
			else 
			RemoteService.instance.leaveTeam(collection.playerId).addHandlers(onLeaveTeam);
		}
		
		public function dragEnterHandler(event:Event):void
		{
			setTimeout(function():void{
			var array:Array = new Array

			for(var n:int = 0;n<teamList.length;n++)
			{
				array.push(teamList[n].id);
			}
			RemoteService.instance.resortTeamMember(collection.playerId,array);},100);
		}
		
		//回调
		public function onDisbandTeam(event:ResultEvent,token:AsyncToken):void
		{
			if(event.result.result == true)
			{
				teamList.splice(0);
				initTeamTable();
				MySelf.instance.isLeader = false;
        		MySelf.instance.isTeamMember = false;
			}
		}
		
		public function onLeaveTeam(event:ResultEvent,token:AsyncToken):void
		{
			if(event.result.result == true)
			{
					teamList.splice(0);
					initTeamTable();
					MySelf.instance.isLeader = false;
        		    MySelf.instance.isTeamMember = false;
			}
		}
		
		public function moveTeamPanel(event:MouseEvent):void
		{		
			shrink.end();
			shrink.target = playerList;
			shrink.play();
			showTeamEffect.end();
			showTeamEffect.target = teamContainer;
			showTeamEffect.play();
			setTimeout(function():void{teamInfo.visible=false;teamInfo.includeInLayout = false;teamInfoList.visible=true;teamTable.visible=true;},200);
		}
		
		public function closeTeamPanel(event:MouseEvent):void
		{
			closeTeamEffect.end();
			closeTeamEffect.target = teamContainer;
			closeTeamEffect.play();
			expand.end();
			expand.target = playerList;
			expand.play();
			teamInfoList.visible=false;
			teamTable.visible=false;
			teamInfo.visible=true;
			teamInfo.includeInLayout = true;
			
		}
		
		
		
	}
}