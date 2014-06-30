package com.glearning.melee.components.login
{
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.controls.Text;
	import mx.controls.TextInput;
	import mx.events.ValidationResultEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.validators.EmailValidator;
	import mx.validators.StringValidator;
	public class RegisterImpl extends Canvas
	{
		public var registerBtn:LinkButton;
		public var pwd1:TextInput;
		public var pwd2:TextInput;
		public var email:TextInput;
		public var username:TextInput;
		public var tipInfo:Label;
		public var normal:NormalTipComponent = new NormalTipComponent();
		public var emailValidator:EmailValidator;
		public var pwd1Validator:StringValidator;
		public var pwd2Validator:StringValidator;
		public var userValidator:StringValidator;
		public var emailError:Text;
		public var Pwd1Error:Text;
		public var Pwd2Error:Text;
		public var UserError:Text;
		public var validuser:Boolean;
		public var validpwd1:Boolean;
		public var validpwd2:Boolean;
		public var validemail:Boolean;
		public function RegisterImpl()
		{
			super();
		}
		
		public function init():void
		{
			registerBtn.addEventListener(MouseEvent.CLICK,startRegister);
		}
		
		public function startRegister(event:MouseEvent):void
		{
			if(validuser == true && validpwd1 == true && validpwd2 == true && validemail== true){
				RemoteService.bol = false;
				RemoteService.instance.registerPlayerInfo(username.text,pwd1.text,email.text).addHandlers(onRegisterPlayer,false);
			}
		    else
		    {
		    	PopUpManager.addPopUp(normal,this,true);
		    	PopUpManager.centerPopUp(normal);
		    	normal.tipText.text = '注册信息有误，请检查后重新填入';
		    	normal.hideButton();
		    	normal.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normal);});
		    }
		}
		
		public function onRegisterPlayer(event:ResultEvent,token:AsyncToken):void
		{

			if(event.result.result == true)
			{

				tipInfo.text = event.result.reason;	
				PopUpManager.removePopUp(this);
		
			}else
			{
				tipInfo.text = event.result.reason;	
				   
			}
			
		}
		
		public function onClose(event:MouseEvent):void
		{
			PopUpManager.removePopUp(this);
		}		
	
		
		public function Pwd2Validator_invalid(event:ValidationResultEvent):void
		{
			if(pwd2.text != pwd1.text)
		     {		
		       Pwd2Error.text = '2次密码不一致';
		       pwd2.errorString = '2次密码不一致';
		       Pwd2Error.setStyle('color','#ff0000');     		      
		       validpwd2 = false;
		     }else if(event.type==ValidationResultEvent.VALID){
		       Pwd2Error.text = '密码设置正确';
		       Pwd2Error.setStyle('color','#01DF01');
		       validpwd2 = true;
		     }else
		     {
		       Pwd2Error.text = '密码长度不符合规范';
		       pwd2.errorString = '密码长度不符合规范';
		       Pwd2Error.setStyle('color','#ff0000');
		       validpwd2 = false;
		     }

		}
		
	    public function Pwd1Validator_invalid(event:ValidationResultEvent):void
	    {
	    	if(event.type==ValidationResultEvent.VALID)
		     {		     		      
		       Pwd1Error.text = '密码设置正确';
		       Pwd1Error.setStyle('color','#01DF01');
		       validpwd1 = true;
		     }else{
		       Pwd1Error.text = '密码长度不符合规范';
		       pwd1.errorString = '密码长度不符合规范';
		       Pwd1Error.setStyle('color','#ff0000');
		       validpwd1 = false;
		     }

	    }
	    
	    public function UserValidator_invalid(event:ValidationResultEvent):void
	    {
	    	if(event.type==ValidationResultEvent.VALID)
		     {		     		      
		       UserError.text = '用户名可用';
		       UserError.setStyle('color','#01DF01');
		       validuser = true;
		     }else{
		       UserError.text = '用户名长度不符合规范';
		       username.errorString = '用户名长度不符合规范';
		       UserError.setStyle('color','#ff0000');
		       validuser = false;
		     }
	    }
	    
	    public function validatorPwd1(event:Event):void
	    {
	    	pwd1Validator.validate(pwd1.text);
	    }
	    
	     public function validatorPwd2(event:Event):void
	    {
	    	pwd2Validator.validate(pwd2.text);
	    }
	    
	    public function validatorUser(event:Event):void
	    {	   
	    	RemoteService.bol = false; 	
	    	RemoteService.instance.isHaveSameUsername(username.text).addHandlers(onIsHaveSameUsername,false);
	    }
	    
	    public function onIsHaveSameUsername(event:ResultEvent,token:AsyncToken):void
	    {
	    	if(event.result.result == true)
	    	{
	    		userValidator.validate(username.text);
	    	}else
	    	{
	    		UserError.text = '该用户名已存在';
	    		UserError.setStyle('color','#ff0000');
	    	}
	    }
		
		public function emailValidator_invalid(event:ValidationResultEvent):void
		{
			if(event.type==ValidationResultEvent.VALID)
			{
			  emailError.text = '电子邮箱格式正确';
			  emailError.setStyle('color','#01DF01');
			  validemail = true;
			}else
			{
			  email.errorString = '请输入正确的电子邮箱地址';
			  emailError.text = '请输入正确的电子邮箱地址';
			  emailError.setStyle('color','#ff0000');
			  validemail = false;
			}
			 
		}
		
		public function validatorEmail(event:Event):void
		{
			emailValidator.validate(email.text);
		}
		
	}
}