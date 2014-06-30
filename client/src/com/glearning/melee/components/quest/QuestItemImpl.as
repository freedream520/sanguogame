package com.glearning.melee.components.quest
{
	import com.glearning.melee.model.QuestItem;
	
	import mx.containers.Canvas;

	public class QuestItemImpl extends Canvas
	{
		[Bindable]
		public var itemData:QuestItem = new QuestItem();
		
		public function QuestItemImpl()
		{
			super();
		}
		
		public function openQuestInfo():void{
			
		}
		
	}
}