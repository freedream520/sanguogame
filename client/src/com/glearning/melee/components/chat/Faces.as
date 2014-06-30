package com.glearning.melee.components.chat
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.core.Application;
	import mx.core.UIComponent;

	public class Faces extends HBox
	{
		public static var _smileys:Array = [jAcid_smiley, jCool_smiley, jEyelash_smiley, jGawp_smiley, jGrin_smiley, 
										    jHmm_smiley, jHuh_smiley, jKiss_smiley, jLaugh_smiley, jSad_smiley,
										    jShocked_smiley, jUnhappy_smiley, jWhat_smiley, jWink_smiley, jXiaoYu_smiley
										    ];
										    
		public var _selectedFacesIndexArray:Array = [];//存放已经点击选取的表情下标
		
		public var faceList:UIComponent;
		
		public function Faces()
		{
			super();
		}
		
		public function initFacesWindow():void{
			createSmileyes();
		}
		
		private function createSmileyes():void{
			var smileyes:Array = _smileys;
			var sprite:Sprite;
			for(var i:int=0; i<smileyes.length; i++){
				sprite = new smileyes[i]() as Sprite;
				faceList.addChild(sprite);
				sprite.buttonMode = true;
				sprite.x = (i%5)*35;
				sprite.y = Math.floor(i/5)*30;
				sprite.addEventListener(MouseEvent.CLICK,smileClick);
			}
		}
		
		private function smileClick(event:MouseEvent):void{
			var smile:Sprite = event.currentTarget as Sprite;
			var selectedIndex:int = faceList.getChildIndex(smile);
			_selectedFacesIndexArray.push(selectedIndex);
			Application.application.chatWindow.textInput.text += ":/";
			this.visible = false;
			/* this.setVisible(false); */
		}
		
	}
}