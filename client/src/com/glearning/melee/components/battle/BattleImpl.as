package com.glearning.melee.components.battle
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.BattlePromptComponent;
	import com.glearning.melee.components.prompts.BattlePromptImpl;
	import com.glearning.melee.components.utils.AutoTip;
	import com.glearning.melee.model.BattleInfo;
	import com.glearning.melee.net.RemoteService;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.SWFLoader;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.effects.Move;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;

	public class BattleImpl extends Canvas
	{
		public var battleIdx:int;
		public var initTime:int = 0;
		public var traversalCanvas:Canvas;
		public var player1Canvas:Canvas;
		public var player2Canvas:Canvas;
		public var player1Hp:Canvas;
		public var player1Mp:Canvas;
		public var player2Hp:Canvas;
		public var player2Mp:Canvas;
		public var prompt:BattlePromptComponent;
//		public var dataArry:Array;
		public var dataIdex:int = 1;
		public var deltaIdx:int = 0;
		public var player1:BattleMiniPersonComponent;
		public var player2:BattleMiniPersonComponent;
        public var num:int = 8;
	    public var angle:int = -90;
	    public var temp:int = 0;
        public var myMove:Move ;
	    public var tempArray:Array;
	    public var fxArray:Array = Application.application.fxArray;
	    public var traversalArray:Array = Application.application.traversalArray;
	    public var figureArray:Array = Application.application.figureArray;
	    public var player1Color:Array = new Array();
	    public var player2Color:Array = new Array();
	    public var damage:int = 0;
	    public var effectScene:Canvas;
	    public var swfArray:Array = new Array();
	    public var team1ChangeTimes:int;
	    public var team2ChangeTimes:int;
	    public var l1:Image;
	    public var l2:Image;
	    public var r2:Image;
	    public var r1:Image;
	    public var ownerArray:Array ;
		public var ownerTimeArray:Array ;
		public var opponentArray:Array ;
		public var opponentTimeArray:Array;
		public var bol:Boolean = false;
		public function BattleImpl()
		{
			super();
			this.addEventListener(FlexEvent.INITIALIZE,initBattle);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,creationBattle);
		}
		
		public function initBattle(event:FlexEvent):void{
			
			battleIdx =  BattleInfo.instance.battleOverTime - BattleInfo.instance.battleTime;
			
			if(battleIdx != 0){
				for(var i:int = 1;i<=BattleInfo.instance.attackData.length-1;i++){
						switch(BattleInfo.instance.attackData[i][1]){
							case 3:
								if(battleIdx < BattleInfo.instance.attackData[i][0]){
									BattleInfo.instance.attackData[0][3][0][0]['hp'] = BattleInfo.instance.attackData[i][3]['party1Hp'];
									BattleInfo.instance.attackData[0][3][0][0]['mp'] = BattleInfo.instance.attackData[i][3]['party1Mp'];
									BattleInfo.instance.attackData[0][3][1][0]['hp'] = BattleInfo.instance.attackData[i][3]['party2Hp'];
									BattleInfo.instance.attackData[0][3][1][0]['mp'] = BattleInfo.instance.attackData[i][3]['party2Mp'];
									bol = true;
									battleIdx = BattleInfo.instance.attackData[i][0];
								}
						}
						if(bol)
							break;
				}
			}
			initializePlayer1(BattleInfo.instance.attackData[0][3][0]);
			initializePlayer2(BattleInfo.instance.attackData[0][3][1]);
//			BattleInfo.instance.player1Skill = BattleInfo.instance.player1SkillInfo;
			
			
			
			
			
//			BattleInfo.instance.player2Skill = BattleInfo.instance.player2SkillInfo;
			
			//创建队友
//			var player1Teams:Array = BattleInfo.instance.player1TeamInfo;
//			for(var idx:int = 0;idx<player1Teams.length;idx++)
//			{
//				
//			}
//			var player2Teams:Array = BattleInfo.instance.player2TeamInfo;
//			for(var idx:int = 0;idx<player2Teams.length;idx++)
//			{
//				
//			}
//			BattleInfo.instance.battleTime = 30;
            //BattleInfo.instance.battleTime =  360;
		}
		
		public function initializePlayer1(array:Array):void
		{
			BattleInfo.instance.player1Name = array[0]['name'];
			BattleInfo.instance.player1Id = array[0]['id'];	
			BattleInfo.instance.player1Level = array[0]['level'];
			BattleInfo.instance.player1Profession = array[0]['professionName'];
			BattleInfo.instance.player1ProfessionStage = array[0]['professionStage'];
			BattleInfo.instance.player1HP = array[0]['hp'];
			BattleInfo.instance.player1Img = stringTool(array[0]['image']);
			BattleInfo.instance.player1MP = array[0]['mp'];
			BattleInfo.instance.player1MaxHP = array[0]['maxHp'];
			BattleInfo.instance.player1MaxMP = array[0]['maxMp'];
			if(array[0]['activeSkill'] == null){
				BattleInfo.instance.player1Skill = '没有技能';
			}else{
//				BattleInfo.instance.player1SkillInfo = BattleInfo.instance.attackData[0][3][0][0]['activeSkill'];
//				BattleInfo.instance.player1Skill = BattleInfo.instance.attackData[0][3][0][0]['activeSkill']['name'] + '   LV '+BattleInfo.instance.attackData[0][3][0][0]['activeSkill']['level'];
				BattleInfo.instance.player1Skill = array[0]['activeSkill']['name'] + '   LV '+array[0]['activeSkill']['level'];
			}
//			BattleInfo.instance.player1Skill = BattleInfo.instance.attackData[0][3][0][0]['activeSkillName'] + '   LV '+BattleInfo.instance.attackData[0][3][0][0]['activeSkillLevel'];
			//匹配形象表
			for(var idx:int = 0;idx<figureArray.length;idx++){
				if(figureArray[idx][0] == array[0]['figure']){
					player1.width = int(figureArray[idx][4]);
					player1.height = int(figureArray[idx][5]) + 80;
					player1.x = int(figureArray[idx][6]);
					player1.y = int(figureArray[idx][7])-60;
					player1.init(figureArray[idx][2]);
					break;
				}
		 	}
			//player1.init(1,"left");
			traversalTools(array[0]['startBattleSentence'].toString(),'left');
			player1Hp.percentWidth = BattleInfo.instance.player1HP/BattleInfo.instance.player1MaxHP*100 - 1;
			player1Mp.percentWidth = BattleInfo.instance.player1MP/BattleInfo.instance.player1MaxMP*100 - 1;
			if(BattleInfo.instance.player1TeamInfo[1] != null)
		    l1.source = BattleInfo.instance.player1TeamInfo[1].image;
			if(BattleInfo.instance.player1TeamInfo[2] != null)
			l2.source = BattleInfo.instance.player1TeamInfo[2].image;
		}
		
		public function initializePlayer2(array:Array):void
		{
			BattleInfo.instance.player2Id = array[0]['id'];
			BattleInfo.instance.player2Name = array[0]['name'];
			BattleInfo.instance.player2Level = array[0]['level'];
			BattleInfo.instance.player2Profession = array[0]['professionName'];
			BattleInfo.instance.player2ProfessionStage = array[0]['professionStage'];
			BattleInfo.instance.player2HP = array[0]['hp'];
			BattleInfo.instance.player2Img = stringTool(array[0]['image']);
			BattleInfo.instance.player2MP = array[0]['mp'];
			BattleInfo.instance.player2MaxHP = array[0]['maxHp'];
			BattleInfo.instance.player2MaxMP = array[0]['maxMp'];
			if(array[0]['activeSkill'] == null){
				BattleInfo.instance.player2Skill = '没有技能';
			}else{
//				BattleInfo.instance.player2SkillInfo = BattleInfo.instance.attackData[0][3][0][0]['activeSkill'];
//				BattleInfo.instance.player2Skill = BattleInfo.instance.attackData[0][3][1][0]['activeSkill']['name'] + '   LV '+BattleInfo.instance.attackData[0][3][1][0]['activeSkill']['level'];
				BattleInfo.instance.player2Skill = array[0]['activeSkill']['name'] + '   LV '+array[0]['activeSkill']['level'];
			}
//			BattleInfo.instance.player2Skill = BattleInfo.instance.attackData[0][3][1][0]['activeSkillName'] + '   LV '+BattleInfo.instance.attackData[0][3][1][0]['activeSkillLevel'];
			//匹配形象表
			for(var idx:int = 0;idx<figureArray.length;idx++){
				if(figureArray[idx][0] == array[0]['figure']){
					player2.width = int(figureArray[idx][4]);
					player2.height = int(figureArray[idx][5]) + 80;
					player2.x = 490-int(figureArray[idx][6])-int(figureArray[idx][4])+490;
					player2.y = int(figureArray[idx][7])-60;
					player2.init(figureArray[idx][3]);
					break;
				}
		 	}
			//player2.init(1,"right");
			traversalTools(array[0]['startBattleSentence'].toString(),'right');
			player2Hp.percentWidth = BattleInfo.instance.player2HP/BattleInfo.instance.player2MaxHP*100 - 1;
			player2Mp.percentWidth = BattleInfo.instance.player2MP/BattleInfo.instance.player2MaxMP*100 - 1;
			if(BattleInfo.instance.player2TeamInfo[1] != null)
			r1.source = BattleInfo.instance.player2TeamInfo[1].image;
			if(BattleInfo.instance.player2TeamInfo[2] != null)
			r2.source = BattleInfo.instance.player2TeamInfo[2].image;
		}
		
		public function creationBattle(event:FlexEvent):void{
			setTimeout(updateFightMonsterProcess,1000);
			//updateFightMonsterProcess();
		}
		
		
