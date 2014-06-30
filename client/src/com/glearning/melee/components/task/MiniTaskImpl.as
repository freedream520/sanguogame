package com.glearning.melee.components.task
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.model.TaskInfo;
	import com.glearning.melee.net.RemoteService;
	import com.glearning.melee.model.MySelf;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.messaging.events.MessageEvent;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class MiniTaskImpl extends Canvas
	{
		public var current:VBox;
		public var battle:VBox;
		public var scene:VBox;
		public var recevible:VBox;
		public var currentButton:LinkButton;
	    public var battleButton:LinkButton;
		public var sceneButton:LinkButton;
		public var receiveButton:LinkButton;
		public function MiniTaskImpl()
		{
			super();
		}
		
		public function init():void
		{
			if(MySelf.instance.isNewPlayer == 0)
				{
					RemoteService.instance.getProgressingQuests(collection.playerId).addHandlers(onProgressingTask);
				}else if(MySelf.instance.isNewPlayer == 1)
				{
					RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onProgressingTask);
				}
			
		}
		
		public function buttonStateChange(id:String):void
		{
			if(id == 'currentButton')
			{
			   currentButton.styleName = 'MiniButton2';
			   battleButton.styleName = 'MiniButton1';
			   sceneButton.styleName = 'MiniButton1';
			   receiveButton.styleName = 'MiniButton1';
			}else if(id == 'battleButton')
			{
			   currentButton.styleName = 'MiniButton1';
			   battleButton.styleName = 'MiniButton2';
			   sceneButton.styleName = 'MiniButton1';
			   receiveButton.styleName = 'MiniButton1';
			}else if(id == 'sceneButton')
			{
			   currentButton.styleName = 'MiniButton1';
			   battleButton.styleName = 'MiniButton1';
			   sceneButton.styleName = 'MiniButton2';
			   receiveButton.styleName = 'MiniButton1';
			}else
			{
		       currentButton.styleName = 'MiniButton1';
			   battleButton.styleName = 'MiniButton1';
			   sceneButton.styleName = 'MiniButton1';
			   receiveButton.styleName = 'MiniButton2';
			}
		}
		
		public function questLinkBar(event:MouseEvent):void
		{
			if(MySelf.instance.status != '战斗中')
			{
				if(event.currentTarget.label == '当前任务'){
					if(MySelf.instance.isNewPlayer == 0)
					{
						RemoteService.instance.getProgressingQuests(collection.playerId).addHandlers(onProgressingTask);
					}else if(MySelf.instance.isNewPlayer == 1)
					{
						RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onProgressingTask);
					}
				}else if(event.currentTarget.label == '可接任务')	{
					RemoteService.instance.getRecievableQuests(collection.playerId).addHandlers(onRecievableTask);
				}else if(event.currentTarget.label == '战斗信息'){				
					
				}else
				{
					
				}
			}
			
		}
		
		public function onProgressingTask(event:ResultEvent,token:AsyncToken):void{
			current.removeAllChildren();
			if(MySelf.instance.isNewPlayer == 0)
			{
				TaskInfo.instance.taskArray = event.result['data'] as Array;			
				var array:Array = TaskInfo.instance.taskArray;
				if(array != null)
				{
					for(var i:int=0;i<array.length;i++)
				{
					var taskInfo:MiniTaskContentComponent = new MiniTaskContentComponent();
					
					current.addChild(taskInfo);	
					taskInfo.taskName.htmlText = '<font size="14">'+array[i].name.toString()+'</font>';				
					var taskId:int = array[i].id as int;
					 switch(array[i].type)
				    {
				    	case 1:taskInfo.taskType.htmlText = "<font color='#ff0000'>主线任务</font>&nbsp;&nbsp;-";break;
				    	case 2:taskInfo.taskType.htmlText = "<font color='#ff0000'>赏金任务</font>&nbsp;&nbsp;-";break;
				    	case 3:taskInfo.taskType.htmlText = "<font color='#ff0000'>支线任务</font>&nbsp;&nbsp;-";break;
				    	case 4:taskInfo.taskType.htmlText = "<font color='#ff0000'>转职任务</font>&nbsp;&nbsp;-";break;
				    }				
				    taskInfo.taskCategory.htmlText = "&nbsp;&nbsp;<font color='#ff0000'>"+array[i].category+"</font>";
				    addInfoEventHandler(taskInfo.watchInfo,taskId);
					var progressStep:Array = array[i].progressesDetails as Array;
					for(var n:int = 0; n<progressStep.length;n++)
					{				
					  var textInfo:Text = new Text();
					  var goToPlace:LinkButton = new LinkButton();
					  goToPlace.height = 18;
					  var stateCal:Label = new Label();
					  var hbox:HBox = new HBox();
					  var placeArray:Array = progressStep[n].parentPlaceList as Array;
					  textInfo.htmlText = (n+1)+'.前往&nbsp;&nbsp;';
					  if( progressStep[n].killCount != 0)
					  {
						  for(var m:int = 0 ;m<placeArray.length ; m++)
						  {
						  	if( m == (placeArray.length-1))
						  	{
						  		textInfo.htmlText += '<font color = "#009933 ">'+placeArray[m].toString()+'</font>&nbsp;&nbsp;';
						  		break;
						  	}
						  	textInfo.htmlText += '<font color = "#009933 ">'+placeArray[m].toString()+'</font>-'				  	
						  }				   
					   textInfo.htmlText += '\n杀死<font color="#ff0000">'+progressStep[n].killCount+'</font>个&nbsp;&nbsp;<font color="#4049C2">'+progressStep[n].npcInfo.name+'</font>'
	 				   if(progressStep[n].currentKillCount == progressStep[n].killCount)
					   {
						   textInfo.htmlText += '&nbsp;&nbsp;<font color="#04B404">已完成</font>';
						   hbox.addChild(textInfo);
						   taskInfo.taskContent.addChild(hbox);	
					   }else
					   {
					   	   textInfo.htmlText += '&nbsp;&nbsp;<font color="#ff0000">未完成</font>';
					   	   stateCal.text = progressStep[n].currentKillCount+'/'+progressStep[n].killCount;
						   hbox.addChild(textInfo);					   
						   hbox.addChild(stateCal);
					   	   if(progressStep[n].npcInfo.placeId >=1000)
					   	   {
						   goToPlace.label = '[传送]';
						   goToPlace.alpha = 0;
						   goToPlace.styleName = 'goToPlace';
						   hbox.addChild(goToPlace);
						   addPlaceEventHandler(goToPlace,progressStep[n].npcInfo.placeId);
					   	   }					  
						  
						   taskInfo.taskContent.addChild(hbox);	
					   }
					  }else if(progressStep[n].itemCount != 0)
					  {
					  	for(var j:int = 0 ;j<placeArray.length ; j++)
						  {
						  	if( j == (placeArray.length-1))
						  	{
						  		textInfo.htmlText += '<font color = "#009933 ">'+placeArray[j].toString()+'</font>&nbsp;&nbsp;';
						  		break;
						  	}
						  	textInfo.htmlText += '<font color = "#009933 ">'+placeArray[j].toString()+'</font>-'				  	
						  }
					   textInfo.htmlText += '\n杀死&nbsp;&nbsp;<font color="#4049C2">'+progressStep[n].npcInfo.name+'</font>&nbsp;&nbsp;收集<font color="#ff0000">'+progressStep[n].itemCount+'</font>个&nbsp;&nbsp;<font color="#4049C2">'+progressStep[n].itemName+'</font>\n';
					   if(progressStep[n].itemCount == progressStep[n].currentCollectCount)
					   {
					   	textInfo.htmlText += '&nbsp;&nbsp;<font color="#04B404">已完成</font>';
					   	hbox.addChild(textInfo);
					   	taskInfo.taskContent.addChild(hbox);	
					   }else
					   {
					   	 textInfo.htmlText += '&nbsp;&nbsp;<font color="#ff0000">未完成</font>';
					   	 stateCal.text = progressStep[n].currentCollectCount+'/'+progressStep[n].itemCount;
						 hbox.addChild(textInfo);					  
						 hbox.addChild(stateCal);
					   	 if(progressStep[n].npcInfo.placeId >=1000)
					      {
						   goToPlace.label = '[传送]';
						   goToPlace.alpha = 0;
						   goToPlace.styleName = 'goToPlace';
						   hbox.addChild(goToPlace);
						   addPlaceEventHandler(goToPlace,progressStep[n].npcInfo.placeId);
						   }
						  
						   taskInfo.taskContent.addChild(hbox);
					   }	
					  }	else
					  {
					  	for(var k:int = 0 ;k<placeArray.length ; k++)
						  {
						  	if( k == (placeArray.length-1))
						  	{
						  		textInfo.htmlText += '<font color = "#009933 ">'+placeArray[k].toString()+'</font>&nbsp;&nbsp;';
						  		break;
						  	}
						  	textInfo.htmlText += '<font color = "#009933 ">'+placeArray[k].toString()+'</font>-'				  	
						  }
						 textInfo.htmlText += '与&nbsp;&nbsp;'+'<font color="#4049C2">'+  progressStep[n].npcInfo.name.toString()+'</font>&nbsp;&nbsp;交谈';
						 if(progressStep[n].hasTalkedToNpc !=0 )
						 {
						 	textInfo.htmlText += '&nbsp;&nbsp;<font color="#04B404">已完成</font>';
					   	    hbox.addChild(textInfo);
					     	taskInfo.taskContent.addChild(hbox);
						 }else
						 {
						 	textInfo.htmlText += '&nbsp;&nbsp;<font color="#ff0000">未完成</font>';
							hbox.addChild(textInfo);
							if(progressStep[n].npcInfo.placeId >=1000)
						    {
							   goToPlace.label = '[传送]';
							   goToPlace.alpha = 0;
							   goToPlace.styleName = 'goToPlace';
							   hbox.addChild(goToPlace);
							   addPlaceEventHandler(goToPlace,progressStep[n].npcInfo.placeId);
							 }
							 taskInfo.taskContent.addChild(hbox);
						 }
					  }			
					   
					}	
					    var textInfo1:Text = new Text();
					    var hbox1:HBox = new HBox();
					    hbox1.addChild(textInfo1);
					     if(array[i].accepterInfo.placeId >= 1000)
					    {
						    var sendPlace:LinkButton = new LinkButton();					    
						    hbox1.addChild(sendPlace);
						    sendPlace.height = 18;
						    sendPlace.label = '[传送]';
						    sendPlace.alpha = 0;
						    sendPlace.styleName = 'goToPlace';
						    addPlaceEventHandler(sendPlace,array[i].accepterInfo.placeId);
					    }
					    var placeArray1:Array = array[i].accepterInfo.parentPlaceList as Array;
					  	textInfo1.htmlText += (n+1)+'.前往&nbsp;&nbsp;';
					  	for(var l:int=0;l<placeArray1.length;l++)
					  	{
					  		if(l == (placeArray1.length -1))
					  		{
					  			textInfo1.htmlText += '<font color="#04B404">'+placeArray1[l]+'</font>&nbsp;&nbsp;';
					  			break;
					  		}
					  		textInfo1.htmlText += '<font color="#04B404">'+placeArray1[l]+'</font>-';
					  	}
					  	textInfo1.htmlText += '向&nbsp;&nbsp;<font color="#4049C2">'+array[i].accepterInfo.name+'</font>&nbsp;&nbsp;交付任务';
					  	taskInfo.taskContent.addChild(hbox1);			
				}
				}
				
			}else if(MySelf.instance.isNewPlayer == 1)
				{
					var taskInfo_new:TaskInfoComponent = new TaskInfoComponent();
					current.addChild(taskInfo_new);
					taskInfo_new.taskName.text = event.result['data'][0][1].toString();
					taskInfo_new.taskType.text = event.result['data'][0][6].toString();
					var text:Text = new Text();
					text.width = 325;
					text.htmlText = event.result['data'][0][2].toString();
					taskInfo_new.taskContent.addChild(text);
				}
			
		}
		
		public function onRecievableTask(event:ResultEvent,token:AsyncToken):void
		{
			recevible.removeAllChildren();
			TaskInfo.instance.taskArray = event.result['data'] as Array;
			var array:Array = TaskInfo.instance.taskArray;
					
			for(var i:int=0;i<array.length;i++)
			{
				var taskInfo:MiniTaskContentComponent = new MiniTaskContentComponent();
				var textInfo:Text = new Text();
				var placeArray:Array = array[i].providerInfo.parentPlaceList as Array;
				recevible.addChild(taskInfo);
				taskInfo.watchInfo.visible = false;
				taskInfo.taskName.text = array[i].name;	
				textInfo.htmlText = '接受任务提示:\n进入';
				for(var n:int = 0;n<placeArray.length;n++)
				{
					if(n == (placeArray.length - 1 ))
					{
					  textInfo.htmlText += '<font color = "#009933 ">'+placeArray[n]+'</font>&nbsp;&nbsp;';
					  break;
					}
				    textInfo.htmlText += '<font color = "#009933 ">'+placeArray[n]+'</font>-';
				}
				textInfo.htmlText += '与&nbsp;&nbsp;<font color = "#4049C2">'+array[i].providerInfo.name+'</font>&nbsp;&nbsp;点选<font color="#009933">'+array[i].name+'</font>\n等级需求:<font color = "#ff0000">'+array[i].minLevelRequire+'</font>';
				taskInfo.taskContent.addChild(textInfo);
			    switch(array[i].type)
			    {
			    	case 1:taskInfo.taskType.htmlText = "<font color='#ff0000'>主线任务</font>&nbsp;&nbsp;-";break;
				    case 2:taskInfo.taskType.htmlText = "<font color='#ff0000'>赏金任务</font>&nbsp;&nbsp;-";break;
				    case 3:taskInfo.taskType.htmlText = "<font color='#ff0000'>支线任务</font>&nbsp;&nbsp;-";break;
				    case 4:taskInfo.taskType.htmlText = "<font color='#ff0000'>转职任务</font>&nbsp;&nbsp;-";break;
			    }
				taskInfo.taskCategory.htmlText = "&nbsp;&nbsp;<font color='#ff0000'>"+array[i].category+"</font>";			
			}
			   
		}
			
		public function addInfoEventHandler(ui:UIComponent,tid:int):void
		{
		    ui.addEventListener(MouseEvent.CLICK,function():void{RemoteService.instance.getQuestDetails(collection.playerId,tid).addHandlers(onGetQuestDetails)});				
		}
		
		public function onGetQuestDetails(event:ResultEvent,token:AsyncToken):void
		{

			var npcTaskComponent:NpcTaskComponent = new NpcTaskComponent();
			PopUpManager.addPopUp(npcTaskComponent,Application.application.canvas1,true);
		    PopUpManager.centerPopUp(npcTaskComponent);
		    var taskDetail:TalkTaskDetailComponent = new TalkTaskDetailComponent();
		    npcTaskComponent.npcTalkTask.addChild(taskDetail);
		    npcTaskComponent.closeButton.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(npcTaskComponent)});
			
			npcTaskComponent.npcImage.source = (event.result['data'].providerInfo.image as String).replace("32","170");
			npcTaskComponent.npcName.text = event.result['data'].providerInfo.name;
			taskDetail.taskName.text = event.result['data'].name;
			switch(event.result['data'].type)
			    {
			    	case 1:taskDetail.taskType.htmlText = "<font color='#ff0000'>主线任务</font>";break;
				    case 2:taskDetail.taskType.htmlText = "<font color='#ff0000'>赏金任务</font>";break;
				    case 3:taskDetail.taskType.htmlText = "<font color='#ff0000'>支线任务</font>";break;
				    case 4:taskDetail.taskType.htmlText = "<font color='#ff0000'>转职任务</font>";break;
			    }
		    taskDetail.description.text = event.result['data'].questTemplateInfo.accepterDialog;
		    var taskArray:Array = event.result['data'].progressesDetails as Array;
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
					  	taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[m].toString()+'</font>-';				  	
					  }
				   taskDetail.target.htmlText += '杀死<font color="#ff0000">'+taskArray[i].killCount+'</font>&nbsp;&nbsp;个<font color="#4049C2">'+taskArray[i].npcInfo.name+'</font>\n';
