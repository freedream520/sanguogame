package com.glearning.melee.components.newplayerquest
{
	import com.glearning.melee.collections.collection;
	import com.glearning.melee.components.CustomerButtonComponent;
	import com.glearning.melee.components.player.ChooseProfessionComponent;
	import com.glearning.melee.components.utils.AutoTip;
	import com.glearning.melee.model.MySelf;
	import com.glearning.melee.net.RemoteService;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.LinkButton;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	public class NpcGuideImpl extends Canvas
	{
		
		public var description:Text;
		public var finish:LinkButton;
		public var type:int;
		public var finishGuide:String;
		public var coin:int;
		public var coupon:int;
		public var exp:int;
		public function NpcGuideImpl()
		{
			super();
					
		}
		
		public function init():void
		{					
			switch(type)
			{
				case 0:
				        description.htmlText = finishGuide;
				        break;
				case 1:
				        description.htmlText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;欢迎来到三国。我是南华星君，冥冥之中早已注定了你会见到我。" + 
				        		               "如今正是乱世，天下正在期待一个结束乱世的英雄出现。每个人都想成为英雄，但英雄可不是这么好当的。来，我会" + 
				        		               "教你些基础，让你轻松上路。请来<font color='#ff0000'>议事中心</font>和我<font color='#ff0000'>交谈</font>。\n";
				        description.htmlText += "铜币奖励:<font color='#ff0000'>5000</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;经验奖励:<font color='#ff0000'>10</font> ";
				        break;
				case 2:
				        description.htmlText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;逢此乱世，则一职业为必须求生之道，大则保家卫国，小则明哲保身，尔可则一喜好职业，冲锋陷阵。\n";
				        description.htmlText += "经验奖励:<font color='#ff0000'>50</font> "
				        break;
				case 3:
				        description.htmlText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;想知道怎么装备武器？看见左边的窗口了吗？点击那里的<font color='#ff0000'>角色</font>就可以打开<font color='#ff0000>角色界面</font>'，" + 
				        		               "然后用<font color='#ff0000'>鼠标双击</font>点击你要装备的武器就可以把它装备上了。防具和饰品也是这么装备的。你也可以<font color='#ff0000'>点击武器</font>" + 
				        		               "然后在弹出的<font color='#ff0000'>菜单</font>中选择<font color='#ff0000'>装备</font>来把他装备起来\n";
				        description.htmlText += "经验奖励:<font color='#ff0000'>150</font> "
				        break;
				case 4:
				        description.htmlText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;随着你在这个世界中的冒险你的等级会上升，每次的你等级上升都会变的很强，并可以获得1点能力点数。你每次可以自由在<font color='#ff0000'>武勇</font>，" + 
				        		               "<font color='#ff0000'>机警</font>，<font color='#ff0000'>体魄</font>中选择一种能力点数来提升。看到左边的<font color='#ff0000'>角色</font>" + 
				        		               "按键了吗？点击它进入<font color='#ff0000'>角色界面</font>，你可以看见自己的能力，然后点击能力后面的<font color='#ff0000'>黄色加好</font>就可以分配你的能力点数了。\n";
				        description.htmlText += "经验奖励:<font color='#ff0000'>50</font> "
				        break;
				case 5:
				        description.htmlText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;身处乱世，总有大大小小的麻烦等着有人去处理。你的冒险过程中经常会遇到各种人交给你的任务。去帮助他们完成这些任务不仅能增长你的经验，委托人还会给你各种奖励。" + 
				        		               "所以你要记得经常点击按键打开<font color='#ff0000'>任务界面</font>，然后<font color='#ff0000'>点击</font>界面上方的<font color='#ff0000'>可接任务</font>" + 
				        		               "查看有没有可以接受的任务。\n";
				        description.htmlText += "经验奖励:<font color='#ff0000'>60</font>"
				        break;
				case 6:
				        description.htmlText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;在这个乱世冒险，一把称手的武器是必不可少的。武器的来源有很多，最基本的就是在武器屋里购买。我们城里也有武器屋哦，是为了新来的朋友们服务的。不知道怎么去？" + 
				        		               "直接<font color='#ff0000'>点击</font>地图上的<font color='#ff0000'>武器屋</font>按键就可以了哦。记得和老板<font color='#ff0000'>交谈</font>说是我介绍你去的。\n";
				        description.htmlText += "经验奖励:<font color='#ff0000'>1000</font>"
				        break;
				case 7:
				        description.htmlText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;武器你已经有了，接下来你还需要防具。防具可以为你提供保护，有的还可以提高你的能力。去城里的<font color='#ff0000'>防具屋</font>看看吧。点击地图上的" + 
				        		               "<font color='#ff0000'>防具屋</font>按键就可以去了。别忘了和老板<font color='#ff0000'>交谈</font>哦\n";
				        description.htmlText += "经验奖励:<font color='#ff0000'>1500</font>"
				        break;
				case 8:
				        description.htmlText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;有了防具，你还需要准备一些披风手套之类的杂货。它们和防具一样，也可以增强你的防御能力。去和<font color='#ff0000'>杂货屋</font>老板" + 
				        		               "<font color='#ff0000'>交谈</font>吧，他同样会帮助你的。点击地图上的<font color='#ff0000'>杂货屋</font>按键就可以到那了。\n";
				        description.htmlText += "经验奖励:<font color='#ff0000'>1500</font>"
				        break;
				case 9:
				        description.htmlText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;这个世界中有种人被称为赏金猎人，他们是为了任务的奖励而每天寻找任务的一群人。他们聚集的地方叫做<font color='#ff0000'>赏金组织</font>。" + 
				        		               "你如果对赏金有兴趣也可以去那看看，那里每天都会有新的任务出现。点击地图上的<font color='#ff0000'>赏金组织</font>按键你就可以到达那里" + 
				        		               "了，先去和赏金猎人<font color='#ff0000'>交谈</font>吧。\n";
				        description.htmlText += "经验奖励:<font color='#ff0000'>2000</font>";
				        break;
				case 10:
				        description.htmlText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;天下之大，无奇不有。有门叫炼丹术的技术能把那些珍奇植物和动物炼成养生健体的物品。刚才你得到的就是其中之一，点击<font color='#ff0000'>角色</font>" + 
				        		               "按键，你可以在右边的包裹栏里找到它。用<font color='#ff0000'>鼠标双击</font>点击<font color='#ff0000'>卷轴</font>就可以把它用在自己身上了。\n";
				        description.htmlText += "经验奖励:<font color='#ff0000'>3000</font>";
				        break;
				case 11:
				        description.htmlText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;现在应该让你出去看看了，但是外面可不像城里这么安全。有各种可怕的怪物和恶人。冒险的过程中你不可避免的要和他们发生冲突。所以你必须学会战斗的方法。" + 
				        		               "先去试试吧。 点击<font color='#ff0000'>出口</font>就可以到外面了，去<font color='#ff0000'>小树林</font>杀死一个<font color='#ff0000'>黄巾侦察兵</font>\n";
				        description.htmlText += "经验奖励:<font color='#ff0000'>3400</font>";
				        break;
				case 12:
				        description.htmlText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;看来你还不习惯这个世界的战斗，那么再去熟悉一下吧。这次的目标凶悍哦。当面对高等级的敌人时，补满血是很有必要的，可以先去宿屋休息下。如果过程中觉得体力不支的话，可以使用药品恢复" + 
				        		               "或者回城里休息。和刚才一样，点击<font color='#ff0000'>出口</font>到外面，去<font color='#ff0000'>陈家村</font>杀死一个<font color='#ff0000'>黄巾力士</font>\n" + 
				        		               "这次我同样会为你在地图上标出你要找的敌人。\n";
				        description.htmlText += "铜币奖励:<font color='#ff0000'>1000</font>\t经验奖励:<font color='#ff0000'>4000</font>";		               
				        break;
				case 13:
				        description.htmlText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;你被要求接受考验了？这说明你的实力已经得到了肯定，勇敢的去接受这次考验吧。这次的敌人可能有点棘手，你最好做好充分的准备，并且恢复好体力和法力再去。和之前一样，" + 
				        		               "点击<font color='#ff0000'>出口</font>去外面，去<font color='#ff0000'>黄巾营帐</font>杀死一个<font color='#ff0000'>黄巾伍长</font>\n";
				        description.htmlText += "铜币奖励:<font color='#ff0000'>7000</font>\t经验奖励:<font color='#ff0000'>7000</font>";		               		               
				        break;
				case 14:
				        description.htmlText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;技能在这里是很重要的一项能力。技能有许多种类，具体情况你可以在学习技能的时候看到。现在就告诉怎么你学习技能。先点击<font color='#ff0000'>按键</font>进入" + 
				        		               "<font color='#ff0000'>角色界面</font>，随后你可以在<font color='#ff0000'>角色界面</font>上方找到<font color='#ff0000'>技能</font>按键，" + 
				        		               "点击它进入<font color='#ff0000'>技能界面</font>。然后在<font color='#ff0000'>可学习技能</font>里就可以看到你现在<font color='#ff0000'>可以学习的" + 
				        		               "技能</font>了。不过技能光学习还不行，你需要在<font color='#ff0000'>当前技能</font>中装备上，技能才会发挥效果。\n";
				        description.htmlText += "经验奖励:<font color='#ff0000'>3000</font>";		               
				        break;
				case 15:
				        description.htmlText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;恭喜你，你已经完成了初步的训练，可以离开这条船，在这个世界中自由冒险了。相处的时候虽然不长，但真到要分开的时候还真有的寂寞呢。这样吧，我送你一件临别的礼物，希望" + 
				        		               "可以帮上你的忙。请你到<font color='#ff0000'>议事中心</font>来和我<font color='#ff0000'>交谈</font>。";
				        description.htmlText += "经验奖励:<font color='#ff0000'>3000</font>";
				        break;
				case 16:
				        description.htmlText = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;我知道你早就选择好了自己未来的道路，不管那是秩序之路，还是混沌之路。我相信你都会凭自己的力量和信念走下去。来<font color='#ff0000'>议事中心</font>找我吧。我会" + 
				        		               "送你去你想去的<font color='#ff0000'>阵营主城</font>，在那里会有新的导师引导你的。再见。也许有一天，我们会在冒险的道路上再见面。\n";
				        description.htmlText += "经验奖励:<font color='#ff0000'>2000</font>";
				        break;
			}
		}
		
		
		
		
	}
}