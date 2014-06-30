package com.glearning.melee.components.worldpanel
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.model.WorldMapInfo;
	import com.glearning.melee.net.RemoteService;
	import com.glearning.melee.components.utils.AutoTip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.LinkButton;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	public class WorldMapImpl extends Canvas
	{
		private static var _instance:WorldMapImpl;
		
		public static function get instance():WorldMapImpl{
			if(instance==null){
				_instance = new WorldMapImpl();
			}
			return _instance;
		}
		
		public function WorldMapImpl()
		{
			super();
			setStyle("backgroundColor",null);
			addEventListener(mx.events.FlexEvent.INITIALIZE, onInitHandler);
		}
		
		private function onInitHandler(event:Event):void{
			var canvas:Canvas = Application.application.canvas1;
			this.x = canvas.width/2+canvas.x-this.width/2;
			this.y = canvas.height/2+canvas.y-this.height/2;
			canvas = null;
			RemoteService.instance.getWorldMapInfo(collection.playerId,MySelf.instance.location).addHandlers(initWorldMapInfo);	
		}
		
		private function initWorldMapInfo(event:ResultEvent,token:AsyncToken):void{
			var wMapPlaces:Array = event.result['wMapPlaces'];
			var regionLocation:int = event.result['locationRegion']['regionId'];
			forEachRegionOrCountry(wMapPlaces,regionLocation);
		}
		
		private function forEachRegionOrCountry(places:Array,placeId:int):void{
			for each(var elm:Object in places){
				if(placeId == elm['id']){
					WorldMapInfo.instance.playerX = int(elm['wextentLeft']) + 15 ;
					WorldMapInfo.instance.playerY = int(elm['wextentTop']) - 26 ;
				}
				var button:LinkButton = new LinkButton();
				button.x = elm['wextentLeft'];
				button.y = elm['wextentTop'];
				button.label = elm['name'];
				button.id = elm['id'];
				if(elm['isLevelRequired'] && elm['isCampRequired']){
					if(MySelf.instance.isNewPlayer == 0 && elm['id'] != 5001){
						button.setStyle("styleName","PlaceButton");
						button.enabled=true;
					}else{
						button.setStyle("styleName","PlaceButtonDisable");
						button.enabled=false;
					}
				}else{
					button.setStyle("styleName","PlaceButtonDisable");
					button.enabled=false;
				}					
				addChild(button);
				button.addEventListener(MouseEvent.CLICK,worldMapEnter); 
			}
		}
		
		private function worldMapEnter(event:Event):void{
			close();
			var placeId:int = event.currentTarget.id;
			RemoteService.instance.enterPlace(collection.playerId,placeId).addHandlers( collection.setEnterPlace );
		}
		
		public function close():void{
			PopUpManager.removePopUp(this);
			if(AutoTip._tip != null)
			{
				AutoTip._tip.visible = true;
			}
		}
	}
}