//		1.战斗开始事件 2.战斗结束事件 3.攻击事件 4.主动技能事件 5.效果获得事件 6.效果消失事件 7.效果触发事件
		
		//战斗过程播放
		public function updateFightMonsterProcess():void{
			
			for(dataIdex;dataIdex<=BattleInfo.instance.attackData.length-1;dataIdex++)
			{
				if(battleIdx == BattleInfo.instance.attackData[dataIdex][0]){
					
					switch(BattleInfo.instance.attackData[dataIdex][1]){
						case 3:							
							if(BattleInfo.instance.attackData[dataIdex][2] == BattleInfo.instance.player1Id){
								damage = BattleInfo.instance.player2HP - BattleInfo.instance.attackData[dataIdex][3]['party2Hp'];
								var size1:int = fontSize(damage,BattleInfo.instance.player2MaxHP);
								player2.showHurt('-'+ damage.toString(),'hp',size1,'right',BattleInfo.instance.attackData[dataIdex][3]['damageType']);
								player1.playFlash();
								
								BattleInfo.instance.player2HP = BattleInfo.instance.attackData[dataIdex][3]['party2Hp'];
								
//								if(BattleInfo.instance.player2HP < BattleInfo.instance.attackData[dataIdex][3]['damage']){
//									BattleInfo.instance.player2HP = 0;
//								}else{
//									BattleInfo.instance.player2HP = BattleInfo.instance.player2HP - BattleInfo.instance.attackData[dataIdex][3]['damage'];
//								}
								traversalTools(BattleInfo.instance.attackData[dataIdex][3]['attack'].toString(),'left');
								traversalTools(BattleInfo.instance.attackData[dataIdex][3]['defense'].toString(),'right');
							}else{
								damage = BattleInfo.instance.player1HP - BattleInfo.instance.attackData[dataIdex][3]['party1Hp'];
								var size2:int = fontSize(damage,BattleInfo.instance.player1MaxHP);
								player1.showHurt('-'+ damage.toString(),'hp',size2,'left',BattleInfo.instance.attackData[dataIdex][3]['damageType']);
								player2.playFlash();
								
								BattleInfo.instance.player1HP = BattleInfo.instance.attackData[dataIdex][3]['party1Hp'];
//								if(BattleInfo.instance.player1HP < BattleInfo.instance.attackData[dataIdex][3]['damage']){
//									BattleInfo.instance.player1HP = 0;
//								}else{
//									BattleInfo.instance.player1HP = BattleInfo.instance.player1HP - BattleInfo.instance.attackData[dataIdex][3]['damage'];
//								}
								traversalTools(BattleInfo.instance.attackData[dataIdex][3]['defense'].toString(),'left');
								traversalTools(BattleInfo.instance.attackData[dataIdex][3]['attack'].toString(),'right');
							}
							trace('谁攻击：'+BattleInfo.instance.attackData[dataIdex][2]);
							trace('伤害：'+damage);
							trace('攻击人话：'+BattleInfo.instance.attackData[dataIdex][3]['attack'].toString());
							trace('被攻击人话：'+BattleInfo.instance.attackData[dataIdex][3]['defense'].toString());
							//左边小队在场队员阵亡
							
							if(BattleInfo.instance.attackData[dataIdex][3]['party1Hp'] == 0 && BattleInfo.instance.player1TeamInfo.length>1 && team1ChangeTimes != (BattleInfo.instance.player1TeamInfo.length-1))
							{
								var changeMemberArray1:Array = BattleInfo.instance.player1TeamInfo;	
								changeMemberArray1.push(changeMemberArray1.shift());
								BattleInfo.instance.player1TeamInfo = changeMemberArray1;
								initializePlayer1(	changeMemberArray1);
								
								team1ChangeTimes++;							
							}
							//右边小队在场队员阵亡
							else if(BattleInfo.instance.attackData[dataIdex][3]['party2Hp'] == 0 && BattleInfo.instance.player2TeamInfo.length>1 && team2ChangeTimes != (BattleInfo.instance.player2TeamInfo.length-1))
							{
								var changeMemberArray2:Array = BattleInfo.instance.player2TeamInfo;	
								changeMemberArray2.push(changeMemberArray2.shift());
								BattleInfo.instance.player2TeamInfo = changeMemberArray2;	
								initializePlayer2(	changeMemberArray2);
								
								team2ChangeTimes++;		
							}
							break;
						case 4:
							if(BattleInfo.instance.attackData[dataIdex][2] == BattleInfo.instance.player1Id){
								BattleInfo.instance.player1MP = BattleInfo.instance.player1MP - BattleInfo.instance.attackData[dataIdex][3]['deltaMp'];
								player1.showHurt('-'+BattleInfo.instance.attackData[dataIdex][3]['deltaMp'].toString(),'mp',1,'left');
								traversalTools(BattleInfo.instance.attackData[dataIdex][3]['usingSkillSentence'].toString(),'left');
							}else{
								BattleInfo.instance.player2MP = BattleInfo.instance.player2MP - BattleInfo.instance.attackData[dataIdex][3]['deltaMp'];
								player2.showHurt('-'+BattleInfo.instance.attackData[dataIdex][3]['deltaMp'].toString(),'mp',1,'right');
								traversalTools(BattleInfo.instance.attackData[dataIdex][3]['usingSkillSentence'].toString(),'right');
							}
							break;
						case 5:
							ownerArray = BattleInfo.instance.attackData[dataIdex][3][0]['ownerGetFx'];
							ownerTimeArray = BattleInfo.instance.attackData[dataIdex][3][0]['ownerGetFxDelay'];
							opponentArray = BattleInfo.instance.attackData[dataIdex][3][0]['opponentGetFx'];
							opponentTimeArray = BattleInfo.instance.attackData[dataIdex][3][0]['opponentGetFxDelay'];
							if(BattleInfo.instance.attackData[dataIdex][2] == BattleInfo.instance.player1Id){
								fxTools(ownerArray,ownerTimeArray,player1Canvas,player1,128,'left',1);
								fxTools(opponentArray,opponentTimeArray,player2Canvas,player2,676,'right',1);
							}else{
								fxTools(ownerArray,ownerTimeArray,player2Canvas,player2,676,'right',1);
								
								fxTools(opponentArray,opponentTimeArray,player1Canvas,player1,128,'left',1);
							}
							break;
						case 6:
							ownerArray = BattleInfo.instance.attackData[dataIdex][3][0]['ownerLoseFx'];
							ownerTimeArray = BattleInfo.instance.attackData[dataIdex][3][0]['ownerLoseFxDelay'];
							opponentArray = BattleInfo.instance.attackData[dataIdex][3][0]['opponentLoseFx'];
							opponentTimeArray = BattleInfo.instance.attackData[dataIdex][3][0]['opponentLoseFxDelay'];
							if(BattleInfo.instance.attackData[dataIdex][2] == BattleInfo.instance.player1Id){
								fxTools(ownerArray,ownerTimeArray,player1Canvas,player1,128,'left',1);
								fxTools(opponentArray,opponentTimeArray,player2Canvas,player2,676,'right',1);
							}else{
								fxTools(ownerArray,ownerTimeArray,player2Canvas,player2,676,'right',1);
								fxTools(opponentArray,opponentTimeArray,player1Canvas,player1,128,'left',1);
							}
							break;
						case 7:
							if(BattleInfo.instance.mphpDelta != null){
								for(deltaIdx;deltaIdx<BattleInfo.instance.mphpDelta.length;deltaIdx++){
									if(battleIdx == BattleInfo.instance.mphpDelta[deltaIdx]['time']){
										if(BattleInfo.instance.mphpDelta[deltaIdx]['defenser'] == BattleInfo.instance.player1Id.toString()){
											var size3:int = fontSize(BattleInfo.instance.mphpDelta[deltaIdx]['opponentHpDelta'],BattleInfo.instance.player1MaxHP);
											if(BattleInfo.instance.mphpDelta[deltaIdx]['opponentHpDelta'] < 0){
												player1.showHurt('-'+BattleInfo.instance.mphpDelta[deltaIdx]['opponentHpDelta'].toString(),'hp',size3,'left');
											}else{
												player1.showHurt('+'+BattleInfo.instance.mphpDelta[deltaIdx]['opponentHpDelta'].toString(),'hp',size3,'left');
											}
											if(BattleInfo.instance.mphpDelta[deltaIdx]['opponentMpDelta'] < 0){
												player1.showHurt('-'+BattleInfo.instance.mphpDelta[deltaIdx]['opponentMpDelta'].toString(),'mp',1,'left');
											}else{
												player1.showHurt('+'+BattleInfo.instance.mphpDelta[deltaIdx]['opponentMpDelta'].toString(),'mp',1,'left');
											}
											
											var osize1:int = fontSize(BattleInfo.instance.mphpDelta[deltaIdx]['ownerHpDelta'],BattleInfo.instance.player2MaxHP);
											if(BattleInfo.instance.mphpDelta[deltaIdx]['ownerHpDelta'] < 0){
												player2.showHurt('-'+BattleInfo.instance.mphpDelta[deltaIdx]['ownerHpDelta'].toString(),'hp',osize1,'right');
											}else{
												player2.showHurt('+'+BattleInfo.instance.mphpDelta[deltaIdx]['ownerHpDelta'].toString(),'hp',osize1,'right');
											}
											if(BattleInfo.instance.mphpDelta[deltaIdx]['ownerMpDelta'] < 0){
												player2.showHurt('-'+BattleInfo.instance.mphpDelta[deltaIdx]['ownerMpDelta'].toString(),'mp',1,'right');
											}else{
												player2.showHurt('+'+BattleInfo.instance.mphpDelta[deltaIdx]['ownerMpDelta'].toString(),'mp',1,'right');
											}
														
										}else{
											var size4:int = fontSize(BattleInfo.instance.mphpDelta[deltaIdx]['opponentHpDelta'],BattleInfo.instance.player2MaxHP);
											if(BattleInfo.instance.mphpDelta[deltaIdx]['opponentHpDelta'] < 0){
												player2.showHurt('-'+BattleInfo.instance.mphpDelta[deltaIdx]['opponentHpDelta'].toString(),'hp',size4,'right');
											}else{
												player2.showHurt('+'+BattleInfo.instance.mphpDelta[deltaIdx]['opponentHpDelta'].toString(),'hp',size4,'right');
											}
											if(BattleInfo.instance.mphpDelta[deltaIdx]['opponentMpDelta'] < 0){
												player2.showHurt('-'+BattleInfo.instance.mphpDelta[deltaIdx]['opponentMpDelta'].toString(),'mp',1,'right');
											}else{
												player2.showHurt('+'+BattleInfo.instance.mphpDelta[deltaIdx]['opponentMpDelta'].toString(),'mp',1,'right');
											}
											
											var osize2:int = fontSize(BattleInfo.instance.mphpDelta[deltaIdx]['ownerHpDelta'],BattleInfo.instance.player1MaxHP);
											if(BattleInfo.instance.mphpDelta[deltaIdx]['ownerHpDelta'] < 0){
												player1.showHurt('-'+BattleInfo.instance.mphpDelta[deltaIdx]['ownerHpDelta'].toString(),'hp',osize2,'left');
											}else{
												player1.showHurt('+'+BattleInfo.instance.mphpDelta[deltaIdx]['ownerHpDelta'].toString(),'hp',osize2,'left');
											}
											if(BattleInfo.instance.mphpDelta[deltaIdx]['ownerMpDelta'] < 0){
												player1.showHurt('-'+BattleInfo.instance.mphpDelta[deltaIdx]['ownerMpDelta'].toString(),'mp',1,'left');
											}else{
												player1.showHurt('+'+BattleInfo.instance.mphpDelta[deltaIdx]['ownerMpDelta'].toString(),'mp',1,'left');
											}
										}
									}else{
										break;
									}
								}
							}
							ownerArray = BattleInfo.instance.attackData[dataIdex][3][0]['ownerRunFx'];
							ownerTimeArray = BattleInfo.instance.attackData[dataIdex][3][0]['ownerRunFxDelay'];
							opponentArray = BattleInfo.instance.attackData[dataIdex][3][0]['opponentRunFx'];
							opponentTimeArray = BattleInfo.instance.attackData[dataIdex][3][0]['opponentRunFxDelay'];
							if(BattleInfo.instance.attackData[dataIdex][2] == BattleInfo.instance.player1Id){
								fxTools(ownerArray,ownerTimeArray,player1Canvas,player1,128,'left',1);
								fxTools(opponentArray,opponentTimeArray,player2Canvas,player2,676,'right',1);
							}else{
								fxTools(ownerArray,ownerTimeArray,player2Canvas,player2,676,'right',1);
								fxTools(opponentArray,opponentTimeArray,player1Canvas,player1,128,'left',1);
							}
							break;
					}

				}
				else{
					if(battleIdx < BattleInfo.instance.attackData[dataIdex][0]){
						break;
					}
				}
			}
			player1Hp.percentWidth = BattleInfo.instance.player1HP/BattleInfo.instance.player1MaxHP*100 - 1;
			player1Mp.percentWidth = BattleInfo.instance.player1MP/BattleInfo.instance.player1MaxMP*100 - 1;
			player2Hp.percentWidth = BattleInfo.instance.player2HP/BattleInfo.instance.player2MaxHP*100 - 1;
			player2Mp.percentWidth = BattleInfo.instance.player2MP/BattleInfo.instance.player2MaxMP*100 - 1;
			BattleInfo.instance.battleTime = BattleInfo.instance.battleTime - initTime;
			initTime = 1;
			battleIdx += 1;
			

			if(BattleInfo.instance.battleTime != 0){
				if(dataIdex<=BattleInfo.instance.attackData.length-1){
					setTimeout(updateFightMonsterProcess,328); 
				}else{
					var i:int = BattleInfo.instance.attackData.length - 1;
					BattlePromptImpl.promptData = BattleInfo.instance.attackData[i];
					prompt= new BattlePromptComponent();	
					setTimeout(function():void{PopUpManager.addPopUp(prompt,Application.application.canvas1,true);
					PopUpManager.centerPopUp(prompt);	
					prompt.closeAllBattle.addEventListener(MouseEvent.CLICK,onCloseAllBattle);},2000);
				}
			}else{
				var i:int = BattleInfo.instance.attackData.length - 1;
				BattlePromptImpl.promptData = BattleInfo.instance.attackData[i];
				prompt= new BattlePromptComponent();	
				setTimeout(function():void{PopUpManager.addPopUp(prompt,Application.application.canvas1,true);
				PopUpManager.centerPopUp(prompt);	
				prompt.closeAllBattle.addEventListener(MouseEvent.CLICK,onCloseAllBattle);},2000);
			}
			
			
		}
		
		//隐藏战斗界面
		public function closeBattle():void{
			this.visible = false;
		}
		
		//移除战斗界面和结果界面
		public function onCloseAllBattle(event:MouseEvent):void{
			closeEffect();
			//closeEffect();
			collection.battleWindow = null;
			collection.isPopupBattle = true;
			RemoteService.instance.refresh(collection.playerId).addHandlers(collection.onRefresh);
			//RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(Application.application.loadPlayerResult);
			Application.application.frashMiniTask();
			PopUpManager.removePopUp(prompt);
			Application.application.removeChild(this);
			if(AutoTip._tip != null)
			AutoTip._tip.visible = true;
			//新手任务
			
		}
		
		
		
		//替换图片路径
		public function stringTool(value:String):String{
			return value.replace("32", "170");  
		}
		
		//判断伤害血量的大小
		public function fontSize(damage:int,maxHp:int):int{
			if(Math.abs(damage)/maxHp*100 < 1){
				return 1;
			}else{
				if(Math.abs(damage)/maxHp*100 > 30){
					return 3;
				}else{
					return 2;
				}
			}
		}
		
