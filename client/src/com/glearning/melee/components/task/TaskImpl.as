package com.glearning.melee.components.task
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.model.TaskInfo;
	import com.glearning.melee.net.RemoteService;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.components.utils.AutoTip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class TaskImpl extends Canvas
	{
		public var ProgressingTask:VBox;
		public var RecievableTask:VBox;
		public var FinishedTask:VBox;
		public var currentButton:LinkButton;
		public var receiveableButton:LinkButton;
		public var finishButton:LinkButton;
		public var img:Image;
		public function TaskImpl()
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
		
		 public function loading():void
		{

            img = new Image();
            img.source = 'images/icon-loading.gif';
            PopUpManager.addPopUp(img,Application.application.canvas1,true);
            PopUpManager.centerPopUp(img);
			
		}
		
		
		
		
		public function closeLoading():void
		{
			PopUpManager.removePopUp(img);
		}
		
		public function buttonStateChange(id:String):void
		{
			if(id == 'currentButton')
			{
			   currentButton.styleName = 'roleClickButton';
			   receiveableButton.styleName = 'roleNoClickButton';
			   finishButton.styleName = 'roleNoClickButton';
			}else if(id == 'receiveableButton')
			{
			   currentButton.styleName = 'roleNoClickButton';
			   receiveableButton.styleName = 'roleClickButton';
			   finishButton.styleName = 'roleNoClickButton';
			}else
			{
			   currentButton.styleName = 'roleNoClickButton';
			   receiveableButton.styleName = 'roleNoClickButton';
			   finishButton.styleName = 'roleClickButton';
			}
		}
		
		public function questLinkBar(event:MouseEvent):void{
			if(event.currentTarget.label == '当前任务'){
				if(MySelf.instance.status != '战斗中'){
					if(MySelf.instance.isNewPlayer == 0)
					{
						RemoteService.instance.getProgressingQuests(collection.playerId).addHandlers(onProgressingTask);
					}else if(MySelf.instance.isNewPlayer == 1)
					{
						RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onProgressingTask);
					}
				}
				
			}else if(event.currentTarget.label == '可接任务')	{
				if(MySelf.instance.isNewPlayer == 1 && 	MySelf.instance.progress == 5)
				{
					RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onNewPlayerQuestInfo);
				}
				RemoteService.instance.getRecievableQuests(collection.playerId).addHandlers(onRecievableTask);
			}else{				
				RemoteService.instance.getFinishedQuests(collection.playerId).addHandlers(onFinishedTask);
			}
			}
			
		public function onNewPlayerQuestInfo(event:ResultEvent,token:AsyncToken):void
		{
			RemoteService.instance.changeQuestProgress(collection.playerId,6).addHandlers(onChangeQuestProgress);
			MySelf.instance.progress = 6;
			RemoteService.instance.addReward(collection.playerId,event.result['data'][0][3],event.result['data'][0][5],event.result['data'][0][4]).addHandlers(onAddReward)
		}
		
		public function onAddReward(event:ResultEvent,token:AsyncToken):void
		{
			RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(collection.onLoadPlayerResult);
					
		}
		
		public function onChangeQuestProgress(event:ResultEvent,token:AsyncToken):void
		{			
            Application.application.newPlayerQuestProgress(event.result.progress);
            Application.application.frashMiniTask();
		}
			
		public function onProgressingTask(event:ResultEvent,token:AsyncToken):void{
			ProgressingTask.removeAllChildren();
			if(MySelf.instance.isNewPlayer == 0)
			{
				TaskInfo.instance.taskArray = event.result['data'] as Array;			
				var array:Array = TaskInfo.instance.taskArray;
				for(var i:int=0;i<array.length;i++)
				{
					var taskInfo:TaskInfoComponent = new TaskInfoComponent();
					
					ProgressingTask.addChild(taskInfo);	
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
					  textInfo.htmlText = (n+1)+'.前往';
					  if( progressStep[n].killCount != 0)
					  {
						  for(var m:int = 0 ;m<placeArray.length ; m++)
						  {
						  	if( m == (placeArray.length-1))
						  	{
						  		textInfo.htmlText += '<font color = "#009933 ">'+placeArray[m].toString()+'</font>';
						  		break;
						  	}
						  	textInfo.htmlText += '<font color = "#009933 ">'+placeArray[m].toString()+'</font>-'				  	
						  }				   
					   textInfo.htmlText += '杀死<font color="#ff0000">'+progressStep[n].killCount+'</font>个<font color="#4049C2">'+progressStep[n].npcInfo.name+'</font>'
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
						  		textInfo.htmlText += '<font color = "#009933">'+placeArray[j].toString()+'</font>;';
						  		break;
						  	}
						  	textInfo.htmlText += '<font color = "#009933">'+placeArray[j].toString()+'</font>-'				  	
						  }
					   textInfo.htmlText += '杀死<font color="#483D8B">'+progressStep[n].npcInfo.name+'</font>&nbsp;&nbsp;收集<font color="#ff0000">'+progressStep[n].itemCount+'</font>个<font color="#4049C2">'+progressStep[n].itemName+'</font>\n';
					   if(progressStep[n].itemCount == progressStep[n].itemCollectCount)
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
						  		textInfo.htmlText += '<font color = "#009933">'+placeArray[k].toString()+'</font>';
						  		break;
						  	}
						  	textInfo.htmlText += '<font color = "#009933">'+placeArray[k].toString()+'</font>-'				  	
						  }
						 textInfo.htmlText += '与'+'<font color="#4049C2">'+  progressStep[n].npcInfo.name.toString()+'</font>交谈';
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
					  	textInfo1.htmlText += (n+1)+'.前往';
					  	for(var l:int=0;l<placeArray1.length;l++)
					  	{
					  		if(l == (placeArray1.length -1))
					  		{
					  			textInfo1.htmlText += '<font color="#04B404">'+placeArray1[l]+'</font>';
					  			break;
					  		}
					  		textInfo1.htmlText += '<font color="#04B404">'+placeArray1[l]+'</font>-';
					  	}
					  	textInfo1.htmlText += '向<font color="#4049C2">'+array[i].accepterInfo.name+'</font>交付任务';
					  	taskInfo.taskContent.addChild(hbox1);			
				}
			}else if(MySelf.instance.isNewPlayer == 1)
			{
				var taskInfoComp:TaskInfoComponent = new TaskInfoComponent();
				ProgressingTask.addChild(taskInfoComp);
				taskInfoComp.taskName.text = event.result['data'][0][1].toString();
				taskInfoComp.taskType.text = event.result['data'][0][6].toString();
				var text:Text = new Text();
				text.htmlText = event.result['data'][0][2].toString();
				taskInfoComp.taskContent.addChild(text);
			}
			
		}
		
		public function addPlaceEventHandler(ui:UIComponent,placeid:int):void
		{
			ui.addEventListener(MouseEvent.CLICK,function():void{
			RemoteService.instance.enterPlace(collection.playerId,placeid).addHandlers(collection.setEnterPlace);
			//Application.application.currentState = 'place';
			var eve:Event = new Event('closePop');
			dispatchEvent(eve);
			});		
		}
		
		public function onGetQuestDetails(event:ResultEvent,token:AsyncToken):void
		{

			var npcTaskComponent:NpcTaskComponent = new NpcTaskComponent();
			PopUpManager.addPopUp(npcTaskComponent,Application.application.canvas1,true);
		    PopUpManager.centerPopUp(npcTaskComponent);
		    var taskDetail:TalkTaskDetailComponent = new TalkTaskDetailComponent();
		    npcTaskComponent.npcTalkTask.addChild(taskDetail);
		    npcTaskComponent.closeButton.addEventListener(MouseEvent.CLICK,function():void{
		      PopUpManager.removePopUp(npcTaskComponent);		   
		    });
			
			npcTaskComponent.npcImage.source = (event.result['data'].providerInfo.image as String).replace("32","170");
			npcTaskComponent.npcName.text = event.result['data'].providerInfo.name;
			taskDetail.taskName.htmlText = '<font size="14">'+event.result['data'].name+'</font>';
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
					  	taskDetail.target.htmlText += '<font color = "#009933 ">'+placeArray[m].toString()+'</font>-'				  	
					  }
				   taskDetail.target.htmlText += '杀死<font color="#ff0000">'+taskArray[i].killCount+'</font>&nbsp;&nbsp;个<font color="#4049C2">'+taskArray[i].npcInfo.name+'</font>\n'
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
		
		public function onRecievableTask(event:ResultEvent,token:AsyncToken):void
		{
			RecievableTask.removeAllChildren();
			TaskInfo.instance.taskArray = event.result['data'] as Array;
			var array:Array = TaskInfo.instance.taskArray;
					
			for(var i:int=0;i<array.length;i++)
			{
				var taskInfo:TaskInfoComponent = new TaskInfoComponent();
				var textInfo:Text = new Text();
				var placeArray:Array = array[i].providerInfo.parentPlaceList as Array;
				RecievableTask.addChild(taskInfo);
				taskInfo.watchInfo.visible = false;
				taskInfo.taskName.htmlText = '<font size="14">'+array[i].name.toString()+'</font>';	
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
		
		public function onFinishedTask(event:ResultEvent,token:AsyncToken):void
		{
			FinishedTask.removeAllChildren();
			if(event.result['result'] == true)
			{
			TaskInfo.instance.taskArray = event.result['data'] as Array;
			var array:Array = TaskInfo.instance.taskArray;
			var taskNum:Label = new Label();
			FinishedTask.addChild(taskNum);
			taskNum.htmlText = '以下是最近完成的<font color="#ff0000">'+array.length+'</font>项任务';			
			for(var i:int=0;i<array.length;i++)
			{
				var taskId:int = array[i].id as int;
				var textInfo:Text = new Text();
				var taskInfo:TaskInfoComponent = new TaskInfoComponent();				
				FinishedTask.addChild(taskInfo);
				taskInfo.taskContent.addChild(textInfo);
				addInfoEventHandler(taskInfo.watchInfo,taskId);
				
				taskInfo.taskName.htmlText = '<font size="14">'+array[i].name.toString()+'</font>';	
			    switch(array[i].type)
			    {
			    	case 1:taskInfo.taskType.htmlText = "<font color='#ff0000'>主线任务</font>&nbsp;&nbsp;-";break;
				    case 2:taskInfo.taskType.htmlText = "<font color='#ff0000'>赏金任务</font>&nbsp;&nbsp;-";break;
				    case 3:taskInfo.taskType.htmlText = "<font color='#ff0000'>支线任务</font>&nbsp;&nbsp;-";break;
				    case 4:taskInfo.taskType.htmlText = "<font color='#ff0000'>转职任务</font>&nbsp;&nbsp;-";break;
			    }
				 taskInfo.taskCategory.htmlText = "&nbsp;&nbsp;<font color='#ff0000'>"+array[i].category+"</font>";

                var taskArray:Array = array[i].progressesDetails as Array;
                for(var n:int = 0; n<taskArray.length;n++)
		         {
		    	 textInfo.htmlText += (n+1)+'.前往&nbsp;&nbsp;';
		    	 var placeArray:Array = taskArray[n].parentPlaceList as Array;
		    	  if( taskArray[n].killCount != 0)
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
				  textInfo.htmlText += '杀死<font color="#ff0000">'+taskArray[n].killCount+'</font>个&nbsp;&nbsp;<font color="#4049C2">'+taskArray[n].npcInfo.name+'</font>\n'
				  }else if(taskArray[n].itemCount != 0)
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
				    textInfo.htmlText += '收集<font color="#ff0000">'+taskArray[n].itemCount+'</font>个&nbsp;&nbsp;<font color="#4049C2">'+taskArray[n].itemName+'</font>\n'
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
					 textInfo.htmlText += '与'+'&nbsp;&nbsp;<font color="#4049C2">'+  taskArray[n].npcInfo.name.toString()+'</font>&nbsp;&nbsp;交谈';
				  }		
		        }		           
				    var placeArray1:Array = array[i].accepterInfo.parentPlaceList as Array;
				  	textInfo.htmlText += (n+1)+'.前往&nbsp;&nbsp;';
				  	for(var l:int=0;l<placeArray1.length;l++)
				  	{
				  		if(l == (placeArray1.length -1))
				  		{
				  			textInfo.htmlText += '<font color="#04B404">'+placeArray1[l]+'</font>&nbsp;&nbsp;';
				  			break;
				  		}
				  		textInfo.htmlText += '<font color="#04B404">'+placeArray1[l]+'</font>-';
				  	}
				  	textInfo.htmlText += '向&nbsp;&nbsp;<font color="#4049C2">'+array[i].accepterInfo.name+'</font>&nbsp;&nbsp;交付任务';
				  	taskInfo.taskContent.addChild(textInfo);
			}
			}    
		}
		
		public function addInfoEventHandler(ui:UIComponent,tid:int):void
		{
		    ui.addEventListener(MouseEvent.CLICK,function():void{RemoteService.instance.getQuestDetails(collection.playerId,tid).addHandlers(onGetQuestDetails)});				
		}
	}
}