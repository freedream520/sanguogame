package com.glearning.melee.components.task
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.TaskTagComponent;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class NpcTaskListImpl extends VBox
	{
		public var taskTagList:VBox;
		public var acceptInfo:String;
		public var npcTalkInfo:Text;
		public var npcId:int;
		public function NpcTaskListImpl()
		{
			super();
		}
		
		public function init():void
		{
			npcTalkInfo.text = acceptInfo;
			RemoteService.instance.talkToNpc(collection.playerId,npcId).addHandlers(onTalkToNpc);
		}
		
		public function onTalkToNpc(event:ResultEvent, token:AsyncToken):void
		{
			var array:Array = event.result['data'] as Array;			
			  for(var i:int = 0;i<array.length;i++)
			  {			  	
			  	for(var n:int = 0;n<array[i].length;n++)
			  	{
			  	var _task:TaskTagComponent = new TaskTagComponent();			  	
			  	taskTagList.addChild(_task);			  	
			  	_task.taskName.label = array[i][n].name;
			  
			  	switch(i)
			  	{
			  		case 0: _task.taskTip.source = 'images/sanGuo/sina.png';
			  		        addEventHandler(_task.taskName,	array[i][n].questTemplateId,true);	  		       
			  		        break;
			  		case 1: var qid:int = array[1][n].id;
			  		        _task.taskTip.source = 'images/sanGuo/question.png';
			  		        addEventHandler(_task.taskName,	qid,false);				  		        
			  		        break;
			  		case 2: var eid:int = array[2][n].id;
			  		        _task.taskTip.source = 'images/sanGuo/emptyQuestion.png';
			  		        addEventHandler(_task.taskName,	eid,false);				  		        
			  		        break;
			  	}			  	
			  	}
			  }
			
		}
		
		public function addEventHandler(obj:UIComponent,num:int,flag:Boolean):void
		{
			if(flag == true)
			obj.addEventListener(MouseEvent.CLICK,function():void{parentDocument.getReceiveDetail(num);});		
			else
			obj.addEventListener(MouseEvent.CLICK,function():void{parentDocument.getTaskDetail(num);});		  		       
		}
		
	}
}