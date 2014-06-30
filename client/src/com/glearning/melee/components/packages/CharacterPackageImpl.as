package com.glearning.melee.components.packages
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.CustomerButtonComponent;
	import com.glearning.melee.components.utils.AutoTip;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.model.Package;
	import com.glearning.melee.model.PackageItem;
	import com.glearning.melee.net.RemoteService;
	
	import mx.containers.Canvas;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.messaging.events.MessageEvent;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	public class CharacterPackageImpl extends Canvas
	{
		public var _melee:melee = melee(Application.application);
		public var packageItems:PackageComponent;
		public var drawPackage:Package = new Package(14,4);
		public var tempButton:CustomerButtonComponent;
		
		public function CharacterPackageImpl()
		{
			addEventListener(FlexEvent.INITIALIZE,initPackage);
			addEventListener(FlexEvent.CREATION_COMPLETE,creationPackage)
		}
		
		
		
		public function initPackage(event:FlexEvent):void{
			RemoteService.instance.subscribe( collection.playerId.toString(), getTempPackage );
			//RemoteService.instance.getItemsInPackage(collection.playerId).addHandlers(loadPackageItems);
		}
		
		public function resetPackage():void{
			
			RemoteService.instance.getItemsInPackage(collection.playerId).addHandlers(loadPackageItems);
		}
		
		public function getTempPackage(event:MessageEvent):void{
			if(event.message.body.toString() == 'tempPackage'){
				tempButton.startEffect();
			}
			if(event.message.body.toString() == 'closeTempPackage'){
				tempButton.endEffect();
			}
		}
		
		public function creationPackage(event:FlexEvent):void{
			
				
		}
		
		public function openTempPackage():void{
			if(this.parent.parent is Application){
				_melee.tempPackage.init();
				_melee.tempPackage.visible = true;
			}
			
		}
		
		public function loadPackageItems(event:ResultEvent,token:AsyncToken):void{
			packageItems.removeAllChildren();
			drawPackage.items.splice(0);
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
			packageItems.packageData = drawPackage;
			packageItems.packageType = 'package';
			packageItems.drawPackageItems();
			if(MySelf.instance.isNewPlayer == 1 && Application.application.currentState == 'character')
			{
				if(MySelf.instance.progress == 3)
				{					
					AutoTip._showTip('双击装备武器',packageItems.getChildren()[0]);
				}else if(MySelf.instance.progress == 10)
				{
					packageItems.getChildren()[packageItems.getChildren().length-1].width =25;
					packageItems.getChildren()[packageItems.getChildren().length-1].height = 25;
					AutoTip._showTip('双击使用物品',packageItems.getChildren()[packageItems.getChildren().length-1]);
				}
			}
			
	
	
		}

		
		
		
	}
}