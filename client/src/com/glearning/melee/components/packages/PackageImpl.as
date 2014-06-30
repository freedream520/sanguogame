package com.glearning.melee.components.packages
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.CustomerTooltipComponent;
	import com.glearning.melee.components.prompts.SplitItemComponent;
	import com.glearning.melee.components.utils.AutoTip;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.model.Package;
	import com.glearning.melee.model.PackageItem;
	import com.glearning.melee.net.RemoteService;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Canvas;
	import mx.containers.Grid;	
	import mx.controls.Image;
	import mx.core.Application;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class PackageImpl extends Canvas implements IEventDispatcher
	{
		private var _packageData:Package;
		public function get packageData():Package {
			return _packageData;
		}
		public function set packageData(data:Package):void {
			_packageData = data;
			// 绘制包裹
			_packageData.addEventListener(Package.EVENT_DATA_CHANGED,onNewItemIcon);
		}
		
		//包裹是否可以拖放
		private var _packageDrag:Boolean = true;
		public function get packageDrag():Boolean{
			return _packageDrag;
		}
		public function set packageDrag(value:Boolean):void{
			_packageDrag = value;
		}
		
		//包裹是否可以使用
		private var _isPackage:Boolean = true;
		public function get isPackage():Boolean{
			return _isPackage;
		}
		public function set isPackage(value:Boolean):void{
			_isPackage = value;
		}
		
		//包裹类型
		private var _packageType:String;
		public function get packageType():String{
			return _packageType;
		}
		public function set packageType(value:String):void{
			_packageType = value;
		}
		
		//包裹限制物品类型
		private var _packageLimitType:int;
		public function get packageLimitType():int{
			return _packageLimitType;
		}
		public function set packageLimitType(value:int):void{
			_packageLimitType = value;
		}
		
		//人物装备物品数据
		private static var _slotPackageData:Object;
		
		private static const EVENT_SLOT_DATA:String = 'SlotPackage';
		
		/**
		 *包裹栏行数 
		 */
		private var rows:int = 14;
		/**
		 *包裹栏列数 
		 */
		private var columns:int = 4;
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
		private var intervalWidth:int = 0;
		/**
		 *单元格之间高度间隔
		 */
		private var intervalHeight:int = 0;
		
		private var oldX:int;
		
		private var oldY:int;
		
		public var xy:Array;
		
		private var doubleClickStrFlag:String;
		
		private var doubleClickObj:PackageItemImpl;
		
		private var onMouseEvent:Boolean = true;
		
		private var tooltip:CustomerTooltipComponent;
		
		public var test:Grid;
		
 		public function PackageImpl()
		{
			super();
			addEventListener(DragEvent.DRAG_ENTER,onDragEnter); 
			addEventListener(DragEvent.DRAG_DROP,onDragDrop);
			addEventListener(MouseEvent.MOUSE_MOVE,onCanvasMove);
		}
		
		/**
		 *初始化包裹栏，加载玩家包裹栏中的物品 
		 * @param event
		 * 
		 */
		
		public function drawPackageItems():void{
			this.width = packageData.width;
			this.height = packageData.height;
			if(packageType == 'equipment_slot'){
				this.styleName = 'roleStyle';
			}else if(packageType == 'package'){
				this.styleName = 'packageStyle';
			}else{
				this.styleName = 'itemInfo';
			}
			
			var itemList:Array = packageData.items as Array;
			for each(var item:Object in itemList){
				var itemIcon:PackageItemComponent = new PackageItemComponent();
				itemIcon.itemData = item as PackageItem;
				
				itemIcon.doubleClickEnabled = true;				
				if(packageType == 'equipment_slot'){
					itemIcon.x = 0;
					itemIcon.y = 0;
					itemIcon.data =[0,0];
				}else{
					itemIcon.x = item['xInPackage'] * perWidth;
					itemIcon.y = item['yInPackage'] * perHeight;
					itemIcon.data = item['xy'];
				}	
				itemIcon.doubleClickEnabled = true;	
				itemIcon.addEventListener(MouseEvent.MOUSE_MOVE,drag);
				if(isPackage){
					if(packageType != 'temporary_package'){
						itemIcon.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
						itemIcon.addEventListener(MouseEvent.CLICK,onClick);
					}					
				}				
				addChild(itemIcon);			
				BindingUtils.bindProperty(itemIcon,'dataObj',item,'itemObj');	
				itemIcon.dataObj = item.itemObj;
				itemIcon.setCount();
				
			}
		}
		

		
		/**
		 *在包裹栏中移动物品 
		 * @param event
		 * 
		 */

		public function drag(event:MouseEvent):void{
			if(isPackage){
				var obj:PackageItemImpl = event.currentTarget as PackageItemImpl;
				if(DragManager.isDragging == false){
					packageData.itemIcon = obj;	
					oldX = event.localX;
					oldY = event.localY;
				}
				
				
				var dragInitor:UIComponent=UIComponent(event.currentTarget);
				/*用来包括拖拽过程中的数据对象*/
				var dragSource:DragSource = new DragSource();
				dragSource.addData(dragInitor,packageType);
				/*创建拖拽对象代理作为拷贝*/
				var dragProxy:Image = new Image();

				dragProxy.graphics.lineStyle(1,0xffffff,1);
				dragProxy.graphics.moveTo(0,0);
				dragProxy.graphics.lineTo(event.currentTarget.itemImage.width,0);
				dragProxy.graphics.lineTo(event.currentTarget.itemImage.width,event.currentTarget.itemImage.height);
				dragProxy.graphics.lineTo(0,event.currentTarget.itemImage.height);
				dragProxy.graphics.lineTo(0,0);
				dragProxy.source = event.currentTarget.itemImage.source;
				dragProxy.width = event.currentTarget.itemImage.width;
				dragProxy.height = event.currentTarget.itemImage.height;

				DragManager.doDrag(dragInitor,dragSource,event,dragProxy);
			}
		}
		
		public function onDragEnter(event:DragEvent):void{
			if(packageDrag){
			var dragTarget:Canvas = event.currentTarget as Canvas;
			DragManager.acceptDragDrop(dragTarget);
			}	
		}
		
		public function onDragDrop(event:DragEvent):void{	
			var obj:Object = event.dragInitiator.parent;		
			var x:int = event.localX  - obj.oldX;
			var y:int = event.localY - obj.oldY;
			xy = getItemXY(x,y);
			var item:Object = event.dragInitiator;			
			var obj_properties:Object = item.itemData.itemObj;
			if(isItemPositionValid(xy,item.width,item.height) == false){return} 		
			if((event.dragSource.formats[0].toString() == 'package' && this.packageType == 'package')||(event.dragSource.formats[0].toString() == 'warehouse_package' && this.packageType == 'warehouse_package') ||(event.dragSource.formats[0].toString() == 'forging_package' && this.packageType == 'forging_package')){
				if(event.dragInitiator['itemData']['count'] >1){
					obj.CreatePopWindow(packageData,xy,event,this.packageType,obj,event.dragInitiator);
				}else{
					obj.packageData.moveItem(xy,event.dragInitiator['data'],packageType,event.dragSource.formats[0].toString(),1,obj,event.dragInitiator);
				}
			}
			//商店拆分
//			if(event.dragSource.formats[0].toString() == 'shop_package' && this.packageType == 'package'){
//				if(event.dragInitiator['itemData']['count'] >1)
//				{
//					obj.CreatePopWindow(packageData,xy,event,'package',obj,event.dragInitiator);
//				}
//			}
			if(event.dragSource.formats[0].toString() == 'temporary_package' && this.packageType == 'package'){
			 
				obj.packageData.moveItemFromOnePackageToAnother(this,'temporary_package','package',obj.packageData.itemIcon.data,xy,obj.packageData.itemIcon.itemData.count,obj,event.dragInitiator);
			}
			if(event.dragSource.formats[0].toString() == 'equipment_slot' && this.packageType == 'package'){
				obj.packageData.moveItemFromOnePackageToAnother(this,'equipment_slot','package',obj.packageLimitType,xy,obj.packageData.itemIcon.itemData.count,obj,event.dragInitiator);
			}
			if(event.dragSource.formats[0].toString() == 'package' && this.packageType == 'equipment_slot'){
				obj.xy = obj.packageData.itemIcon.data;				
				obj.packageData.moveItemFromOnePackageToAnother(this,'package','equipment_slot',obj.packageData.itemIcon.data,packageLimitType,obj.packageData.itemIcon.itemData.count,obj,event.dragInitiator);
			}
			if(event.dragSource.formats[0].toString() == 'shop_package' && this.packageType == 'package'){
				var extraAttribute:String = '';	
				var stackInfo:int = 0;
				for(var i:int = 0;i<obj_properties.extraAttributeList.length;i++)
				{
					extraAttribute += obj_properties.extraAttributeList[i].id+',';
				}	
				obj.packageData.buyItemFromShop(this,collection.playerId,obj_properties.itemTemplateInfo.id,extraAttribute,obj_properties.stack,obj_properties.position,xy);
				
			}
			if(event.dragSource.formats[0].toString() == 'package' && this.packageType == 'shop_package')
			{
				obj.packageData.sellPackageItem(item.itemData.itemId,'package',item.itemData.count,obj,item);
			}
			//仓库与包裹栏
			if(event.dragSource.formats[0].toString() == 'warehouse_package' && this.packageType == 'package'){
			 
				obj.packageData.moveItemFromOnePackageToAnother(this,'warehouse_package','package',obj.packageData.itemIcon.data,xy,obj.packageData.itemIcon.itemData.count,obj,event.dragInitiator);
			}
			if(event.dragSource.formats[0].toString() == 'package' && this.packageType == 'warehouse_package'){
			 
				obj.packageData.moveItemFromOnePackageToAnother(this,'package','warehouse_package',obj.packageData.itemIcon.data,xy,obj.packageData.itemIcon.itemData.count,obj,event.dragInitiator);
			}
			if(event.dragSource.formats[0].toString() == 'temporary_package' && this.packageType == 'warehouse_package'){
			 
				obj.packageData.moveItemFromOnePackageToAnother(this,'temporary_package','warehouse_package',obj.packageData.itemIcon.data,xy,obj.packageData.itemIcon.itemData.count,obj,event.dragInitiator);
			}
			if(event.dragSource.formats[0].toString() == 'equipment_slot' && this.packageType == 'warehouse_package'){
				obj.packageData.moveItemFromOnePackageToAnother(this,'equipment_slot','warehouse_package',obj.packageLimitType,xy,obj.packageData.itemIcon.itemData.count,obj,event.dragInitiator);
			}
			
			//锻造
			if(event.dragSource.formats[0].toString() == 'package' && this.packageType == 'forging_package'){
			 
				obj.packageData.moveItemFromOnePackageToAnother(this,'package','forging_package',obj.packageData.itemIcon.data,xy,obj.packageData.itemIcon.itemData.count,obj,event.dragInitiator);
			}
			if(event.dragSource.formats[0].toString() == 'forging_package' && this.packageType == 'package'){
			 
				obj.packageData.moveItemFromOnePackageToAnother(this,'forging_package','package',obj.packageData.itemIcon.data,xy,obj.packageData.itemIcon.itemData.count,obj,event.dragInitiator);
			}
		}
		
		public function CreatePopWindow(packageInfo:Package,array:Array,event:DragEvent,type:String,obj:PackageImpl,child:PackageItemImpl):void
		{
			var SplitWindow:SplitItemComponent = new SplitItemComponent();
			SplitWindow.splitNum = event.dragInitiator['itemData'];
			SplitWindow.x = Application.application.width/6*3;
			SplitWindow.y = Application.application.height/5*3;			
			PopUpManager.addPopUp(SplitWindow,this,true);
			SplitWindow.cancel.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(SplitWindow)});
			SplitWindow.accept.addEventListener(MouseEvent.CLICK,function():void{		
			if(int(SplitWindow.num.text)>SplitWindow.splitNum.count)
			SplitWindow.alertNum.visible = true;  
			else{ 
			SplitWindow.splitFinish(packageInfo,array,event,type,obj,child);
			PopUpManager.removePopUp(SplitWindow);
			}
			});
		}
		
		/**
		 *判断物品位置是否合法（物品是否超出包裹栏边框） 
		 * @param height:物品的高度
		 * @param width：物品的宽度 
		 * @return bool
		 */
		public function isItemPositionValid(position:Array,width:int,height:int):Boolean{
			if((width+perWidth*position[0]-2)>this.width || (height+perHeight*position[1]-4) > this.height){
				return false;
			}
			return true;
		}		
		
		/**
		 *根据格子坐标设置物品x,y坐标 
		 * @param position
		 * 
		 */
		public function getItemGridXY(item:Object,position:Array):void{
			if(isItemPositionValid(position,item.width,item.height) == false){return} 
			item.x = int(position[0])*perWidth;
			item.y = int(position[1])*perHeight;
		}
		
		/**
		 *根据物品的格子位子得到横纵格子坐标
		 * 
		 */
		public function getItemXY(x:int,y:int):Array{
			var gridX:int = (x+perWidth)/perWidth -1;
			var gridY:int = (y+perHeight)/perHeight -1;
			if(gridX<0){gridX=0}
			if(gridY<0){gridY=0}
			return [gridX,gridY];
		}
		
		//添加新的物品实例
		private function onNewItemIcon(event:Event):void{
			var itemList:Array = packageData.items as Array;
			for each(var item:Object in itemList){
				if(item['xInPackage'] == xy[0] && item['yInPackage'] == xy[1]){		
					var newItemIcon:PackageItemComponent = new PackageItemComponent();
					newItemIcon.itemData = item as PackageItem;
					newItemIcon.x = item['xInPackage'] * perWidth;
					newItemIcon.y = item['yInPackage'] * perHeight;
					newItemIcon.data = xy;
					newItemIcon.dataObj = item.itemObj;
					this.addChild(newItemIcon);
					newItemIcon.setCount();
					newItemIcon.addEventListener(MouseEvent.CLICK,onClick);
					newItemIcon.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
					newItemIcon.addEventListener(MouseEvent.MOUSE_MOVE,drag);
					newItemIcon.doubleClickEnabled = true;
				}
				
			}
		}
		
		
		//双击调用
		public function onDoubleClick(event:MouseEvent):void
		{	
			doubleClickObj = event.currentTarget as PackageItemImpl;
			doubleClickStrFlag = event.type.toString(); 
			if(MySelf.instance.isNewPlayer == 1)
			{
				if(MySelf.instance.progress == 3 || MySelf.instance.progress == 10)
				{
					AutoTip._destoryTip();
					RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onNewPlayerQuestInfo);			
				}
					
			}
			
		}
		
		//新手指导
		public function onNewPlayerQuestInfo(event:ResultEvent,token:AsyncToken):void
		{
			RemoteService.instance.addReward(collection.playerId,event.result['data'][0][3],event.result['data'][0][5],event.result['data'][0][4]).addHandlers(onAddReward);
			
		}
		
		public function onAddReward(event:ResultEvent,token:AsyncToken):void
		{
			RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(collection.onLoadPlayerResult);
			RemoteService.instance.changeQuestProgress(collection.playerId,MySelf.instance.progress+1).addHandlers(onChangeQuestProgress);
			MySelf.instance.progress = MySelf.instance.progress+1;	     
		}
		
		public function onChangeQuestProgress(event:ResultEvent,token:AsyncToken):void
		{
			Application.application.newPlayerQuestProgress(event.result.progress);
			Application.application.frashMiniTask();
		}
		
		//单击调用
		public function onClick(event:MouseEvent):void
		{
			doubleClickObj = event.currentTarget as PackageItemImpl;
			doubleClickStrFlag = event.type.toString(); 
			setTimeout(laterClickFunction,200);
		}
		
		 public function laterClickFunction():void {
		 	var obj:Object = doubleClickObj.parent as PackageImpl;
		 	var slotObj:Object = new Object();
		 	packageLimitType = doubleClickObj.itemData.itemInfo.bodyType -1;
		 	if(Application.application.currentState == 'character')
		 	{
			    slotObj = getSlotObj(packageLimitType);
		 	}else if(Application.application.currentState == 'shop')
		 	{
		 		slotObj = getShopSlotObj(packageLimitType);
		 	}else if(Application.application.currentState == 'warehouse'){
		 		slotObj = getWarehouseSlotObj(packageLimitType);
		 	}else if(Application.application.currentState == 'forging'){
		 		slotObj = getForgingSlotObj(packageLimitType);
		 	}
			xy = doubleClickObj.itemData.xy;
			if( packageType != 'shop_package')
			{
	 		if(doubleClickStrFlag == "doubleClick" && packageType != 'temporary_package' && packageType !='forging_package' && packageType !='warehouse_package') {	 			
	 				var type:String = collection.getItemTypeGroupString(doubleClickObj.itemData.itemInfo.type);
		        	if(type == '道具' && doubleClickObj.itemData.itemInfo['addEffect'] !='-1'){
		        		obj.packageData.useItem(doubleClickObj.itemData.itemId,obj,doubleClickObj);
		        	}else{
		        		if(type == '武器' || type == '防具'){
			        		if(this.packageType == 'package')
							{	
								obj.packageData.moveItemFromOnePackageToAnother(slotObj,'package','equipment_slot',obj.packageData.itemIcon.data,packageLimitType,obj.packageData.itemIcon.itemData.count,obj,doubleClickObj);	 
							}
							if(this.packageType == 'equipment_slot'){
								if(Application.application.currentState == 'character')
								{
									obj.packageData.moveItemFromOnePackageToAnother(Application.application.characterPackage.packageItems,'equipment_slot','package',packageLimitType,[-1,-1],1,obj,doubleClickObj);
								}else if (Application.application.currentState == 'shop')
								{
									obj.packageData.moveItemFromOnePackageToAnother(Application.application.shopPage.characterPackage.packageItems,'equipment_slot','package',packageLimitType,[-1,-1],1,obj,doubleClickObj);
								}else if(Application.application.currentState == 'warehouse')
								{
									obj.packageData.moveItemFromOnePackageToAnother(Application.application.warehouse.characterPackage.packageItems,'equipment_slot','package',packageLimitType,[-1,-1],1,obj,doubleClickObj);
								}else if(Application.application.currentState == 'forging'){
									obj.packageData.moveItemFromOnePackageToAnother(Application.application.forging.characterPackage.packageItems,'equipment_slot','package',packageLimitType,[-1,-1],1,obj,doubleClickObj);
								}
								
							}
		        		}else{
		        			collection.errorEvent('此道具无法使用',null);		        			
		        		}
						
		        	}
	 			
	        } else if(doubleClickStrFlag == "click") {
	        	doubleClickObj.packageType = packageType;
	        	doubleClickObj.show(obj,doubleClickObj,slotObj,packageLimitType,doubleClickObj.data as Array); 
	        }
		    }    
		 }
		 
		 public function getSlotObj(idx:int):PackageComponent{
		 	switch(idx){
		 		case 0:
					return Application.application.slot.header;
				case 1:
					return Application.application.slot.body;
				case 2:
					return Application.application.slot.belt;
				case 3:
					return Application.application.slot.trousers;
				case 4:
					return Application.application.slot.shoes;
				case 5:
					return Application.application.slot.bracer;
				case 6:
					return Application.application.slot.cloak;
				case 7:
					return Application.application.slot.necklace;
				case 8:
					return Application.application.slot.waist;
				case 9:
					return Application.application.slot.weapon;
		 	}
		 	return null;
		 } 
		 
		  public function getShopSlotObj(idx:int):PackageComponent{
		 	switch(idx){
		 		case 0:
					return Application.application.shopPage.equip.header;
				case 1:
					return Application.application.shopPage.equip.body;
				case 2:
					return Application.application.shopPage.equip.belt;
				case 3:
					return Application.application.shopPage.equip.trousers;
				case 4:
					return Application.application.shopPage.equip.shoes;
				case 5:
					return Application.application.shopPage.equip.bracer;
				case 6:
					return Application.application.shopPage.equip.cloak;
				case 7:
					return Application.application.shopPage.equip.necklace;
				case 8:
					return Application.application.shopPage.equip.waist;
				case 9:
					return Application.application.shopPage.equip.weapon;
		 	}
		 	return null;
		 } 
		 
		 //仓库装备栏
		 public function getWarehouseSlotObj(idx:int):PackageComponent{
		 	switch(idx){
		 		case 0:
					return Application.application.warehouse.equip.header;
				case 1:
					return Application.application.warehouse.equip.body;
				case 2:
					return Application.application.warehouse.equip.belt;
				case 3:
					return Application.application.warehouse.equip.trousers;
				case 4:
					return Application.application.warehouse.equip.shoes;
				case 5:
					return Application.application.warehouse.equip.bracer;
				case 6:
					return Application.application.warehouse.equip.cloak;
				case 7:
					return Application.application.warehouse.equip.necklace;
				case 8:
					return Application.application.warehouse.equip.waist;
				case 9:
					return Application.application.warehouse.equip.weapon;
		 	}
		 	return null;
		 }
		 
		 //锻造装备栏
		 public function getForgingSlotObj(idx:int):PackageComponent{
		 	switch(idx){
		 		case 0:
					return Application.application.forging.equip.header;
				case 1:
					return Application.application.forging.equip.body;
				case 2:
					return Application.application.forging.equip.belt;
				case 3:
					return Application.application.forging.equip.trousers;
				case 4:
					return Application.application.forging.equip.shoes;
				case 5:
					return Application.application.forging.equip.bracer;
				case 6:
					return Application.application.forging.equip.cloak;
				case 7:
					return Application.application.forging.equip.necklace;
				case 8:
					return Application.application.forging.equip.waist;
				case 9:
					return Application.application.forging.equip.weapon;
		 	}
		 	return null;
		 }
		 
		 public function onCanvasMove(event:MouseEvent):void{

		 }
	}
}