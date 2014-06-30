//吕忠涛
package com.glearning.melee.components.player
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.CustomerTooltipComponent;
	import com.glearning.melee.components.prompts.DeathComponent;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.model.MySelf;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.LinkButton;
	import mx.controls.ProgressBar;
	import mx.core.Application;
	import mx.events.ToolTipEvent;
	import mx.managers.PopUpManager;
	
	public class PlayerBaseInfoImpl extends Canvas
	{
		public var hp:Canvas;
		public var mp:Canvas;
		public var exp:Canvas;
		public var recoverEnergy:LinkButton;
		[Bindable]
		public var professionStage:String;
		
		public function PlayerBaseInfoImpl()
		{
			super();		
		}
		
        public  function createCustomToolTip(event:ToolTipEvent):void { 
  
             var toolTip:CustomerTooltipComponent = new CustomerTooltipComponent();  
             toolTip.progressId = event.target.id;                 
             toolTip.init(5);
             event.toolTip = toolTip; 
         } 
		
		public function update():void {
        	hp.percentWidth = MySelf.instance.hp/MySelf.instance.maxHp*100-3;        	
        	mp.percentWidth = MySelf.instance.mp/MySelf.instance.maxMp*100-3;        	
        	exp.percentWidth = MySelf.instance.exp/MySelf.instance.maxExp*100-3;
        	if(MySelf.instance.allProfessionStages != null)
        	{
        		for(var i:int = 0;i<MySelf.instance.allProfessionStages.length;i++)
				{				
				   if(i == MySelf.instance.currentProfessionStageIndex as int){
						professionStage= MySelf.instance.allProfessionStages[i].toString()
						break;
				   }
			       
				}	
        	}
        			
		}
		
		public function resumeEnergy():void{
			if (MySelf.instance.location != MySelf.instance.town){
				var tip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = '请回城恢复活力';
		        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});

			}else{
				Application.application.currentState = 'resthouse';
				Application.application.restHousePanle.placeId = collection.resetRoom;
				Application.application.restHousePanle.init();
				collection.currentPosition = 'city'
			}
		}
		
		public function openDeath():void{
			if(MySelf.instance.status == '死亡'){
				var death:DeathComponent = new DeathComponent();
                PopUpManager.addPopUp(death,Application.application.canvas1,true);
                PopUpManager.centerPopUp(death);
			}
		}
	}
}