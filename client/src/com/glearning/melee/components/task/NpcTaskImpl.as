package com.glearning.melee.components.task
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.model.TaskInfo;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class NpcTaskImpl extends Canvas
	{
		public var npcId:int = 0;
		public var npcImage:Image;
		public var npcName:Label;
		public var talkDescription:Text;
		public var npcTaskList:NpcTaskListComponent;
		public var talkTaskDetail:TalkTaskDetailComponent;
		public var npcTalkTask:HBox;
		public var npcInfo:Object;
		public var isFinished:Boolean;
		public var cqid:int;
		public var itemObj:Object;
		public var coinObj:int;
		public var expObj:int;
		public function NpcTaskImpl()
		{
			super();
		}
		
		public function init():void
		{
	     
		}
		
		public function getReceiveDetail(templateid:int):void
		{			
			RemoteService.instance.getRecievableQuestDetails(collection.playerId,templateid).addHandlers(onRecievableQuestDetails);
		}
		
		public function getTaskDetail(questid:int):void
		{
		   
			RemoteService.instance.getQuestDetails(collection.playerId,questid).addHandlers(onQuestDetails);
		}
		
		public function onRecievableQuestDetails(event:ResultEvent,token:AsyncToken):void
		{
			this.npcTalkTask.getChildAt(0).visible = false;
			(this.npcTalkTask.getChildAt(0) as NpcTaskListComponent).includeInLayout = false;
			var taskDetail:TalkTaskDetailComponent = new TalkTaskDetailComponent();
			this.npcTalkTask.addChild(taskDetail);
			taskDetail.taskName.text = event.result['data'].name;
			switch(event.result['data'].type)
			    {
			    	case 1:taskDetail.taskType.htmlText = "<font color='#ff0000'>主线任务</font>";break;
				    case 2:taskDetail.taskType.htmlText = "<font color='#ff0000'>赏金任务</font>";break;
				    case 3:taskDetail.taskType.htmlText = "<font color='#ff0000'>支线任务</font>";break;
				    case 4:taskDetail.taskType.htmlText = "<font color='#ff0000'>转职任务</font>";break;
			    }
		    taskDetail.description.text = event.result['data'].providerDialog;
		    var taskArray:Array = event.result['data'].questgoals as Array;
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
				   taskDetail.target.htmlText += '杀死<font color="#ff0000">'+taskArray[i].killCount+'</font>&nbsp;&nbsp;个<font color="#4049C2">'+taskArray[i].npcInfo.name+'</font>\n'
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
				    taskDetail.target.htmlText += '收集<font color="#ff0000">'+taskArray[i].itemCount+'</font>个&nbsp;&nbsp;<font color="#4049C2">'+taskArray[i].itemName+'</font>\n';
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
					 taskDetail.target.htmlText += '与&nbsp;&nbsp;'+'<font color="#4049C2">'+  taskArray[i].npcInfo.name.toString()+'</font>&nbsp;&nbsp;交谈\n';					
				  }		
		    }
			 taskDetail.target.htmlText += (taskArray.length+1)+'.前往&nbsp;&nbsp;<font color = "#009933">'+event.result['data'].accepterInfo.placeName.toString()+'</font>向&nbsp;&nbsp;<font color="#4049C2">'+event.result['data'].accepterInfo.name.toString()+'</font>&nbsp;&nbsp;交付任务';
		    if(int(event.result['data'].coinBonus) != 0)
		    taskDetail.award.htmlText += '铜币:<font color="#ff0000">'+ event.result['data'].coinBonus+'</font>\n';
		    if(int(event.result['data'].expBonus) != 0)
		    taskDetail.award.htmlText += '经验:<font color="#ff0000">'+ event.result['data'].expBonus+'</font>\n';
		    if(event.result['data'].itemBonus != null)
		    {
		    	taskDetail.itemBouns.htmlText += '装备:<font color="#ff0000">'+ event.result['data'].itemBonus.name+'</font>\n';
		    	taskDetail.itemBouns.data = event.result['data'].itemBonus;
		    	itemObj = event.result['data'].itemBonus
		    }
		    taskDetail.accept.label = '接受';
		    addEventAcceptHandler( taskDetail.accept,event.result['data'].id as int);
		    taskDetail.backForward.addEventListener(MouseEvent.CLICK,function():void{npcTalkTask.removeChild(taskDetail);npcTalkTask.getChildAt(0).visible=true;});

		}

		
		public function addEventAcceptHandler(ui:UIComponent,id:int):void
		{
			ui.addEventListener(MouseEvent.CLICK,function():void{RemoteService.instance.applyQuest(collection.playerId,id).addHandlers(onApplyQuest);});
		}
		
		public function onApplyQuest(event:ResultEvent,token:AsyncToken):void
		{
			if(event.result['result'] == false)
			{
				var tip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = event.result['reason'].toString();
		        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});			
			}else
			{
	            TaskInfo.instance.taskNum = int(event.result['data'].receivedActiveCount);           
				PopUpManager.removePopUp(this);
				Application.application.frashMiniTask();		
			}
		}
		
		public function onQuestDetails(event:ResultEvent,token:AsyncToken):void
		{
			this.npcTalkTask.getChildAt(0).visible = false;
			(this.npcTalkTask.getChildAt(0) as NpcTaskListComponent).includeInLayout = false;
			var taskDetail:TalkTaskDetailComponent = new TalkTaskDetailComponent();
			this.npcTalkTask.addChild(taskDetail);
			taskDetail.taskName.text = event.result['data'].name;
			switch(event.result['data'].type)
			    {
			    	case 1:taskDetail.taskType.text = "主线任务";break;
			    	case 2:taskDetail.taskType.text = "赏金任务";break;
			    	case 3:taskDetail.taskType.text = "支线任务";break;
			    	case 4:taskDetail.taskType.text = "转职任务";break;
			    }
		    taskDetail.description.text = event.result['data'].questTemplateInfo.accepterDialog;
		    var taskArray:Array = event.result['data'].progressesDetails as Array;
		    for(var i:int = 0; i<taskArray.length;i++)
		    {
		    	 taskDetail.target.htmlText += (i+1)+'.前往';
		    	 var placeArray:Array = taskArray[i].parentPlaceList as Array;
		    	  if( taskArray[i].killCount != 0)
				  {
					  for(var m:int = 0 ;m<placeArray.length ; m++)
					  {
					  	if( m == (placeArray.length-1))
					  	{
					  		taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[m].toString()+'</font>';
					  		break;
					  	}
					  	taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[m].toString()+'</font>-'				  	
					  }
				   if(taskArray[i].currentKillCount != taskArray[i].killCount)
				   taskDetail.accept.visible = false;
				   taskDetail.target.htmlText += '杀死'+taskArray[i].killCount+'个<font color="">'+taskArray[i].npcInfo.name+'</font>\n'
				  }else if(taskArray[i].itemCount != 0)
				  {
				  	for(var k:int = 0 ;k<placeArray.length ; k++)
					  {
					  	if( k == (placeArray.length-1))
					  	{
					  		taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[k].toString()+'</font>';
					  		break;
					  	}
					  	taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[k].toString()+'</font>的'				  	
					  }
				   if(taskArray[i].itemCount != taskArray[i].currentCollectCount)
				   taskDetail.accept.visible = false;
				   taskDetail.target.htmlText += '收集'+taskArray[i].itemCount+'个<font color="">'+taskArray[i].itemName+'</font>\n'
				  }	else
				  {
				  	for(var j:int = 0 ;j<placeArray.length ; j++)
					  {
					  	if( j == (placeArray.length-1))
					  	{
					  		taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[j].toString()+'</font>';
					  		break;
					  	}
					  	taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[j].toString()+'</font>的'				  	
					  }
					 taskDetail.target.htmlText += '与'+'<font color="#009933">'+  taskArray[i].npcInfo.name.toString()+'</font>交谈\n';
					 if(taskArray[i].hasTalkedToNpc == 0)
				     taskDetail.accept.visible = false;
				  }		
		    }
		    taskDetail.target.htmlText += (i+1)+'.前往<font color = "#009933 ">'+event.result['data'].accepterInfo.placeName.toString()+'</font>向<font color="#ff0000">'+event.result['data'].accepterInfo.name.toString()+'</font>交付任务';
		    if(int(event.result['data'].coinBonus) != 0)
		    {
		    	taskDetail.award.htmlText += '铜币:<font color="#ff0000">'+ event.result['data'].coinBonus+'</font>\n';
		    	coinObj = event.result['data'].coinBonus;
		    }
		    
		    if(int(event.result['data'].expBonus) != 0)
		    {
		    	taskDetail.award.htmlText += '经验:<font color="#ff0000">'+ event.result['data'].expBonus+'</font>\n';
		    	expObj = event.result['data'].expBonus;
		    }
		    
		    if(event.result['data'].itemBonus != null)
		    {
		    	taskDetail.itemBouns.htmlText += '装备:<font color="#ff0000">'+ event.result['data'].itemBonus.name+'</font>\n';
		    	taskDetail.itemBouns.data = event.result['data'].itemBonus;
		    }
		    taskDetail.accept.label = '完成';
		    addEventFinishHandler( taskDetail.accept,event.result['data'].id as int);
		    taskDetail.backForward.addEventListener(MouseEvent.CLICK,function():void{npcTalkTask.removeChild(taskDetail);npcTalkTask.getChildAt(0).visible=true;});
		}
		
		public function addEventFinishHandler(ui:UIComponent,tid:int):void
		{
			ui.addEventListener(MouseEvent.CLICK,commitQuestFunction);
			cqid = tid;
		}
		
		public function commitQuestFunction(event:MouseEvent):void
		{
			RemoteService.instance.commitQuest(collection.playerId,cqid).addHandlers(onFinishQuest);
		}
		
		public function onFinishQuest(event:ResultEvent,token:AsyncToken):void
		{
			if(event.result['result'] == false)
			{
				var falseTip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(falseTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(falseTip);
				falseTip.tipText.text = event.result['reason'].toString();
				falseTip.hideButton();
				falseTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(falseTip);});
			}else
			{
				MySelf.instance.coin = event.result['data'].coin;
				MySelf.instance.exp = event.result['data'].exp;
				MySelf.instance.maxExp = event.result['data'].maxExp;
				Application.application.baseAvatar.update();
				MySelf.instance.currentProfessionStageIndex = event.result['data'].currentProfessionStageIndex;
				Application.application.frashMiniTask();
				
				PopUpManager.removePopUp(this);
				if(Application.application.currentState == 'shop'){
					Application.application.shopPage.tempPackage.init();
					Application.application.shopPage.characterPackage.resetPackage();
				}else if(Application.application.currentState == 'warehouse'){
					Application.application.warehouse.tempPackage.init();
					Application.application.warehouse.characterPackage.resetPackage();
				}else if(Application.application.currentState == 'forging'){
					Application.application.forging.tempPackage.init();
					Application.application.forging.characterPackage.resetPackage();
				}
				collection.showAddward(coinObj,expObj,itemObj);
			}
		}
		
		
		
	}
}