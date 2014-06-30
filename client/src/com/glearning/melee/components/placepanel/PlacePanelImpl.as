//吕忠涛
package com.glearning.melee.components.placepanel
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.CustomerButtonComponent;
	import com.glearning.melee.components.MonsterItemComponent;
	import com.glearning.melee.components.NpcItemComponent;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.components.utils.AutoTip;
	import com.glearning.melee.components.worldpanel.WorldMapComponent;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.model.PlaceInfo;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;

	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	
	public class PlacePanelImpl extends Canvas
	{
		public var txtPlaceName:Label;
		public var txtFaction:LinkButton;
		public var toCity:CustomerButtonComponent;
		public var placeSorted:Canvas;

		public var placeMap:PlaceMapImpl;
		public var monsterList:Canvas;
		public var sincelocation:Canvas;
		public var locationId:int = 0;
		public var levelArray:Array;
		public function PlacePanelImpl()
		{
			super();
 
		}

		public function onUpdateComplete():void {
			if(AutoTip._tip != null)
			{
				AutoTip._destoryTip();
			}
			if(MySelf.instance.isNewPlayer == 1)
        	{
        		if(MySelf.instance.isKilled == 1)
        		{
        			toCity.startEffect();
					AutoTip._showTip('返回国都向南华新君交付任务',toCity);
        		}
        		
        		if(Application.application.baseAvatar.txtStatus.label == '死亡')
        		{
        			AutoTip._destoryTip();
        		}
        	}
			var npcsData:Array = PlaceInfo.instance.npcList;
			monsterList.removeAllChildren();
			sincelocation.removeAllChildren();
			placeSorted.removeAllChildren();
			setSinceLocation();
			setSorted();
			for(var idx:Object in npcsData){
				var npc:Object = npcsData[idx];
				npc.type == "人物" ? createNpc(npc, idx) : createMonster(npc, idx);
			}
			toCity.addEventListener(MouseEvent.CLICK, goCity);
			for(var idxs:Object in PlaceInfo.instance.placeList){
				if(PlaceInfo.instance.placeList[idxs]['id'] == locationId)
				{
					PlaceInfo.instance.playerX = PlaceInfo.instance.placeList[idxs]['extentLeft'] + 20;
					PlaceInfo.instance.playerY = int(PlaceInfo.instance.placeList[idxs]['extentTop']) - 26;
					PlaceInfo.instance.name = PlaceInfo.instance.placeList[idxs]['name'];
				}
			}
			if(PlaceInfo.instance.inRegion == false){
				txtFaction.setStyle("color",PlaceInfo.instance.factionColor);
				txtFaction.setStyle("textRollOverColor",PlaceInfo.instance.factionColor);
				txtFaction.setStyle("textSelectedColor",PlaceInfo.instance.factionColor);
				placeMap.setPlace(PlaceInfo.instance.placeList);
			}
			locationId = 0;
			
		}
		
		//返回国都
		public function goCity(e:Event):void{
			AutoTip._destoryTip();
			toCity.endEffect();
			if(MySelf.instance.isTeamMember == false || (MySelf.instance.isLeader == true && MySelf.instance.isTeamMember == true)){
			var placeId:int = e.currentTarget.data;
			RemoteService.instance.enterPlace(collection.playerId,placeId).addHandlers( collection.setEnterPlace );
			}
			else
			{
				var normalTip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(normalTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(normalTip);
				normalTip.tipText.text = '您不是队长，无法带队返回国都';
				normalTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normalTip);});
			}
		}
		
		/**
		 *打开世界地图 
		 */
		public function openWorldMap():void{
			PopUpManager.createPopUp(melee(Application.application),WorldMapComponent,true);
			if(AutoTip._tip != null)
			{
				AutoTip._tip.visible = false;
			}
		}
		
		//创建Monster
		public function createMonster(data:Object,idx:Object):void{
			var monsterComponent:MonsterItemComponent = new MonsterItemComponent();
			monsterComponent.monsterData = data;
			var array:Array = (data.dropItemIdGroup as String).split(";");
            array.sort();                       
			setNpcPosition(monsterComponent,idx);
			monsterList.addChild(monsterComponent);		
			if(PlaceInfo.instance.placeList[0]['type'] == '副本'){
				monsterComponent.type = 2;				
			}else{
				monsterComponent.type = 1;
				levelArray = (data.levelGroup as String).split(';');
				if(Math.abs(MySelf.instance.level - levelArray[levelArray.length-1]) > 3 )
				{
				   monsterComponent.practice.visible = false;
				}else
				{
				   monsterComponent.practice.visible = true;
				}
			}
				
			
			if(array[0] - MySelf.instance.level > 3)
		    monsterComponent.practice.visible = false;  
		}
		
		//创建NPC
		public function createNpc(data:Object,idx:Object):void{
			var npcComponent:NpcItemComponent = new NpcItemComponent();
			npcComponent.npcData = data;
			setNpcPosition(npcComponent,idx);
			monsterList.addChild(npcComponent);
		}
		
		//对场景中的怪物进行排列
		private function setNpcPosition(npc:Object, idx:Object):void{
			var  x:int, y:int;
			
			int(idx) % 2 == 0 ? x = 1 : x = 145;
			y = (Math.floor(int(idx)/ 2)) * 40 + 10;
			
			npc.y = y;
			npc.x = x;
		}
		
		//场景中子地点
		public function setSinceLocation():void{
			var datas:Array = PlaceInfo.instance.palceChilds;
			var locationDatas:Array = PlaceInfo.instance.locationMap;
			if(PlaceInfo.instance.placeType == '子地点')
			{
				for(var idxs:Object in locationDatas)
				{
					var locationData:Object = locationDatas[idxs];
					if(locationData['type'] == '地点')
					{
						var locationLink:LinkButton = new LinkButton();
						locationLink.alpha = 0;
						locationLink.label = '返回上级场景【'+locationData['name']+'】';
						locationId = locationData['id'];
						locationLink.data = locationData;
						locationLink.styleName = "CommonLinkButton";
						locationLink.addEventListener(MouseEvent.CLICK, inPlaceChild);
						sincelocation.addChild(locationLink);
					}	
				
				}
			}
			for(var idx:Object in datas){
				var data:Object = datas[idx];
				var link:LinkButton = new LinkButton();
				if(MySelf.instance.location.toString() == data['id'].toString())
				{
					link.setStyle('disabledColor','#43341b');
					link.enabled = false;
					link.useHandCursor = false;
				}else{
					link.styleName = "CommonLinkButton";
				}

				link.alpha = 0;
				link.label = data['name'];
				link.data = data;
				link.addEventListener(MouseEvent.CLICK, inPlaceChild);
				setChildPosition(link,idx);
				sincelocation.addChild(link);
			}
		}
		
		private function setChildPosition(link:Object, idx:Object):void{
			var  x:int, y:int;
			int(idx) % 2 == 0 ? x = 1 : x = 70;
			y = (Math.floor((int(idx))/ 2))*20+20;
			link.y = y;
			link.x = x;
		}
		
		public function inPlaceChild(e:Event):void{
			var normal:NormalTipComponent = new NormalTipComponent();
			
			var data:Object = e.currentTarget.data;
			if(data['type'] == '出口'){
				if(MySelf.instance.camp == data['camp'] || data['name'].toString().charAt(0) == '前' ){
					if(MySelf.instance.level >= data['levelRequire']){
						RemoteService.instance.enterPlace(collection.playerId,data['regionId']).addHandlers( collection.setEnterPlace );
					}else{
						PopUpManager.addPopUp(normal,Application.application.canvas1,true);
						PopUpManager.centerPopUp(normal);
						normal.hideButton();
						normal.tipText.text = "您的级别不够，需要达到 "+data['levelRequire'].toString()+"级才能进入";
						normal.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normal);});
					}
				}else{
						PopUpManager.addPopUp(normal,Application.application.canvas1,true);
						PopUpManager.centerPopUp(normal);
						normal.hideButton();
						normal.tipText.text = "您无法进去敌对阵营的城市";
						normal.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normal);});
					
				}
			}else{
				RemoteService.instance.enterPlace(collection.playerId,data['id']).addHandlers( collection.setEnterPlace );
			}
			

		}
		
	
		
		//场景中总地点导航条
		public function setSorted():void{
			var datas:Array = PlaceInfo.instance.locationMap;
			if(datas.length == 1){
				var lab:LinkButton = new LinkButton();
				lab.label = PlaceInfo.instance.placeName;
				lab.setStyle('disabledColor','#43341b');
				lab.enabled = false;
				lab.useHandCursor = false;
				placeSorted.addChild(lab);
			}
			else{
				var i:int = 0;
				for(var idx:Object in datas)
				{
					var data:Object = datas[idx];
					if(data['type'] != '城市')
					{
						var link:LinkButton = new LinkButton();
						link.alpha = 0;
						link.label = data['name'];
						//link.id = data['id'];
						link.data = data;
						link.styleName = "CommonLinkButton";
						link.x = i * 80;
						link.addEventListener(MouseEvent.CLICK, inPlaceChild);
						placeSorted.addChild(link);
						var biaoqian:Label = new Label()
						biaoqian.text = '<';
						biaoqian.x = (i+1) * 80-10;
						placeSorted.addChild(biaoqian);
						i++;
					}	
				}
				var lab2:LinkButton = new LinkButton();
				lab2.label = PlaceInfo.instance.placeName;
				lab2.enabled = false;
				lab2.useHandCursor = false;
				lab2.setStyle('disabledColor','#43341b');
				lab2.x = i * 80;
				placeSorted.addChild(lab2);   
			}
		}
		
	}
}