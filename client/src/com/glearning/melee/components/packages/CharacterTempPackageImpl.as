package com.glearning.melee.components.packages
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.model.Package;
	import com.glearning.melee.model.PackageItem;
	import com.glearning.melee.net.RemoteService;
	
	import mx.containers.Canvas; 
	import mx.events.FlexEvent;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class CharacterTempPackageImpl extends Canvas
	{
		public static var tempItemData:Array;
		public var tempPackage:PackageComponent;
		public var drawPackage:Package = new Package(10,8);
		
		public function CharacterTempPackageImpl()
		{
			//addEventListener(FlexEvent.SHOW,showPackage)
		}
		
//		public function showPackage(event:FlexEvent):void{
//
//			RemoteService.instance.getItemsInTempPackage(collection.playerId).addHandlers(loadPackageItems);
//		}
		
		public function init():void{
			if(MySelf.instance.status != '战斗中')
			{
				drawPackage.items.splice(0);
				tempPackage.removeAllChildren();			
				RemoteService.instance.getItemsInTempPackage(collection.playerId).addHandlers(loadPackageItems);
			}else{
				tempPackage.packageData = drawPackage;
				tempPackage.packageDrag = false;
				tempPackage.packageType = 'temporary_package';
				tempPackage.drawPackageItems();
			}
			
		}
		
		public function loadPackageItems(event:ResultEvent,token:AsyncToken):void{
			var itemList:Array = event.result as Array;
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
			tempPackage.packageData = drawPackage;
			tempPackage.packageDrag = false;
			tempPackage.packageType = 'temporary_package';
			tempPackage.drawPackageItems();
		}
		
		public function close():void{
//			drawPackage.items.splice(0);
//			tempPackage.removeAllChildren();
			this.visible = false;
		}
		
		public function sellAll():void{
			RemoteService.instance.sellAllItemsInTempPackage(collection.playerId).addHandlers(onSellAllItemsInTempPackage);
		}
		
		public function onSellAllItemsInTempPackage(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				var list:Array = event.result['itemSoldPosition'];
				for(var i:int = 0;i<list.length;i++){
					var tempItems:Array = tempPackage.getChildren();
					var tempDataItems:Array = tempPackage.packageData.items;
					for(var num:int =0;num<tempItems.length;num++)
					{
						if(tempItems[num].x == list[i][0]*26 && tempItems[num].y == list[i][1]*26 )
						{
							tempPackage.removeChildAt(num);
							tempDataItems.splice( num, 1 );
							break;
						}
					}
				}
				
				MySelf.instance.coin = event.result['coin'];
				
				if(event.result['cannotSellCount'] > 0)
				{
					collection.errorEvent('有'+event.result['cannotSellCount'].toString()+"个物品不能出售！",null);
				
				}
			}		
		}
		
	}
}