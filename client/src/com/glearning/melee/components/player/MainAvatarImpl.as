package com.glearning.melee.components.player
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.packages.PackageItemComponent;
	import com.glearning.melee.components.skill.EffectOnHeaderComponent;
	import com.glearning.melee.components.utils.TimeUtil;
	import com.glearning.melee.model.EffectInfo;
	import com.glearning.melee.model.SkillInfo;
	import com.glearning.melee.net.RemoteService;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.SWFLoader;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.effects.Glow;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	import mx.messaging.events.MessageEvent;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class MainAvatarImpl extends Canvas
	{
		
		public var avatarImage:SmoothImage;
		public var txtName:Label;
		public var txtLevel:Label;
		public var glowImage:Glow;
		public var unglowImage:Glow;
		public var _canvas:Canvas;
		public var image1:Image;
		public var image2:Image;
		public var image3:Image;
		public var image4:Image;
	    public var levelSwf:SWFLoader;
		public function MainAvatarImpl()
		{
			super();
			
		}	
		
	
		
		private function refreshEffect(event:MessageEvent):void
		{
			if(event.message.body.toString() == 'effectOver')
			{
				onCreationComplete();
			}
		}
		
		public  function onCreationComplete():void {
			RemoteService.instance.subscribe( collection.playerId.toString(), refreshEffect );
			avatarImage.addEventListener(flash.events.Event.COMPLETE, onAvatarImageLoaded);
			_canvas.addEventListener(DragEvent.DRAG_DROP,dragDrop);
			_canvas.addEventListener(DragEvent.DRAG_ENTER,dragEnter);
			BindingUtils.bindProperty(txtLevel,'data',txtLevel,'text');				
			if(EffectInfo.instance.effectArray != null)
			{
				var array:Array = EffectInfo.instance.effectArray ;
			   
        		for(var i:int = 0;i<array.length;i++)
        		{
        			var img:EffectOnHeaderComponent = new EffectOnHeaderComponent();
        			var timeUtil:TimeUtil = new TimeUtil(array[i].timeDuration/1000);
//        			removeImg(img,array[i].timeDuration);        			
        			timeUtil.startCount();
        			BindingUtils.bindProperty(img,"timeCount",timeUtil,"time");		
        			img.data = array[i];
        			img.source = array[i].icon;        			
        			img.x = 115 ;
        			img.y = i*32+10;
        			_canvas.addChild(img);
        		}
			}
			if(EffectInfo.instance.itemEffectArray != null)
			onLeftEffect(EffectInfo.instance.itemEffectArray);
		}
		
//		public function removeImg(ui:UIComponent,timeNum:int):void
//		{
//			setTimeout(function():void
//			{
//				_canvas.removeChild(ui);
//			},timeNum);
//		}
				
		public function update():void {
			// update info
		}
		
		private function onAvatarImageLoaded(e:Event):void {
			glowImage.target = avatarImage;
			glowImage.play(null,true);
		}
		
		public function dragEnter(event:DragEvent):void{
			if(event.dragSource.formats[0] == 'package' || event.dragSource.formats[0] == 'skill'){
				var dropTarget:Canvas=event.currentTarget as Canvas;			
		    	DragManager.acceptDragDrop(dropTarget);
			}
			
		}
		
		public function dragDrop(event:DragEvent):void{			
			if(event.dragSource.formats[0] == 'package')
			{	
				var child:PackageItemComponent = event.dragInitiator as PackageItemComponent;
				var obj:Object = child.parent;
				if(child.itemData.itemInfo['addEffect'] != '-1') 
				{
					obj.packageData.useItem(child.itemData.itemId,obj,child);
				}
			}
			if(event.dragSource.formats[0] == 'skill'){
				RemoteService.instance.equipSkill(collection.playerId,SkillInfo.instance.id,SkillInfo.instance.skillType).addHandlers(onEquipSkill);
			}		
		    
		}
		
		//效果图标
		public function onEquipSkill(event:ResultEvent,token:AsyncToken):void
        {   
        	
        		if(event.result['result'] == true)
	        	{
	        		
	        		var array:Array = event.result['data'][1] as Array;
	        		for(var i:int = 0;i<array.length;i++)
	        		{
	        			var img:EffectOnHeaderComponent = new EffectOnHeaderComponent();
	        			var timeUtil:TimeUtil = new TimeUtil(array[i].timeDuration/1000);
//	        			removeImg(img,array[i].timeDuration);        			
	        			timeUtil.startCount();
	        			BindingUtils.bindProperty(img,"timeCount",timeUtil,"time");		
	        			img.data = array[i];
	        			img.source = array[i].icon;        			
	        			img.x = 115 ;
	        			img.y = i*32+10;
	        			_canvas.addChild(img);
	        		}
	        		RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(Application.application.loadPlayerResult);
	        	}else{
	        		collection.errorEvent(event.result['reason'],event.result['data']);
	
	        	}
        	
        	
        }
        
        //物品效果
        public function onLeftEffect(array:Array):void
        {        	
        		for(var i:int = 0;i<array.length;i++)
        		{
        			var img:EffectOnHeaderComponent = new EffectOnHeaderComponent();
        			var timeUtil:TimeUtil = new TimeUtil(array[i].timeDuration/1000);
//        			removeImg(img,array[i].timeDuration); 
        			timeUtil.startCount();
        			BindingUtils.bindProperty(img,"timeCount",timeUtil,"time");		
        			img.data = array[i];
        			img.source = array[i].icon;        			
        			img.x = 20;
        			img.y = i*32+10;
        			_canvas.addChild(img);
        		}
        }
        
        public function showLevelEffect():void
        {        	  
        	levelSwf.visible = true;
        	MovieClip(levelSwf.content).play();	       
	        MovieClip(levelSwf.content).addEventListener('finish',function():void
	        {
	        	MovieClip(levelSwf.content).stop();	
	        	setTimeout(function():void
	        	{
	        		MovieClip(levelSwf.content).gotoAndStop(1);	
	        		levelSwf.visible = false;	        			   
	        	},1000);
		            	    	
	        });	        	
        	     	
        }
        
       
       
	}
}