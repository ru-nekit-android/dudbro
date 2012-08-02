package ru.nekit.disn.model.friend
{
	
	import flash.utils.Dictionary;
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.user.user_internal;
	import ru.nekit.disn.model.vo.FriendshipRequestVO;
	
	use namespace user_internal;
	
	public class FriendshipRequestList extends ModelLink
	{
		
		private var _uidList:Dictionary;
		private var _friendshipRequestList:Vector.<User>;
		
		public function FriendshipRequestList()
		{
			_uidList 				= new Dictionary;
			_friendshipRequestList 	= new Vector.<User>;
		}
		
		public function get list():Vector.<User>
		{
			return _friendshipRequestList;
		}
		
		public function save(user:User, status:uint, text:String = null):Boolean
		{
			var request:FriendshipRequestVO;
			if( hasRequest(user) )
			{
				request 		= getRequest(user);
				request.status 	= status;
				if( text )
				{
					request.text 	= text;
				}
				model.db.update(request);
			}
			else
			{
				request					= new FriendshipRequestVO(user.uid, status, text);
				_uidList[user.uid]	= request;
				_friendshipRequestList[_friendshipRequestList.length] 	= user;
				model.db.save(request);
				return true;
			}
			return false;
		}
		
		public function getRequest(user:User):FriendshipRequestVO
		{
			if( hasRequest(user) )
			{
				return _uidList[user.uid];
			}
			return null;
		}
		
		public function hasRequest(user:User):Boolean
		{
			return user.uid in _uidList;
		}
		
		public function remove(user:User):void
		{
			var request:FriendshipRequestVO = getRequest(user);
			if( request )
			{
				delete _uidList[user.uid];
				var index:int = _friendshipRequestList.indexOf(user);
				if( index != -1 )
				{
					_friendshipRequestList.splice(index, 1);
				}
				model.db.remove(request);
			}
		}
		
		public function reset():void
		{
			model.db.removeAll(FriendshipRequestVO);
		}
		
		public function init():void
		{
			//reset();
			var list:Array 				= model.db.selectAll(FriendshipRequestVO);
			var i:uint					= _friendshipRequestList.length;
			for each (var request:FriendshipRequestVO in list) 
			{
				var user:User = model.userList.getByID(request.user);
				if( user)
				{
					_friendshipRequestList[i++] 	= user;
					_uidList[request.user]			= request;
				}
			}
		}
		
		public function get length():uint
		{
			return _friendshipRequestList.length;
		}
	}
}