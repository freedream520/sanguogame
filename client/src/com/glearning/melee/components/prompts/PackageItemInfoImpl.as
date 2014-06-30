package com.glearning.melee.components.prompts
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.utils.AutoTip;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	public class PackageItemInfoImpl extends Canvas
	{
		[Bindable]
		public var info:Object;
		public var image:Image;
		public var infos:VBox;
		public var apply:LinkButton;
		public var mend:LinkButton;
		public var sell:LinkButton;
		public var dice:LinkButton;
		public var reveal:LinkButton;
		public var storage:LinkButton;
		public var equiped:HBox;
		public var property:HBox;
		public var packageType:String;
		public var obj:Object;
		public var child:Object;
		public var slotObj:Object;
		public var packageLimitType:int;
		public var position:Array;
		
		public function PackageItemInfoImpl()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,creationInfo);
		}
		
		public function creationInfo(event:FlexEvent):void{
			hideButton(reveal);
			//hideButton(storage);
			var centerX:int = info.width*26/2;
			var centerY:int = info.height*26/2;
			image.x = 39 - centerX;
			image.y = 52 - centerY;
			var type:String = collection.getItemTypeGroupString(info.itemInfo.type);
			var itemtype:String = collection.getItemTypeString(info.itemInfo.type);
			var armortype:String = collection.getArmorTypeString(info.itemInfo.type);
			if(packageType == 'warehouse_package' || packageType == 'forging_package' ||MySelf.instance.isNewPlayer == 1){
				hideButton(apply);
				hideButton(mend);
				hideButton(sell);
				hideButton(dice);
				hideButton(reveal);
				hideButton(storage);
			}
			if(info.itemObj.itemLevel >1){
				var levelLabel:Label = new Label();
				levelLabel.text = "LV."+info.itemObj.itemLevel.toString();
				equiped.addChild(levelLabel);
			}
			var hbox1:HBox = new HBox();
			var hbox2:HBox = new HBox();
			var lable:Label = new Label();
			var lable1:Label = new Label();
			var lable2:Label = new Label();
			var lable4:Label = new Label();
			var lable3:Label = new Label();
			var lable5:Label = new Label();
			if(type == '武器'){
				hideButton(apply);
				hideButton(mend);
				if(packageType != 'temporary_package' && packageType != 'warehouse_package' && packageType != 'forging_package' && Application.application.currentState !='shop'&& Application.application.currentState !='warehouse'&& Application.application.currentState !='forging')
				isEquiped();
				
				lable1.htmlText = '装备类型:<font color="#ff0012">'+itemtype+'</font>';
				
				lable2.htmlText = '攻击力:<font color="#ff0012">'+info.itemInfo.minDamage+'~'+info.itemInfo.maxDamage+'</font>';
				hbox1.addChild(lable1);
				hbox1.addChild(lable2);
				
				
				lable4.htmlText = '价值:<font color="#ff0012">'+info.itemSellPrice+'</font>铜币';
				if(info.itemInfo.druability == -1){
					hbox2.addChild(lable4);
				}else{
					
					lable3.htmlText = '耐久度:<font color="#ff0012">'+info.itemInfo.druability+'/'+info.itemInfo.druability+'</font>';
					hbox2.addChild(lable3);
					hbox2.addChild(lable4);
				}
				infos.addChild(hbox1);
				infos.addChild(hbox2);
			}else if(type == '防具'){
				hideButton(apply);
				hideButton(mend);
				if(packageType != 'temporary_package' && packageType != 'warehouse_package' && packageType != 'forging_package')
				isEquiped();
				lable1.htmlText = '装备类型:<font color="#ff0012">'+itemtype+'</font>';
				lable2.htmlText = '护甲类型:<font color="#ff0012">'+armortype+'</font>';
				hbox1.addChild(lable1);
				hbox1.addChild(lable2);
				lable4.htmlText = '防御力:<font color="#ff0012">'+info.itemInfo.defense+'</font>';
				if(info.itemInfo.druability == -1){
					
					lable5.htmlText = '价值:<font color="#ff0012">'+info.itemSellPrice+'</font>铜币';
					hbox2.addChild(lable4);
					hbox2.addChild(lable5);
					infos.addChild(hbox1);
					infos.addChild(hbox2);
				}else{
					lable3.htmlText = '耐久度:<font color="#ff0012">'+info.itemInfo.druability+'/'+info.itemInfo.druability+'</font>';
					hbox2.addChild(lable4);
					hbox2.addChild(lable3);
					var hbox3:HBox = new HBox();
					lable5.htmlText = '价值:<font color="#ff0012">'+info.itemSellPrice+'</font>铜币';
					hbox3.addChild(lable5);
					infos.addChild(hbox1);
					infos.addChild(hbox2);
					infos.addChild(hbox3);
				}
				
			}else{
				if(packageType == 'temporary_package' || info.itemInfo.addEffect == '-1' || packageType == 'warehouse_package' || packageType == 'forging_package')
					hideButton(apply);
				hideButton(mend);
				if(info.count >1){
					
					lable.text = '*'+info.count;
					equiped.addChild(lable);
				}
				lable1.htmlText = '<font color="#ff0012">'+info.itemInfo.description+'</font>';
				lable2.htmlText = '价值:<font color="#ff0012">'+info.itemSellPrice+'</font>铜币';
				infos.addChild(lable1);
				infos.addChild(lable2);
			}
			for(var i:int=0;i<info.itemProperty.length;i++){
				var effectLable:Label = new Label();
				if(i%2 ==0){
					if(property != null)
						infos.addChild(property);
					property= new HBox();
				}
				effectLable.htmlText = '<font color="#ff0012">'+info.itemProperty[i]['attributeEffects'][0]+'</font>'
				property.addChild(effectLable);
			}
			if(info.itemProperty.length != 0)
			infos.addChild(property);
		}
		
		//关闭
		public function closeInfo():void{
			PopUpManager.removePopUp(this);
		}
		
		//隐藏按钮
		public function hideButton(button:LinkButton):void{
			button.visible = false;
			button.includeInLayout = false ;
		}
		
		//拿下装备
		public function toPackage(event:MouseEvent):void{
			closeInfo();
			obj.packageData.moveItemFromOnePackageToAnother(Application.application.characterPackage.packageItems,'equipment_slot','package',packageLimitType,[-1,-1],1,obj,child);
		}
		
		//装上装备
		public function toSlot(event:MouseEvent):void{
			if(MySelf.instance.isNewPlayer == 1)
			{
				if(MySelf.instance.progress == 3)
				{
					AutoTip._destoryTip();
					RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onNewPlayerQuestInfo);			
				}
					
			}
			closeInfo();
			obj.packageData.moveItemFromOnePackageToAnother(slotObj,'package','equipment_slot',position,packageLimitType,1,obj,child);
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
		
		public function isEquiped():void{
			var lableEquiped:Label = new Label();
			var buttonEquiped:LinkButton = new LinkButton();
			if(info.itemIsEquiped){			
				lableEquiped.text = '（已装备）';
				buttonEquiped.label = '[取下装备]';
				buttonEquiped.alpha = 0;
				buttonEquiped.height = 20;
				buttonEquiped.styleName = 'InfoLinkButton';
				buttonEquiped.addEventListener(MouseEvent.CLICK,toPackage);
				equiped.addChild(lableEquiped);
				equiped.addChild(buttonEquiped);
			}else{
				lableEquiped.text = '（未装备）';
				buttonEquiped.label = '[穿上装备]';
				buttonEquiped.height = 20;
				buttonEquiped.styleName = 'InfoLinkButton';
				buttonEquiped.alpha = 0;
				buttonEquiped.addEventListener(MouseEvent.CLICK,toSlot);
				equiped.addChild(lableEquiped);
				equiped.addChild(buttonEquiped);
			}
		}
		
		//出售
		public function sellItem():void{
			if(MySelf.instance.isNewPlayer == 1)
			{
				sell.visible = false;
			}else
			{
				sell.visible = true;
				closeInfo();
				obj.packageData.sellPackageItem(info.itemId,packageType,info.count,obj,child);
			}
			
		}
	
		//丢弃
		public function diceItem():void{
			if(MySelf.instance.isNewPlayer == 1)
			{
				dice.visible = false;
			}
			else
			{
				dice.visible = true;
				closeInfo();
				obj.packageData.dropItem(info.itemId,packageType,obj,child);
			}
			
		}
		
		//使用
		public function applyItem():void{
			closeInfo();
			obj.packageData.useItem(info.itemId,obj,child);
			if(MySelf.instance.isNewPlayer == 1)
			{
				if(MySelf.instance.progress == 10)
				{
					AutoTip._destoryTip();
					RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onNewPlayerQuestInfo);			
				}
					
			}
		}
		
		//入库
		public function storageItem():void{
			closeInfo();
			var warehouseObj:Object;
			if(Application.application.warehouse == null){
				warehouseObj = null;
			}else{
				warehouseObj = Application.application.warehouse.warehousePackage
			}
			if(packageType == 'package'){
				obj.packageData.moveItemFromOnePackageToAnother(warehouseObj,'package','warehouse_package',position,[-1,-1],child.dataObj.stack,obj,child);
			}else if(packageType == 'temporary_package'){
				obj.packageData.moveItemFromOnePackageToAnother(warehouseObj,'temporary_package','warehouse_package',position,[-1,-1],child.dataObj.stack,obj,child);
			}else{
				obj.packageData.moveItemFromOnePackageToAnother(warehouseObj,'equipment_slot','warehouse_package',position,[-1,-1],child.dataObj.stack,obj,child);
			}
			
		}
	}
}