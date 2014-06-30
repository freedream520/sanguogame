package com.glearning.melee.components.skill
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.prompts.NormalTipComponent;
	import com.glearning.melee.net.RemoteService;
	import mx.core.Application;
	import mx.containers.Canvas;
	import mx.controls.ComboBox;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import flash.events.MouseEvent;

	public class SkillSettingsImpl extends Canvas
	{
		//主动技能
		[Bindable]
		public var activeSkillData:Array = new Array();
		
		public var warrior:ComboBox;
		public var guardian:ComboBox;
		public var samurai:ComboBox;
		public var toShi:ComboBox;
		public var advisers:ComboBox;
		public var warlock:ComboBox;
		
		public var isNewSettings:Boolean = false;
		
		public function SkillSettingsImpl()
		{
			super();
		}
		
		//初始
		public function init():void{
			RemoteService.instance.getSkillSettings(collection.playerId).addHandlers(onResult);
		}
		
		//关闭
		public function close():void{
			PopUpManager.removePopUp(this);
		}
		
		//确定
		public function ok():void{
			var warriorId:int =warrior.selectedItem.data;
			var samuraiId:int =samurai.selectedItem.data;
			var advisersId:int =advisers.selectedItem.data;
			var guardianId:int =guardian.selectedItem.data;
			var toShiId:int =toShi.selectedItem.data;
			var warlockId:int =warlock.selectedItem.data;
			RemoteService.instance.updataSkillSettings(collection.playerId,isNewSettings,warriorId,guardianId,samuraiId,toShiId,advisersId,warlockId).addHandlers(onUpdataSkillSettings);
		}
		
		//确定回调
		private function onUpdataSkillSettings(event:ResultEvent,token:AsyncToken):void{
			if(event.result == true){
				close();
				tip('保存设置已成功！');
			}else{
				tip('保存设置失败，请重试！');
			}
		}
		
		//回调
		private function onResult(event:ResultEvent,token:AsyncToken):void{
			if(event.result['result'] == true){
				warrior.selectedIndex = settingsTool(event.result['data'][0][2]);
				guardian.selectedIndex = settingsTool(event.result['data'][0][3]);
				samurai.selectedIndex = settingsTool(event.result['data'][0][4]);
				toShi.selectedIndex = settingsTool(event.result['data'][0][5]);
				advisers.selectedIndex = settingsTool(event.result['data'][0][6]);
				warlock.selectedIndex = settingsTool(event.result['data'][0][7]);
			}else{
				isNewSettings = true;
			}
		}
		
		//匹配设置表中的位置
		public function settingsTool(id:int):int{
			for(var idx:int=0;idx<activeSkillData.length;idx++){
				if(activeSkillData[idx].data == id){
					return idx;
				}
			}
			return 0;
		}
		
		//提醒
		public function tip(str:String):void{
			var tip:NormalTipComponent = new NormalTipComponent();
			PopUpManager.addPopUp(tip,Application.application.canvas1,true);
	        PopUpManager.centerPopUp(tip);
	        tip.hideButton();
	        tip.tipText.text = str;
	        tip.accept.addEventListener(MouseEvent.CLICK,function():void{PopUpManager.removePopUp(tip);});
		}
		
	}
}