package com.glearning.melee.components.shop
{
	import com.glearning.melee.components.packages.PackageComponent;
	import com.glearning.melee.model.Package;
	import com.glearning.melee.model.PackageItem;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.LinkButton;

	public class ProductListImpl extends Canvas
	{
		public var packageItems:PackageComponent;
		public var drawPackage:Package = new Package(6,8);
		public var last:LinkButton;
		public var next:LinkButton;
		public var placeId:int;
		public var itemArray:Array;
		public var pageNum:int;
		public var itemContent:Canvas;
		public var currentArray:Array;
		public function ProductListImpl()
		{
			super();
		}
		
		public function init():void
		{
			itemArray = new Array();
			pageNum = 1;
			
		}
	
		
		public function showItems(array:Array):void
		{
			packageItems.removeAllChildren();
			currentArray = new Array();
			currentArray = array;            
			drawPackage.items.splice(0);	   
			for each(var item:Object in array){
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
			packageItems.packageType = 'shop_package';
			packageItems.drawPackageItems();
		}
		
		public function nextPage(event:MouseEvent):void
		{
			if(pageNum < itemArray.length)
			{
				showItems(itemArray[pageNum]);
				pageNum++;
			}
		}
		
		public function lastPage(event:MouseEvent):void
		{
			if(pageNum != 1)
			{
				showItems(itemArray[pageNum-2]);
				pageNum--;
			}
		}
		
		public function resetShop(position:Array):void
		{
			for(var i:int =0 ; i<currentArray.length;i++)
			{
				if(currentArray[i].position[0] == position[0] && currentArray[i].position[1] == position[1])
				{
					currentArray.splice(i,1);
					packageItems.removeChildAt(i);
				}
			}
//			showItems(currentArray);
//            var childArray:Array = packageItems.getChildren();
//            for(var j:int =0 ; j<childArray.length;j++)
//            {
//            	if(childArray[j].x == position[0] && childArray[j].y == position[1])
//            	{
//            		packageItems.removeChildAt(j);
//            	}
//            }
			
		}
		
	
	}
}