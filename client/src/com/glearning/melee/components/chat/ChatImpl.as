package com.glearning.melee.components.chat
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.utils.TextFormatUtil;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.LinkButton;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.effects.Parallel;
	import mx.effects.Resize;
	import mx.messaging.events.MessageEvent;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class ChatImpl extends VBox
	{
		public var chatInfoContainer:UIComponent;
		public var textInput:TextInput;
		public var nameInput:TextInput;
		public var complexChatInfo:RichTextField;
		public var worldChatInfo:RichTextField;
		public var countryChatInfo:RichTextField;
		public var sceneChatInfo:RichTextField;
		public var chatToChatInfo:RichTextField;
		public var legionChatInfo:RichTextField;
		public var processionChatInfo:RichTextField;
		public var sendButton:LinkButton;
		public var smile:LinkButton;
		public var chatTo:LinkButton;
		public var complex:LinkButton;
		public var world:LinkButton;
		public var country:LinkButton;
		public var scene:LinkButton;
		public var legion:LinkButton;
		public var procession:LinkButton;
		public var expandContent:Parallel;
		public var shrinkContent:Parallel;
		public var shrink:Resize;
		public var expand:Resize;
		public var up:LinkButton;
		public var down:LinkButton;
		public var tempChatInfo:RichTextField;
		public var channelStyle:Array = ['country','scene','communication','legion','team','world']
		public var channelSelect:ComboBox;		
		private var interval:Timer = new Timer(1500,1);
		/**
		 *-1为不可聊天，1可以聊天
		 * */
		private var _status:Number = 1;
		private var _header:String = '综合';
		
		public function ChatImpl()
		{
			super();
		}
		
		/**
		 * 初始化聊天信息输出窗口
		 * */
		public function initChatWindow():void{
			channelSelect.dataProvider = channelStyle;
			channelSelect.styleName = 'worldUp';
			complexChatInfo = initChatInfo(complexChatInfo);
			worldChatInfo = initChatInfo(worldChatInfo);
			countryChatInfo = initChatInfo(countryChatInfo);
			sceneChatInfo = initChatInfo(sceneChatInfo);
			chatToChatInfo = initChatInfo(chatToChatInfo);
			legionChatInfo = initChatInfo(legionChatInfo);
			processionChatInfo = initChatInfo(processionChatInfo);
			showTopicChatInfo("综合");
//			sendMessage(tempChatInfo);
			sendButton.addEventListener(MouseEvent.CLICK,clickSend);
			addEventListener(KeyboardEvent.KEY_DOWN,enterSend);
			Application.application.focusManager.setFocus(textInput);
			/*注册聊天间隔事件监听器*/
			interval.addEventListener(TimerEvent.TIMER,timeEventHandler);
		   
		}
		
		public function tellInGame():void
		{
			RemoteService.instance.subscribe('场景',getMessage);
			RemoteService.instance.subscribe('世界',getMessage);
			RemoteService.instance.subscribe('国家',getMessage);
			RemoteService.instance.subscribe('军团',getMessage);
			RemoteService.instance.subscribe('队伍',getMessage);
			RemoteService.instance.subscribe(MySelf.instance.nickName,getMessage);
			RemoteService.instance.chatConnecting(collection.playerId,'场景',MySelf.instance.nickName+'进入了游戏').addHandlers(onChatConnecting);
			RemoteService.instance.chatConnecting(collection.playerId,'世界','').addHandlers(onChatConnecting);
			RemoteService.instance.chatConnecting(collection.playerId,'国家','').addHandlers(onChatConnecting);
			RemoteService.instance.chatConnecting(collection.playerId,'军团','').addHandlers(onChatConnecting);
			RemoteService.instance.chatConnecting(collection.playerId,'队伍','').addHandlers(onChatConnecting);
			RemoteService.instance.chatConnecting(collection.playerId,MySelf.instance.nickName,'').addHandlers(onChatConnecting);
		}
		
		//combobox过滤频道		
		public function filterChannel(event:Event):void
		{
			trace(channelSelect.selectedIndex);
				if(channelSelect.selectedIndex == 0)
				{
					disableChatTo();
					_header = "世界";
					channelSelect.styleName = 'countryUp';
				}else if(channelSelect.selectedIndex == 1)
				{
					disableChatTo();
			    	_header = "场景";
			    	channelSelect.styleName = 'sceneUp';
				}else if(channelSelect.selectedIndex == 2)
				{
					enableChatTo();
				    _header = "密语";
				    channelSelect.styleName = 'communicationUp';
				}else if(channelSelect.selectedIndex == 3)
				{
					disableChatTo();
				    _header = "军团";
				     channelSelect.styleName = 'legionUp';
				}else if(channelSelect.selectedIndex == 4)
				{
					disableChatTo();
				    _header = "队伍";
				    channelSelect.styleName = 'teamUp';
				}else if(channelSelect.selectedIndex == 5)
				{
					disableChatTo();
				    _header = "世界";
				    channelSelect.styleName = 'worldUp';
				}
			if(complex.styleName == 'chatHeaderSelect')
			{
				showTopicChatInfo('综合');
			}else
			{
				showTopicChatInfo(_header);
			}
				
			
		}
		
		/**
		 * 初始化单个RichTextField组件
		 * */
		public function initSubscribe():void
		{

		}
		 
		public function initChatInfo(chatInfo:RichTextField):RichTextField{
			chatInfo = new RichTextField(chatInfoContainer.width,chatInfoContainer.height);			
			chatInfoContainer.addChild(chatInfo);
			chatInfo.lineHeight = 22;
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 13;
			textFormat.color = 0x663300;
			chatInfo.defaultTextFormat = textFormat;
			return chatInfo
		}
		
		/**
		 * 点击发送按钮发送消息
		 * */
		public function clickSend(event:MouseEvent):void{
			sendMessage(tempChatInfo);
			
		}
		
		/**
		 * enter键发送消息
		 * */
		public function enterSend(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.ENTER){
				sendMessage(tempChatInfo);
			}
		}
		
		/**
		 * 事件间隔事件回调
		 * */
		public function timeEventHandler(event:TimerEvent):void{
			this._status = 1;
		}
		
		/**
		 * 发送消息
		 * */
		public function sendMessage(chatInfo:RichTextField):void{
			if(_status==-1){
				if(chatInfo!=complexChatInfo){
					complexChatInfo.appendRichText("对不起，您说的太快了");
				}
				chatInfo.appendRichText("对不起，您说的太快了");
				return;
			}else{
				_status = -1;
				interval.start();//启动监听，1.5秒后自动结束
			}
			var content:String = textInput.text;
			if(Application.application.faceWindow._selectedFacesIndexArray.length>0){
				content += "&"+Application.application.faceWindow._selectedFacesIndexArray.toString()+"&";
			}
			if(content==''){
				return;
			}
			var topic:String = _header;
			topic = (nameInput.text==''?topic:nameInput.text); 
			textInput.text = '';
//			RemoteService.instance.subscribe(topic,getMessage);
//			if(topic == '综合')
//			{
				RemoteService.bol = false;
				if(channelSelect.styleName == 'worldUp')
				{
					RemoteService.instance.chatConnecting(collection.playerId,'世界',content).addHandlers(onChatConnecting);
				}else if(channelSelect.styleName == 'countryUp')
				{
					RemoteService.instance.chatConnecting(collection.playerId,'国家',content).addHandlers(onChatConnecting);
				}else if(channelSelect.styleName == 'sceneUp')
				{
					RemoteService.instance.chatConnecting(collection.playerId,'场景',content).addHandlers(onChatConnecting);
				}else if(channelSelect.styleName == 'legionUp')
				{
					RemoteService.instance.chatConnecting(collection.playerId,'军团',content).addHandlers(onChatConnecting);
				}else if(channelSelect.styleName == 'teamUp')
				{
					RemoteService.instance.chatConnecting(collection.playerId,'队伍',content).addHandlers(onChatConnecting);
				}else
				{
					RemoteService.instance.chatConnecting(collection.playerId,topic,content).addHandlers(onChatConnecting);
				}
//			}
			
			
		}
		
		/**
		 * 获取消息 message:[topic,name,content]
		 * */
		public function getMessage(event:MessageEvent):void{
			addMessage(event.message.body.toString());
		}
		
		public function onChatConnecting(event:ResultEvent,token:AsyncToken):void{
			if(event.result!=null){
				if(event.result['result']==false){
					complexChatInfo.appendRichText(event.result['reason']);
				}
			}
		}
		
		/**
		 * 向聊天框中增加聊天语
		 * */
		public function addMessage(message:String):void{
			var messageList:Array = message.split('^^^');
			var topic:String = messageList[0];
			var camp:String = messageList[1];
			var name:String = messageList[2];
			var content:String = messageList[3];
			var sender:String = messageList[4];	
			var location:String = messageList[5];		
			if(content == null || content == '')
			 return;
			var newMessage:String = "";
			newMessage += "["+ topic +"]";
			newMessage += "["+ name +"]";
			newMessage += "：";
			newMessage += content;
			
			
			if(topic=="世界"){
				tempChatInfo = worldChatInfo;
			}else if(topic=="国家"){				
				tempChatInfo = countryChatInfo;
			}else if(topic=="场景"){
				tempChatInfo = sceneChatInfo;
			}else if(topic=="军团"){
				tempChatInfo = legionChatInfo;
			}else if(topic=="队伍"){
				tempChatInfo = processionChatInfo;
			}else{
				tempChatInfo = chatToChatInfo;
			}
			
			if(topic != '世界')
			{
				if(int(camp) == MySelf.instance.camp)				
				{
					if(topic == '军团')
					{
						addChatText(newMessage,tempChatInfo,TextFormatUtil.LEGIONFORMAT);					
						addChatText(newMessage,complexChatInfo,TextFormatUtil.LEGIONFORMAT);
					}else if(topic == '队伍')
					{
						addChatText(newMessage,tempChatInfo,TextFormatUtil.TEAMFORMAT);					
						addChatText(newMessage,complexChatInfo,TextFormatUtil.TEAMFORMAT);
					}else if(topic == '国家')
					{
						addChatText(newMessage,tempChatInfo,TextFormatUtil.COUNTRYFORMAT);					
						addChatText(newMessage,complexChatInfo,TextFormatUtil.COUNTRYFORMAT);
					}else if(topic == '场景')
					{
						addChatText(newMessage,sceneChatInfo,TextFormatUtil.SCENEFORMAT);					
						addChatText(newMessage,complexChatInfo,TextFormatUtil.SCENEFORMAT);
					}						
				}				
					if(topic == MySelf.instance.nickName)
					{						 
						newMessage = "["+ sender +"]";
						newMessage += "：";
						newMessage += content;
						addChatText(newMessage,tempChatInfo,TextFormatUtil.CHATTOFORMAT);					
						addChatText(newMessage,complexChatInfo,TextFormatUtil.CHATTOFORMAT);
					}else if(sender == MySelf.instance.nickName)
					{
						if(topic != '场景' && topic != '军团' && topic != '队伍' && topic != '国家' && topic != '世界')
						{
						newMessage = "发送["+ topic +"]";
						newMessage += "：";
						newMessage += content;
						addChatText(newMessage,tempChatInfo,TextFormatUtil.CHATTOFORMAT);					
						addChatText(newMessage,complexChatInfo,TextFormatUtil.CHATTOFORMAT);
						}
						  
					}
					
//				}			
			}else
			{
				if(int(camp) == 1)
				{
					
					newMessage = "[魏国]";
					newMessage += "["+ name +"]";
					newMessage += "：";
					newMessage += content;
					addChatText(newMessage,tempChatInfo,TextFormatUtil.WEIINFOFORMAT);
					addChatText(newMessage,complexChatInfo,TextFormatUtil.WEIINFOFORMAT);
				}else if(int(camp) == 2)
				{
					newMessage = "[蜀国]";
					newMessage += "["+ name +"]";
					newMessage += "：";
					newMessage += content;
					addChatText(newMessage,tempChatInfo,TextFormatUtil.SHUINFOFORMAT);
					addChatText(newMessage,complexChatInfo,TextFormatUtil.SHUINFOFORMAT);
				}else if(int(camp) == 3)
				{
					newMessage = "[吴国]";
					newMessage += "["+ name +"]";
					newMessage += "：";
					newMessage += content;
					addChatText(newMessage,tempChatInfo,TextFormatUtil.WUINFOFORMAT);
					addChatText(newMessage,complexChatInfo,TextFormatUtil.WUINFOFORMAT);
				}else
				{
					newMessage = "[在野]";
					newMessage += "["+ name +"]";
					newMessage += "：";
					newMessage += content;
					addChatText(newMessage,tempChatInfo,TextFormatUtil.WUINFOFORMAT);
					addChatText(newMessage,complexChatInfo,TextFormatUtil.WUINFOFORMAT);
				}
				
			}
//			addChatText(newMessage,complexChatInfo);
			scrollChatInfo(complexChatInfo);
			
			scrollChatInfo(tempChatInfo);
			Application.application.faceWindow._selectedFacesIndexArray = [];
		}
		
		/**
		 * 判断是否有表情，根据情况添加聊天内容
		 * "fklasjdfajf:/:/&1,3&"
		 * */
		public function addChatText(content:String,chatInfo:RichTextField,format:TextFormat = null):void{
			var temp:String = content;
			var index:int = 0;
			var tempIndex:int =0;/**记录“:)”的下标，存储于数组中，以方便appendRichText()调用 **/
			
			var array:Array = content.split("&");
			var smileArray:Array = [];
			if(array.length>1){
				smileArray = array[1].split(",");
			}
			content = array[0];
 			if(temp.indexOf(":/")!=-1){
				var inserts:Array = new Array();
				var i:int = 0;
				var regExp:RegExp = new RegExp(":\/","g");
				while(temp.indexOf(":/")!=-1){
					index = temp.indexOf(":/");
					tempIndex += index; 
					temp = temp.substring(index+2);
                    if(i>smileArray.length-1){
                    	break;
					}else{
						var smile:Sprite = new Faces._smileys[int(smileArray[i])]() as Sprite;
						inserts.push({src:smile,index:tempIndex});
					}
					i++;
				}
				chatInfo.appendRichText(content.replace(regExp,""),inserts,format);
			}else{
				chatInfo.appendText(temp,format);
			} 
			chatInfo.assignScrollBar();
		}
		
		/**
		 * 增加一条聊天记录，聊天信息框自动向下拉伸
		 * */
		public function scrollChatInfo(chatInfo:RichTextField):void{
			if(chatInfo.textfield.maxScrollV)
			{
				chatInfo.textfield.scrollV = chatInfo.textfield.maxScrollV;
			}
		}
		
		/**
		 * 关闭打开表情框
		 * */
		public function facesWindowClick(event:MouseEvent):void{
			if (Application.application.faceWindow.visible==true){
				Application.application.faceWindow.setVisible(false);  
			}else{
				Application.application.faceWindow.setVisible(true);  
			}
		}
		
		/**
		 * 频道选择
		 * */
		public function chooseChanleHandler(event:MouseEvent):void{
			var button:LinkButton = event.currentTarget as LinkButton;
			if(button == chatTo){
				enableChatTo();
				_header = "密语";
				channelSelect.styleName = 'communicationUp';
				chatTo.styleName = 'chatHeaderSelect';
				complex.styleName = 'chatHeader';
				world.styleName = 'chatHeader';
				country.styleName = 'chatHeader';
				scene.styleName = 'chatHeader';
				legion.styleName = 'chatHeader';
				procession.styleName = 'chatHeader';
			}else if(button == complex){
				if(channelSelect.styleName == 'communicationUp')
				{
					enableChatTo();
				}else
				{
					disableChatTo();
				}					
				
				_header = "综合";	
				chatTo.styleName = 'chatHeader';
				complex.styleName = 'chatHeaderSelect';
				world.styleName = 'chatHeader';
				country.styleName = 'chatHeader';
				scene.styleName = 'chatHeader';
				legion.styleName = 'chatHeader';
				procession.styleName = 'chatHeader';		
			}else if (button == world){
				disableChatTo();
				_header = "世界";
				channelSelect.styleName = 'worldUp';
				chatTo.styleName = 'chatHeader';
				complex.styleName = 'chatHeader';
				world.styleName = 'chatHeaderSelect';
				country.styleName = 'chatHeader';
				scene.styleName = 'chatHeader';
				legion.styleName = 'chatHeader';
				procession.styleName = 'chatHeader';	
			}else if (button == country){
				disableChatTo();
				_header = "国家";
				channelSelect.styleName = 'countryUp';
//				channelSelect.styleName = 'worldUp';
				chatTo.styleName = 'chatHeader';
				complex.styleName = 'chatHeader';
				world.styleName = 'chatHeader';
				country.styleName = 'chatHeaderSelect';
				scene.styleName = 'chatHeader';
				legion.styleName = 'chatHeader';
				procession.styleName = 'chatHeader';	
			}else if(button==scene){
				disableChatTo();
				_header = "场景";
				channelSelect.styleName = 'sceneUp';
//				channelSelect.styleName = 'countryUp';
//				channelSelect.styleName = 'worldUp';
				chatTo.styleName = 'chatHeader';
				complex.styleName = 'chatHeader';
				world.styleName = 'chatHeader';
				country.styleName = 'chatHeader';
				scene.styleName = 'chatHeaderSelect';
				legion.styleName = 'chatHeader';
				procession.styleName = 'chatHeader';	
			}else if(button==legion){
				disableChatTo();
				_header = "军团";
				channelSelect.styleName = 'legionUp';
//				channelSelect.styleName = 'sceneUp';
//				channelSelect.styleName = 'countryUp';
//				channelSelect.styleName = 'worldUp';
				chatTo.styleName = 'chatHeader';
				complex.styleName = 'chatHeader';
				world.styleName = 'chatHeader';
				country.styleName = 'chatHeader';
				scene.styleName = 'chatHeader';
				legion.styleName = 'chatHeaderSelect';
				procession.styleName = 'chatHeader';	
			}else if(button==procession){
				disableChatTo();
				_header = "队伍";
				channelSelect.styleName = 'teamUp';
//				channelSelect.styleName = 'legionUp';
//				channelSelect.styleName = 'sceneUp';
//				channelSelect.styleName = 'countryUp';
//				channelSelect.styleName = 'worldUp';
				chatTo.styleName = 'chatHeader';
				complex.styleName = 'chatHeader';
				world.styleName = 'chatHeader';
				country.styleName = 'chatHeader';
				scene.styleName = 'chatHeader';
				legion.styleName = 'chatHeader';
				procession.styleName = 'chatHeaderSelect';
			}
			showTopicChatInfo(_header);
		}
		
		/**启动密语、隐藏密语*/
		public function enableChatTo():void{
			textInput.x = 90;
			textInput.width = 255;
			nameInput.visible = true;
			Application.application.focusManager.setFocus(nameInput);
			textInput.setStyle('backgrounImage','images/chat/textInputBG.png');
		}
		public function disableChatTo():void{
			nameInput.setVisible(false);
			textInput.x = 39;
			textInput.width = 310;
			Application.application.focusManager.setFocus(textInput);
			textInput.setStyle('backgrounImage','images/chat/longTextInput.png');
		}
		
		/**
		 * 显示特定频道聊天信息
		 * */
		public function showTopicChatInfo(topic:String):void{
			complexChatInfo.visible = false;
			worldChatInfo.visible = false;
			countryChatInfo.visible = false;
			sceneChatInfo.visible = false;
			chatToChatInfo.visible = false;
			legionChatInfo.visible = false;
			processionChatInfo.visible = false;
			if(topic=="综合"){
				complexChatInfo.visible = true;
			}else if(topic=="世界"){
				worldChatInfo.visible = true;
			}else if(topic=="国家"){
				countryChatInfo.visible = true;
			}else if(topic=="场景"){
				sceneChatInfo.visible = true;
			}else if(topic=="军团"){
				legionChatInfo.visible = true;
			}else if(topic=="队伍"){
				processionChatInfo.visible = true;
			}else{
				chatToChatInfo.visible = true;
			}
		}
		
		//拉伸特效
		public function expandTalk(event:MouseEvent):void
		{
			expandContent.end();
			expandContent.target = this;
			expandContent.play();
			expand.end();
			expandContent.target = chatInfoContainer;
			expand.play();		
			up.visible = false;
			up.includeInLayout = false;
			down.visible = true;
			down.includeInLayout = true;
			setTimeout(function():void{Alert.show(chatInfoContainer.height.toString())},1000);
		}
		
	
	}
}