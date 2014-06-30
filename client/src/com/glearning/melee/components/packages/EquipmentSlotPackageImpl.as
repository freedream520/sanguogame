package com.glearning.melee.components.packages
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.model.Package;
	import com.glearning.melee.model.PackageItem;
	import com.glearning.melee.net.RemoteService;
	
	import mx.containers.Canvas;
	import mx.events.FlexEvent;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class EquipmentSlotPackageImpl extends Canvas
	{
		/**
		 *每个单元格的width 
		 */
		private var perWidth:int = 26;
		/**
		 *每个单元格的height
		 */
		private var perHeight:int = 26;
		
		public var bol:Boolean = true;
		
		public var weapon:PackageComponent;
		public var header:PackageComponent;
		public var cloak:PackageComponent;
		public var body:PackageComponent;
		public var belt:PackageComponent;
		public var trousers:PackageComponent;
		public var shoes:PackageComponent;
		public var waist:PackageComponent;
		public var bracer:PackageComponent;
		public var necklace:PackageComponent;
		public var weaponPackage:Package = new Package(2,4);
		public var headerPackage:Package = new Package(2,2);
		public var bodyPackage:Package = new Package(2,3);
		public var beltPackage:Package = new Package(2,1);
		public var trousersPackage:Package = new Package(2,3);
		public var shoesPackage:Package = new Package(2,2);
		public var bracerPackage:Package = new Package(2,2);
		public var cloakPackage:Package = new Package(2,4);
		public var necklacePackage:Package = new Package(1,1);
		public var waistPackage:Package = new Package(1,1);
		
		public var packageType:String = 'equipment_slot';
		
		
		public function EquipmentSlotPackageImpl()
		{
			addEventListener(FlexEvent.INITIALIZE,initPackage);
			addEventListener(FlexEvent.CREATION_COMPLETE,creationPackage);
		}
		
		public function initPackage(event:FlexEvent):void{
			
			//RemoteService.instance.getItemsInEquipSlot(collection.playerId).addHandlers(loadSlotPackageItems);	
		}
		
		public function resetPackage():void{
			
			RemoteService.instance.getItemsInEquipSlot(collection.playerId).addHandlers(loadSlotPackageItems);	
		}
		
		//查看其它玩家装备栏用
		public function peoplePackage(peopleId:int):void{
			RemoteService.instance.getOtherEquipSlot(collection.playerId,peopleId).addHandlers(loadSlotPackageItems);	
		}
		
		public function loadSlotPackageItems(event:ResultEvent,token:AsyncToken):void{
			for(var i:int = 0;i<event.result.length;i++){
				var packag:Package = getPackage(i);
				var packageComponent:PackageComponent = getPackageComponent(i);
				packageComponent.isPackage = bol;	
				packageComponent.removeAllChildren();
				packag.items.splice(0);
				if(event.result[i] != null){
					var obj:Object = event.result[i];
					var packageSlotItem:PackageItem = new PackageItem();
					packageSlotItem.itemInfo = obj['itemTemplateInfo'];
					packageSlotItem.image = obj['itemTemplateInfo']['icon'];
					packageSlotItem.width = obj['itemTemplateInfo']['width'];
					packageSlotItem.height = obj['itemTemplateInfo']['height'];
					packageSlotItem.itemBindType = obj['bindType'];
					packageSlotItem.itemIsBoundDesc = obj['isBoundDesc'];
					packageSlotItem.itemName = obj['name'];
					packageSlotItem.itemSellPrice = obj['sellPrice'];
					packageSlotItem.itemIsEquiped = obj['isEquiped'];
					packageSlotItem.count = 1;
					packageSlotItem.itemProperty = obj['extraAttributeList'] as Array;
					packageSlotItem.itemId = obj['itemId'];
					packageSlotItem.itemObj = obj;
					packag.items.push(packageSlotItem);
				}
				packageComponent.packageData = packag;
				packageComponent.packageType = packageType;
				packageComponent.packageLimitType = i;
				packageComponent.drawPackageItems();
			}
			
		}
		
		public function creationPackage(event:FlexEvent):void{
			
			
		}
		
		public function getPackageComponent(idx:int):PackageComponent{
			switch(idx){
				case 0:
					return header;
				case 1:
					return body;
				case 2:
					return belt;
				case 3:
					return trousers;
				case 4:
					return shoes;
				case 5:
					return bracer;
				case 6:
					return cloak;
				case 7:
					return necklace;
				case 8:
					return waist;
				case 9:
					return weapon;
			}
			return null;
		}
		
		public function getPackageLimitType(idx:int):String{
			switch(idx){
				case 0:
					return 'header';
				case 1:
					return 'body';
				case 2:
					return 'belt';
				case 3:
					return 'trousers';
				case 4:
					return 'shoes';
				case 5:
					return 'bracer';
				case 6:
					return 'cloak';
				case 7:
					return 'necklace';
				case 8:
					return 'waist';
				case 9:
					return 'weapon';
			}
			return null;
		}
		
		public function getPackage(idx:int):Package{
			switch(idx){
				case 0:
					return headerPackage;
				case 1:
					return bodyPackage;
				case 2:
					return beltPackage;
				case 3:
					return trousersPackage;
				case 4:
					return shoesPackage;
				case 5:
					return bracerPackage;
				case 6:
					return cloakPackage;
				case 7:
					return necklacePackage;
				case 8:
					return waistPackage;
				case 9:
					return weaponPackage;
			}
			return null;
		}
		

	}
}