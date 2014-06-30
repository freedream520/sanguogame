package com.glearning.melee.components.team
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.Image;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class kickTeamMemberImpl extends HBox
	{
		public var kickMember:Image;
		
		public function kickTeamMemberImpl()
		{
			super();
		}
		
		override public function set data(value:Object):void {
			super.data = value;
			if(kickMember == null)
			kickMember = new Image();
			kickMember.source = 'images/sanGuo/team/Tperson.gif';
		}
		
		public function kickFunction(event:MouseEvent):void
		{
			RemoteService.instance.removeTeamMember(collection.playerId,data.id).addHandlers(onRemoteTeamMember);
		}
		
		public function onRemoteTeamMember(event:ResultEvent,token:AsyncToken):void
		{
			
		}
	}
}