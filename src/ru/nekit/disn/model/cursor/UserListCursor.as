package ru.nekit.disn.model.cursor
{
	
	import ru.nekit.disn.model.filter.ReplaceResult;
	import ru.nekit.disn.model.user.User;
	
	public class UserListCursor
	{
		
		private var _uidList:Object
		private var _list:Vector.<User>;
		
		public function UserListCursor(list:Vector.<User>, sortFunction:Function)
		{
			if( sortFunction == null )
			{
				_list = list
			}
			else
			{
				_list = list.sort(
					sortFunction
				);
			}
			_uidList 	= {};
			const length:uint = list.length;
			for( var i:uint = 0 ; i < length; i++ )
			{
				var item:User = list[i];
				_uidList[item.uid] = i;
			}
		}
		
		public function get list():Vector.<User>
		{
			return _list;
		}
		
		public function remove(user:User):int
		{
			var index:int = indexOf(user);
			if( index >= 0 )
			{
				delete _uidList[user.uid];
				_list.splice(index, 1);
			}
			return index;
		}
		
		public function checkOnReplace(user:User, valueFunction:Function = null):ReplaceResult
		{
			if( valueFunction == null )
			{
				valueFunction = simpleValueFunction;
			}
			var index:int = indexOf(user);
			var newIndex:int = -1;
			if( index != -1 )
			{
				var length:uint = _list.length;
				var need:Boolean = false;
				if( index == 0 )
				{
					if( length > index + 1)
					{
						need = valueFunction(user) > valueFunction(_list[index+1]);
					}
				}
				else if( index == length - 1 )
				{
					if( length > index - 1)
					{
						need = valueFunction(user) < valueFunction(_list[index-1]);
					}
				}
				else
				{
					need = valueFunction(user) > valueFunction(_list[index+1]) || valueFunction(user) < valueFunction(_list[index-1]);
				}
				if( need )
				{
					_list.splice(index, 1);
					var find:int = binarySearch(user, valueFunction);
					if( find < 0 )
					{
						newIndex =   -find - 1;
					}
					_list.splice(newIndex, 0, user);
					_uidList[user.uid] = newIndex;
				}
				else
				{
					return new ReplaceResult(-1, -1);
				}
			}
			else
			{
				return null;
			}
			return new ReplaceResult(index, newIndex);
		}
		
		public function add(user:User, valueFunction:Function = null):int
		{
			if( valueFunction == null )
			{
				valueFunction = simpleValueFunction;
			}
			var find:int = binarySearch(user, valueFunction);
			if( find < 0 )
			{
				find = -(find + 1);
			}
			_list.splice(find, 0, user);
			_uidList[user.uid] = find;
			return find;
		}
		
		public function indexOf(user:User):int
		{
			if( user.uid in _uidList )
			{
				return _uidList[user.uid];
			}
			return -1;
		}
		
		public function hasUser(user:User):Boolean
		{
			return indexOf(user) != -1;
		}
		
		private function binarySearch(user:User, valueFunction:Function):int
		{
			var left:int 	= 0;
			var right:int	= _list.length - 1;
			while (left <= right) {
				var middle:int 				= (left + right) / 2;
				var currentValue:String =	valueFunction(_list[middle]);
				var checkValue:String 	= valueFunction(user);
				if ( currentValue < checkValue )
					left = middle + 1;
				else if (currentValue > checkValue )
					right = middle - 1;
				else
					return middle;
			}
			return -(left + 1); 
		}
		
		public static function simpleSortFunction(a:User, b:User):int
		{
			var aname:String = simpleValueFunction(a);
			var bname:String = simpleValueFunction(b);
			if( aname < bname)
				return -1;
			if( aname > bname)
				return 1;
			return 0;
		}
		
		public static function onlineOfflineSortFunction(a:User, b:User):int
		{
			var aname:String = onlineOfflineValueFunction(a);
			var bname:String = onlineOfflineValueFunction(b);
			if( aname < bname)
				return -1;
			if( aname > bname)
				return 1;
			return 0;
		}
		
		public static function simpleValueFunction(user:User):String
		{
			return user.displayName;
		}
		
		public static function onlineOfflineValueFunction(user:User):String
		{
			return ( user.online ? "0" : "1" ) + user.displayName;
		}
		
		public function destroy():void
		{
			_list = null;
			_uidList = null;
		}
	}
}