//		//定时触发
//		
//		public function setEffectStartTime(object:UIComponent,type:String,point:int,time:int,
//		                                    ui:Container,c:String,a:Number,time:int,flag:Boolean)
//		{
//		                                    	
//		}
		
		 //抖动
	    
	    public function shork(object:UIComponent,type:String,point:int,time:int=1800):void
	    {
	    
	       myMove = new Move();
    	   myMove.target = object;	       
	       myMove.duration = 50;
	       myMove.end();	
    	   if((time-50)>=50)
    	   {                  
    	   	if(type == 'y')
    	   	{ 
	        myMove.yBy = num*Math.sin(Math.PI/180*angle)+temp;		           
	        myMove.play();	        	                    
	        }else if(type == 'x')
	        {
	        myMove.xBy = num*Math.sin(Math.PI/180*angle)+temp;		           
	        myMove.play();
	        }
	        temp = num*Math.sin(Math.PI/180*angle)*(-1);	      
	        angle += 180;		    
	        setTimeout(function():void{shork(object,type,point,(time-100))},50);	        
	       }else
	       {
	       	if(type == 'y'){
	       	myMove.yTo = point;
	    	myMove.play();
	       }else
	       	{
	         myMove.xTo = point;
	    	 myMove.play();
	        }
	    	
	       }	       
	     }
	       
	    //移除抖动

	    public function removeShork(ui:UIComponent,varX:int,varY:int):void
	     {
	     	if(myMove != null){
	     		 myMove.target = ui;
		       	 myMove.end();
		       	 myMove.yTo = varY;
		       	 myMove.xTo = varX;
		       	 myMove.play();
	     	}
	       	
	     }
	    
	    //压案
	
		 public function changeColor(ui:Container,c:String,a:Number,type:String,typeStr:String,fxEvent:int,time:int=1800):void
		 {
		 	var tempArray:Array;
		 	if(typeStr == 'left'){
		 		tempArray = player1Color;
		 		if(fxEvent == 1){
		 			removeColor(ui,tempArray,'3');
		 		}else{
		 			removeColor(ui,tempArray);
		 		}
		 	}else{
		 		tempArray = player2Color;
		 		if(fxEvent == 1){
		 			removeColor(ui,tempArray,'3');
		 		}else{
		 			removeColor(ui,tempArray);
		 		}
		 	}
		 	var _canvas:Canvas = new Canvas();
		 	_canvas.width = ui.width;
		 	_canvas.height = ui.height;
		 	_canvas.x=0;
		 	_canvas.y=0;
		 	_canvas.setStyle("backgroundColor",c);
		 	_canvas.setStyle("backgroundAlpha",a);	
		 	ui.addChild(_canvas);
		 	var clearTime:uint = setTimeout(function():void{ui.removeChild(_canvas);_canvas = null;},time);
		 	if(time == 1800)
		 		tempArray.push({type:type,obj:_canvas,time:clearTime});
		 }

		 //移除压案
		 public function removeColor(ui:Container,array:Array,type:String = 'all'):void
		 {
		 	if(type =='all'){
		 		for(var i:int = 0;i<array.length;i++)
		 		{
		 			clearTimeout(array[0]['time']);
		 			ui.removeChild(array[0]['obj']);
		 		}	
		 		array.splice(0);
		 	}
		 	if(type == '3'){
		 		for(var k:int = 0;k<array.length;k++)
		 		{
		 			if(array[k]['type'] == '3'){
		 				clearTimeout(array[0]['time']);
		 				ui.removeChild(array[0]['obj']);
		 				array.splice(k,1);
		 				k -= 1;
		 			}
		 		}
		 	}
		 	if(type == '2'){
		 		for(var j:int = 0;j<array.length;j++)
		 		{
		 			if(array[j]['type'] == '2'){
		 				clearTimeout(array[0]['time']);
		 				ui.removeChild(array[0]['obj']);
		 				array.splice(j,1);
		 				j -= 1;
		 			}
		 		}
		 	}
		 }
		 
		 //对话泡工具
		 /**
		 * 0：id号
		 * 1：名字
		 * 2：在左边显示时的图片
		 * 3：在右边显示时的图片
		 * 4：显示时间(毫秒)
		 * 5：对话泡宽度
		 * 6：对话泡高度
		 * 7：X轴坐标
		 * 8：Y轴坐标
		 * 9：左侧文字X
		 * 10：左侧文字Y
		 * 11：右侧文字X
		 * 12：右侧文字Y
		 * 13：文字宽
		 * 14：文字高
		 * */
		 public function traversalTools(str:String,type:String):void{
		 	//读取对话泡文件  获得 X、Y ，图片的宽、高、图片的路径 、显示多久时间
		 	if(str !=''){
		 		var arry:Array =traversalCanvas.getChildren();
		 		var traversal:Array = str.split(';');
		 		traversal[1] = traversal[1].toString().replace('c=','color="');
		 		traversal[1] = traversal[1].toString().replace('f=','" size="');
		 		traversal[1] = traversal[1].toString().concat('"');
		 		var traversalNum:int = int(traversal[0].toString().substr(traversal[0].toString().indexOf("=")+1));
		 		var canvas:Canvas = new Canvas();
		 		var text:Text = new Text();
		 		var image:Image = new Image();
		 		var tempArray:Array;
		 		for(var idx:int = 0;idx<traversalArray.length;idx++){
					if(traversalArray[idx][0] == traversalNum){
						tempArray = traversalArray[idx];
					}
		 		}
		 		text.htmlText='<font '+traversal[1].toString()+'>'+traversal[2].toString()+'</font>';
		 		text.setStyle('textAlign','center');
		 		text.setStyle('fontWeight','bold');
		 		text.width = int(tempArray[13]);
		 		text.height = int(tempArray[14])
		 		image.width = int(tempArray[5]);
		 		image.height = int(tempArray[6]);
		 		canvas.setStyle('backgroundAlpha','0');
		 		canvas.y = int(tempArray[8]);
		 		if(type == "left"){
		 			text.y = int(tempArray[10])
		 			text.x = int(tempArray[9])
		 			image.source = tempArray[2];
		 			canvas.x = int(tempArray[7]);
//		 			for(var idx:int = 0;idx<arry.length;idx++){
//		 				if(arry[idx].x <490){
//		 					traversalCanvas.removeChildAt(idx);
//		 					break;
//		 				}
//		 			}
		 		}else{
		 			text.y = int(tempArray[12])
		 			text.x = int(tempArray[11])
		 			image.source = tempArray[3];
//		 			for(var idx:int = 0;idx<arry.length;idx++){
//		 				if(arry[idx].x >490){
//		 					traversalCanvas.removeChildAt(idx);
//		 					break;
//		 				}
//		 			}
		 			canvas.x = 490-int(tempArray[7])-int(tempArray[5])+490;
		 		}
		 		canvas.addChild(image);
		 		canvas.addChild(text);
		 		traversalCanvas.addChild(canvas);	
		 		setTimeout(function():void{traversalCanvas.removeChild(canvas);},int(tempArray[4]));
		 	}
		 }
		 
		 //队友生产
		 public function createTeammate(obj:Array,type:String):void{
		 	
		 }
		 
		 //改变组队
		 public function changeTeam(obj:Array):void{
		 	
		 }
		 
		 //特效工具
		 /**
		 * 0:ID号
		 * 1：特效名称
		 * 2：特效的动画图片   可以为-1
		 * 3："特效循环1:只播放一次2:循环到效果结束3.循环到有其他技能特效时立即中断"
		 * 4："1.左右震动2.上下震动3.晃动" 可以为-1
		 * 5："震动的循环类型1.时间2.循环到效果结束3.循环到有其他技能特效时立即中断"
		 * 6："震动持续的时间填写数值单位(毫秒)"
		 * 7："压暗的遮盖层的颜色设置-1为不压暗"
		 * 8："压暗的遮盖层的ALPHA值设置;-1为不压暗"
		 * 9："压暗的循环类型1.时间2.循环到效果结束3.循环到有其他技能特效时立即中断"
		 * 10："压暗持续的时间填写数值单位(毫秒)"
		 * 11："特效同时播放时,该数值高的优先显示,相同时,ID靠前的先显示(具体能显示几层需要确认)1-9(暂定,越高越在上层显示)"
		 **/
		 public function fxTools(array:Array,timeArray:Array,canvas:Canvas,playerMini:Object,point:int,type:String,fxEvent:int):void{
		 	tempArray = new Array();		 	
		 	for(var idx:int = 0;idx<array.length;idx++)
			{
				if(array[idx] != '-1')
				{
					for(var k:int=0;k<fxArray.length;k++)
					{
						if(fxArray[k][0] == array[idx]){
							var tempFxArray:Array = fxArray[k];
							tempFxArray[17] = timeArray[idx];
							tempArray.push(tempFxArray);
						}
					}
				}
			}
			for(var i:int = 0;i<tempArray.length;i++)
			{
				for(var j:int = i+1;j<tempArray.length;j++)
				{
					if(int(tempArray[j][11])>int(tempArray[i][11]))
					{
						var temp:Array = tempArray[j];
						tempArray[j] = tempArray[i];
						tempArray[i] = temp;
					}
				}
			}
		 	var arry:Array;
		 	if(tempArray.length>0){
		 		for(var n:int=0;n<tempArray.length;n++)
			 	{
			 		arry = new Array();
			 		arry = tempArray[n];
			 		setTimeout(function():void{fxPlay(canvas,playerMini,arry,point,type,fxEvent);},int(tempArray[n][17]));
			 	}
		 	}else{
		 		if(fxEvent == 2){
		 			playerMini.closeEffect('2');
		 			if(type == 'left'){
		 				removeColor(canvas,player1Color,'2');
		 			}else{
		 				removeColor(canvas,player2Color,'2');
		 			}
		 			
		 		}
		 	}
		 	
		 	
		 }
		 
		 public function fxPlay(canvas:Canvas,playerMini:Object,array:Array,x:int,type:String,fxEvent:int):void{
		 	if(array[2] != '-1'){
//		 		if(x < 490){
//		         	initial(array[3],array[2],fxEvent,array[15],array[16]);
//		        }else{
//		        	var rightX:int = 490-int(array[13])-int(array[15])+490;
//		         	initial(array[3],array[12],fxEvent,rightX,array[16]);
//		        }
		 		initial(array[3],array[2],fxEvent,array[15],array[16]);
		 	}		
		 	if(array[4] != '-1'){
		 		removeShork(canvas,x,143);
		 		var str:String = '';
		 		if(array[4] == '1'){
		 			str = 'x'
		 			if(array[5] == '1'){
		 				shork(canvas,str,x,int(array[6]));
			 		}else{
			 			shork(canvas,str,x);
			 		}
		 		}else if(array[4] == '2')
		 		{
		 			str = 'y';
		 			if(array[5] == '1'){
			 			shork(canvas,str,143,int(array[6]));
			 		}else{
			 			shork(canvas,str,143);
			 		}
		 		}
		 	}
		 	if(array[7] != '-1'){
		 		if(array[9] != '1'){
		 			changeColor(canvas,array[7],array[8],array[9],type,fxEvent);
		 		}else{
		 			changeColor(canvas,array[7],array[8],array[9],type,fxEvent,int(array[10]));
		 		}
		 	}
		 		
		 }
		 
		 //初始对战双方信息
		 public function init():void{
		 	
		 }
		 
		 //初始化特效动画并播放
		 public function initial(count:int,path:String,fxEvent:int,x:int,y:int):void
      {
      	if(fxEvent == 1){
      		closeEffect('3');
      	}else{
      		closeEffect();
      	}
         var effectSwf:SWFLoader = new SWFLoader();
         effectSwf.source = path;
         effectSwf.x = x;
		 effectSwf.y = y;
         effectScene.addChild(effectSwf);
         effectSwf.addEventListener(Event.COMPLETE,function():void
         {
           if(count == 1)
           {
              MovieClip(effectSwf.content).addEventListener("finish",function():void
              {
               MovieClip(effectSwf.content).stop();
               effectScene.removeChild(effectSwf);
              });
           }else
           {
           	swfArray.push({type:count,obj:effectSwf});
            MovieClip(effectSwf.content).play();
           }
         });
        
      }		
      
      //关闭所有动画特效
      
      public function closeEffect(type:String ='all'):void
      {
      	if(type == 'all'){
      		effectScene.removeAllChildren();
      		swfArray.splice(0);
      	}
      	if(type == '3'){
      		for(var i:int = 0;i<swfArray.length;i++)
	 		{
	 			if(swfArray[i]['type'] == 3){
	 				effectScene.removeChild(swfArray[0]['obj']);
	 				swfArray.splice(i,1);
	 				i -= 1;
	 			}
	 		}
      	}
      	if(type == '2'){
      		for(var j:int = 0;j<swfArray.length;j++)
	 		{
	 			if(swfArray[j]['type'] == 2){
	 				effectScene.removeChild(swfArray[0]['obj']);
	 				swfArray.splice(j,1);
	 				j -= 1;
	 			}
	 		}
      	}
      	//effectScene.removeAllChildren();
      }
	}
}