//				   taskDetail.target.htmlText += (i+1)+'.前往<font color = "#009933 ">'+taskArray[i].accepterInfo.placeName.toString()+'</font>向<font color="#ff0000">'+taskArray[i].accepterInfo.name.toString()+'</font>交付任务';
				  }else if(taskArray[i].itemCount != 0)
				  {
				  		for(var j:int = 0 ;j<placeArray.length ; j++)
					  {
					  	if( j == (placeArray.length-1))
					  	{
					  		 taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[j].toString()+'</font>&nbsp;&nbsp;';
					  		break;
					  	}
					  	 taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[j].toString()+'</font>-'				  	
					  }
				   taskDetail.target.htmlText += '收集<font color="#ff0000">'+taskArray[i].itemCount+'</font>个&nbsp;&nbsp;<font color="#4049C2">'+taskArray[i].itemName+'</font>\n';
//				    taskDetail.target.htmlText += (i+1)+'.前往<font color = "#009933 ">'+taskArray[i].accepterInfo.placeName.toString()+'</font>向<font color="#ff0000">'+taskArray[i].accepterInfo.name.toString()+'</font>交付任务';
				  }	else
				  {
				  	for(var k:int = 0 ;k<placeArray.length ; k++)
					  {
					  	if( k == (placeArray.length-1))
					  	{
					  		taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[k].toString()+'</font>&nbsp;&nbsp;';
					  		break;
					  	}
					  	taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[k].toString()+'</font>-'				  	
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
		    }
		    taskDetail.backForward.visible = false;
		  
		}
		
		public function addPlaceEventHandler(ui:UIComponent,placeid:int):void
		{
			ui.addEventListener(MouseEvent.CLICK,function():void{
			RemoteService.instance.enterPlace(collection.playerId,placeid).addHandlers(collection.setEnterPlace);
		
			//Application.application.currentState = 'place';
			});		
		}
		
	}
}