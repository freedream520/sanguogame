package com.glearning.melee.components.packages
{
	import com.glearning.melee.components.prompts.CustomerTooltipComponent;
	import com.glearning.melee.components.prompts.PackageItemInfoComponent;
	import com.glearning.melee.components.shop.ProductListComponent;
	import com.glearning.melee.model.PackageItem;
	
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.core.Application;
	import mx.events.ToolTipEvent;
	import mx.managers.PopUpManager;

	public class PackageItemImpl extends Canvas
	{
		[Bindable]
		public var itemData:PackageItem = new PackageItem();
		
		public var txtCount:Label;
		
		public var itemImage:Image;
		
		public var packageType:String;
		
		public var dataObj:Object;
		
		public var imageBorder:Canvas;
		
		
		
		public function PackageItemImpl()
		{
			super();		
		}
		
		public  function createCustomToolTip(event:ToolTipEvent):void { 
             var toolTip:CustomerTooltipComponent = new CustomerTooltipComponent();              
             if(this.parent.parent is CharacterPackageComponent)
             {
             	toolTip.packageType = 1;             	
             }             
             else if(this.parent.parent is EquipmentSlotPackageComponent)
             toolTip.packageType = 2;
             else if(this.parent.parent is ProductListComponent)
             toolTip.packageType = 3;
             toolTip.packageItem = event.target.dataObj;             
             toolTip.init(1);
             event.toolTip = toolTip; 
         } 
         
          public function positionToolTip(e:ToolTipEvent):void
		   {
		    var pt:Point = new Point();
		    pt.x = 0;
		    pt.y = 0;
		    
		    pt = this.localToGlobal(pt);
		    if(pt.x >= (Application.application.canvas1.width - 300))
		    {
		    	e.toolTip.x = pt.x - 220;
		    }
		    
//		    e.toolTip.y = pt.y - 200;
		   }

		
		public function setCount():void{
			if(itemData.count <= 1){
				txtCount.text = '';
			}else{
				txtCount.y = itemImage.height - 3;
			}
		}
		
		public function show(obj:Object,child:Object,slotObj:Object,packageLimitType:int,position:Array):void{
			var itemInfo:PackageItemInfoComponent = new PackageItemInfoComponent();
			itemInfo.info = itemData;
			itemInfo.packageType = packageType;
			itemInfo.obj = obj;
			itemInfo.child = child;
			itemInfo.slotObj = slotObj;
			itemInfo.position = position;
			itemInfo.packageLimitType = packageLimitType;
	        PopUpManager.addPopUp(itemInfo,Application.application.canvas1,true);
	        PopUpManager.centerPopUp(itemInfo);
		}
			
	}
}