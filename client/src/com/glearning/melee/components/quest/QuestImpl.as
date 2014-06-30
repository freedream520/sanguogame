package com.glearning.melee.components.quest
{
	import com.glearning.melee.net.RemoteService;
	
	import mx.containers.Canvas;
	import mx.controls.List;
	import mx.events.ItemClickEvent;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	public class QuestImpl extends Canvas
	{
		public var FinishedQuest:List;
		public var ProgressingQuest:List;
		public var RecievableQuest:List;
			
		public function QuestImpl()
		{
			super();
		}
		
		//linkBar点击事件
		public function questLinkBar(event:ItemClickEvent):void{
			if(event.label == '当前任务'){
				RemoteService.instance.getProgressingQuests(1).addHandlers(onGetProgressingQuests);
			}else{
				if(event.label == '可接任务'){
					RemoteService.instance.getRecievableQuests(1).addHandlers(onGetRecievableQuests);
				}else{
					RemoteService.instance.getFinishedQuests(1).addHandlers(onGetFinishedQuests);
				}
			}
			
		}
		
		//当前任务回调
		public function onGetProgressingQuests(event:ResultEvent,token:AsyncToken):void{
			
		}
		
		//可接任务回调
		public function onGetRecievableQuests(event:ResultEvent,token:AsyncToken):void{
			
		}
		
		//完成任务回调
		public function onGetFinishedQuests(event:ResultEvent,token:AsyncToken):void{
			
		}
		
		
	}
}