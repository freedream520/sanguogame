//吕忠涛
package com.glearning.melee.components
{
	import com.glearning.melee.components.task.NpcTaskComponent;
	import com.glearning.melee.components.task.NpcTaskListComponent;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	public class NpcItemImpl extends Canvas
	{
		public var npcIcon:Image;
		public var npcName:Label;
		public var talkNpc:Image;
		public var npcTask:NpcTaskComponent;
		public var npcDescription:NpcDescriptionComponent;
		[Bindable]
		public var npcData:Object;
		
		public function NpcItemImpl()
		{
			super();
		}
		
		
		//NPC交谈
		public function talk():void{

            npcTask = new NpcTaskComponent();
            PopUpManager.addPopUp(npcTask,Application.application.canvas1,true);
            PopUpManager.centerPopUp(npcTask);
            npcTask.npcImage.source = (npcData.image as String).replace("32","170");
            npcTask.npcInfo = npcData;
            npcTask.npcId = npcIcon.data as int;
            npcTask.npcName.text = npcData.name.toString() ;
            npcTask.closeButton.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(npcTask)});
            var npcTaskList:NpcTaskListComponent = new NpcTaskListComponent();
            npcTaskList.acceptInfo = npcData.dialogContent;
            npcTaskList.npcId = npcData.id;
            npcTask.npcTalkTask.addChild(npcTaskList);
		}
		
		public function NpcInfo():void
		{
			npcDescription = new NpcDescriptionComponent();			
			PopUpManager.addPopUp(npcDescription,Application.application.canvas1,true);
			PopUpManager.centerPopUp(npcDescription);
			npcDescription.npcName.text = npcData.name;
			npcDescription.description.text = npcData.description;
			npcDescription.npcImage.source = (npcData.image as String).replace("32","170");
			npcDescription.closeButton.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(npcDescription)});
		}
	}
}