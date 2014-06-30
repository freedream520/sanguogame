package com.glearning.melee.components.forgingSystem
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.packages.CharacterPackageComponent;
	import com.glearning.melee.components.packages.CharacterTempPackageComponent;
	import com.glearning.melee.components.packages.PackageComponent;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.components.task.NpcTaskComponent;
	import com.glearning.melee.components.task.NpcTaskListComponent;
	import com.glearning.melee.model.Package;
	import com.glearning.melee.model.PackageItem;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class ForgingImpl extends Canvas
	{
		public var tempPackage:CharacterTempPackageComponent;
		public var characterPackage:CharacterPackageComponent;
		public var forgingPackage:PackageComponent;
		public var drawPackage:Package = new Package(6,6);
		public var placeId:int;
		[Bindable]
		public var image:String;
		public var npcId:int;
		public var npcName:String;
		public var description:String;
		public function ForgingImpl()
		{
			super();
		}
		
		public function init():void{
			characterPackage.tempButton.addEventListener(MouseEvent.CLICK,openTempPackage);
			RemoteService.instance.getForgingPackage(collection.playerId,placeId).addHandlers( onResult );
		}
		
		//重绘包裹
		public function restPackage():void{
			RemoteService.instance.getForgingPackage(collection.playerId,placeId).addHandlers( onResult );
		}
		
		
		public function openTempPackage(event:MouseEvent):void{
			tempPackage.init();
			tempPackage.visible = true;
		}
		
		//回调
		public function onResult(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				tool(event.result['data']['items']);
				image = event.result['data']['npcInfo']['image'];
				npcId = event.result['data']['npcInfo']['id'];
				npcName = event.result['data']['npcInfo']['name'];
				description = event.result['data']['npcInfo']['dialogContent'];
			}

		}
		
		public function tool(itemList:Array):void{
			for each(var item:Object in itemList){
				var packageItem:PackageItem = new PackageItem();
				packageItem.id = item['idInPackage'];
				packageItem.image = item['itemTemplateInfo']['icon'];
				packageItem.xInPackage= item['position'][0];
				packageItem.yInPackage = item['position'][1];
				packageItem.width = item['itemTemplateInfo']['width'];
				packageItem.height = item['itemTemplateInfo']['height'];
				packageItem.count = item['stack'];
				packageItem.stack = item['itemTemplateInfo']['stack'];
				packageItem.itemInfo = item['itemTemplateInfo'];
				packageItem.xy = item['position'];
				packageItem.itemBindType = item['bindType'];
				packageItem.itemIsBoundDesc = item['isBoundDesc'];
				packageItem.itemName = item['name'];
				packageItem.itemSellPrice = item['sellPrice'];
				packageItem.itemIsEquiped = item['isEquiped'];
				packageItem.itemId = item['itemId'];
				packageItem.itemProperty = item['extraAttributeList'] as Array;
				packageItem.itemObj = item;
				drawPackage.items.push(packageItem);
			}
			forgingPackage.packageData = drawPackage;
			forgingPackage.packageType = 'forging_package';
			forgingPackage.drawPackageItems();	
		}
		
		public function backToCity():void
		{
			forgingPackage.removeAllChildren();
			drawPackage.items.splice(0);
			Application.application.currentState =  'city';
		}
		
		//交谈
		public function showTask():void
		{
			var npcTask:NpcTaskComponent = new NpcTaskComponent();
            PopUpManager.addPopUp(npcTask,Application.application.canvas1,true);
            PopUpManager.centerPopUp(npcTask);
            npcTask.npcImage.source = image;           
            npcTask.npcId = npcId;            
            npcTask.npcName.text = npcName;
            npcTask.closeButton.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(npcTask)});
            var npcTaskList:NpcTaskListComponent = new NpcTaskListComponent();
            npcTaskList.acceptInfo = description;
            npcTaskList.npcId = npcId;
            npcTask.npcTalkTask.addChild(npcTaskList);
		}
		
		//合成
		public function startSynthetic():void{
			RemoteService.instance.setSyntheticItem(collection.playerId).addHandlers( onSyntheticItem );
		}
		
		private function onSyntheticItem(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				tip(event.result['reason']);
				forgingPackage.removeAllChildren();
				drawPackage.items.splice(0);
				tool(event.result['data']);
			}else{
				tip(event.result['reason']);
			}
		}
		
		public function tip(reason:String):void{
			var tip:NormalTipComponent = new NormalTipComponent();
			PopUpManager.addPopUp(tip,Application.application.canvas1,true);
	        PopUpManager.centerPopUp(tip);
	        tip.hideButton();
	        tip.tipText.text = reason;
	        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});
		}
	}
}