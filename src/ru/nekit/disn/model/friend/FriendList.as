package ru.nekit.disn.model.friend
{
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.user.UserList;
	import ru.nekit.disn.model.vo.FriendVO;
	
	public class FriendList extends ModelLink
	{
		
		private var _uidList:Dictionary;
		private var _friendList:Vector.<User>;
		
		public function FriendList()
		{
			_uidList 				= new Dictionary;
			_friendList 			= new Vector.<User>;
		}
		
		public function get list():Vector.<User>
		{
			return _friendList;
		}
		
		public function hasFriend(user:User):Boolean
		{
			return user.uid in _uidList;
		}
		
		public function add(user:User):Boolean
		{
			if( !hasFriend(user) )
			{
				var friend:FriendVO					= new FriendVO(user.uid);
				_uidList[user.uid]					= friend;
				_friendList[_friendList.length] 	= user;
				model.db.save(friend);
				return true;
			}
			return false;
		}
		
		public function remove(user:User):void
		{
			if( hasFriend(user) )
			{
				var friend:FriendVO = _uidList[user.uid];
				delete _uidList[user.uid];
				_friendList.splice(_friendList.indexOf(user), 1);
				model.db.remove(friend);
			}
		}
		
		public function get length():uint
		{
			return list.length;
		}
		
		public function init():void
		{
			reset();
			var list:Array 					= model.db.selectAll(FriendVO);
			var i:uint 						= _friendList.length;
			for each (var friend:FriendVO in list) 
			{
				var user:User = model.userList.getByID(friend.user);
				if( user )
				{
					_friendList[i++] 			= user;
					_uidList[friend.user]	= friend;
				}
			}
		}
		
		public function reset():void
		{
			model.db.removeAll(FriendVO);
		}
		
		public function get dataProvider():ArrayCollection
		{
			var ac:ArrayCollection = new ArrayCollection;
			const length:uint = _friendList.length;
			for( var i:uint = 0 ; i < length; i++)
			{
				ac.addItem(_friendList[i]);
			}
			return ac;
		}
	}
}