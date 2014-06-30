package com.glearning.melee.components.citypanel
{
	import com.glearning.melee.collections.LocationButton;
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.CustomerButtonComponent;
	import com.glearning.melee.components.player.PersonalTopComponent;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.components.utils.AutoTip;
	import com.glearning.melee.components.worldpanel.WorldMapComponent;
	import com.glearning.melee.model.CityInfo;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.*;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.LinkButton;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	public class CityPanelImpl extends Canvas
	{
		public var cityFaction:LinkButton;
		public var img:Image;
		
		public function CityPanelImpl()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onUpdateComplete);
		}	
		 public function loading():void
		{

            img = new Image();
            img.source = 'images/icon-loading.gif';
            PopUpManager.addPopUp(img,Application.application.canvas1,true);
            PopUpManager.centerPopUp(img);
			
		}
		
		
		
		
		public function closeLoading():void
		{
			PopUpManager.removePopUp(img);
		}	
		
		private function onUpdateComplete(e:Event):void {
			var data:Array = CityInfo.instance.facilityList;
			for(var idx:Object in data){
				if(data[idx]['type'] != '城市' && data[idx]['type'] != '区域'){
					var linkButton:LinkButton = LocationButton.createBuild(data[idx]);
					linkButton.addEventListener(MouseEvent.CLICK, enterCity);
					addChild(linkButton);
				}	
			}	
		}
		
		
		public function onUpdateCity():void {
			var data:Array = CityInfo.instance.facilityList;
			for(var idx:Object in data){
				if(data[idx]['type'] != '城市' && data[idx]['type'] != '区域'){
					var linkButton:LinkButton = LocationButton.createBuild(data[idx]);
					linkButton.addEventListener(MouseEvent.CLICK, enterCity);
					addChild(linkButton);
				}	
			}	
		}
		
		public function removeAllButton():void
		{
			var array:Array = this.getChildren();
			for(var i:int = 0 ; i<array.length ; i++)
			{
				if(array[i] is CustomerButtonComponent)
				{
					removeChild(array[i]);
					array[i] = null;
				}
				  
			}
		}
		
		public function enterCity(e:Event):void{
			if(e.currentTarget.label == '出口'){
				if(MySelf.instance.progress > 10 && MySelf.instance.isNewPlayer == 1)
				{
					AutoTip._destoryTip();
					(e.currentTarget as CustomerButtonComponent).endEffect();
					var placeId:int = e.currentTarget.id
					RemoteService.instance.enterPlace(collection.playerId,placeId).addHandlers( collection.setEnterPlace );
				}else if(MySelf.instance.progress <= 10 && MySelf.instance.isNewPlayer == 1)
				{
				    var dontGoOut:NormalTipComponent = new NormalTipComponent();
				    PopUpManager.addPopUp(dontGoOut,Application.application.canvas1,true);
				    PopUpManager.centerPopUp(dontGoOut);
				    dontGoOut.tipText.text = '您现在出去有点危险哟，还是先完成新手任务吧';
				    dontGoOut.hideButton();
				    dontGoOut.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(dontGoOut);});	
				}else if(MySelf.instance.isNewPlayer == 0)
				{
					var curPlaceId:int = e.currentTarget.id
					RemoteService.instance.enterPlace(collection.playerId,curPlaceId).addHandlers( collection.setEnterPlace );
				}
				
			}
			else if(e.currentTarget.label == '赏金组织'){	
				if(MySelf.instance.progress != 3 &&	MySelf.instance.progress != 5 &&MySelf.instance.progress != 10 &&MySelf.instance.progress != 14)
				{
					(e.currentTarget as CustomerButtonComponent ).endEffect();
				    AutoTip._destoryTip();	
				}		
									
				Application.application.currentState = 'goldtask';
				Application.application.goldTask.placeId =e.currentTarget.id ;	
				Application.application.goldTask.init();				
			}else if(e.currentTarget.label == '宿屋'){
				if(MySelf.instance.progress != 3 &&	MySelf.instance.progress != 5 &&MySelf.instance.progress != 10 &&MySelf.instance.progress != 14)
				{
					
				    AutoTip._destoryTip();	
				}	
				Application.application.currentState = 'resthouse';
				Application.application.restHousePanle.placeId =e.currentTarget.id ;
				Application.application.restHousePanle.init();
			}else if(e.currentTarget.label == '议事中心'){
				if(MySelf.instance.progress != 3 &&	MySelf.instance.progress != 5 &&MySelf.instance.progress != 10 &&MySelf.instance.progress != 14)
				{
					(e.currentTarget as CustomerButtonComponent ).endEffect();
				    AutoTip._destoryTip();	
				}	
				
				Application.application.currentState = 'procedurehall';
				Application.application.procedureHall.placeId = e.currentTarget.id;
				Application.application.procedureHall.init();
			}else if(e.currentTarget.label == '防具屋')
			{		
				if(MySelf.instance.progress != 3 &&	MySelf.instance.progress != 5 &&MySelf.instance.progress != 10 &&MySelf.instance.progress != 14)
				{
					(e.currentTarget as CustomerButtonComponent ).endEffect();
				    AutoTip._destoryTip();	
				}		
				Application.application.currentState = 'shop';
				Application.application.shopPage.initShop = 1;
				Application.application.shopPage.characterPackage.resetPackage();
				Application.application.shopPage.equip.resetPackage();
				Application.application.shopPage.placeId = e.currentTarget.id;
				Application.application.shopPage.init();
			}else if(e.currentTarget.label == '武器屋')
			{
				if(MySelf.instance.progress != 3 &&	MySelf.instance.progress != 5 &&MySelf.instance.progress != 10 &&MySelf.instance.progress != 14)
				{
					(e.currentTarget as CustomerButtonComponent ).endEffect();
				    AutoTip._destoryTip();	
				}	
				
				Application.application.currentState = 'shop';
				Application.application.shopPage.initShop = 3;
				Application.application.shopPage.characterPackage.resetPackage();
				Application.application.shopPage.equip.resetPackage();
				Application.application.shopPage.placeId = e.currentTarget.id;
				Application.application.shopPage.init();
			}else if(e.currentTarget.label == '杂货屋')
			{
				if(MySelf.instance.progress != 3 &&	MySelf.instance.progress != 5 &&MySelf.instance.progress != 10 &&MySelf.instance.progress != 14)
				{
					(e.currentTarget as CustomerButtonComponent ).endEffect();
				    AutoTip._destoryTip();	
				}	
				Application.application.currentState = 'shop';
				Application.application.shopPage.initShop = 4;
				Application.application.shopPage.characterPackage.resetPackage();
				Application.application.shopPage.equip.resetPackage();
				Application.application.shopPage.placeId = e.currentTarget.id;
				Application.application.shopPage.init();
			}else if(e.currentTarget.label == '材料屋')
			{
				if(MySelf.instance.progress != 3 &&	MySelf.instance.progress != 5 &&MySelf.instance.progress != 10 &&MySelf.instance.progress != 14)
				{
					
				    AutoTip._destoryTip();	
				}		
				Application.application.currentState = 'shop';
				Application.application.shopPage.initShop = 2;
				Application.application.shopPage.characterPackage.resetPackage();
				Application.application.shopPage.equip.resetPackage();
				Application.application.shopPage.placeId = e.currentTarget.id;
				Application.application.shopPage.init();
			}else if(e.currentTarget.label == '钱庄')
			{
				if(MySelf.instance.progress != 3 &&	MySelf.instance.progress != 5 &&MySelf.instance.progress != 10 &&MySelf.instance.progress != 14)
				{
					
				    AutoTip._destoryTip();	
				}	
				Application.application.currentState = 'warehouse';
				Application.application.warehouse.characterPackage.resetPackage();
				Application.application.warehouse.equip.resetPackage();
				Application.application.warehouse.placeId = e.currentTarget.id;
				Application.application.warehouse.init();
			}
			else if(e.currentTarget.label == '锻造屋')
			{
				if(MySelf.instance.progress != 3 &&	MySelf.instance.progress != 5 &&MySelf.instance.progress != 10 &&MySelf.instance.progress != 14)
				{
					
				    AutoTip._destoryTip();	
				}	
				Application.application.currentState = 'forging';
				Application.application.forging.characterPackage.resetPackage();
				Application.application.forging.equip.resetPackage();
				Application.application.forging.placeId = e.currentTarget.id;
				Application.application.forging.init();
			}else if(e.currentTarget.label == '名誉榜')
			{
				var top:PersonalTopComponent = new PersonalTopComponent();
	        	PopUpManager.addPopUp(top,Application.application.canvas1,true);
	        	PopUpManager.centerPopUp(top);
			}
			collection.currentPosition = 'city'
		}
		
		/**
		 *打开世界地图 
		 */
		public function openWorldMap():void{
			if(MySelf.instance.isNewPlayer == 1 && MySelf.instance.progress <11)
			{
				var normalTip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(normalTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(normalTip);
				normalTip.tipText.text = '世界地图只在7级时对您开放';
				normalTip.hideButton();
				normalTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normalTip);});
			}else
			{
				PopUpManager.createPopUp(melee(Application.application),WorldMapComponent,true);
				if(AutoTip._tip != null)
				{
					AutoTip._tip.visible = false;
				}
			}
			
		}
		
		/**
		 *城镇颜色 
		 */
		public function init():void{
			
			if(CityInfo.instance.cityFaction == "中立")
			cityFaction.setStyle('color','#94AFE1');
	
		}
	}
}