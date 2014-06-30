package com.glearning.melee.components.shop
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.newplayerquest.NpcGuideComponent;
	import com.glearning.melee.components.packages.CharacterPackageComponent;
	import com.glearning.melee.components.packages.CharacterTempPackageComponent;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.components.prompts.PayMoneyComponent;
	import com.glearning.melee.components.task.NpcTaskComponent;
	import com.glearning.melee.components.task.NpcTaskListComponent;
	import com.glearning.melee.components.utils.TimeUtil;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.messaging.events.MessageEvent;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class ShopPageImpl extends Canvas
	{
		public var armor:Image;
		public var material:Image;
		public var weapon:Image;
		public var grocery:Image;
		public var shopName:Image;
		public var initShop:int;
		public var productList:ProductListComponent;
		public var characterPackage:CharacterPackageComponent;
		public var placeId:int;
		public var npcId:int;
		public var npcPhoto:Image;
		public var description:Text;
		public var timeUtil:TimeUtil;
		public var refreshTimeContent:Canvas;
		public var closeButton:LinkButton;
		public var refreshButton:LinkButton;
		public var shopInfo:Array;
		public var payMoney:PayMoneyComponent;
		public var tempPackage:CharacterTempPackageComponent;
		public var getTask:LinkButton;
		public var img:Image;
		public function ShopPageImpl()
		{
			super();
		}
		
		public function init():void
		{
			closeButton.addEventListener(MouseEvent.CLICK,backToCity);
			armor.addEventListener(MouseEvent.CLICK,goToArmor);
			material.addEventListener(MouseEvent.CLICK,goToMaterial);
			weapon.addEventListener(MouseEvent.CLICK,goToWeapon);
			grocery.addEventListener(MouseEvent.CLICK,goToGrocery);
			refreshButton.addEventListener(MouseEvent.CLICK,payForShop);
			characterPackage.tempButton.addEventListener(MouseEvent.CLICK,openTempPackage);
			getTask.addEventListener(MouseEvent.CLICK,showTask);
			if(initShop == 1)
			{
				armor.source = 'images/sanGuo/shop/armor2.png';
				material.source = 'images/sanGuo/shop/material1.png';
			    weapon.source = 'images/sanGuo/shop/weapon1.png';
			    grocery.source = 'images/sanGuo/shop/grocery1.png';
			    shopName.source = 'images/sanGuo/shop/FangJuDian.png';
			    productList.itemName.text = '防具商品';
			}else if(initShop == 2)
			{
				armor.source = 'images/sanGuo/shop/armor1.png';
				material.source = 'images/sanGuo/shop/material2.png';
				weapon.source = 'images/sanGuo/shop/weapon1.png';
				grocery.source = 'images/sanGuo/shop/grocery1.png';
				shopName.source = 'images/sanGuo/shop/CaiLiaoDian.png';
				productList.itemName.text = '材料商品';
			}else if(initShop == 3)
			{
				armor.source = 'images/sanGuo/shop/armor1.png';
			    material.source = 'images/sanGuo/shop/material1.png';
			    weapon.source = 'images/sanGuo/shop/weapon2.png';
			    grocery.source = 'images/sanGuo/shop/grocery1.png';
			    shopName.source = 'images/sanGuo/shop/WuQiDian.png';
			    productList.itemName.text = '武器商品';
			}else if(initShop == 4)
			{
				armor.source = 'images/sanGuo/shop/armor1.png';
			    material.source = 'images/sanGuo/shop/material1.png';
			    weapon.source = 'images/sanGuo/shop/weapon1.png';
			    grocery.source = 'images/sanGuo/shop/grocery2.png';
			    shopName.source = 'images/sanGuo/shop/ZaHuoDian.png';
			    productList.itemName.text = '杂货商品';
			}
			
			RemoteService.instance.getShopInfo(collection.playerId,placeId).addHandlers(onGetShopInfo);		
			RemoteService.instance.subscribe(collection.playerId.toString(),onRefreshShopItems);
			showTalkTip();
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
		
		public function onRefreshShopItems(msg:MessageEvent):void
		{
			if(msg.message.body == 'refresh shop items')
			{
				RemoteService.instance.refreshShopItems(collection.playerId,placeId).addHandlers(getNewShopItems)
			}
			
		}
		
		public function getNewShopItems(event:ResultEvent,token:AsyncToken):void
		{
			productList.showItems(event.result['data'].pagedShopItems[0] as Array);
			productList.itemArray = event.result['data'].pagedShopItems as Array;
			timeUtil.resetTimer(3600);            
		}
		
		public function goToArmor(event:MouseEvent):void
		{
			for(var a:int=0;a<shopInfo.length;a++)
			{
				if(shopInfo[a].name == '防具屋')
				{
					initShop = 1;
					placeId = shopInfo[a].id;
					break;
				}
			}
			init();
		}
		
		public function goToMaterial(event:MouseEvent):void
		{
			for(var a:int=0;a<shopInfo.length;a++)
			{
				if(shopInfo[a].name == '材料屋')
				{
					initShop = 2;
					placeId = shopInfo[a].id;
					break;
				}
			}
			init();
		}
		
		public function goToWeapon(event:MouseEvent):void
		{
			for(var a:int=0;a<shopInfo.length;a++)
			{
				if(shopInfo[a].name == '武器屋')
				{
					initShop = 3;
					placeId = shopInfo[a].id;
					break;
				}
			}
			init();
		}
		
		public function goToGrocery(event:MouseEvent):void
		{
			for(var a:int=0;a<shopInfo.length;a++)
			{
				if(shopInfo[a].name == '杂货屋')
				{
					initShop = 4;
					placeId = shopInfo[a].id;
					break;
				}
			}
			init();
		}
		
		public function backToCity(event:MouseEvent):void
		{
			Application.application.currentState =  'city';
		}
		
		public function payForShop(event:MouseEvent):void
		{	
			if(MySelf.instance.isNewPlayer == 1)
			{
				collection.errorEvent('对不起，该功能不对新手状态开放',null);
			}else
			{
				payMoney = new PayMoneyComponent();
				PopUpManager.addPopUp(payMoney,Application.application.canvas1,true);
				PopUpManager.centerPopUp(payMoney);
				payMoney.prompt.htmlText = '您将花费<font color="#ff0000">10</font>黄金/礼券来刷新商店物品列表';
				payMoney.goldLabel.htmlText = '花费<font color="#ff0000">10</font>黄金';		
				payMoney.couponLabel.htmlText = '花费<font color="#ff0000">10</font>礼券';			
				payMoney.payMoneyOK.addEventListener(MouseEvent.CLICK,
	             function():void
	             {
	             	if(payMoney.gold.selected == true)
	             	  RemoteService.instance.immediateRefreshShopItems(collection.playerId,placeId,'gold',10).addHandlers(onImmediateRefreshShopItems);
	             	else
	             	  RemoteService.instance.immediateRefreshShopItems(collection.playerId,placeId,'coupon',10).addHandlers(onImmediateRefreshShopItems);
	             }
	             );	
			}
					

		}
		
		public function onImmediateRefreshShopItems(event:ResultEvent,token:AsyncToken):void
		{
			if(event.result['result']==true)
			{
				MySelf.instance.gold = event.result['data'].gold;
				MySelf.instance.coupon = event.result['data'].coupon;
				timeUtil.resetTimer(3600);            
				productList.showItems(event.result['data'].pagedShopItems[0] as Array);
				productList.itemArray = event.result['data'].pagedShopItems as Array;
				PopUpManager.removePopUp(payMoney);
			}
			else
			{
				var falseTip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(falseTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(falseTip);
				falseTip.tipText.text = event.result['reason'].toString();
				falseTip.hideButton();
				falseTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(falseTip);});
			}
			
		}
		
		public function onGetShopInfo(event:ResultEvent,token:AsyncToken):void
		{
			
			npcId = event.result['data'].shopNpcInfo.id;
			shopInfo = event.result['data'].relatedShops;
			npcPhoto.source = event.result['data'].shopNpcInfo.image;
			description.htmlText = event.result['data'].shopNpcInfo.description;
			productList.showItems(event.result['data'].pagedShopItems[0] as Array);
			productList.itemArray = event.result['data'].pagedShopItems as Array;
			refreshTimeContent.removeAllChildren();
			var refreshTime:Label = new Label();		
			refreshTimeContent.addChild(refreshTime);
			timeUtil = new TimeUtil(event.result['data'].refreshTime);
			BindingUtils.bindProperty(refreshTime,"text",timeUtil,"time");
			timeUtil.startCount();
		}
		
	
		public function changeButtonSkin(event:MouseEvent):void
		{
			
			if(event.currentTarget.id == 'armor')
			{
			  armor.source = 'images/sanGuo/shop/armor2.png';
			  material.source = 'images/sanGuo/shop/material1.png';
			  weapon.source = 'images/sanGuo/shop/weapon1.png';
			  grocery.source = 'images/sanGuo/shop/grocery1.png';
			}else if(event.currentTarget.id == 'material')
			{
			  armor.source = 'images/sanGuo/shop/armor1.png';
			  material.source = 'images/sanGuo/shop/material2.png';
			  weapon.source = 'images/sanGuo/shop/weapon1.png';
			  grocery.source = 'images/sanGuo/shop/grocery1.png';
			}else if(event.currentTarget.id == 'weapon')
			{
			  armor.source = 'images/sanGuo/shop/armor1.png';
			  material.source = 'images/sanGuo/shop/material1.png';
			  weapon.source = 'images/sanGuo/shop/weapon2.png';
			  grocery.source = 'images/sanGuo/shop/grocery1.png';
			}else
			{
			  armor.source = 'images/sanGuo/shop/armor1.png';
			  material.source = 'images/sanGuo/shop/material1.png';
			  weapon.source = 'images/sanGuo/shop/weapon1.png';
			  grocery.source = 'images/sanGuo/shop/grocery2.png';
			}
		}
		
		public function openTempPackage(event:MouseEvent):void{
			tempPackage.init();
			tempPackage.visible = true;
		}
		
		public function showTask(event:MouseEvent):void
		{
			if(MySelf.instance.isNewPlayer == 0)
			{
				var npcTask:NpcTaskComponent = new NpcTaskComponent();
	            PopUpManager.addPopUp(npcTask,Application.application.canvas1,true);
	            PopUpManager.centerPopUp(npcTask);
	            npcTask.npcImage.source = npcPhoto.source;           
	            npcTask.npcId = npcId;            
	            npcTask.npcName.text = productList.itemName.text.substr(0,2)+'老板' ;
	            npcTask.closeButton.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(npcTask)});
	            var npcTaskList:NpcTaskListComponent = new NpcTaskListComponent();
	            npcTaskList.acceptInfo = description.text;
	            npcTaskList.npcId = npcId;
	            npcTask.npcTalkTask.addChild(npcTaskList);
			}else if(MySelf.instance.isNewPlayer == 1)
			{
				var npcGuide:NpcGuideComponent = new NpcGuideComponent();
				if(MySelf.instance.progress == 6 && initShop == 3)
				{
					npcGuide.type = 0;
					npcGuide.finishGuide = '是左慈先生让你来的吧，俺这里小到菜刀镰刀，大到青龙颜月，应有尽有。啥？你没钱？看在左慈先生的面子上' + 
							               '送你白金免费消费卡一张，只有一次哟~';
					PopUpManager.addPopUp(npcGuide,Application.application.canvas1,true);
					PopUpManager.centerPopUp(npcGuide);
					npcGuide.npcImg.source = 'images/npc/shop170/WuQiWu.jpg';
					npcGuide.npcName.text = '武器屋老板';
	                npcGuide.finish.addEventListener(MouseEvent.CLICK,function():void{
	                	 RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onNewPlayerQuestInfo);
	                	 PopUpManager.removePopUp(npcGuide);
	                });
				}else if(MySelf.instance.progress == 7 && initShop == 1)
				{
					npcGuide.type = 0;
					npcGuide.finishGuide = '是左慈先生让你来的吧，金甲银甲不如咱这的无敌甲，不是老子吹牛，方圆五百里，只此一间。啥？你没钱？看在左慈先生的面子上' + 
							               '送你白金免费消费卡一张，只有一次哟~';
					PopUpManager.addPopUp(npcGuide,Application.application.canvas1,true);
					PopUpManager.centerPopUp(npcGuide);
					npcGuide.npcImg.source = 'images/npc/shop170/FangJuWu.jpg';
					npcGuide.npcName.text = '防具屋老板';
	                npcGuide.finish.addEventListener(MouseEvent.CLICK,function():void{
	                	 RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onNewPlayerQuestInfo);
	                	 PopUpManager.removePopUp(npcGuide);
	                });
				}else if(MySelf.instance.progress == 8 && initShop == 4)
				{
					npcGuide.type = 0;
					npcGuide.finishGuide = '是左慈先生让你来的吧，面到灵芝，雪山参，光到阿莫西林，快客，中西药结合疗效好。啥？你没钱？看在左慈先生的面子上' + 
							               '送你白金免费消费卡一张，只有一次哟~';
					PopUpManager.addPopUp(npcGuide,Application.application.canvas1,true);
					PopUpManager.centerPopUp(npcGuide);
					npcGuide.npcImg.source = 'images/npc/shop170/ZaHuoWu.jpg';
					npcGuide.npcName.text = '杂货屋老板';
	                npcGuide.finish.addEventListener(MouseEvent.CLICK,function():void{
	                	 RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onNewPlayerQuestInfo);
	                	 PopUpManager.removePopUp(npcGuide);
	                });
				}
			} 
			
		}
		
		//新手指导
		public function onNewPlayerQuestInfo(event:ResultEvent,token:AsyncToken):void
		{
			RemoteService.instance.addReward(collection.playerId,event.result['data'][0][3],event.result['data'][0][5],event.result['data'][0][4]).addHandlers(onAddReward);
//			getTask.endEffect();	     
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
		
		public function showTalkTip():void
		{
			if(MySelf.instance.isNewPlayer == 1)
			{
				if(MySelf.instance.progress == 6 ||MySelf.instance.progress == 7||MySelf.instance.progress == 8)
				{
//					getTask.startEffect();
				}
			}
		}
		
	}
}