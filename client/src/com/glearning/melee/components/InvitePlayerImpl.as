package com.glearning.melee.components
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.net.RemoteService;
	import com.glearning.melee.model.PlaceInfo;
	import com.glearning.melee.model.MySelf;
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.Image;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class InvitePlayerImpl extends HBox
	{
		public var invite:Image;
		
		public function InvitePlayerImpl()
		{
			super();
		}
		
		override public function set data(value:Object):void {
			super.data = value;			
			invite.source = 'images/sanGuo/team/inviteTeam.gif';
			
		}
		
		public function invitePlayer():void
		{

            var inviteTip:NormalTipComponent = new NormalTipComponent();
            PopUpManager.addPopUp(inviteTip,Application.application.canvas1,true);
            PopUpManager.centerPopUp(inviteTip);
            inviteTip.tipText.htmlText = '您确定要邀请<font color="#ff0000">'+data.nickname+'</font>加入您的队伍吗？'
            inviteTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(inviteTip);RemoteService.instance.launchAddTeamMember(collection.playerId,data.id,1,MySelf.instance.location).addHandlers(onAddTeamMember);});   
            
		}
		
		public function onAddTeamMember(event:ResultEvent,token:AsyncToken):void
		{
			var normalTip:NormalTipComponent = new NormalTipComponent();
			if(event.result.result == true)
			{
				PopUpManager.addPopUp(normalTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(normalTip);
				normalTip.tipText.htmlText = '组队邀请发送成功，请等待<font color="#ff0000">'+data.nickname+'</font>回应';
				normalTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normalTip);});
				normalTip.hideButton();
			}
			else
			{
				PopUpManager.addPopUp(normalTip,Application.application.canvas1,true);
				PopUpManager.centerPopUp(normalTip);
				normalTip.tipText.htmlText = event.result.reason;
				normalTip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(normalTip);});
				normalTip.hideButton();
			}
		}
		
	}
}