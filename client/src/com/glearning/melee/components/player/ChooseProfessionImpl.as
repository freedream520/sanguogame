package com.glearning.melee.components.player
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.CustomerButtonComponent;
	import com.glearning.melee.components.GameLoadingComponent;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.SWFLoader;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class ChooseProfessionImpl extends Canvas
	{
		public var c1:SWFLoader;
		public var c2:SWFLoader;
		public var c3:SWFLoader;
		public var c4:SWFLoader;
		public var c5:SWFLoader;
		public var c6:SWFLoader;
	
	    public var c1_complete:int = 0;
	    public var c2_complete:int = 0;
	    public var c3_complete:int = 0;
	    public var c4_complete:int = 0;
	    public var c5_complete:int = 0;
	    public var c6_complete:int = 0;
		
		public var ce1:SWFLoader;
		public var ce2:SWFLoader;
		public var ce3:SWFLoader;
		public var ce4:SWFLoader;
		public var ce5:SWFLoader;
		public var ce6:SWFLoader;
	
	    public var ce1_complete:int = 0;
	    public var ce2_complete:int = 0;
	    public var ce3_complete:int = 0;
	    public var ce4_complete:int = 0;
	    public var ce5_complete:int = 0;
	    public var ce6_complete:int = 0;
	    
		public var speed:Canvas;
		public var attack:Canvas;
		public var control:Canvas;
		public var physical:Canvas;
		public var dodge:Canvas;
		public var guard:Canvas;
		
		public var p1:CustomerButtonComponent;
		public var p2:CustomerButtonComponent;
		public var p3:CustomerButtonComponent;
		public var p4:CustomerButtonComponent;
		public var p5:CustomerButtonComponent;
		public var p6:CustomerButtonComponent;
		public var professionTitle:Image;
		public var professionDescription:Text;
		
		public var profession:int =0;
		public var weaponType:int =0;
		public var gameLoading:GameLoadingComponent = new GameLoadingComponent();
		
		public function ChooseProfessionImpl()
		{
			super();
		}
	
	    public function initial():void
	    {
	    	PopUpManager.addPopUp(gameLoading,Application.application.canvas1,true);
            PopUpManager.centerPopUp(gameLoading);
	    }
		
		public function init():void
		{
			if(MySelf.instance.gender == 1)
			{
				c1.source = 'images/sanGuo/profession/PC_1_M_L.swf';
				c2.source = 'images/sanGuo/profession/PC_2_M_L.swf';
				c3.source = 'images/sanGuo/profession/PC_3_M_L.swf';
				c4.source = 'images/sanGuo/profession/PC_4_M_L.swf';
				c5.source = 'images/sanGuo/profession/PC_5_M_L.swf';
				c6.source = 'images/sanGuo/profession/PC_6_M_L.swf';
			}else
			{
				c1.source = 'images/sanGuo/profession/PC_1_F_L.swf';
				c2.source = 'images/sanGuo/profession/PC_2_F_L.swf';
				c3.source = 'images/sanGuo/profession/PC_3_F_L.swf';
				c4.source = 'images/sanGuo/profession/PC_4_F_L.swf';
				c5.source = 'images/sanGuo/profession/PC_5_F_L.swf';
				c6.source = 'images/sanGuo/profession/PC_6_F_L.swf';
			}
			c1.addEventListener(MouseEvent.CLICK,selectedProfession);
			c2.addEventListener(MouseEvent.CLICK,selectedProfession);
			c3.addEventListener(MouseEvent.CLICK,selectedProfession);
			c4.addEventListener(MouseEvent.CLICK,selectedProfession);
			c5.addEventListener(MouseEvent.CLICK,selectedProfession);
			c6.addEventListener(MouseEvent.CLICK,selectedProfession);
			
			
			p1.glowImage.color = 0xB4F3F1;
			p1.unglowImage.color = 0xB4F3F1;
			p2.glowImage.color = 0xB4F3F1;
			p2.unglowImage.color = 0xB4F3F1;
			p3.glowImage.color = 0xB4F3F1;
			p3.unglowImage.color = 0xB4F3F1;
			p4.glowImage.color = 0xB4F3F1;
			p4.unglowImage.color = 0xB4F3F1;
			p5.glowImage.color = 0xB4F3F1;
			p5.unglowImage.color = 0xB4F3F1;
			p6.glowImage.color = 0xB4F3F1;
			p6.unglowImage.color = 0xB4F3F1;		
			
			
		}
		
		
		public function playSwf(swf:SWFLoader):void
		{
			MovieClip(swf.content).play();
		}
		
		public function stopSwf(swf:SWFLoader):void
		{
			MovieClip(swf.content).gotoAndStop(1);
		}
		
		public function selectedProfession(event:MouseEvent):void
		{
			if(event.currentTarget.id == 'c1')
			{
				profession = 6;
				weaponType = 1;
				playSwf(ce1);
				playSwf(c1);
				p1.startEffect();
				p2.endEffect();
				p3.endEffect();
				p4.endEffect();
				p5.endEffect();
				p6.endEffect();
				stopSwf(ce2);
				stopSwf(ce3);
				stopSwf(ce4);
				stopSwf(ce5);
				stopSwf(ce6);
				stopSwf(c2);
				stopSwf(c3);
				stopSwf(c4);
				stopSwf(c5);
				stopSwf(c6);
				speed.percentWidth = 20;
				attack.percentWidth = 85;
				control.percentWidth = 30;
				physical.percentWidth = 70;
				dodge.percentWidth = 50;
				guard.percentWidth = 15;
				professionTitle.source = 'images/sanGuo/profession/c1.png';
				professionDescription.width = 205;
				professionDescription.htmlText = '简介：\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;健硕的身体与无畏的气魄,使用强有力的重型装备,以武勇为主的职业,仿佛一击就能将敌人粉碎!在战场上绝对是任何敌人的噩梦!\n';
				professionDescription.htmlText += '特点：\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;将高攻的重型武器发挥到极致,重视攻击,同时会为自己带来一些防御方面的负面影响.'
			}else if(event.currentTarget.id == 'c2')
			{
				profession = 5;
				weaponType = 1;
				playSwf(ce2);
				playSwf(c2);
				p1.endEffect();
				p2.startEffect();
				p3.endEffect();
				p4.endEffect();
				p5.endEffect();
				p6.endEffect();
				stopSwf(ce1);
				stopSwf(ce3);
				stopSwf(ce4);
				stopSwf(ce5);
				stopSwf(ce6);
				stopSwf(c1);
				stopSwf(c3);
				stopSwf(c4);
				stopSwf(c5);
				stopSwf(c6);
				speed.percentWidth = 18;
				attack.percentWidth = 55;
				control.percentWidth = 60;
				physical.percentWidth = 90;
				dodge.percentWidth = 90;
				guard.percentWidth = 30;
				professionTitle.source = 'images/sanGuo/profession/c2.png';
				professionDescription.width = 205;
				professionDescription.htmlText = '简介：\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;全身以重型装备武装,内心武勇,深谙保护自己才能享受最后的关键,在战斗中等待着敌人的致命空隙使出终结战斗的强力反击!\n';
				professionDescription.htmlText += '特点：\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;将高防的重型防具发挥到极致,重视防御,可以抵御很多攻击,并且对这些攻击采取反击.'
			}else if(event.currentTarget.id == 'c3')
			{
				profession = 1;
				weaponType = 51;
				playSwf(ce3);
				playSwf(c3);
				p1.endEffect();
				p2.endEffect();
				p3.startEffect();
				p4.endEffect();
				p5.endEffect();
				p6.endEffect();
				stopSwf(ce1);
				stopSwf(ce2);
				stopSwf(ce4);
				stopSwf(ce5);
				stopSwf(ce6);			
				stopSwf(c1);
				stopSwf(c2);
				stopSwf(c4);
				stopSwf(c5);
				stopSwf(c6);
				speed.percentWidth = 50;
				attack.percentWidth = 80;
				control.percentWidth = 20;
				physical.percentWidth = 50;
				dodge.percentWidth = 28;
				guard.percentWidth = 45;
				professionTitle.source = 'images/sanGuo/profession/c3.png';
				professionDescription.width = 205;
				professionDescription.htmlText = '简介：\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;进能攻,退能守,从来不会盲目地攻击,对敌人展开沉稳的打击和防御.兼备武勇与机警,身着中型装备,是个攻防兼备的职业.\n';
				professionDescription.htmlText += '特点：\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;各项能力平均,但偏向攻击性,虽然中型武器的攻击力一般,但配合技能,可以使出很不错的持续攻击输出.'
			}else if(event.currentTarget.id == 'c4')
			{			
				profession = 2;	
				weaponType = 51;
				playSwf(ce4);
				playSwf(c4);
				p1.endEffect();
				p2.endEffect();
				p3.endEffect();
				p4.startEffect();
				p5.endEffect();
				p6.endEffect();
				stopSwf(ce1);
				stopSwf(ce3);
				stopSwf(ce2);
				stopSwf(ce5);
				stopSwf(ce6);
				stopSwf(c1);
				stopSwf(c2);
				stopSwf(c3);
				stopSwf(c5);
				stopSwf(c6);
				speed.percentWidth = 35;
				attack.percentWidth = 73;
				control.percentWidth = 46;
				physical.percentWidth = 55;
				dodge.percentWidth = 35;
				guard.percentWidth = 40;
				professionTitle.source = 'images/sanGuo/profession/c4.png';
				professionDescription.width = 205;
				professionDescription.htmlText = '简介：\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;穿着中型装备,精通武艺,而在游历途中又见识各种辅助之术,通过这些技能,他们会更好地穿梭与战斗之中.讲究武勇与机警的均衡运用.\n'
				professionDescription.htmlText += '特点：\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;各项能力平均,但偏向防御性,虽然中型防具的防御力一般,但配合技能,可以使出很多防御技巧.'
			}else if(event.currentTarget.id == 'c5')
			{
				profession = 3;
				weaponType = 101;
				playSwf(ce5);
				playSwf(c5);
				p1.endEffect();
				p2.endEffect();
				p3.endEffect();
				p4.endEffect();
				p5.startEffect();
				p6.endEffect();
				stopSwf(ce1);
				stopSwf(ce3);
				stopSwf(ce4);
				stopSwf(ce2);
				stopSwf(ce6);
				stopSwf(c1);
				stopSwf(c2);
				stopSwf(c3);
				stopSwf(c4);
				stopSwf(c6);
				speed.percentWidth = 55;
				attack.percentWidth = 88;
				control.percentWidth = 23;
				physical.percentWidth = 55;
				dodge.percentWidth = 30;
				guard.percentWidth = 48;
				professionTitle.source = 'images/sanGuo/profession/c5.png';
				professionDescription.width = 205;
				professionDescription.htmlText = '简介：\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;依靠各种计谋可以在瞬间对敌人产生大量的伤害!虽然机警过人,但是只能穿着轻型装备的他们在防御方面却是非常地薄弱.\n'
			    professionDescription.htmlText += '特点：\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;技能的攻击输出非常高,只要命中,威力惊人,但本身只能装备轻型装备,自身生存能力低下.'
			}else if(event.currentTarget.id == 'c6')
			{
				profession = 4;
				weaponType = 101;
				playSwf(ce6);
				playSwf(c6);
				p1.endEffect();
				p2.endEffect();
				p3.endEffect();
				p4.endEffect();
				p5.endEffect();
				p6.startEffect();
				stopSwf(ce1);
				stopSwf(ce3);
				stopSwf(ce4);
				stopSwf(ce5);
				stopSwf(ce2);
				stopSwf(c1);
				stopSwf(c2);
				stopSwf(c3);
				stopSwf(c4);
				stopSwf(c5);
				speed.percentWidth = 35;
				attack.percentWidth = 75;
				control.percentWidth = 58;
				physical.percentWidth = 64;
				dodge.percentWidth = 28;
				guard.percentWidth = 35;
				professionTitle.source = 'images/sanGuo/profession/c6.png';
				professionDescription.width = 205;
				professionDescription.htmlText = '简介：\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;修习了各种神秘的异术，在战斗中会产生各种奇妙的效果，牵制敌人,从而克敌制胜。他们穿着轻型装备,依靠机警的心穿行于战斗.\n'
			    professionDescription.htmlText += '特点：\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;通过控制技能削弱敌人实力,使敌人的攻击,防御,命中等能力降低,从而慢慢打击敌人.但本身攻击力与防御力低下是致命缺点.'
			}
		}
		
		public function handlerSelectProfession(event:MouseEvent):void
		{
			if(profession ==0 || weaponType == 0 )
			{
				var chooseWrong:NormalTipComponent = new NormalTipComponent();
				PopUpManager.addPopUp(chooseWrong,Application.application.canvas1,true);
				PopUpManager.centerPopUp(chooseWrong);
				chooseWrong.hideButton();
				chooseWrong.tipText.text = '您还没有选择一个职业';
				chooseWrong.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(chooseWrong);});
			}else
			{
				RemoteService.instance.handlerProfession(profession,collection.playerId).addHandlers(onHandlerProfession);
			}
			
		}
		
		public function onHandlerProfession(event:ResultEvent,token:AsyncToken):void
		{
			var normal:NormalTipComponent = new NormalTipComponent();
			PopUpManager.addPopUp(normal,this,true);
			PopUpManager.centerPopUp(normal);
			normal.tipText.text = event.result.reason;
			normal.hideButton();
			if(event.result.result == true)
			{		
				Application.application.removeChild(this);
				normal.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normal);});
				RemoteService.instance.NewPlayerQuestInfo(collection.playerId).addHandlers(onNewPlayerQuestInfo);
				
			}else
			{
				normal.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normal);});
			}
		}
		
		public function onNewPlayerQuestInfo(event:ResultEvent,token:AsyncToken):void
		{
			RemoteService.instance.addReward(collection.playerId,event.result['data'][0][3],event.result['data'][0][5],event.result['data'][0][4]).addHandlers(onAddReward)
		}
		
		public function onAddReward(event:ResultEvent,token:AsyncToken):void
		{
			
			RemoteService.instance.changeQuestProgress(collection.playerId,MySelf.instance.progress+1).addHandlers(onChangeQuestProgress);
			MySelf.instance.progress = MySelf.instance.progress+1;
			RemoteService.instance.sendNewPlayerWeapon(collection.playerId,weaponType,'0,0').addHandlers(onSendNewPlayerWeapon);
		}
		
		public function onChangeQuestProgress(event:ResultEvent,token:AsyncToken):void
		{

		}
		
		public function onSendNewPlayerWeapon(event:ResultEvent,token:AsyncToken):void
		{
			Application.application.newPlayerQuestProgress(event.result.progress);
			RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(collection.onLoadPlayerResult);
			Application.application.frashMiniTask();
		}
		
		public function loadingProgress():void
		{
			if(c1_complete == 1 && c2_complete == 1 && c3_complete == 1 &&
			   c4_complete == 1 && c5_complete == 1 && c6_complete == 1 &&
			   ce1_complete == 1 && ce2_complete == 1 && ce3_complete == 1 &&
			   ce4_complete == 1 && ce5_complete == 1 && ce6_complete == 1 
			   )
			   {
			   	PopUpManager.removePopUp(gameLoading);
			   }
		}
	
	}
}