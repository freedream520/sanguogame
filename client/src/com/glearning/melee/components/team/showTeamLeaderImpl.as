package com.glearning.melee.components.team
{
	import mx.containers.Canvas;
	import mx.containers.HBox;

	public class showTeamLeaderImpl extends HBox
	{
		public var teamMember:Canvas;
		
		public function showTeamLeaderImpl()
		{
			super();
		}
		
		override public function set data(value:Object):void {
			super.data = value;
			if(teamMember == null)
			 teamMember = new Canvas();
			if (value.isLeader == true) {
				teamMember.setStyle('backgroundColor','#FF0000');
			} else {
				teamMember.setStyle('backgroundColor','#00BB00');
			}
		}
		
	}
}