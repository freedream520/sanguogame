package com.glearning.melee.components.player
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.CustomerTooltipComponent;
	import com.glearning.melee.components.prompts.PayMoneyComponent;
	import com.glearning.melee.components.utils.AutoTip;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Canvas;
	import mx.containers.Panel;
	import mx.controls.LinkButton;
	import mx.controls.ProgressBar;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.events.ToolTipEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class PortionPointImpl extends Canvas
	{
		public var str:Canvas;
		public var dex:Canvas;
		public var vit:Canvas;
		public var strAdd:LinkButton;
		public var strAdds:LinkButton;
		public var dexAdd:LinkButton;
		public var dexAdds:LinkButton;
		public var vitAdd:LinkButton;
		public var vitAdds:LinkButton;
		public var point:Text;
		public var panel:Panel;
		public var eve:ResultEvent;
		public var restPoint:int;		
		public var payMoney:PayMoneyComponent;		
		public function PortionPointImpl()
		{
			super();			
		}	
		//10+(等级-1)*(职业该属性的成长率+1)

		public function init():void
		{			
			BindingUtils.bindProperty(point,'data',point,'text');		
			hasPoint();			
			str.percentWidth = (MySelf.instance.baseStr+MySelf.instance.manualStr)/(10+(MySelf.instance.level-1)*(MySelf.instance.growRate[0]+1))*100-3;
			dex.percentWidth = (MySelf.instance.baseDex+MySelf.instance.manualDex)/(10+(MySelf.instance.level-1)*(MySelf.instance.growRate[1]+1))*100-3;
			vit.percentWidth = (MySelf.instance.baseVit+MySelf.instance.manualVit)/(10+(MySelf.instance.level-1)*(MySelf.instance.growRate[2]+1))*100-3;
		
	    	if(MySelf.instance.isNewPlayer == 1 && MySelf.instance.progress == 4 && point.text != '0')
	    	{
	    		AutoTip._showTip('点击完成能力加点',strAdd);
	    	}	    	
		}
		
		public  function createCustomToolTip(event:ToolTipEvent):void { 
  
             var toolTip:CustomerTooltipComponent = new CustomerTooltipComponent();  
             toolTip.progressId = event.target.id;                 
             toolTip.init(3);
             event.toolTip = toolTip; 
         } 
				
		
		public function addPoint(playid:int,type:String,all:int):void
		{				
				RemoteService.instance.addPoint(playid,type,all).addHandlers(onAddPoint);	
				if(MySelf.instance.isNewPlayer == 1)
				{
					if(MySelf.instance.progress == 4)
					{
						AutoTip._destoryTip();
					}
				}				
				
		}
		
		public function onNewPlayerQuestInfo(event:ResultEvent,token:AsyncToken):void
		{
			RemoteService.instance.changeQuestProgress(collection.playerId,5).addHandlers(onChangeQuestProgress);
			MySelf.instance.progress = 5;
			RemoteService.instance.addReward(collection.playerId,event.result['data'][0][3],event.result['data'][0][5],event.result['data'][0][4]).addHandlers(onAddReward)
		}
		
		public function onAddReward(event:ResultEvent,token:AsyncToken):void
		{
//			RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(collection.onLoadPlayerResult);
					
		}
		
		public function onChangeQuestProgress(event:ResultEvent,token:AsyncToken):void
		{
			if(point.text == '0')
            Application.application.newPlayerQuestProgress(event.result.progress);
            Application.application.frashMiniTask();
		}
		
		public function onAddPoint(event:ResultEvent,token:AsyncToken):void
		{
            if(event.result['result'] == true)
            {
				MySelf.instance.sparePoint = event.result['data']['sparePoint'];
				if(event.result['data']['type'] == 'manualStr')
					MySelf.instance.manualStr = event.result['data']['point'];
				else if(event.result['data']['type'] == 'manualDex')
					MySelf.instance.manualDex = event.result['data']['point'];
				else if(event.result['data']['type'] == 'manualVit')
					MySelf.instance.manualVit = event.result['data']['point'];
					
				//1	
				RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(collection.onLoadPlayerResult);
				init();			
				hasPoint();	
				if(MySelf.instance.isNewPlayer == 1 && MySelf.instance.progress == 4 && point.text == '0')
				{
					
					RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onNewPlayerQuestInfo);	
				}
		    	
            }else
            {
            	collection.errorEvent(event.result['reason'],event.result['data']);

            }
		}
		
	
		
		public function hasPoint():void
		{
			if(MySelf.instance.sparePoint == 0)
			{
			    strAdd.enabled = false;
		    	strAdds.enabled = false;
		    	dexAdd.enabled = false;
		    	dexAdds.enabled = false;
		    	vitAdd.enabled = false;
		    	vitAdds.enabled = false;	
		    			  
			}
			else
			{
			    strAdd.enabled = true;
		    	strAdds.enabled = true;
		    	dexAdd.enabled = true;
		    	dexAdds.enabled = true;
		    	vitAdd.enabled = true;
		    	vitAdds.enabled = true;			   
			}						
		}
		
		//Popupmanager重新分配弹出窗口
		public function reassignPoint():void
		{
			restPoint = MySelf.instance.manualDex + MySelf.instance.manualStr+MySelf.instance.manualVit;
			payMoney = new PayMoneyComponent();
			payMoney.amount = restPoint.toString();
			payMoney.description = '立即重置点数吗？';
			PopUpManager.addPopUp(payMoney,Application.application.canvas1,true);
			PopUpManager.centerPopUp(payMoney);
			payMoney.payMoneyOK.addEventListener(MouseEvent.CLICK,payMoneyOK);			
		}
		
		public function payMoneyOK(event:MouseEvent):void{
			var type:String = '';
			if(payMoney.gold.selected == true){
				type = 'gold';
			}else{
				type = 'coupon';
			}
			RemoteService.instance.reassginPoint(collection.playerId,type,restPoint).addHandlers(onReassginPoint);
			PopUpManager.removePopUp(payMoney);
		}
		
	
		public function onReassginPoint(event:ResultEvent,token:AsyncToken):void
		{
           if(event.result['result'] == true)
           {
				MySelf.instance.sparePoint = event.result['data']['sparePoint'];
				MySelf.instance.manualDex = event.result['data']['manualDex'];
				MySelf.instance.manualStr = event.result['data']['manualStr'];
				MySelf.instance.manualVit = event.result['data']['manualVit'];						
				RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(collection.onLoadPlayerResult);
				init();
				hasPoint();	
           }
           else
           {
           		collection.errorEvent(event.result['reason'],event.result['data']);

           }
		}
		

		
		
	}
}