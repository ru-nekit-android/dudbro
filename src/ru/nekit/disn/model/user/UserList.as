package ru.nekit.disn.model.user
{
	
	import flash.utils.Dictionary;
	
	import ru.nekit.disn.manager.entity.IEntity;
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.vo.UserDataVO;
	
	use namespace user_internal;
	
	public class UserList extends ModelLink
	{	
		
		private var _list:Vector.<User>;
		private var _dictionary:Dictionary;
		private var _peerDictionary:Dictionary;
		
		public function UserList()
		{
			_list 			= new Vector.<User>;
			_dictionary 	= new Dictionary;
			_peerDictionary = new Dictionary;
		}
		
		public function add(user:User):Boolean
		{
			save(user);
			if( !(user.uid in _dictionary) )
			{
				_dictionary[user.uid] 		= user;
				addByPeerID(user);
				_list[_list.length] 			= user;
				return true;
			}
			var _user:User = _dictionary[user.uid];
			_user.set(user);
			addByPeerID(user);
			return false;
		}
		
		public function addByPeerID(user:User):void
		{
			_peerDictionary[user.peerID] 	= user;
		}
		
		public function reset():void
		{
			model.db.removeAll(UserDataVO);
		}
		
		public function removeList(list:Vector.<User>):void
		{
			var result:Vector.<IEntity> = new Vector.<IEntity>;
			for each( var user:User in list )
			{
				result.push(user.vo);
			}
			model.db.removeList(UserDataVO, result);
		}
		
		public function save(user:User):void
		{
			if( user.uid in _dictionary )
			{
				model.db.update(user.user_internal::vo);
			}
			else
			{
				model.db.save(user.user_internal::vo);
			}
		}
		
		public function init():void
		{
			var list:Array 	= model.db.selectAll(UserDataVO);
			var i:uint 		= _list.length;
			for each (var userData:UserDataVO in list) 
			{
				if( !(userData.uid in _dictionary) )
				{
					var user:User 		= new User;
					user.setVO( userData );
					_dictionary[userData.uid] 	= user;
					_list[i++] 							= user;
				}
			}
		}
		
		public function getByPeerID(peerID:String):User
		{
			if( peerID in _peerDictionary )
			{
				return _peerDictionary[peerID];
			}
			return null;
		}
		
		public function removeByPeerID(peerID:String):void
		{
			if( getByPeerID(peerID ) )
			{
				delete _peerDictionary[peerID];
			}
		}
		
		public function getByID(id:String):User
		{
			if( id in _dictionary )
			{
				return _dictionary[id];
			}
			return null;
		}
		
		public function has(user:User):Boolean
		{
			return user.uid in _dictionary;
		}
		
		public function get list():Vector.<User>
		{
			return _list;
		}
	}
}