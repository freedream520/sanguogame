package com.glearning.melee.model
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.packages.PackageImpl;
	import com.glearning.melee.components.packages.PackageItemComponent;
	import com.glearning.melee.components.packages.PackageItemImpl;
	import com.glearning.melee.net.RemoteService;
	

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class Package extends EventDispatcher
	{
		public static const EVENT_DATA_CHANGED:String = 'DataChanged';
		/**
		 *每个单元格的width 
		 */
		private var perWidth:int = 26;
		/**
		 *每个单元格的height
		 */
		private var perHeight:int = 26;
		
		/**
		 *单元格之间宽度间隔 
		 */
		private var intervalWidth:int = 2;
		/**
		 *单元格之间高度间隔
		 */
		private var intervalHeight:int = 2;
		
		public function Package(rows:uint = 0,columns:uint = 0)
		{
			_width = rows*perWidth;
//			_width = rows*perWidth+(rows-1)*intervalWidth;
//			_height = columns*perHeight+(columns-1)*intervalHeight; 
			_height = columns*perHeight;
			_items = new Array();
		}
			
		public var _width:uint;
		public function get width():uint{
			return _width
		}
		public function set width(value:uint):void{
			_width = value;
		}
		
		public var _height:uint;
		public function get height():uint{
			return _height;
		}
		public function set height(value:uint):void{
			_height = value;
		}
		
		public var _items:Array;
		public function get items():Array{
			return _items;
		}
		public function set items(value:Array):void{
			_items = value;
		}
		
		public var _itemIcon:PackageItemImpl;
		public function get itemIcon():PackageItemImpl{
			return _itemIcon;
		}
		public function set itemIcon(value:PackageItemImpl):void{
			_itemIcon = value;
		}
		
		public var _itemParent:PackageImpl;
		public function get itemParent():PackageImpl{
			return _itemParent;
		}
		public function set itemParent(value:PackageImpl):void{
			_itemParent = value;
		}

		public var _packageObj:Object;
		public function get packageObj():Object{
			return _packageObj;
		}
		public function set packageObj(value:Object):void{
			_packageObj = value;
		}
		
//		public function getItemInPosition( x:uint, y:uint ):PackageItem {
//			for( var i:int=0; i<this._items.length; i++ ) {
//				if( (_items[i] as PackageItem).containsPosition(x,y) ) {
//					return _items[i];
//				}
//			}
//			return null;
//		}
//		
//		public function canItemPutInPosition( item:PackageItem, x:uint, y:uint ):Boolean {
//			for( var i:int=0; i<this._items.length; i++ ) {
//				var oneItem:PackageItem = _items[i] as PackageItem;
//				if( oneItem.checkOverlap(item,x,y) ) {
//					// TODO: check wether two items can overlap
//					return false;
//				}
//			}
//			return true;
//		}
//		
//		public function putItemInPosition( item:PackageItem, x:uint, y:uint ):void {
//			if( this.canItemPutInPosition( item, x, y ) ) {
//				if( this._items.indexOf( item ) == -1 ) {
//					this._items.push( item );
//				}
//				item.xInPackage = x;
//				item.yInPackage = y;
//			}
//		}
//		
		public function removeItem( item:PackageItem ):void {
			var idx:int = this._items.indexOf( item );
			if( idx != -1 ) {
				this._items.splice( idx, 1 );
			}
		
		}


		//单个包裹栏中的移动 拆分 合并
		public function moveItem(newXY:Array,oldXY:Array,typeIn:String,typeOn:String,stack:int,thisObj:PackageImpl,childen:PackageItemImpl):void{
			this.itemParent = thisObj;
			this.itemIcon = childen;
			RemoteService.instance.moveItem(collection.playerId,newXY,oldXY,typeOn,typeIn,stack).addHandlers(onMoveItem);
		}
		
		public function onMoveItem(event:ResultEvent,token:AsyncToken):void{
			
			//拆合物品
			if(event.result['result'] == true){
				if(event.result['spareCount'] < 1){
					if(event.result['isMerge'] == true){
						var oneItem:PackageItem;
						removeEvent(this._itemIcon);
						this._itemIcon.parent.removeChild(this._itemIcon);
						for( var i:int=0; i<this._items.length; i++ ) {
							oneItem = _items[i] as PackageItem;
							if(oneItem.id == event.result['dragId']){
								this._items.splice( i, 1 );
							}
						}
						for( var j:int=0; j<this._items.length; j++ ) {
							oneItem = _items[j] as PackageItem;
							if(oneItem.id == event.result['destId']){
								oneItem.count = event.result['currentDestStack'];
								oneItem.itemObj.stack = event.result['currentDestStack'];
							}
						}
					}else{
						if(this.itemParent.packageType == 'warehouse_package'){
							var data:Array = WareHouseInfo.instance.oneWarehouseItems;
							for(var k:int= 0;k<data.length;k++){
								if(this._itemIcon.dataObj.idInPackage == data[k].idInPackage){
									data[k].position= event.result['currentPosition'];
								}
							}
						}
						this._itemIcon.x = event.result['currentPosition'][0] * perWidth;
						this._itemIcon.y = event.result['currentPosition'][1] * perHeight;
						this._itemIcon.data = event.result['currentPosition'];
						this._itemIcon.itemData.xInPackage = event.result['currentPosition'][0];
						this._itemIcon.itemData.yInPackage = event.result['currentPosition'][1];
						this._itemIcon.itemData.xy = event.result['currentPosition'];
						
						
					}
				}else{
					if(event.result['isMerge'] == true){
						for( var num:int=0; num <this._items.length; num++ ) {
							var one:PackageItem = _items[num] as PackageItem;
							if(one.id == event.result['destId']){
								one.count = event.result['currentDestStack'];
								one.itemObj.stack = event.result['currentDestStack'];
							}
						}
					}else{	
						var packageItem:PackageItem = new PackageItem();
						packageItem.id = event.result['newSplitRecord']['idInPackage'];
						packageItem.image = event.result['newSplitRecord']['itemTemplateInfo']['icon'];
						packageItem.xInPackage= event.result['newSplitRecord']['position'][0];
						packageItem.yInPackage = event.result['newSplitRecord']['position'][1];
						packageItem.xy = event.result['newSplitRecord']['position'];
						packageItem.width = event.result['newSplitRecord']['itemTemplateInfo']['width'];
						packageItem.height = event.result['newSplitRecord']['itemTemplateInfo']['height'];
						packageItem.count = event.result['newSplitRecord']['stack'];
						packageItem.stack = event.result['newSplitRecord']['itemTemplateInfo']['stack'];
						packageItem.itemInfo = event.result['newSplitRecord']['itemTemplateInfo'];
						packageItem.itemBindType = event.result['newSplitRecord']['bindType'];
						packageItem.itemIsBoundDesc = event.result['newSplitRecord']['isBoundDesc'];
						packageItem.itemName = event.result['newSplitRecord']['name'];
						packageItem.itemSellPrice = event.result['newSplitRecord']['sellPrice'];
						packageItem.itemIsEquiped = false;
						packageItem.itemId = event.result['newSplitRecord']['itemId'];
						packageItem.itemProperty = event.result['newSplitRecord']['extraAttributeList'] as Array;
						packageItem.itemObj = event.result['newSplitRecord'];
						this.items.push(packageItem);
						this.dispatchEvent(new Event(EVENT_DATA_CHANGED));	
					}
					this._itemIcon.dataObj.stack = event.result['spareCount'];
					this._itemIcon.itemData.count = event.result['spareCount'];
					if(this._itemIcon.itemData.count == 1){
						this._itemIcon.txtCount.text = '';
					}	
				}
			}else{
				errorException(event.result['reason'].toString());
				
				collection.errorEvent(event.result['reason'],event.result['data']);

			}
		}
		
		//2个包裹栏中的移动  拆分 合并
		public function moveItemFromOnePackageToAnother(obj:Object,fromPackage:String,toPackage:String,fromPosition:Object,toPosition:Object,stack:int,thisObj:PackageImpl,childen:PackageItemImpl):void{
			packageObj = obj;
			this.itemParent = thisObj;
			this.itemIcon = childen;
			RemoteService.instance.moveItemFromOnePackageToAnother(collection.playerId,fromPackage,toPackage,fromPosition,toPosition,stack).addHandlers(onMoveItemFromOnePackageToAnother);
		}
		
		public function buyItemFromShop(obj:Object,id:int,itemTemplateId:int,dropExtraAttributeId:String,stack:int,position:Array,toPosition:Array):void
		{
			packageObj = obj;
			RemoteService.instance.buyItem(id,itemTemplateId,dropExtraAttributeId,stack,position,toPosition).addHandlers(onBuyItem);
		}
		//商店回调
		public function onBuyItem(event:ResultEvent,token:AsyncToken):void
		{
			if(event.result['result'] == true)
             {
			    var packageItems:PackageItem = new PackageItem();
					packageItems.id = event.result['data']['newItem']['newSplitRecord']['idInPackage'];
					packageItems.image = event.result['data']['newItem']['newSplitRecord']['itemTemplateInfo']['icon'];
					packageItems.xInPackage= event.result['data']['newItem']['newSplitRecord']['position'][0];
					packageItems.yInPackage = event.result['data']['newItem']['newSplitRecord']['position'][1];
					packageItems.xy = event.result['data']['newItem']['newSplitRecord']['position'];
					packageItems.width = event.result['data']['newItem']['newSplitRecord']['itemTemplateInfo']['width'];
					packageItems.height = event.result['data']['newItem']['newSplitRecord']['itemTemplateInfo']['height'];
					packageItems.count = event.result['data']['newItem']['newSplitRecord']['stack'];
					packageItems.stack = event.result['data']['newItem']['newSplitRecord']['itemTemplateInfo']['stack'];
					packageItems.itemInfo = event.result['data']['newItem']['newSplitRecord']['itemTemplateInfo'];
					packageItems.itemBindType = event.result['data']['newItem']['newSplitRecord']['bindType'];
					packageItems.itemIsBoundDesc = event.result['data']['newItem']['newSplitRecord']['isBoundDesc'];
					packageItems.itemName = event.result['data']['newItem']['newSplitRecord']['name'];
					packageItems.itemSellPrice = event.result['data']['newItem']['newSplitRecord']['sellPrice'];
					packageItems.itemIsEquiped = false;
					packageItems.itemId = event.result['data']['newItem']['newSplitRecord']['itemId'];
					packageItems.itemObj = event.result['data']['newItem']['newSplitRecord'];
					packageItems.itemProperty = event.result['data']['newItem']['newSplitRecord']['extraAttributeList'] as Array;
					packageObj.packageData.items.push(packageItems);
					packageObj.packageData.dispatchEvent(new Event(EVENT_DATA_CHANGED));
					MySelf.instance.coin = event.result['data'].coin;
					Application.application.shopPage.productList.resetShop(event.result['data'].formerPosition);
             }else
             {
             	collection.errorEvent(event.result['reason'],null);
             	
             }
		}
		
		//包裹回调
		public function onMoveItemFromOnePackageToAnother(event:ResultEvent,token:AsyncToken):void{
			var oneItem:PackageItem;
			var packageItem:PackageItem = new PackageItem();
			var item:Array;
			if(event.result['result'] == true){
				if(event.result['isExchange'] == true){
					removeEvent(itemIcon);
					itemParent.removeChild(itemIcon);
					packageObj.removeAllChildren();
					packageObj.packageData.items.splice(0,1);
					for( var i:int=0; i<this._items.length; i++ ) {
						oneItem  = _items[i] as PackageItem;
						if(oneItem.id == event.result['dragId']){
							this._items.splice( i, 1 );
							break;
						}
					}
					
					packageItem.itemInfo = event.result['newItems'][0]['itemTemplateInfo'];
					packageItem.image = event.result['newItems'][0]['itemTemplateInfo']['icon'];
					packageItem.width = event.result['newItems'][0]['itemTemplateInfo']['width'];
					packageItem.height = event.result['newItems'][0]['itemTemplateInfo']['height'];
					packageItem.itemBindType = event.result['newItems'][0]['bindType'];
					packageItem.itemIsBoundDesc = event.result['newItems'][0]['isBoundDesc'];
					packageItem.itemName = event.result['newItems'][0]['name'];
					packageItem.itemSellPrice = event.result['newItems'][0]['sellPrice'];
					packageItem.itemIsEquiped = true;
					packageItem.itemId = event.result['newItems'][0]['itemId'];
					packageItem.count = 1;
					packageItem.itemProperty = event.result['newItems'][0]['extraAttributeList'] as Array;
					packageItem.itemObj = event.result['newItems'][0];
					packageObj.packageData.items.push(packageItem);
					packageObj.drawPackageItems();
					
					var packageItems:PackageItem = new PackageItem();
					packageItems.id = event.result['newItems'][1]['idInPackage'];
					packageItems.image = event.result['newItems'][1]['itemTemplateInfo']['icon'];
					packageItems.xInPackage= event.result['newItems'][1]['position'][0];
					packageItems.yInPackage = event.result['newItems'][1]['position'][1];
					packageItems.xy = event.result['newItems'][1]['position'];
					packageItems.width = event.result['newItems'][1]['itemTemplateInfo']['width'];
					packageItems.height = event.result['newItems'][1]['itemTemplateInfo']['height'];
					packageItems.count = event.result['newItems'][1]['stack'];
					packageItems.stack = event.result['newItems'][1]['itemTemplateInfo']['stack'];
					packageItems.itemInfo = event.result['newItems'][1]['itemTemplateInfo'];
					packageItems.itemBindType = event.result['newItems'][1]['bindType'];
					packageItems.itemIsBoundDesc = event.result['newItems'][1]['isBoundDesc'];
					packageItems.itemName = event.result['newItems'][1]['name'];
					packageItems.itemSellPrice = event.result['newItems'][1]['sellPrice'];
					packageItems.itemIsEquiped = false;
					packageItems.itemId = event.result['newItems'][1]['itemId'];
					packageItems.itemObj = event.result['newItems'][1];
					packageItems.itemProperty = event.result['newItems'][1]['extraAttributeList'] as Array;
					this.items.push(packageItems);
					this.dispatchEvent(new Event(EVENT_DATA_CHANGED));
					
				}else{
					if(event.result['spareCount'] == 0){
						removeEvent(itemIcon);
						itemParent.removeChild(itemIcon);
						if(itemParent.packageType == 'warehouse_package'){
							for(var j:int=0;j<WareHouseInfo.instance.oneWarehouseItems.length;j++){
								if(event.result['dragId'] == WareHouseInfo.instance.oneWarehouseItems[j].idInPackage){
									WareHouseInfo.instance.oneWarehouseItems.splice(j,1);
								}
							}
						}
						for( var k:int=0; k<this._items.length; k++ ) {
							oneItem = _items[k] as PackageItem;
							if(oneItem.id == event.result['dragId']){
								this._items.splice( k, 1 );
								break;
							}
						}
						if(event.result['isMerge'] == true){
							for( var l:int=0; l<packageObj.packageData.items.length; l++ ) {
								oneItem = packageObj.packageData.items[l] as PackageItem;
								if(oneItem.id == event.result['destId']){
									oneItem.count = event.result['currentDestStack'];
									oneItem.itemObj.stack = event.result['currentDestStack'];
									break;
								}
							}
						}else{
							if(event.result['isSlotPackage'] == true){
								this.items.splice( 0, 1 );
							}
							if(packageObj != null){
								if(packageObj.packageType == 'warehouse_package'){
									WareHouseInfo.instance.oneWarehouseItems.push(event.result['newSplitRecord']);
								}
								item = event.result['newSplitRecord'] as Array;
								packageItem.id = event.result['newSplitRecord']['idInPackage'];
								packageItem.image = event.result['newSplitRecord']['itemTemplateInfo']['icon'];
								packageItem.xInPackage= event.result['newSplitRecord']['position'][0];
								packageItem.yInPackage = event.result['newSplitRecord']['position'][1];
								packageItem.xy = event.result['newSplitRecord']['position'];
								packageItem.width = event.result['newSplitRecord']['itemTemplateInfo']['width'];
								packageItem.height = event.result['newSplitRecord']['itemTemplateInfo']['height'];
								packageItem.count = event.result['newSplitRecord']['stack'];
								packageItem.stack = event.result['newSplitRecord']['itemTemplateInfo']['stack'];
								packageItem.itemInfo = event.result['newSplitRecord']['itemTemplateInfo'];
								packageItem.itemBindType = event.result['newSplitRecord']['bindType'];
								packageItem.itemIsBoundDesc = event.result['newSplitRecord']['isBoundDesc'];
								packageItem.itemName = event.result['newSplitRecord']['name'];
								packageItem.itemSellPrice = event.result['newSplitRecord']['sellPrice'];
								packageItem.itemIsEquiped = false;
								packageItem.itemId = event.result['newSplitRecord']['itemId'];
								packageItem.itemProperty = event.result['newSplitRecord']['extraAttributeList'] as Array;
								packageItem.itemObj = event.result['newSplitRecord'];
								packageObj.xy = packageItem.xy;
								packageObj.packageData.items.push(packageItem);
								packageObj.packageData.dispatchEvent(new Event(EVENT_DATA_CHANGED));
							}
								
							
						}
					}else{
						if(event.result['isSlotPackage'] == true){
							removeEvent(itemIcon);
							itemParent.removeChild(itemIcon);
							for( var n:int=0; n<this._items.length; n++ ) {
								oneItem = _items[n] as PackageItem;
								if(oneItem.id == event.result['dragId']){
									this._items.splice( n, 1 );
									break;
								}
							}
							var type:String = getPackageLimitType(packageObj.packageLimitType);
							packageItem.itemInfo = event.result[type]['itemTemplateInfo'];
							packageItem.image = event.result[type]['itemTemplateInfo']['icon'];
							packageItem.width = event.result[type]['itemTemplateInfo']['width'];
							packageItem.height = event.result[type]['itemTemplateInfo']['height'];
							packageItem.itemBindType = event.result[type]['bindType'];
							packageItem.itemIsBoundDesc = event.result[type]['isBoundDesc'];
							packageItem.itemName = event.result[type]['name'];
							packageItem.itemSellPrice = event.result[type]['sellPrice'];
							packageItem.itemIsEquiped = true;
							packageItem.itemId = event.result[type]['itemId'];
							packageItem.count = 1;
							packageItem.itemProperty = event.result[type]['extraAttributeList'] as Array;
							packageItem.itemObj = event.result[type];
							packageObj.packageData.items.push(packageItem);
							packageObj.drawPackageItems();
						}else{
							this._itemIcon.dataObj.stack = event.result['spareCount'];
							this._itemIcon.itemData.count = event.result['spareCount'];
							if(event.result['isMerge'] == true){
								for( var m:int=0; m<packageObj.packageData.items.length; m++ ) {
									oneItem = packageObj.packageData.items[m] as PackageItem;
									if(oneItem.id == event.result['destId']){
										oneItem.count = event.result['currentDestStack'];
										oneItem.itemObj.stack = event.result['currentDestStack'];
										break;
									}
								}
							}else{
								item = event.result['newSplitRecord'] as Array;
								packageItem.id = event.result['newSplitRecord']['idInPackage'];
								packageItem.image = event.result['newSplitRecord']['itemTemplateInfo']['icon'];
								packageItem.xInPackage= event.result['newSplitRecord']['position'][0];
								packageItem.yInPackage = event.result['newSplitRecord']['position'][1];
								packageItem.xy = event.result['newSplitRecord']['position'];
								packageItem.width = event.result['newSplitRecord']['itemTemplateInfo']['width'];
								packageItem.height = event.result['newSplitRecord']['itemTemplateInfo']['height'];
								packageItem.count = event.result['newSplitRecord']['stack'];
								packageItem.stack = event.result['newSplitRecord']['itemTemplateInfo']['stack'];
								packageItem.itemInfo = event.result['newSplitRecord']['itemTemplateInfo'];
								packageItem.itemBindType = event.result['newSplitRecord']['bindType'];
								packageItem.itemIsBoundDesc = event.result['newSplitRecord']['isBoundDesc'];
								packageItem.itemName = event.result['newSplitRecord']['name'];
								packageItem.itemSellPrice = event.result['newSplitRecord']['sellPrice'];
								packageItem.itemIsEquiped = false;
								packageItem.itemId = event.result['newSplitRecord']['itemId'];
								packageItem.itemProperty = event.result['newSplitRecord']['extraAttributeList'] as Array;
								packageItem.itemObj = event.result['newSplitRecord'];
								packageObj.items.push(packageItem);
								packageObj.dispatchEvent(new Event(EVENT_DATA_CHANGED));	
								
							}
						}
						
					}
				}
				
				RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(collection.onLoadPlayerResult);
			}else{
				errorException(event.result['reason'].toString());
				
				collection.errorEvent(event.result['reason'],event.result['data']);

			}
			itemParent.isPackage = true;
		}
		
		//出售
		public function sellPackageItem(itemId:int,packageType:String,count:int,thisObj:PackageImpl,child:PackageItemComponent):void{
			this.itemIcon = child;
			this.itemParent = thisObj;
			RemoteService.instance.sellPackageItem(collection.playerId,itemId,packageType,count).addHandlers(onSellPackageItem);
		}
		
		public function onSellPackageItem(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				MySelf.instance.coin = event.result['data']['coin'];
				removeEvent(itemIcon);
				itemParent.removeChild(itemIcon);
				if(event.result['data']['isEquipmentSlot'] == true){
					this._items.splice( 0, 1 );
				}else{
					for( var i:int=0; i<this._items.length; i++ ) {
						var oneItem:PackageItem = _items[i] as PackageItem;
						if(oneItem.id == event.result['data']['idInPackage']){
							this._items.splice( i, 1 );
							break;
						}
					}
				}
				
			}else{
				errorException(event.result['reason'].toString());
				
				collection.errorEvent(event.result['reason'],event.result['data']);
			}
		}
		
		//丢弃
		public function dropItem(itemId:int,packageType:String,thisObj:PackageImpl,child:PackageItemComponent):void{
			this.itemIcon = child;
			this.itemParent = thisObj;
			RemoteService.instance.dropItem(collection.playerId,itemId,packageType).addHandlers(onDropItem);
		}
		
		public function onDropItem(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				removeEvent(itemIcon);
				itemParent.removeChild(itemIcon);
				if(event.result['data']['isEquipmentSlot'] == true){
					this._items.splice( 0, 1 );
				}else{
					for( var i:int=0; i<this._items.length; i++ ) {
						var oneItem:PackageItem = _items[i] as PackageItem;
						if(oneItem.id == event.result['data']['idInPackage']){
							this._items.splice( i, 1 );
							break;
						}
					}
				}
			}else{
				errorException(event.result['reason'].toString());
				
				collection.errorEvent(event.result['reason'],event.result['data']);
			}
		}
		
		//使用
		public function useItem(itemId:int,thisObj:PackageImpl,child:PackageItemComponent):void{
			this.itemIcon = child;
			this.itemParent = thisObj;
			RemoteService.instance.useItem(collection.playerId,itemId).addHandlers(onUseItem);
		}
		
		public function onUseItem(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				if(event.result['count'] == 0){
					removeEvent(itemIcon);
					itemParent.removeChild(itemIcon);
					for( var i:int=0; i<this._items.length; i++ ) {
						var oneItem:PackageItem = _items[i] as PackageItem;
						if(oneItem.id == event.result['idInPackage']){
							this._items.splice( i, 1 );
							break;
						}
					}
				}else{
					itemIcon.dataObj.stack =  event.result['count'];
					itemIcon.itemData.count =  event.result['count'];
					if(itemIcon.itemData.count == 1){
						this._itemIcon.txtCount.text = '';
					}
				}
				
				if(event.result['data'][0] == '瞬时效果'){
					MySelf.instance.hp =  event.result['data'][1];
					MySelf.instance.mp =  event.result['data'][2];
					Application.application.baseAvatar.update();
				}else{
					Application.application.mainAvatar.onLeftEffect(event.result['data'][1]);
				}
			}else{
				errorException(event.result['reason'].toString());
				
				collection.errorEvent(event.result['reason'],event.result['data']);
			}
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
		
		//删除监听事件
		public function removeEvent(uiComponent:UIComponent):void{
			uiComponent.removeEventListener(MouseEvent.MOUSE_MOVE,function():void{});			
			uiComponent.removeEventListener(MouseEvent.DOUBLE_CLICK,function():void{});
			uiComponent.removeEventListener(MouseEvent.CLICK,function():void{});
		}
		
		//异常操作处理
		public function errorException(str:String):void{
			if(str.indexOf('存在') != -1){
				if(this.itemParent.packageType == 'warehouse_package' || packageObj.packageType == 'warehouse_package'){
					if(Application.application.currentState == 'warehouse')
						Application.application.warehouse.restPackage();
				}
				if(this.itemParent.packageType == 'forging_package' || packageObj.packageType == 'forging_package'){
					if(Application.application.currentState == 'forging')
						Application.application.forging.restPackage();
				}
				if(this.itemParent.packageType == 'package' || packageObj.packageType == 'package'){
					if(Application.application.currentState == 'character'){
						Application.application.characterPackage.resetPackage();
					}
					if(Application.application.currentState == 'warehouse'){
						Application.application.warehouse.characterPackage.resetPackage();
					}
					if(Application.application.currentState == 'forging'){
						Application.application.forging.characterPackage.resetPackage();
					}
				}
				if(this.itemParent.packageType == 'temporary_package' || packageObj.packageType == 'temporary_package'){
					if(Application.application.currentState == 'character'){
						Application.application.tempPackage.init();
					}
					if(Application.application.currentState == 'warehouse'){
						Application.application.warehouse.tempPackage.init();
					}
					if(Application.application.currentState == 'forging'){
						Application.application.forging.tempPackage.init();
					}
				}
				if(this.itemParent.packageType == 'equipment_slot'){
					if(Application.application.currentState == 'character'){
						Application.application.slot.resetPackage();
					}
					if(Application.application.currentState == 'warehouse'){
						Application.application.warehouse.equip.resetPackage();
					}
					if(Application.application.currentState == 'forging'){
						Application.application.forging.equip.resetPackage();
					}
				}
			}
		} 
	}
}