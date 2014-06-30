package com.glearning.melee.components.player
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class ChooseCountryImpl extends Canvas
	{
		public var wei:MyEffectButtonComponent;
		public var shu:MyEffectButtonComponent;
		public var wu:MyEffectButtonComponent;
		public var textName:Image;
		public var countryDescription:Text;
		public var camp:int = 0;
		public var weiImg:campEffectComponent;
		public var shuImg:campEffectComponent;
		public var wuImg:campEffectComponent;
		public var img1:Image;
		public var img2:Image;
		public var img3:Image;
		public function ChooseCountryImpl()
		{
			super();
		}
		
		
		
		public function init():void
		{
			wei.image.source = 'images/sanGuo/Camp/weiCamp2.png';
			shu.image.source = 'images/sanGuo/Camp/shuCamp2.png';
			wu.image.source = 'images/sanGuo/Camp/wuCamp2.png';
			
			wei.campName.styleName = 'weiCamp';
			shu.campName.styleName = 'shuCamp';
			wu.campName.styleName = 'wuCamp';
			
			weiImg.campName.styleName = 'weiCampTitle';
			shuImg.campName.styleName = 'shuCampTitle';
			wuImg.campName.styleName = 'wuCampTitle';
		}
		
		public function showText(event:MouseEvent):void
		{
			if(event.currentTarget.id == 'wei' || event.currentTarget.id == 'weiImg')
			{
				weiImg.glowImage.color = 0xFE2E9A;
				weiImg.unglowImage.color = 0xFE2E9A;
				shuImg.endEffect();
				wuImg.endEffect();
				weiImg.startEffect();
				textName.source = 'images/sanGuo/Camp/weiGuo.png';
				countryDescription.width = 200;
				countryDescription.htmlText = '';
				countryDescription.htmlText += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;魏以是豫州为中心建立的政权。有着广阔的土地和众多人口，实力雄厚，魏武的强盛，为天下所共知。\n';
				countryDescription.htmlText += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;君主曹操不仅是出色的军事家和政治家，还是一位著名的诗人，文武双全。他雄心勃勃的建立了强大的曹魏，以此为称霸天下的基础。\n';
				countryDescription.htmlText += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;该国拥有夏侯敦，曹仁，许楮等英勇善战的猛将。郭嘉，程昱，贾诩等智谋过人的谋士，曹操率领着他们，向着他的霸道迈进。\n';
				camp = 1;
				img1.source = 'images/sanGuo/Camp/caocao.jpg';
				img2.source = 'images/sanGuo/Camp/guojia.jpg';
				img3.source = 'images/sanGuo/Camp/xiahoudun.jpg';
			}
			else if(event.currentTarget.id == 'shu' || event.currentTarget.id == 'shuImg')
			{
				shuImg.glowImage.color = 0xF7FE2E;
				shuImg.unglowImage.color = 0xF7FE2E;
				weiImg.endEffect();
				wuImg.endEffect();
				shuImg.startEffect();
				textName.source = 'images/sanGuo/Camp/shuGuo.png';
				countryDescription.width = 200;
				countryDescription.htmlText = '';
				countryDescription.htmlText += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;建立于益州的蜀，是三国中唯一的汉室政权。益州险塞，沃野千里，国富民殷，天府之国。\n';
				countryDescription.htmlText += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;君主刘备，乃是景帝之后，汉室宗亲。他虽然出身贫瘠，却有着匡扶汉室，结束乱世的理想。许多良臣猛将被他所吸引，来着到他的身边。\n';
				countryDescription.htmlText += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;该国有着无夫莫敌的猛将张飞，忠肝义胆的武将关羽，一身是胆的勇将赵云，人称卧龙的智将诸葛亮等良臣猛将，跟随着刘备，希望实现他们复兴汉室的理想。\n';
				
				camp = 2;
				img1.source = 'images/sanGuo/Camp/liubei.jpg';
				img2.source = 'images/sanGuo/Camp/guanyu.jpg';
				img3.source = 'images/sanGuo/Camp/zhangfei.jpg';
			}
			else if(event.currentTarget.id == 'wu' || event.currentTarget.id == 'wuImg')
			{
				wuImg.glowImage.color = 0x0080FF;
				wuImg.unglowImage.color = 0x0080FF;
				weiImg.endEffect();
				shuImg.endEffect();
				wuImg.startEffect();
				textName.source = 'images/sanGuo/Camp/wuGuo.png';
				countryDescription.width = 200;
				countryDescription.htmlText = '';
				countryDescription.htmlText += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;孙氏家族以东吴地方为中心建立了吴。江东水乡土地肥沃，兼有两江之险，英杰辈出，成就了吴的基业。\n';
				countryDescription.htmlText += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;君主孙权虽然年少，却是一位英明的君主。他礼贤下士，广招贤才。他怀着开创吴的未来，统一天下的理想，拿起了武器。\n';
				countryDescription.htmlText += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;该国历代都督，周瑜，鲁肃，吕蒙，陆逊。无一不是出色的名将。更有甘宁，周泰，太史慈等忠心耿耿的勇将，团结在孙权周围，为结束乱世而努力。\n';
				camp = 3;
			    img1.source = 'images/sanGuo/Camp/sunquan.jpg';
				img2.source = 'images/sanGuo/Camp/zhouyu.jpg';
				img3.source = 'images/sanGuo/Camp/ganning.jpg';
			}
		}
		
		public function accpetEnterCamp(event:MouseEvent):void
		{
			if(camp == 0)
			{
				collection.errorEvent('请选择国家',null);
			}else
			{	
			   RemoteService.instance.acceptEnterCamp(int(camp+'01'),int(camp+'01'),camp,collection.playerId).addHandlers(onAcceptEnterCamp);
			}
		}
		
		public function onAcceptEnterCamp(event:ResultEvent,token:AsyncToken):void
		{
			var normal:NormalTipComponent = new NormalTipComponent();
			PopUpManager.addPopUp(normal,this,true);
			PopUpManager.centerPopUp(normal);
			normal.tipText.text = event.result.reason;
			normal.hideButton();
			if(event.result.result == true)
			{				
			    MySelf.instance.isNewPlayer = 0;
			    RemoteService.instance.changeNewPlayerState(collection.playerId).addHandlers(onChangeNewPlayerState);
			    RemoteService.instance.getPlayerInfo(collection.playerId).addHandlers(collection.onLoadPlayerResult);				
				PopUpManager.removePopUp(this);
				normal.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normal);});
				MySelf.instance.location = event.result['data'].location;
				MySelf.instance.town = event.result['data'].town;	
							
				RemoteService.instance.enterPlace(collection.playerId,event.result['data'].location).addHandlers( collection.setEnterPlace );
				Application.application.frashMiniTask();
			}else
			{
				normal.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normal);});				
			}
			
		}
		
		public function onChangeNewPlayerState(event:ResultEvent,token:AsyncToken):void
		{
		
		}
		
	
		
		
		
	
		
	}
}