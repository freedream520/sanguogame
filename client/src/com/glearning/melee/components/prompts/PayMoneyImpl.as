package com.glearning.melee.components.prompts
{
	import com.glearning.melee.model.MySelf;
	
	import mx.containers.Canvas;

	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.controls.RadioButton;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	public class PayMoneyImpl extends Canvas
	{
		public var goldLabel:Label;
		public var couponLabel:Label;
		public var gold:RadioButton;
		public var coupon:RadioButton;
		public var prompt:Label;
		public var amount:String = '';
		public var description:String = '';
		public var payMoneyOK:LinkButton;
			
		public function PayMoneyImpl()
		{
			super();
			this.addEventListener(FlexEvent.INITIALIZE,init);
		}
		
		public function init(event:FlexEvent):void{
			prompt.htmlText = '您确定要支付<font color="#ff0000">'+amount+'</font>黄金/礼券来'+ description;
			goldLabel.htmlText = '使用黄金支付(当前余额：<font color="#ff0000">'+MySelf.instance.gold.toString()+'</font>)';
			couponLabel.htmlText = '使用礼券支付(当前余额：<font color="#ff0000">'+MySelf.instance.coupon.toString()+'</font>)';
		}
		
		//关闭
		public function closePayMoney():void{
			PopUpManager.removePopUp(this);
		}

	}
}