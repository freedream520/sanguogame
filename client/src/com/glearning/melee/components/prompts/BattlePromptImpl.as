package com.glearning.melee.components.prompts
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.model.BattleInfo;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	import com.glearning.melee.components.utils.AutoTip;
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class BattlePromptImpl extends Canvas
	{
		public var img:Image;
		public var closeAllBattle:LinkButton;
		public static var promptData:Array;
		private var lostImage:String = 'images/battle/failure.png';
		public var loserPlayer:Text;
		public var winnerPlayer:Text;
		public var winnerPlayerExp:Label;
		public var itemBonuses:Text;
		public var loserName:String;
		public var winnerName:String;
		
		public function BattlePromptImpl()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,creationBattlePrompt);
		}
		
		public function creationBattlePrompt(event:FlexEvent):void{
			var player1Nams:String ='';
			var player2Nams:String ='';
			for(var i:int = 0;i<BattleInfo.instance.attackData[0][3][0].length;i++){
				if(i == 0)
					player1Nams = BattleInfo.instance.attackData[0][3][0][i]['name'];
				else
					player1Nams += ','+BattleInfo.instance.attackData[0][3][0][i]['name'];			
			}
			for(var j:int = 0;j<BattleInfo.instance.attackData[0][3][1].length;j++){
				if(j == 0)
					player2Nams = BattleInfo.instance.attackData[0][3][1][j]['name'];
				else
					player2Nams += ','+BattleInfo.instance.attackData[0][3][1][j]['name'];
			}
			for(var k:int = 0; k<promptData[3].length;k++){
				if(collection.playerId == promptData[3][k]['id'])
				{
					var winner :Array = promptData[3][k]['battleResult']['winner'];
					for(var g:int =0 ;g<winner.length;g++){
						if(winner[g] == collection.playerId){
						//胜利后的提示
							winnerPlayerExp.htmlText = '<font color="#ff0000">您</font>提升了'+(promptData[3][k]['battleResult']['scoreBonus']+promptData[3][k]['battleResult']['expBonus'])+'点经验值';
							
							//获得物品的提示
							var partyItemBonuses:Array = promptData[3][k]['battleResult']['itemBonuses'] as Array;
							for(var n:int = 0;n<partyItemBonuses.length;n++){
								if(partyItemBonuses[n]['partyId'] == collection.playerId.toString()){
									itemBonuses.htmlText += '您获得了<font color="#EB37A1">'+partyItemBonuses[n]['itemName']+'</font>   '+partyItemBonuses[n]['amount']+'件\n';
								}
							}
							
							for(var m:int = 0;m<BattleInfo.instance.attackData[0][3][0].length;m++){
								if(collection.playerId == BattleInfo.instance.attackData[0][3][0][m]['id']){
									winnerName = player1Nams;
									loserName = player2Nams;
									break;	
								}
							}
							
							break;
						}else{
							for(var l:int = 0;l<BattleInfo.instance.attackData[0][3][0].length;l++){
								if(collection.playerId == BattleInfo.instance.attackData[0][3][0][l]['id']){
									loserName = player1Nams;
									winnerName = player2Nams;
									break;	
								}
							}
							img.source = lostImage;
						}
					}
					
				}
			}
	
			loserPlayer.htmlText = '<font color="#ff0000">'+loserName+'</font>已经没有再战之力';
			winnerPlayer.htmlText = '<font color="#ff0000">'+winnerName+'</font>技高一筹，获得了胜利';
				
		    if(winnerName == player1Nams)
		    {
		    	trace(MySelf.instance.isNewPlayer)
				trace(MySelf.instance.progress);
				trace(BattleInfo.instance.player2Id)
				if(MySelf.instance.isNewPlayer == 1)
				{
					if(MySelf.instance.progress == 11 && BattleInfo.instance.player2Id == 5001)
					{
						if(Application.application.currentState == 'place')
						{
							Application.application.placePanel.toCity.startEffect();
							AutoTip._showTip('返回国都向左慈交付任务',Application.application.placePanel.toCity);
							RemoteService.instance.changePlayerHasKilledMonster(collection.playerId,1).addHandlers(onChangePlayerHasKilledMonster);
							
						}				
					}else if(MySelf.instance.progress == 12 && BattleInfo.instance.player2Id == 5008)
					{
						if(Application.application.currentState == 'place')
						{
							Application.application.placePanel.toCity.startEffect();
							AutoTip._showTip('返回国都向左慈交付任务',Application.application.placePanel.toCity);
							RemoteService.instance.changePlayerHasKilledMonster(collection.playerId,1).addHandlers(onChangePlayerHasKilledMonster);
						}
					}else if(MySelf.instance.progress == 13 && BattleInfo.instance.player2Id == 5015)
					{
						if(Application.application.currentState == 'place')
						{
							Application.application.placePanel.toCity.startEffect();
							AutoTip._showTip('返回国都向左慈交付任务',Application.application.placePanel.toCity);
							RemoteService.instance.changePlayerHasKilledMonster(collection.playerId,1).addHandlers(onChangePlayerHasKilledMonster);
						}
					}
					AutoTip._tip.visible = false;
				}
				if(AutoTip._tip != null)
					AutoTip._tip.visible = false;
		    }
		}
		
		public function onChangePlayerHasKilledMonster(event:ResultEvent,token:AsyncToken):void
		{
			MySelf.instance.isKilled = 1;
		}
		
	}
}