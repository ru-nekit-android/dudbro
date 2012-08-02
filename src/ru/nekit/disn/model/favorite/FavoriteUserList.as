package ru.nekit.disn.model.favorite
{
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.vo.FavoriteUserVO;
	
	public class FavoriteUserList extends ModelLink
	{
		
		private var _uidList:Dictionary;
		private var _list:Vector.<User>;
		
		public function FavoriteUserList()
		{
			_uidList 		= new Dictionary;
			_list 			= new Vector.<User>;
		}
		
		public function get list():Vector.<User>
		{
			return _list;
		}
		
		public function hasFavorite(user:User):Boolean
		{
			return user.uid in _uidList;
		}
		
		public function add(user:User):Boolean
		{
			if( !hasFavorite(user) )
			{
				var favorite:FavoriteUserVO			= new FavoriteUserVO(user.uid);
				_uidList[user.uid]					= favorite;
				_list[_list.length] = user;
				model.db.save(favorite);
				return true;
			}
			return false;
		}
		
		public function remove(user:User):void
		{
			if( hasFavorite(user) )
			{
				var favorite:FavoriteUserVO = _uidList[user.uid];
				delete _uidList[user.uid];
				_list.splice(_list.indexOf(user), 1);
				model.db.remove(favorite);
			}
		}
		
		public function init():void
		{
			var list:Array 				= model.db.selectAll(FavoriteUserVO);
			var i:uint 					= _list.length;
			for each (var favorite:FavoriteUserVO in list) 
			{
				var user:User 			= model.userList.getByID(favorite.user);
				if( user )
				{
					_list[i++] 		= user;
					_uidList[favorite.user]	= favorite;	
				}
			}
		}
		
		public function reset():void
		{
			model.db.removeAll(FavoriteUserVO);
		}
		
		public function get dataProvider():IList
		{
			var ac:ArrayList = new ArrayList;
			const length:uint = _list.length;
			for( var i:uint = 0 ; i < length; i++)
			{
				ac.addItem(_list[i]);
			}
			return ac;
		}
	}
}