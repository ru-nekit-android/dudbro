package ru.nekit.disn.model.user
{
	
	import com.projectcocoon.p2p.vo.ClientVO;
	
	import ru.nekit.disn.model.account.Account;
	import ru.nekit.disn.model.photo.Photo;
	import ru.nekit.disn.model.ping.CyclicUserPing;
	import ru.nekit.disn.model.types.UserPrivateRule;
	import ru.nekit.disn.model.university.University;
	import ru.nekit.disn.model.user.base.BaseUserProxy;
	import ru.nekit.disn.model.vo.FriendshipRequestVO;
	import ru.nekit.disn.model.vo.UserDataVO;
	
	use namespace user_internal;
	
	public class UserProxy extends BaseUserProxy
	{
		
		private var _ping:CyclicUserPing;
		
		public function UserProxy()
		{
			super(null);
			_photo = new Photo(null);
			_account = new Account(null);
			_university = new University(null);
			_ping = new CyclicUserPing(null);
		}
		
		public function get ping():CyclicUserPing
		{
			return _ping;
		}
		
		public function get isFriend():Boolean
		{
			return model.friendList.hasFriend(user);
		}
		
		public function get friendshipRequest():FriendshipRequestVO
		{
			return model.friendshipRequestList.getRequest(user);
		}
		
		public function get friendshipRequestFromMe():FriendshipRequestVO
		{
			var request:FriendshipRequestVO = friendshipRequest;
			if( request && model.friendshipRequestFilter.isFromMe(request) )
			{
				return request;
			}
			return null;
		}
		
		public function get friendshipRequesToMe():FriendshipRequestVO
		{
			var request:FriendshipRequestVO = friendshipRequest;
			if( request && model.friendshipRequestFilter.isToMe(request) )
			{
				return request;
			}
			return null;
		}
		
		public function get isFavorite():Boolean
		{
			return model.favoriteUserList.hasFavorite(user);
		}
		
		public function addToFavorites():void
		{
			model.favoriteUserList.add(user);
		}
		
		public function removeFromFavorites():void
		{
			model.favoriteUserList.remove(user);
		}
		
		override public function hasDataAccessByField(rule:uint):Boolean
		{
			return isFriend || super.hasDataAccessByField(rule) || friendshipRequesToMe != null;
		}
		
		public function get fullname():String
		{
			if( hasDataAccessByField( UserPrivateRule.ALLOW_NAME ) )
			{
				return user.vo.name;
			}
			return null;
		}
		
		public function get sex():int
		{
			if( hasDataAccessByField( UserPrivateRule.ALLOW_SEX ) )
			{
				return user.vo.sex;
			}
			return 0;
		}
		
		public function get birthday():Date
		{
			if( hasDataAccessByField( UserPrivateRule.ALLOW_BIRTHDAY ) )
			{
				return user.vo.birthDay;
			}
			return null;
		}
		
		override public function get ageString():String
		{
			var birthday:Date = this.birthday;
			if( birthday )
			{
				return super.ageString;
			}
			return null;
		}
		
		override public function get sexString():String
		{
			var sex:int = this.sex;
			if( sex == 0 )
			{
				return null;
			}
			return super.sexString
		}
		
		public function get phone():String
		{
			if( hasDataAccessByField( UserPrivateRule.ALLOW_PHONE ) )
			{
				return user.vo.phone;
			}
			return null;
		}
		
		public function get aboutMe():String
		{
			if( hasDataAccessByField( UserPrivateRule.ALLOW_ABOUT_ME ) )
			{
				return user.vo.aboutMe;
			}
			return null;
		}
		
		public function get online():Boolean
		{
			return user.online;
		}
		
		public function get user():User
		{
			return _baseUser as User;
		}
		
		public function get displayName():String
		{
			return user.displayName;
		}
		
		public function get nickname():String
		{
			return user.nickname;
		}
		
		public function set nickname(value:String):void
		{
			if( nickname != value )
			{
				user.nickname = value;
				model.userList.save(user);
			}
		}
		
		public function get status():String
		{
			return user.status;
		}
		
		public function set user(value:User):void
		{
			_baseUser = value;
			if( value )
			{
				_photo.vo = value.photoVO;
				_account.vo = value.accountsVO;
				_university.vo = value.universityVO;
				_ping.user = this.user;
			}
		}
		
		public function save(data:UserDataVO):void
		{
			user.setVO(data);
			model.userList.save(user);
		}
		
		public function connect():void
		{			
			user.online			= true;
			user.active			= true;
			model.userList.add(user);
		}
		
		public function exit():void
		{
			if( user && user.online )
			{
				user.online = false;
				user.active	= false;
				model.userList.removeByPeerID(user.peerID);
			}
		}
		
		public function register(client:ClientVO):User
		{
			if( !model.userList.getByPeerID(client.peerID) )
			{
				_baseUser		= model.userList.getByID(client.uid);
				if( !_baseUser )
				{
					_baseUser = new User;
				}
				user.type			= client.type;
				user.uid     		= client.uid;
				user.nickname 		= client.clientName;
				user.peerID 		= client.peerID;
				user.groupID 		= client.groupID;
				model.userList.addByPeerID(user);
				return user;
			}
			return null;
		}
	}
}