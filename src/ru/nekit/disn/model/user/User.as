package ru.nekit.disn.model.user
{
	
	import ru.nekit.disn.model.user.base.BaseUser;
	import ru.nekit.disn.model.vo.UserDataVO;
	
	use namespace user_internal;
	
	public class User extends BaseUser
	{
		
		public var peerID:String;
		public var groupID:String;
		public var online:Boolean = false;
		public var ping:uint = 0;
		
		public function User()
		{
			super();
		}
		
		user_internal function get vo():UserDataVO
		{
			return _vo;	
		}
		
		public function setVO(value:UserDataVO):void
		{
			_vo.set(value);
		}
		
		public function set(user:User):void
		{
			setBaseUser(user);
			online 	= user.online;
			peerID 	= user.peerID;
			groupID = user.groupID;
		}
		
		public function get displayName():String
		{
			return _vo.nickname;
		}
	}
}