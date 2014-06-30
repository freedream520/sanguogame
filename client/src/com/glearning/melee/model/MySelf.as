package com.glearning.melee.model
{
	
	/**
	 * MySelf is an entity class, stores data of the player itself,
	 * such as name, level, strenth etc. UI components' properties may bind
	 * to these properties.
	 * MySelf is a Singleton. 
	 * @author hanbing
	 * 
	 */
	public class MySelf
	{
		/**
		 * The singleton MySelf instance.
		 */
		public static function get instance():MySelf
		{
			if (!_instance)
				_instance = new MySelf();
			
			return _instance;
		}
		  
		private static var _instance:MySelf = null;
    
		public function MySelf()
		{
		}

		
		/**
		 * name of player 
		 */
		private var _name:String = "";
		[Bindable]
		public function get name():String {
			return _name;
		}
		public function set name(value:String):void {
			_name = value;
		}
		
		/**
		 * player level 
		 */
		private var _level:uint = 1;
		[Bindable]
		public function get level():uint {
			return _level;
		}
		public function set level(value:uint):void {
			_level = value;
		}
		
		/**
		 * avatar image of player 
		 */
		private var _avatarImage:String = "";
		[Bindable]
		public function get avatarImage():String {
			return _avatarImage;
		}
		public function set avatarImage(value:String):void {
			_avatarImage = value;
		}
		
		private var _nickName:String="";
		[Bindable]
		public function get nickName():String{
			return _nickName;
		}
		public function set nickName(nickName:String):void{
			_nickName = nickName;
		}
		
		/**
		 * player hp
		 **/
		private var _hp:uint = 1;
		[Bindable]
		public function get hp():uint {
			return _hp;
		}
		public function set hp(value:uint):void {
			_hp = value;
		}
		
		/**
		 * player maxHp
		 **/
		private var _maxHp:uint = 1;
		[Bindable]
		public function get maxHp():uint {
			return _maxHp;
		}
		public function set maxHp(value:uint):void {
			_maxHp = value;
		}
		
		/**
		 * player mp
		 **/
		private var _mp:uint = 1;
		[Bindable]
		public function get mp():uint {
			return _mp;
		}
		public function set mp(value:uint):void {
			_mp = value;
		}
		
		/**
		 * player maxMp
		 **/
		private var _maxMp:uint = 1;
		[Bindable]
		public function get maxMp():uint {
			return _maxMp;
		}
		public function set maxMp(value:uint):void {
			_maxMp = value;
		}
		
		/**
		 * player exp
		 * */
		private var _exp:uint = 1;
		[Bindable]
		public function get exp():uint {
			return _exp;
		}
		public function set exp(value:uint):void {
			_exp = value;
		}
		
		/**
		 * player maxExp
		 * */
		private var _maxExp:uint = 1;
		[Bindable]
		public function get maxExp():uint {
			return _maxExp;
		}
		public function set maxExp(value:uint):void {
			_maxExp = value;
		}
		
		/**
		 * player energy
		 * */
		private var _energy:uint = 1;
		[Bindable]
		public function get energy():uint {
			return _energy;
		}
		public function set energy(value:uint):void {
			_energy = value;
		}
		
		/**
		 * player profession
		 * */
		private var _profession:String = "";
		[Bindable]
		public function get profession():String {
			return _profession;
		}
		public function set profession(value:String):void {
			_profession = value;
		}
		
		/**
		 * player status
		 * */
		private var _status:String = "";
		[Bindable]
		public function get status():String {
			return _status;
		}
		public function set status(value:String):void {
			_status = value;
		}
		
		/**
		 * player pkStatus
		 * */
		private var _pkStatus:String = "";
		[Bindable]
		public function get pkStatus():String {
			return _pkStatus;
		}
		public function set pkStatus(value:String):void {
			_pkStatus = value;
		}
		
		/**
		 * player station
		 * */
		private var _station:String = "";
		[Bindable]
		public function get station():String {
			return _station;
		}
		public function set station(value:String):void {
			_station = value;
		}
		
		/**
		 * player coin
		 * */
		private var _coin:uint = 0;
		[Bindable]
		public function get coin():uint {
			return _coin;
		}
		public function set coin(value:uint):void {
			_coin = value;
		}
		
		/**
		 * player coupon
		 * */
		private var _coupon:uint = 0;
		[Bindable]
		public function get coupon():uint {
			return _coupon;
		}
		public function set coupon(value:uint):void {
			_coupon = value;
		}
		
		/**
		 * player gold
		 * */
		private var _gold:uint = 0;
		[Bindable]
		public function get gold():uint {
			return _gold;
		}
		public function set gold(value:uint):void {
			_gold = value;
		}
		
		/**
		 *  player location
		 * */
		private var _location:uint = 0;
		[Bindable]
		public function get location():uint {
			return _location;
		}
		public function set location(value:uint):void {
			_location = value;
		}
		
		/**
		 *  玩家的国都
		 **/
		
		private var _town:uint = 0;
		[Bindable]
		public function get town():uint {
			return _town;
		}
		public function set town(value:uint):void {
			_town = value;
		}
		
		/**
		 *  玩家阵营
		 **/
		private var _camp:uint = 0;
		[Bindable]
		public function get camp():uint {
			return _camp;
		}
		public function set camp(value:uint):void {
			_camp = value;
		}
		
		//职位、头衔
		private var _title:String = '无';
		[Bindable]
		public function get title():String {
			return _title;
		}
		public function set title(value:String):void {
			_title = value;
		}
		
		//声望
		private var _Prestige:uint = 0;
		[Bindable]
		public function get Prestige():uint{
			return _Prestige;
		} 
		public function set Prestige(value:uint):void{
			_Prestige = value;
		}
		
		//排名
		private var _worldRank:uint = 0;
		[Bindable]
		public function get worldRank():uint{
			return _worldRank;
		}
		public function set worldRank(value:uint):void{
			_worldRank = value;
		}
		
		//职业
		private var _professionStage:uint = 0;
		[Bindable]
		public function get professionStage():uint{
			return _professionStage;
		}
		public function set professionStage(value:uint):void{
			_professionStage = value;
		}
		
		//罪恶
		private var _sin:uint = 0;
		[Bindable]
		public function get sin():uint{
			return _sin;
		}
		public function set sin(value:uint):void{
			_sin = value;
		}
		
		//贡献
		private var _contribution:uint = 0;
		[Bindable]
		public function get contribution():uint{
			return _contribution;
		}
		public function set contribution(value:uint):void{
			_contribution = value;
		}
		
		//格斗
		private var _fisticuff:uint = 0;
		[Bindable]
		public function get fisticuff():uint{
			return _fisticuff;
		}
		public function set fisticuff(value:uint):void{
			_fisticuff = value;
		}
		
		//荣誉
		private var _honors:uint = 0;
		[Bindable]
		public function get honors():uint{
			return _honors;
		}
		public function set honors(value:uint):void{
			_honors = value;
		}
		
		//家族
		private var _family:String = '暂无';
		[Bindable]
		public function get family():String{
			return _family;
		}
		public function set family(value:String):void{
			_family = value;
		}
		
		//派系描述
		private var _professionDescription:String = '';
		[Bindable]
		public function get professionDescription():String{
			return _professionDescription;
		}
		public function set professionDescription(value:String):void{
			_professionDescription = value;
		}
		
		//人物剩余点数
		private var _sparePoint:int;
		[Bindable]
		public function get sparePoint():int{
			return _sparePoint;
		}
		public function set sparePoint(value:int):void{
			_sparePoint = value;
		}
		
		//人物基础属性--力量
		private var _baseStr:int;
		[Bindable]
		public function get baseStr():int{
			return _baseStr;
		}
		public function set baseStr(value:int):void{
			_baseStr = value;
		}
		
		//人物基础属性--体质
		private var _baseVit:int;
		[Bindable]
		public function get baseVit():int{
			return _baseVit;
		}
		public function set baseVit(value:int):void{
			_baseVit = value;
		}
		
		//人物基础属性--灵巧
		private var _baseDex:int;
		[Bindable]
		public function get baseDex():int{
			return _baseDex;
		}
		public function set baseDex(value:int):void{
			_baseDex = value;
		}
		
		//自定义分配点数--力量
		private var _manualStr:int;
		[Bindable]
		public function get manualStr():int{
			return _manualStr;
		}
		
		public function set manualStr(value:int):void{
			_manualStr = value;
		}
		
		//自定义分配点数--体力
		private var _manualVit:int;
		[Bindable]
		public function get manualVit():int{
			return _manualVit;
		}
		public function set manualVit(value:int):void{
			_manualVit = value;
		}
		
		//自定义分配点数--灵巧
		private var _manualDex:int;
		[Bindable]
		public function get manualDex():int{
			return _manualDex;
		}
		public function set manualDex(value:int):void{
			_manualDex = value;
		}
		
		//命中率
		private var _hitRate:int;
		[Bindable]
		public function get hitRate():int{
			return _hitRate;
		}
		public function set hitRate(value:int):void{
			_hitRate = value;
		}
		
		//暴击率
		private var _criRate:int;
		[Bindable]
		public function get criRate():int{
			return _criRate;
		}
		public function set criRate(value:int):void{
			_criRate = value;
		}
		
		//躲闪率
		private var _dodgeRate:int;
		[Bindable]
		public function get dodgeRate():int{
			return _dodgeRate;
		}
		public function set dodgeRate(value:int):void{
			_dodgeRate = value;
		}
		
		//破防率
		private var _bogeyRate:int;
		[Bindable]
		public function get bogeyRate():int{
			return _bogeyRate;
		}
		public function set bogeyRate(value:int):void{
			_bogeyRate = value;
		}
		
		//攻击
		private var _currentDamage:Object;
		[Bindable]
		public function get currentDamage():Object{
			return _currentDamage;
		}
		public function set currentDamage(value:Object):void{
			_currentDamage = value;
		}
		
		//防御
		private var _currentDefense:int;
		[Bindable]
		public function get currentDefense():int{
			return _currentDefense;
		}
		public function set currentDefense(value:int):void
		{
			_currentDefense = value;
		}
		
		//速度
		private var _currentSpeedDescription:String;
		[Bindable]
		public function get currentSpeedDescription():String{
			return _currentSpeedDescription;
		}
		public function set currentSpeedDescription(value:String):void{
			_currentSpeedDescription = value;
		}
		
		//职业阶段
		private var _allProfessionStages:Array;
		[Bindable]
		public function get allProfessionStages():Array{
			return _allProfessionStages
		}
		public function set allProfessionStages(value:Array):void
		{
			_allProfessionStages = value;
		}
		
		//当前职业阶段
		private var _currentProfessionStageIndex:int;
		[Bindable]
		public function get currentProfessionStageIndex():int{
			return _currentProfessionStageIndex;
		}
		public function set currentProfessionStageIndex(value:int):void{
			_currentProfessionStageIndex = value;
		}
		
		//小憩
		private var _rest:int =1;
		[Bindable]
		public function get rest():int{
			return _rest;
		}
		public function set rest(value:int):void{
			_rest = value;
		}
		
		//浅睡
		private var _shallowSleep:int =1;
		[Bindable]
		public function get shallowSleep():int{
			return _shallowSleep;
		}
		public function set shallowSleep(value:int):void{
			_shallowSleep = value;
		}
		
		//安眠
		private var _sleep:int =1;
		[Bindable]
		public function get sleep():int{
			return _sleep;
		}
		public function set sleep(value:int):void{
			_sleep = value;
		}
		
		//酣睡
		private var _sleeping:int =2;
		[Bindable]
		public function get sleeping():int{
			return _sleeping;
		}
		public function set sleeping(value:int):void{
			_sleeping = value;
		}
		
		//是否队长
		private var _isLeader:Boolean =false;
		[Bindable]
		public function get isLeader():Boolean{
			return _isLeader;
		}
		public function set isLeader(value:Boolean):void{
			_isLeader = value;
		}
		
		//是否在队伍中
		private var _isTeamMember:Boolean =false;
		[Bindable]
		public function get isTeamMember():Boolean{
			return _isTeamMember;
		}
		public function set isTeamMember(value:Boolean):void{
			_isTeamMember = value;
		}
		
		//仓库数量
		private var _warehouses:int = 1;
		[Bindable]
		public function get warehouses():int{
			return _warehouses;
		}
		public function set warehouses(value:int):void{
			_warehouses = value;
		}
		
		//存款
		private var _deposit:int = 0;
		[Bindable]
		public function get deposit():int{
			return _deposit
		}
		public function set deposit(value:int):void{
			_deposit = value;
		}
		
		//是否是新玩家
		private var _isNewPlayer:int = 0;
		[Bindable]
		public function get isNewPlayer():int{
			return _isNewPlayer
		}
		public function set isNewPlayer(value:int):void{
			_isNewPlayer = value;
		}
		
		//当前新手任务步骤
		private var _progress:int = 0;
		[Bindable]
		public function get progress():int{
			return _progress
		}
		public function set progress(value:int):void{
			_progress = value;
		}
		
		//新手是否完成杀怪任务
		private var _isKilled:int = 0;
		[Bindable]
		public function get isKilled():int{
			return _isKilled
		}
		public function set isKilled(value:int):void{
			_isKilled = value;
		}
		
		//成长率
		private var _growRate:Array;
		[Bindable]
		public function get growRate():Array{
			return _growRate
		}
		public function set growRate(value:Array):void{
			_growRate = value;
		}
		
	
		//额外力量描述
		private var _extraStr:int;
		[Bindable]
		public function get extraStr():int{
			return _extraStr;
		}
		public function set extraStr(value:int):void{
			_extraStr = value;
		}
		
		//额外敏捷描述
		private var _extraDex:int;
		[Bindable]
		public function get extraDex():int{
			return _extraDex;
		}
		public function set extraDex(value:int):void{
			_extraDex = value;
		}
		
		//额外体魄描述
		private var _extraVit:int;
		[Bindable]
		public function get extraVit():int{
			return _extraVit;
		}
		public function set extraVit(value:int):void{
			_extraVit = value;
		}
		
		//性别
		private var _gender:int;
		[Bindable]
		public function get gender():int{
			return _gender;
		}
		public function set gender(value:int):void{
			_gender = value;
		}
	}
}