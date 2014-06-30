package com.glearning.melee.components.task
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.components.prompts.PayMoneyComponent;
	import com.glearning.melee.components.utils.TimeUtil;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.model.TaskInfo;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.messaging.events.MessageEvent;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class GoldTaskImpl extends Canvas
	{
		public var NpcIntroduce:Text;
		public var Npc:GoldTaskNpcComponent;
		public var npcImage:String;
		public var npcDescription:String;
		public var taskList:TaskGridComponent;
		public var closeButton:LinkButton;
		public var placeId:int;
		public var autoComponent:UIComponent;
		public var date:int;
        public var npcId:int;
        public var playerTask:CurrentTaskListComponent;
        public var tempUI:UIComponent;
        public var targetUI:UIComponent;
        public var payMoney:PayMoneyComponent;
        public var money:int;
        public var payForId:int;
        public var countTime:TimeUtil;
//		public var timer:Timer;
		public var tempAutoButton:UIComponent;
		public var npcTask:NpcTaskComponent;
		public var refashObject:Object;
		public var currentActiveQueueArray:Array;
		public var locked:Boolean = false;
		public var currentAutoTask:String;
		public var manualTask:String;
		public function GoldTaskImpl()
		{
			super();
		}
		
		public function init():void
		{			
			
			RemoteService.instance.subscribe( collection.playerId.toString(), gotServerPushs );
			closeButton.addEventListener(MouseEvent.CLICK,backToPlace);	
			Npc.npcTalk.htmlText = "任务头目：<br/>别看我英俊潇洒，风度翩翩，天生练武奇才，还不是练这些任务成长的。<br/>" + 
					           "<font color='#ff0000'>战斗型</font>任务：可获得经验奖励。<font color='#ff0000'>收集型</font>任务：" + 
					           "可获得铜币奖励。<br/><font color='#ff0000'>竞技型</font>任务：可获得声望奖励。<font color='#ff0000'>刺杀型</font>任务：" + 
					           "可获得国家贡献和精力点奖励。"
		    initList();
			//addFrushImmediate(taskList.frushImmediate,npcId);
           
		}
		
		
		
		public function initList():void{
		 
		    RemoteService.instance.getActiveRewardQuestPanelInfo(collection.playerId,placeId).addHandlers(onActiveRewardQuestPanelInfo);
			
		}
		
		public  function gotServerPushs(event:MessageEvent):void{
			if(event.message.body.toString() == 'questFinish'){
				RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(collection.onLoadPlayerResult);
				RemoteService.instance.getActiveRewardQuestPanelInfo(collection.playerId,placeId).addHandlers(onActiveRewardQuestPanelInfo);
			}else if(event.message.body.toString() == 'restFinish'){
				RemoteService.instance.getActiveRewardQuestPanelInfo(collection.playerId,placeId).addHandlers(onActiveRewardQuestPanelInfo);
				//RemoteService.instance.autoRefreshActiveRewardQuestList(collection.playerId,npcId).addHandlers(onRefreshActiveRewardQuestList);
			}
		}
		
		public function onActiveRewardQuestPanelInfo(event:ResultEvent,token:AsyncToken):void
		{
           TaskInfo.instance.taskNum = event.result['data'].currentRewardQuestCount;         
//           if (npcId == 0){
//           	RemoteService.instance.autoRefreshActiveRewardQuestList(collection.playerId,event.result['data'].npcInfo.id).addHandlers(onRefreshActiveRewardQuestList);
//           }
		   npcId = Npc.npcId = event.result['data'].npcInfo.id;
		   npcImage = Npc.npcImage = event.result['data'].npcInfo.image;
		   Npc.npcPic.source = event.result['data'].npcInfo.image;
		   npcDescription = Npc.talkInfo = event.result['data'].npcInfo.dialogContent;
		   Npc.npcName = event.result['data'].npcInfo.name;
		   if(countTime == null)
		   {
			   countTime = new TimeUtil(event.result['data'].intervalSeconds as int);		   
//			   timer = new Timer(1000,event.result['data'].intervalSeconds as int);
			   BindingUtils.bindProperty(taskList.date,"text",countTime,"time"); 
//               taskList.date.text = countTime.countTime;    
		       countTime.startCount();
//		       timer.start();
	       }
		   refashObject = event.result['data'] as Object;
		   refrashPanel(event.result['data'] as Object);
			
		}
		
		public function freshTimeEvent(event:TimerEvent):void
		{
			//RemoteService.instance.autoRefreshActiveRewardQuestList(collection.playerId,npcId).addHandlers(onRefreshActiveRewardQuestList);      
		}
		
		public function refrashPanel(object:Object):void
		{
			currentActiveQueueArray = new Array();
		    taskList.lists.removeAllChildren();	 
		    playerTask.masterTask.removeAllChildren();
		    playerTask.otherTask.removeAllChildren();  
		    playerTask.goldTask.removeAllChildren();    		
			var currentTaskArray:Array = object.progressQuestList as Array;
		   for(var m:int =0;m<currentTaskArray.length;m++)
			{
				for(var n:int =0 ; n<currentTaskArray[m].length;n++)
				{
					var parentBox:HBox = new HBox();
					switch(m)
					{
						case 0:var masterTask:LinkButton = new LinkButton();
						       masterTask.setStyle('alpha',0);						       
						       parentBox.percentWidth = 100;
						       parentBox.addChild(masterTask);						       
						       masterTask.label = currentTaskArray[m][n].name;						       
						       masterTask.setStyle('color','0xff0000');
						       addAcceptEventHandler(masterTask,currentTaskArray[m][n].id,false);
						       playerTask.masterTask.addChild(parentBox);
						       break;
						case 1:var otherTask:LinkButton = new LinkButton();
						       otherTask.setStyle('alpha',0);
						       parentBox.percentWidth = 100;
						       parentBox.addChild(otherTask);						       
						       otherTask.label = currentTaskArray[m][n].name;						      
						       otherTask.setStyle('color','0xff0000');
						       addAcceptEventHandler(otherTask,currentTaskArray[m][n].id,false);
						       playerTask.otherTask.addChild(parentBox);
						       break; 
						case 2:var goldTask:LinkButton = new LinkButton();
						       goldTask.setStyle('alpha',0);
						       parentBox.percentWidth = 100;
						       parentBox.addChild(goldTask);						       
						       goldTask.label = currentTaskArray[m][n].name;						       
						       goldTask.setStyle('color','0xff0000');
						       addAcceptEventHandler(goldTask,currentTaskArray[m][n].id,false);
						       playerTask.goldTask.addChild(parentBox);
						       break;             
					}
				}
			}				
			var array:Array = object.activeRewardQuestList as Array;
			array.sort(sortFunction);
			for(var i:int =0;i<array.length;i++)
			{
				var buttons:HBox = new HBox();	
				buttons.setStyle('horizontalAlign','center');
				buttons.width = 178;
				buttons.setStyle('horizontalGap','0');			
				var id:int = array[i][0] as int;
				//任务名称按钮
				var taskName:LinkButton = new LinkButton();
				taskName.label = array[i][5].toString();
				taskName.alpha = 0;
				taskName.width = 142;				
				var taskType:Label = new Label();
				taskType.text = '赏金任务';
				taskType.width = 57;
				taskType.setStyle('textAlign','center');
				var taskCategory:Label = new Label();
				taskCategory.text = array[i][6].toString();
				taskCategory.width = 57;
				taskCategory.setStyle('textAlign','center');
				//已完成的任务
				if(array[i][1] == 1)
				{		
					var finished:Label = new Label();
					buttons.addChild(finished);					
					finished.htmlText = '<font color="#04B404">已完成</font>';
					addAcceptEventHandler(taskName,id,false);
				}else //未接受的任务
				{
					if(array[i][3] == 0)
					{	
					    var autoFinish_1:LinkButton = new LinkButton();
						buttons.addChild(autoFinish_1);
						autoFinish_1.styleName = 'goldTaskStyle';	
						autoFinish_1.alpha = 0;					
						autoFinish_1.label = '自动完成';	
						addAutoEventHandler(autoFinish_1,taskName,array[i][0] as int);
						var acceptTask:LinkButton = new LinkButton();
						buttons.addChild(acceptTask);
						acceptTask.styleName = 'goldTaskStyle';
						acceptTask.alpha = 0;
						acceptTask.label = '接受任务';
						changeEventHandler(autoFinish_1,taskName,acceptTask,id);						
						addAcceptEventHandler(taskName,id,true);								
				    }else//进行中的任务
				    {
				    	//手动接受任务
				 	    if(array[i][7] == -1)
				 	   {
				 		var autoFinish_2:LinkButton = new LinkButton();
						buttons.addChild(autoFinish_2);
						autoFinish_2.styleName = 'goldTaskStyle';
						autoFinish_2.alpha = 0;						
						autoFinish_2.label = '自动完成';	
						addAutoEventHandler(autoFinish_2,taskName,array[i][0] as int);
						var progressing:Label = new Label();										
						progressing.htmlText = '<font color="#ff0000">进行中</font>';
						buttons.addChild(progressing);	
						addAcceptEventHandler(taskName,id,false);									
				 	   }else//自动完成任务
				 	   {
				 	   	locked = true;
				 	   	currentAutoTask = array[i][5].toString();
				 		var immediateFinish:LinkButton = new LinkButton();
						buttons.addChild(immediateFinish);
						immediateFinish.alpha = 0;
						immediateFinish.label = '立即完成';
						addImmediateFinishHandler(immediateFinish,array[i][0] as int);	
						var timeUtil:TimeUtil = new TimeUtil(array[i][7] as int);			          
//			            var timer:Timer = new Timer(1000,array[i][7] as int);	          
			            var timeCount:Label = new Label();	
			            buttons.addChild(timeCount);		         
			            BindingUtils.bindProperty(timeCount,"text",timeUtil,"time");	
			            timeUtil.startCount();
//			            timer.start();
			            var progress:Label = new Label();
						buttons.addChild(progress);
						progress.htmlText = '<font color="#ff0000">进行中</font>';
						addAcceptEventHandler(taskName,id,false);
				 	}
				    }
				}				
						
					var hbox:HBox = new HBox();
					hbox.addChild(taskName);
					hbox.addChild(taskType);
					hbox.addChild(taskCategory);
					hbox.addChild(buttons);
					taskList.lists.addChild(hbox);
				}	
		}
		
		public function sortFunction(a:Array,b:Array):int
		{
			var aNum:int = a[4];
			var bNum:int = b[4];
			if(aNum > bNum) {
             return 1;
		    } else if(aNum < bNum) {
		     return -1;
		    } else  {		        
		     return 0;
		    }

		}
		
		public function changeEventHandler(autoUI:UIComponent,nameUI:UIComponent,acceptUI:UIComponent,id:int):void
		{
			acceptUI.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{targetUI = e.currentTarget as LinkButton;RemoteService.instance.getRecievableQuestDetails(collection.playerId,id).addHandlers(onQuestDetails)});
			tempUI = nameUI;
			tempAutoButton = autoUI;
			
		}
		
		public function addAutoEventHandler(ui:UIComponent,taskName:UIComponent,uid:int):void
		{
//			initList();
			ui.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
		    if(locked == false)
		    {		    	
		    	autoComponent = e.currentTarget as LinkButton;
				RemoteService.instance.autoFinishActiveRewardQuest(collection.playerId,uid).addHandlers(onFinishActiveRewardQuest);
		    }
			else
			{
				collection.errorEvent('你同时只能委托 1 项任务，请等待任务完成才能再次委托！',null);
			}
			});
            tempUI = taskName;
		}
		
		
		
		public function onFinishActiveRewardQuest(event:ResultEvent,token:Object):void
		{
//			initList();
	        if(event.result['result'] == true)
	        {
	        	locked = true;
	        	TaskInfo.instance.taskNum = event.result['data'].currentRewardQuestCount;
	            refrashPanel(event.result['data'] as Object);
	            var container:HBox = autoComponent.parent as HBox;
	            container.removeAllChildren();
	            var timeUtil:TimeUtil = new TimeUtil(event.result['data'].autoFinishTime as int);	          
//	            var timer:Timer = new Timer(1000,event.result['data'].autoFinishTime as int);	          
	            var timeCount:Label = new Label();	         
	            BindingUtils.bindProperty(timeCount,"text",timeUtil,"time");
	            timeUtil.startCount();
//	            timer.start();
	            var immediateFinish:LinkButton = new LinkButton();
	            immediateFinish.label = '立即完成';	         
	            addImmediateFinishHandler(immediateFinish,event.result['data'].questRecordId as int);             
	            var progress:Label = new Label();
	            progress.htmlText = '<font color="#ff0000">进行中</font>';
	            container.addChildAt(immediateFinish,0);
	            container.addChildAt(timeCount,1);
	            container.addChildAt(progress,2);	        	
	        }
	        else
	        {
	        	var falseTip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(falseTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(falseTip);
				falseTip.tipText.text = event.result['reason'].toString();
				falseTip.hideButton();
				falseTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(falseTip);});
	        }
		}
		
		public function backToPlace(event:MouseEvent):void
		{
			Application.application.currentState =  'city';
		}
		
		public function addImmediateFinishHandler(ui:UIComponent,tid:int):void
		{
			
			ui.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{payForId = tid;autoComponent = e.currentTarget as LinkButton;RemoteService.instance.getImmediateFinishTime(collection.playerId,tid).addHandlers(onImmediateFinishActiveRewardQuest);});
			
		}
		
		public function onImmediateFinishActiveRewardQuest(event:ResultEvent,token:Object):void
		{
			if(event.result['result'] == true)
			{
				var leftSeconds:int = event.result['data'].leftSeconds;
				money = leftSeconds/60/10;
                if(money < 1)
                  money = 1;
				payMoney = new PayMoneyComponent();
				payMoney.amount = money.toString();
				payMoney.description = '完成该任务吗？';
				PopUpManager.addPopUp(payMoney,Application.application.canvas1,true);
				PopUpManager.centerPopUp(payMoney);
				payMoney.payMoneyOK.addEventListener(MouseEvent.CLICK,payForTask);
				
			}else
			{
				var falseTip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(falseTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(falseTip);
				falseTip.tipText.text = event.result['reason'].toString();
				falseTip.hideButton();
				falseTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(falseTip);});
			}
		}
		
		public function payForTask(event:MouseEvent):void
		{
			if(payMoney.gold.selected == true)
			{
			   RemoteService.instance.immediateFinishActiveRewardQuest(collection.playerId,payForId,'gold',money).addHandlers(payForFinishTask);
			   
			}else
			{
			   RemoteService.instance.immediateFinishActiveRewardQuest(collection.playerId,payForId,'coupon',money).addHandlers(payForFinishTask);
			}
			locked = false;
			   
		}
		
		public function payForFinishTask(event:ResultEvent,token:AsyncToken):void
		{
			if(event.result['result'] == true)
			{
				if(event.result['data'].gold != 0)
				MySelf.instance.gold = event.result['data'].gold;
				if(event.result['data'].coupon != 0)
				MySelf.instance.coupon = event.result['data'].coupon;
				if(event.result['data'].coin != 0)
				MySelf.instance.coin = event.result['data'].coin;
				if(event.result['data'].exp != null)
				MySelf.instance.exp = event.result['data'].exp;
				PopUpManager.removePopUp(payMoney);
				refrashPanel(event.result['data'] as Object);
				var container:HBox = autoComponent.parent as HBox;
			    container.removeAllChildren();
				var finish:Label = new Label();
				finish.setStyle('textAlign','center');
				finish.htmlText = '<font color="#04B404">已完成</font>';
				container.addChild(finish);
				Application.application.baseAvatar.update();
			}else
			{
				var falseTip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(falseTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(falseTip);
				falseTip.tipText.text = event.result['reason'].toString();
				falseTip.hideButton();
				falseTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(falseTip);});
			}
		}
		
		public function refrushMoney(event:ResultEvent,token:AsyncToken):void
		{
			if(event.result['result'] == true)
			{
				refrashPanel(event.result['data'] as Object);
				PopUpManager.removePopUp(payMoney);
				MySelf.instance.gold = event.result['data'].gold;
				MySelf.instance.coupon = event.result['data'].coupon;
				countTime.resetTimer(7200);
//				timer.reset();
//				timer.start();
			}
			else
			{
			    var falseTip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(falseTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(falseTip);
				falseTip.tipText.text = event.result['reason'].toString();
				falseTip.hideButton();
				falseTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(falseTip);});
			}
		}
		
		public function addAcceptEventHandler(ui:UIComponent,tid:int,flag:Boolean):void
		{			
			if(flag == true)
			ui.addEventListener(MouseEvent.CLICK,function():void{targetUI = ui;RemoteService.instance.getRecievableQuestDetails(collection.playerId,tid).addHandlers(onQuestDetails)});
            else
            ui.addEventListener(MouseEvent.CLICK,function():void{targetUI = ui;RemoteService.instance.getQuestDetails(collection.playerId,tid).addHandlers(onQuestDetails)});
		}
		
		public function onQuestDetails(event:ResultEvent,token:Object):void
		{
			npcTask = new NpcTaskComponent();
			PopUpManager.addPopUp(npcTask,Application.application.canvas1,true);
			PopUpManager.centerPopUp(npcTask);			
			npcTask.npcName.text = event.result['data'].providerInfo.name;
			npcTask.closeButton.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(npcTask);});
			var taskDetail:TalkTaskDetailComponent = new TalkTaskDetailComponent();
			npcTask.npcTalkTask.addChild(taskDetail);
			taskDetail.taskName.htmlText = '<font size="14">'+event.result['data'].name+'</font>';
			switch(event.result['data'].type)
			{
			   case 1:taskDetail.taskType.htmlText = "<font color='#ff0000'>主线任务</font>";break;
			   case 2:taskDetail.taskType.htmlText = "<font color='#ff0000'>赏金任务</font>";break;
			   case 3:taskDetail.taskType.htmlText = "<font color='#ff0000'>支线任务</font>";break;
			   case 4:taskDetail.taskType.htmlText = "<font color='#ff0000'>转职任务</font>";break;
			}
		    taskDetail.description.text = event.result['data'].providerDialog;
		    var taskArray:Array;
		     if(event.result['data'].questType == 'receieval')
			    {
			      taskArray = event.result['data'].questgoals as Array;
			      npcTask.npcImage.source = (event.result['data'].providerInfo.image as String).replace("32","170");
			      taskDetail.accept.label = '接受';
			      addEventAcceptHandler( taskDetail.accept,event.result['data'].id as int);
			    }else if(event.result['data'].questType == 'progressing')
			    {
			      taskArray = event.result['data'].progressesDetails as Array;
			      npcTask.npcImage.source = (event.result['data'].accepterInfo.image as String).replace("32","170");
			      taskDetail.accept.label = '完成';
			      manualTask = event.result['data'].name;
			      addEventCommitHandler( taskDetail.accept,event.result['data'].id as int);	
			    }else
			    {
			      npcTask.npcImage.source = (event.result['data'].accepterInfo.image as String).replace("32","170");
			      taskArray = event.result['data'].progressesDetails as Array;
			      taskDetail.accept.visible = false;
			      taskDetail.backForward.visible = false;
			    }
		   
		    for(var i:int = 0; i<taskArray.length;i++)
		    {
		    	 taskDetail.target.htmlText += (i+1)+'.前往&nbsp;&nbsp;';
		    	 var placeArray:Array = taskArray[i].parentPlaceList as Array;
		    	  if( taskArray[i].killCount != 0)
				  {
					  for(var m:int = 0 ;m<placeArray.length ; m++)
					  {
					  	if( m == (placeArray.length-1))
					  	{
					  		taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[m].toString()+'</font>&nbsp;&nbsp;';
					  		break;
					  	}
					  	taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[m].toString()+'</font>&nbsp;&nbsp;-&nbsp;&nbsp;'				  	
					  }
				   if(event.result['data'].questType == 'progressing' && (taskArray[i].killCount != taskArray[i].currentKillCount))
				    taskDetail.accept.visible = false;
				   taskDetail.target.htmlText += '杀死<font color="#ff0000">'+taskArray[i].killCount+'</font>个&nbsp;&nbsp;<font color="#4049C2">'+taskArray[i].npcInfo.name+'</font>\n'
				  }else if(taskArray[i].itemCount != 0)
				  {
				  	for(var k:int = 0 ;k<placeArray.length ; k++)
					  {
					  	if( k == (placeArray.length-1))
					  	{
					  		taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[k].toString()+'</font>&nbsp;&nbsp;';
					  		break;
					  	}
					  	taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[k].toString()+'</font>&nbsp;&nbsp;-&nbsp;&nbsp;'				  	
					  }
				   if(event.result['data'].questType == 'progressing' && (taskArray[i].itemCount != taskArray[i].currentCollectCount))
				    taskDetail.accept.visible = false;
				   taskDetail.target.htmlText += '收集<font color="#ff0000">'+taskArray[i].itemCount+'</font>个&nbsp;&nbsp;<font color="#4049C2">'+taskArray[i].itemName+'</font>\n'
				  }	else
				  {
				  	for(var j:int = 0 ;j<placeArray.length ; j++)
					  {
					  	if( j == (placeArray.length-1))
					  	{
					  		taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[j].toString()+'</font>&nbsp;&nbsp;';
					  		break;
					  	}
					  	taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[j].toString()+'</font>&nbsp;&nbsp;-&nbsp;&nbsp;'				  	
					  }
					 
					 	taskDetail.target.htmlText += '与&nbsp;&nbsp;'+'<font color="#4049C2">'+  taskArray[i].npcInfo.name+'</font>&nbsp;&nbsp;交谈\n';
					 	 if(event.result['data'].questType == 'progressing' && (taskArray[i].hasTalkedToNpc == 0))
				         taskDetail.accept.visible = false;					  
				  }		
		    }
		    taskDetail.target.htmlText += (i+1)+'.前往&nbsp;&nbsp;<font color = "#009933 ">'+event.result['data'].accepterInfo.placeName.toString()+'</font>向&nbsp;&nbsp;<font color="#4049C2">'+event.result['data'].accepterInfo.name.toString()+'</font>&nbsp;&nbsp;交付任务';
		    if(int(event.result['data'].coinBonus) != 0)
		    taskDetail.award.htmlText += '铜币:<font color="#ff0000">'+ event.result['data'].coinBonus+'</font>\n';
		    if(int(event.result['data'].expBonus) != 0)
		    taskDetail.award.htmlText += '经验:<font color="#ff0000">'+ event.result['data'].expBonus+'</font>\n';
		    if(event.result['data'].itemBonus != null)
		    {
		    	taskDetail.itemBouns.htmlText += '装备:<font color="#ff0000">'+ event.result['data'].itemBonus.name+'</font>\n';
		    	taskDetail.itemBouns.data = event.result['data'].itemBonus;
		    }
		    
		    taskDetail.backForward.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(npcTask);});
		}
		
		public function addEventCommitHandler(ui:UIComponent,id:int):void
		{
			ui.addEventListener(MouseEvent.CLICK,function():void{RemoteService.instance.commitQuest(collection.playerId,id).addHandlers(onCommitQuest);});
		}
		
		public function addEventAcceptHandler(ui:UIComponent,id:int):void
		{
			ui.addEventListener(MouseEvent.CLICK,function():void{RemoteService.instance.applyQuest(collection.playerId,id).addHandlers(onApplyQuest);});
		}
		
		public function onApplyQuest(event:ResultEvent,token:AsyncToken):void
		{
			var falseTip:NormalTipComponent = new NormalTipComponent();
			if(event.result['result'] == false)
			{
				
				PopUpManager.addPopUp(falseTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(falseTip);
				falseTip.tipText.text = event.result['reason'].toString();
				falseTip.hideButton();
				falseTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(falseTip);});
			}else
			{
				PopUpManager.addPopUp(falseTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(falseTip);
				falseTip.tipText.text = '任务接受成功';
				falseTip.hideButton();
				falseTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(falseTip);});
				PopUpManager.removePopUp(npcTask);
				TaskInfo.instance.taskNum = event.result['data'].receivedActiveCount as int;
				var container:HBox = targetUI.parent as HBox;
				container.removeChildAt(1);
				var label:Label = new Label();
				container.addChildAt(label,1);
				TaskInfo.instance.taskNum = event.result['data'].receivedActiveCount;
				label.htmlText = '<font color="#ff0000">进行中</font>';
				refrashPanel(event.result['data'] as Object);
				Application.application.frashMiniTask();
			}
		}
		
		public function onCommitQuest(event:ResultEvent,token:AsyncToken):void
		{
			var falseTip:NormalTipComponent = new NormalTipComponent();
			if(event.result['result'] == false)
			{
				PopUpManager.addPopUp(falseTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(falseTip);
				falseTip.tipText.text = event.result['reason'].toString();
				falseTip.hideButton();
				falseTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(falseTip);});
			}else
			{
				if(manualTask == currentAutoTask)
				{
					locked = false;
				}
				PopUpManager.addPopUp(falseTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(falseTip);
				falseTip.tipText.text = event.result['reason'].toString();
				falseTip.hideButton();
				falseTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(falseTip);});
				PopUpManager.removePopUp(npcTask);
				
			}
		}
		
		public function onRefreshActiveRewardQuestList(event:ResultEvent,token:AsyncToken):void
		{
			refrashPanel(event.result['data'] as Object);			
			countTime.resetTimer(7200);
			
		}
		
		public function onImmediateRefreshActiveRewardQuestList(event:ResultEvent,token:AsyncToken):void
		{			
			
			refrashPanel(event.result['data'] as Object);			
			countTime.resetTimer(7200);
			
		}
		
		public function frushImmediate():void
		{
			if(MySelf.instance.isNewPlayer == 1)
			{
				collection.errorEvent('对不起，该功能不对新手状态开放',null);
			}else
			{
				payMoney = new PayMoneyComponent();
				payMoney.amount = '10';
				payMoney.description = '刷新任务列表吗？';
				PopUpManager.addPopUp(payMoney,Application.application.canvas1,true);
				PopUpManager.centerPopUp(payMoney);			
				money = 10;
				payMoney.payMoneyOK.addEventListener(MouseEvent.CLICK,clickForPayList);	
			}
					
		}
		
		public function clickForPayList(event:MouseEvent):void
		{
			if(payMoney.gold.selected == true)
			RemoteService.instance.immediateRefreshActiveRewardQuestList(collection.playerId,'gold',money,npcId).addHandlers(refrushMoney);
			else
			RemoteService.instance.immediateRefreshActiveRewardQuestList(collection.playerId,'coupon',money,npcId).addHandlers(refrushMoney);
		}
		
	}
}