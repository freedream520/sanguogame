package com.glearning.melee.components.warehouseSystem
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.packages.CharacterPackageComponent;
	import com.glearning.melee.components.packages.CharacterTempPackageComponent;
	import com.glearning.melee.components.packages.PackageComponent;
	import com.glearning.melee.components.task.NpcTaskComponent;
	import com.glearning.melee.components.task.NpcTaskListComponent;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.model.Package;
	import com.glearning.melee.model.PackageItem;
	import com.glearning.melee.model.WareHouseInfo;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class WarehouseImpl extends Canvas
	{
		public var tempPackage:CharacterTempPackageComponent;
		public var characterPackage:CharacterPackageComponent;
		public var warehousePackage:PackageComponent;
		public var drawPackage:Package = new Package(6,6);
		public var placeId:int;
		[Bindable]
		public var page:int = 0;
		[Bindable]
		public var image:String;
		public var npcId:int;
		public var npcName:String;
		public var description:String;
		
		public function WarehouseImpl()
		{
			super();
		}
		
		public function init():void{
			page = 0;
			characterPackage.tempButton.addEventListener(MouseEvent.CLICK,openTempPackage);
			RemoteService.instance.getWarehouseInfo(collection.playerId,placeId).addHandlers( onResult );
		}
		
		//回调
		public function onResult(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				WareHouseInfo.instance.warehouseItems = event.result['data']['items'];
				tool(event.result['data']['items'][0]);
				image = event.result['data']['npcInfo']['image'];
				npcId = event.result['data']['npcInfo']['id'];
				npcName = event.result['data']['npcInfo']['name'];
				description = event.result['data']['npcInfo']['dialogContent'];
			}

		}
		
		//上一个仓库
		public function lastPackage():void{
			if (page -1 >= 0){
				page -= 1;
				WareHouseInfo.instance.warehouseItems[page+1] = WareHouseInfo.instance.oneWarehouseItems;
				RemoteService.instance.nextPageWarehouse(collection.playerId,page).addHandlers( onNextPageWarehouse );
			}
		}
		
		//下一个仓库
		public function nextPackage():void{
			if (page +1 <= MySelf.instance.warehouses-1){
				page += 1;
				WareHouseInfo.instance.warehouseItems[page-1] = WareHouseInfo.instance.oneWarehouseItems;
				RemoteService.instance.nextPageWarehouse(collection.playerId,page).addHandlers( onNextPageWarehouse );
			}
		}
		
		//重绘当前仓库
		public function restPackage():void{
			RemoteService.instance.nextPageWarehouse(collection.playerId,page).addHandlers( onNextPageWarehouse );
		}
		
		//翻页回调
		private function onNextPageWarehouse(event:ResultEvent,token:AsyncToken):void{
			tool(WareHouseInfo.instance.warehouseItems[page]);
		}
		
		public function tool(itemList:Array):void{
			warehousePackage.removeAllChildren();
			drawPackage.items.splice(0);
			WareHouseInfo.instance.oneWarehouseItems = itemList;
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
			warehousePackage.packageData = drawPackage;
			warehousePackage.packageType = 'warehouse_package';
			warehousePackage.drawPackageItems();	
		}
		
		public function backToCity():void
		{
			Application.application.currentState =  'city';
		}
		
		public function openTempPackage(event:MouseEvent):void{
			tempPackage.init();
			tempPackage.visible = true;
		}
		
		public function openDeposit():void{
			var deposit:DepositComponent = new DepositComponent();
			PopUpManager.addPopUp(deposit,Application.application.canvas1,true);
	        PopUpManager.centerPopUp(deposit);
		}
		
		public function openWithdrawal():void{
			var withdrawal:WithdrawalComponent = new WithdrawalComponent();
			PopUpManager.addPopUp(withdrawal,Application.application.canvas1,true);
	        PopUpManager.centerPopUp(withdrawal);
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
			
	}
}