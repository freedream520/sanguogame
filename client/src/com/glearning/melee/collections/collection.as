//用户登录后所在的state
package com.glearning.melee.collections
{
	import com.glearning.melee.components.GameLoadingComponent;
	import com.glearning.melee.components.Workout.WorkoutOptionComponent;
	import com.glearning.melee.components.battle.BattleComponent;
	import com.glearning.melee.components.player.DeleteCopyProgressComponent;
	import com.glearning.melee.components.prompts.BattlePromptComponent;
	import com.glearning.melee.components.prompts.BattlePromptImpl;
	import com.glearning.melee.components.prompts.BattleTipComponent;
	import com.glearning.melee.components.prompts.DeathComponent;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.model.BattleInfo;
	import com.glearning.melee.model.CityInfo;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.model.PlaceInfo;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.messaging.events.MessageEvent;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.*;
	public class collection
	{
		public static var _melee:melee = melee(Application.application);
		public static var dataEvent:ResultEvent;
		public static var _playerId:int;
		public static var _resetRoom:int;
		public static var _currentPosition:String;
		public static var battleWindow:BattleComponent; 
		public static var isPopupBattle:Boolean = true;
		public static var prompt:BattlePromptComponent;
		public static var battleTimeOut:uint;
		public static var isFirst:Boolean;
		public static var instanceName:String;
		public static var instanceId:int;
		public static var firstLogin:Boolean = true;
		/*
		 * 0000001:长刃(武器) 0000002:拳套(武器) 0000004:短刃(武器) 0000010:头部(防具) 0000020:上装(防具)
		 * 0000040:腰带(防具) 0000080:下装(防具) 0000160:鞋子(防具) 0000320:护腕(防具) 0000640:披风(防具)
		 * 0010000:重甲(仅用于防具) 0020000:皮甲(仅用于防具) 0040000:布甲(仅用于防具) 0100000:项链 0200000:腰饰
		 * 1000000:消耗物品 2000000:改造类物品 4000000:任务物品
		 */
		public static var gItemTypeMap:Array = new Array(
													{"mask" : '4',
														"maskoffset" : 0,
														"value" : "轻型"},		
													{"mask" : '2',
														"maskoffset" : 0,
														"value" : "中型"},
													{"mask" : '1',
														"maskoffset" : 0,
														"value" : "重型"},
													{"mask" : '64',
														"maskoffset" : 1,
														"value" : "披风"},
													{"mask" : '32',
														"maskoffset" : 1,
														"value" : "护腕"},
													{"mask" : '16',
														"maskoffset" : 1,
														"value" : "鞋子"},
													{"mask" : '8',
														"maskoffset" : 1,
														"value" : "下装"},
													{"mask" : '4',
														"maskoffset" : 1,
														"value" : "腰带"},
													{"mask" : '2',
														"maskoffset" : 1,
														"value" : "上装"},
													{"mask" : '1',
														"maskoffset" : 1,
														"value" : "头部"},
													{"mask" : '4',
														"maskoffset" : 4,
														"value" : "布甲"},
													{"mask" : '2',
														"maskoffset" : 4,
														"value" : "皮甲"},
													{"mask" : '1',
														"maskoffset" : 4,
														"value" : "重甲"},
													{"mask" : '1',
														"maskoffset" : 5,
														"value" : "项链"},
													{"mask" : '2',
														"maskoffset" : 5,
														"value" : "腰饰"},
													{"mask" : '4',
														"maskoffset" : 6,
														"value" : "任务物品"},
													{"mask" : '2',
														"maskoffset" : 6,
														"value" : "改造类物品"},
													{"mask" : '1',
														"maskoffset" : 6,
														"value" : "消耗物品"});
		
		public static var gArmorTypeMap:Array = new Array({
														"mask" : '4',
														"maskoffset" : 4,
														"value" : "轻型"},
														{
														"mask" : '2',
														"maskoffset" : 4,
														"value" : "中型"},
														{
														"mask" : '1',
														"maskoffset" : 4,
														"value" : "重型"});

		public function collection(){
			
		}

		//地图移动
		public static function setEnterPlace(event:ResultEvent, token:AsyncToken):void{
			if(isFirst == false && event.result !=null)
			{
			if(event.result['result'] == true){
				if(event.result['data']['placeInfo']['type'] == '城市'){
					MySelf.instance.location = event.result['data']['placeInfo']['id'];
					CityInfo.instance.cityName = event.result['data']['placeInfo']['name'];
					if(event.result['data']['placeInfo']['camp'] == 1){
						CityInfo.instance.cityFaction = '魏国';
					}else{
						if(event.result['data']['placeInfo']['camp'] == 2){
							CityInfo.instance.cityFaction = '蜀国';
						}else{
							if(event.result['data']['placeInfo']['camp'] == 3){
								CityInfo.instance.cityFaction = '吴国';
							}else{
								if(event.result['data']['placeInfo']['camp'] == 9){
									CityInfo.instance.cityFaction = '中立';
								}else{
									CityInfo.instance.cityFaction = '在野';
								}
								
							}	
						}
					}
					CityInfo.instance.facilityList = event.result['data']['info']['childList'] as Array;
					CityInfo.instance.cityImg = event.result['data']['placeInfo']['image'].toString();
					if(firstLogin == false)
					{
						Application.application.cityMap.removeAllButton();
						Application.application.cityMap.onUpdateCity();
						
					}
					firstLogin = false;
					_melee.currentState = 'city';
				}			
				else{
					if(PlaceInfo.instance.regionName == event.result['data']['placeInfo']['regionName']){
						PlaceInfo.instance.inRegion = true;
					}else{
						PlaceInfo.instance.inRegion = false;
						PlaceInfo.instance.regionName = event.result['data']['placeInfo']['regionName'];	
					}	
					if(event.result['data']['placeInfo']['camp'] == 1){
						PlaceInfo.instance.faction = '魏国';
					}else{
						if(event.result['data']['placeInfo']['camp'] == 2){
							PlaceInfo.instance.faction = '蜀国';
						}else{
							if(event.result['data']['placeInfo']['camp'] == 3){
								PlaceInfo.instance.faction = '吴国';
							}else{
								if(event.result['data']['placeInfo']['camp'] == 9){
									PlaceInfo.instance.faction = '中立';
								}else{
									PlaceInfo.instance.faction = '在野';
								}							
							}	
						}
					}
					if(MySelf.instance.camp == event.result['data']['placeInfo']['camp']){
						PlaceInfo.instance.factionColor = '#95F46F';
					}else{
						if(event.result['data']['placeInfo']['camp'] == 9){
							PlaceInfo.instance.factionColor = '#94AFE1';
						}else{
							PlaceInfo.instance.factionColor = '#F15F59';
						}
					}
					PlaceInfo.instance.placeName = event.result['data']['placeInfo']['name'];
					PlaceInfo.instance.description = event.result['data']['placeInfo']['desciption'];
					PlaceInfo.instance.placeList = event.result['data']['info']['childs'] as Array;
					PlaceInfo.instance.npcList = event.result['data']['info']['npcsInfo'] as Array;
					PlaceInfo.instance.placeType = event.result['data']['placeInfo']['type'];
					PlaceInfo.instance.playerX = event.result['data']['placeInfo']['extentLeft'] + 20;
					PlaceInfo.instance.playerY = int(event.result['data']['placeInfo']['extentTop']) - 26;
					PlaceInfo.instance.name = event.result['data']['placeInfo']['name'];
					PlaceInfo.instance.palceChilds = event.result['data']['info']['childList'] as Array;
					PlaceInfo.instance.locationMap = event.result['data']['info']['parentPlacesSquence'] as Array;
					PlaceInfo.instance.playerList = event.result['data']['info']['playerList'] as Array;
					MySelf.instance.location = event.result['data']['placeInfo']['id'];
					if(Application.application.currentState != 'character')
					_melee.currentState = 'place';
					Application.application.placePanel.onUpdateComplete();
				}
				if(MySelf.instance.status == '战斗中'){
					if(isPopupBattle){
						isPopupBattle = false;
						RemoteService.instance.getProcessingBattleData(collection.playerId).addHandlers(onBattle);
					}
				}
				if(MySelf.instance.status == '死亡'){
					
					var death:DeathComponent = new DeathComponent();
	                PopUpManager.addPopUp(death,Application.application.canvas1,true);
	                PopUpManager.centerPopUp(death);
	               
				}
				RemoteService.instance.subscribe( collection.playerId.toString(), gotServerPush );
			}else{
				errorEvent(event.result['reason'],event.result['data']);
			}
		}
		}
		
		
		
		
		//弹出战斗界面 对 数据复制
		public static function onBattle(event:ResultEvent,token:AsyncToken):void{
			if(event.result != null)
			{
				if(event.result['result'] == true){				
					if(event.result['data'] != null){
						MySelf.instance.energy -= 1;
						MySelf.instance.status = '战斗中'
						BattleInfo.instance.attackData = event.result['data']['battleEventProcessList'] as Array;
						BattleInfo.instance.battleTime = event.result['data']['maxTime'];
						BattleInfo.instance.battleOverTime = event.result['data']['timeLimit'];
						BattleInfo.instance.mphpDelta = event.result['data']['MPHPDelta'] as Array;
						BattleInfo.instance.player1TeamInfo = event.result['data']['battleEventProcessList'][0][3][0] as Array;
						BattleInfo.instance.player2TeamInfo = event.result['data']['battleEventProcessList'][0][3][1] as Array;				
						if(event.result['data']['battleType'] == 1){
							BattleInfo.instance.battleType ='野外战斗';
						}else if(event.result['data']['battleType'] == 2){
							BattleInfo.instance.battleType ='副本战斗';
						}else{
							BattleInfo.instance.battleType ='决斗';
						}
						if(isPopupBattle){
							isPopupBattle = false;
							battleWindow = new BattleComponent();
							Application.application.addChild(battleWindow);
						}
					}else{
						RemoteService.instance.refresh(collection.playerId).addHandlers(onRefresh);
					}
					
				}else{
					errorEvent(event.result['reason'],event.result['data']);
				}
			}
			
		}
		
		//于服务器数据库同步
		public static function onRefresh(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(Application.application.loadPlayerResult);
			}
		}
		
		//弹出战斗结束框
		public static function battleOverWindow():void{
			var i:int = BattleInfo.instance.attackData.length - 1;
			BattlePromptImpl.promptData = BattleInfo.instance.attackData[i];
			prompt = new BattlePromptComponent();	
			PopUpManager.addPopUp(prompt,Application.application.canvas1,true);
			PopUpManager.centerPopUp(prompt);	
			prompt.closeAllBattle.addEventListener(MouseEvent.CLICK,onCloseAllBattle);
			RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(Application.application.loadPlayerResult);
		}
		
		public static function onCloseAllBattle(event:MouseEvent):void{
			PopUpManager.removePopUp(prompt);
		}
		
		//更新玩家属性
		public static function onLoadPlayerResult(event:ResultEvent, token:AsyncToken):void
		{
			if(event.result != null)
			{
				MySelf.instance.level = event.result['level'];
				MySelf.instance.camp = event.result['camp'];
				MySelf.instance.coin = event.result['coin'];
				MySelf.instance.gold = event.result['gold'];
				MySelf.instance.exp = event.result['exp'];
				MySelf.instance.maxExp = event.result['maxExp'];
				MySelf.instance.coupon = event.result['coupon'];
				MySelf.instance.hp = event.result['hp'];
				MySelf.instance.maxHp = event.result['maxHp'];
				MySelf.instance.mp = event.result['mp'];
				MySelf.instance.maxMp = event.result['maxMp'];
				MySelf.instance.exp = event.result['exp'];
				MySelf.instance.maxExp = event.result['maxExp'];
				MySelf.instance.currentSpeedDescription = event.result['currentSpeedDescription'];
				MySelf.instance.currentDamage = event.result['currentDamage'];			
				MySelf.instance.currentDefense = event.result['currentDefense'];			
				MySelf.instance.dodgeRate = event.result['dodgeRate'];
				MySelf.instance.bogeyRate = event.result['bogeyRate'];
				MySelf.instance.criRate = event.result['criRate'];
				MySelf.instance.hitRate = event.result['hitRate'];
				MySelf.instance.energy = event.result['energy'];
	        	MySelf.instance.profession = event.result['profession'];
	        	MySelf.instance.status = event.result['status'];
	        	MySelf.instance.pkStatus = event.result['pkStatus'];
	        	MySelf.instance.station = event.result['station'];
	        	MySelf.instance.baseDex = event.result['baseDex'];
				MySelf.instance.baseStr = event.result['baseStr'];
				MySelf.instance.baseVit = event.result['baseVit'];
				MySelf.instance.manualDex = event.result['manualDex'];
				MySelf.instance.manualStr = event.result['manualStr'];
				MySelf.instance.manualVit = event.result['manualVit'];
				MySelf.instance.extraStr = event.result['extraStr'];
				MySelf.instance.extraDex = event.result['extraDex'];
				MySelf.instance.extraVit = event.result['extraVit'];
				MySelf.instance.sparePoint = event.result['sparePoint'];
				MySelf.instance.currentSpeedDescription = event.result['currentSpeedDescription'];
				MySelf.instance.currentDamage = event.result['currentDamage'];			
				MySelf.instance.currentDefense = event.result['currentDefense'];			
				MySelf.instance.dodgeRate = event.result['dodgeRate'];
				MySelf.instance.bogeyRate = event.result['bogeyRate'];
				MySelf.instance.criRate = event.result['criRate'];
				MySelf.instance.hitRate = event.result['hitRate'];
				MySelf.instance.allProfessionStages = event.result['allProfessionStages'];
				MySelf.instance.currentProfessionStageIndex = event.result['currentProfessionStageIndex'];
				MySelf.instance.professionDescription = event.result['professionDescription'];
				Application.application.baseAvatar.update(); 
				if(MySelf.instance.sparePoint == 0)
	        	{
	        		Application.application.character.data = '角色';
	        	}else
	        	{
	        		Application.application.character.data = '您有'+MySelf.instance.sparePoint+'点属性点可加';
	        	}
			}
			
		}
		
		
		public static function itemIsEquip(type:int):Boolean{
			return type < 1000000; 
		}
		
		//判断物品是类型
		public static function getItemTypeGroupString(type:int):String{
			if (itemIsEquip(type)){
				if (type < 10) {
					return "武器";
				}
				return "防具";
			}
			return "道具";
		}
		
		//装备类型
		public static function getItemTypeString(type:int):String{
			var st:String = type.toString();
			for (var i:int = 0; i < gItemTypeMap.length; i++){
				var v:Object = gItemTypeMap[i];
				var c:String = st.substr(st.length - v.maskoffset - v.mask.length,v.mask.length);
				if (c == v.mask){
					return v.value;
				}
			}
			return "未知道具";
		}
		
		//护甲类型
		public static function getArmorTypeString(type:int):String{
			var st:String = type.toString();
			for (var i:int = 0; i < gArmorTypeMap.length; i++){
				var v:Object = gArmorTypeMap[i];
				var c:String = st.substr(st.length - v.maskoffset - v.mask.length,v.mask.length);
				if (c == v.mask){
					return v.value;
				}
			}
			return "未知类型";
		}
 	
		
		//登录后的用户ID
		public static function set playerId(playerId:int):void{
			_playerId = playerId;
		}
		
		public static function get playerId():int{
			return _playerId;
		}
		
		//用户当前所在地方
		public static function set currentPosition(currentPosition:String):void{
			_currentPosition = currentPosition;
		}
		
		public static function get currentPosition():String{
			return _currentPosition;
		}
		
		//宿屋的placeId
		public static function set resetRoom(resetRoom:int):void{
			_resetRoom = resetRoom;
		}
		
		public static function get resetRoom():int{
			return _resetRoom;
		}
		
		//所有错误 信息处理
		public static function errorEvent(reason:String,data:Object):void{
			if(MySelf.instance.status == '战斗中')
            {
                var battleTip:BattleTipComponent = new BattleTipComponent();
                PopUpManager.addPopUp(battleTip,Application.application.canvas1,true);
                PopUpManager.centerPopUp(battleTip);
		    }else if(MySelf.instance.status == '死亡')
		    {
		    	var death:DeathComponent = new DeathComponent();
                PopUpManager.addPopUp(death,Application.application.canvas1,true);
                PopUpManager.centerPopUp(death);
		    }else if(MySelf.instance.status == '修炼中')
		    {
		    	var workoutOption:WorkoutOptionComponent = new WorkoutOptionComponent();
				workoutOption.expBonus = data.totalExp;
				workoutOption.monsterName = data.monsterName;
				workoutOption.totalCount = data.countHit;
				workoutOption.time = data.seconds;
				PopUpManager.addPopUp(workoutOption,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(workoutOption);
		        workoutOption.setTime();
		    }
		    else{
		    	var tip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(tip,Application.application.canvas1,true);
		        PopUpManager.centerPopUp(tip);
		        tip.hideButton();
		        tip.tipText.text = reason;
		        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});
		    }
		}
		
		//实时通知 战斗、修炼 、大厅结束时的回调
		public static function gotServerPush(event:MessageEvent):void{
			if(event.message.body.toString() == 'finish'){
				trace(MySelf.instance.status);
				if(MySelf.instance.status == '战斗中')
            	{
            		if(battleWindow == null){
            			battleOverWindow();
            		}
            	}else{
            		Application.application.frashMiniTask();
            		RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(Application.application.loadPlayerResult );	
            	}
				 
			}
			if(event.message.body.toString() == 'newMail'){
				Application.application.mail.startEffect();
				Application.application.mail.data = '您有新的消息';
			}
			if(event.message.body.toString() == 'updataLevel'){
				Application.application.character.startEffect();
				RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(onLoadPlayerResult);				
				Application.application.mainAvatar.showLevelEffect();
				
			}
			if(event.message.body.toString() == 'newQuest'){
				Application.application.quest.startEffect();
				Application.application.quest.data = '您有可接任务';
			}
			if(event.message.body.toString() == 'newTempPackage'){
				Application.application.character.startEffect();
			}
		}
		
		//
		public static function enterPlace(e:Event):void{
			var placeId:int = e.currentTarget.id;
			if(MySelf.instance.isTeamMember == false || (MySelf.instance.isLeader == true && MySelf.instance.isTeamMember == true)){
				if(e.currentTarget.uid == 9000 && e.currentTarget.data == '地点')
				{
					instanceName = e.currentTarget.name;
					instanceId = placeId;
					RemoteService.instance.getInstanceStatus(collection.playerId,placeId).addHandlers(isEnterInstance);
					
				}
				else
				{
					RemoteService.instance.enterPlace(collection.playerId,placeId).addHandlers(collection.setEnterPlace);
				}
			}else{
				var normalTip:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(normalTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(normalTip);
				normalTip.tipText.text = '您不是队长，无法带队移动';
				normalTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normalTip);});
			}
		
		}
		
		public static function isEnterInstance(event:ResultEvent,token:AsyncToken):void
		{
			if(event.result != null)
			{
				var enterTip:DeleteCopyProgressComponent = new DeleteCopyProgressComponent();
				if(event.result == false)
				{		
					PopUpManager.addPopUp(enterTip,Application.application.canvas1,true);
					PopUpManager.centerPopUp(enterTip);
					enterTip.tipContent.htmlText += '您是否确定要开始挑战'+instanceName+'?\n';
					enterTip.tipContent.htmlText += '挑战副本需要消耗<font color="#FF7575">10</font>点活力和<font color="#FF7575">1</font>次副本挑战次数，如果您的活力或挑战次数不足则无法挑战\n';
					enterTip.tipContent.htmlText += '注意：如果您保存有其他副本的进度，进入该副本会变为此副本的进度，原进度将会消失';
					enterTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(enterTip);RemoteService.instance.enterInstance(collection.playerId,instanceId).addHandlers(onEnterInstance);});
				}
				else
				{
					PopUpManager.addPopUp(enterTip,Application.application.canvas1,true);
					PopUpManager.centerPopUp(enterTip);
					enterTip.tipContent.htmlText += '&nbsp;&nbsp;&nbsp;&nbsp;您保存有该副本的进度，使用此进度可以让您继续上次的进度挑战该副本，\n';
					enterTip.tipContent.htmlText += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您是否想使用此进度?\n';
					enterTip.tipContent.htmlText += '&nbsp;&nbsp;&nbsp;&nbsp;如果您想从头开始挑战，请在角色界面清除进度后再次挑战';
					enterTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(enterTip);RemoteService.instance.enterInstance(collection.playerId,instanceId).addHandlers(onEnterInstance);});
				}		
			}			
				
		}
		
		public static function onEnterInstance(event:ResultEvent,token:AsyncToken):void
		{
			if(event.result != null)
			{
				if(event.result.result == false)
				{
					var normalTip:NormalTipComponent = new NormalTipComponent();
					PopUpManager.addPopUp(normalTip,Application.application.canvas1,true);
					PopUpManager.centerPopUp(normalTip);
					normalTip.hideButton();
					normalTip.tipText.text = event.result.reason;
					normalTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normalTip);});			
				}else
				{
					MySelf.instance.energy = event.result['data'].energy;
					RemoteService.instance.enterPlace(collection.playerId,event.result['data'].layer).addHandlers(collection.setEnterPlace);
				}
			}
			
		}
		
		public static var test:GameLoadingComponent = new GameLoadingComponent();
		public static var bol:Boolean = true;
		
		public static function openLoading():void{
			if(bol){
				PopUpManager.addPopUp(test,Application.application.canvas1,true);
				PopUpManager.centerPopUp(test);
				bol =false;
			}
				
		}
		
		public static function closeLoading():void{
			PopUpManager.removePopUp(test);
			bol = true;
		}
		
		public static function showAddward(coin:int,exp:int,itemBonus:Object = null):void
		{
			var normal:NormalTipComponent = new NormalTipComponent();
			PopUpManager.addPopUp(normal,Application.application.canvas1,true);
			PopUpManager.centerPopUp(normal);
			normal.hideButton();
			normal.tipText.htmlText += '恭喜，你获得了以下奖励！\n'
			if(coin != 0)
			{
				normal.tipText.htmlText += '铜币奖励:<font color="#ff0000">'+coin+'</font>\n';
			}
			if(exp != 0)
			{
				normal.tipText.htmlText += '经验奖励:<font color="#ff0000">'+exp+'</font>\n';
			}
			if(itemBonus != null)
			{
				normal.tipText.htmlText += '物品奖励:<font color="#ff0000">'+itemBonus.name+'</font>\n';
			}
			normal.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normal);});
		}
		
	}
}