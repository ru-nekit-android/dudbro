package ru.nekit.disn.model.viewBuilder
{
	
	import mx.collections.ArrayList;
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.dataProvider.DataProviderFunction;
	import ru.nekit.disn.model.photo.Photo;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.user.user_internal;
	import ru.nekit.disn.model.vo.FriendshipRequestVO;
	
	use namespace user_internal;
	
	public class UserViewBuilder extends ModelLink
	{
		
		private var _photoProxy:Photo;
		
		private var _userListDataProviderFunction:DataProviderFunction;
		private var _friendListDataProviderFunction:DataProviderFunction;
		private var _friendshipListDataProviderFunction:DataProviderFunction;
		
		public function UserViewBuilder()
		{
			_photoProxy						= new Photo(null);
		}
		
		public function get userListDataProviderFunction():DataProviderFunction
		{
			if( !_userListDataProviderFunction	)
			{
				_userListDataProviderFunction = new DataProviderFunction
					(
						function(user:User):String
						{
							return user.displayName;
						}
						,
						function(user:User):String
						{
							return user.online ? "В сети"  : "Не в сети";
						}
						,
						function (user:User):Object
						{
							_photoProxy.vo = user.photoVO;
							return _photoProxy.source;
						}
						,
						null
					)
			}
			return _userListDataProviderFunction;
		}
		
		public function get friendListDataProviderFunction():DataProviderFunction
		{
			if( !_friendListDataProviderFunction )
			{
				_friendListDataProviderFunction = new DataProviderFunction
					(
						userListDataProviderFunction.labelFunction
						,
						userListDataProviderFunction.messageFunction
						,
						userListDataProviderFunction.iconFunction
						,
						null
					)
			}
			return _friendListDataProviderFunction;
		}
		
		public function get friendshipListDataProviderFunction():DataProviderFunction
		{
			if( !_friendshipListDataProviderFunction )
			{
				_friendshipListDataProviderFunction = new DataProviderFunction
					(
						userListDataProviderFunction.labelFunction
						,
						function(user:User):String
						{
							var request:FriendshipRequestVO = model.friendshipRequestList.getRequest(user);
							if( request )
							{
								return request.date.toTimeString();
							}
							return "";
						}
						,
						userListDataProviderFunction.iconFunction
						,
						null
					)
			}
			return _friendshipListDataProviderFunction;
		}
		
		public function toDataProvider(value:Vector.<User>):ArrayList
		{
			return new ArrayList(toArray(value));
		}
		
		public function toArray(value:Vector.<User>):Array
		{
			var result:Array = new Array;
			value.forEach(
				function (item:User, index:int, array:Vector.<User>):void
				{
					result.push(item);
				}
			);
			return result;
		}
	}
}