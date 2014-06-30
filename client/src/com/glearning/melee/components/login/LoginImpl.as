package com.glearning.melee.components.login
{
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.components.utils.PopUpEffect;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	public class LoginImpl extends Canvas
	{
		public var userName:TextInput;
		public var password:TextInput;
		public var loginSubmit:Button;
		public var obj:Object;
		public var httpService:HTTPService;
		private var advance:XML;
        public var gameInfo:DataGrid;
        public var register:LinkButton;
        public var version:Label;
		public function LoginImpl()
		{
			super();
		}
		
		public function initLoginComponent():void{
			httpService = new HTTPService();
			httpService.url = 'data/advance.xml';            
			httpService.resultFormat = 'xml'; 		
			httpService.addEventListener(ResultEvent.RESULT,resultHandler);
			httpService.send();
			Application.application.focusManager.setFocus(userName);
			userName.setSelection(0,0);
			loginSubmit.addEventListener(MouseEvent.CLICK,buttonSubmit);
			addEventListener(KeyboardEvent.KEY_DOWN,keyboardSubmit);
			register.addEventListener(MouseEvent.CLICK,openRegister);
			RemoteService.instance.getVersion().addHandlers(onGetVersion);
		}
		
		public function onGetVersion(event:ResultEvent,token:AsyncToken):void
		{
			version.text = event.result['data'];
		}
		
		public function openRegister(event:MouseEvent):void
		{
			var registerPanel:RegisterComponent = new RegisterComponent();
			PopUpManager.addPopUp(registerPanel,this,true);
			PopUpManager.centerPopUp(registerPanel);
		}
		
		public function resultHandler(event:ResultEvent):void
		{
			advance = XML(event.result);
			gameInfo.dataProvider = advance.children();
		}
		
		public function buttonSubmit(event:MouseEvent):void{
			submit();
		}
		
		public function keyboardSubmit(event:KeyboardEvent):void{
			if (event.keyCode==Keyboard.ENTER){
				submit();
			}
		}
		
		public function submit():void{
			if( userName.text=='' || password.text==''){
				var tip:NormalTipComponent = new NormalTipComponent();
				PopUpEffect.Show(tip,this,true);
		        tip.hideButton();
		        tip.tipText.text = '用户或密码为空';
		        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpEffect.Hide(tip);});
				return;
			} else{
				//新手登陆
				RemoteService.bol = false;
				RemoteService.instance.loginToServer(userName.text,password.text).addHandlers(Application.application.onLogin,false);
			}
		}
		
		public function destroy():void{
			removeAllChildren();
			this.parent.removeChild(this);
		}
	}
}