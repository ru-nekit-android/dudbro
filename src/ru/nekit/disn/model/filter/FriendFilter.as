package ru.nekit.disn.model.filter
{
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.user.User;
	
	public class FriendFilter extends ModelLink
	{
		
		public function get allFriends():Vector.<User>
		{
			return sourceList;
		}
		
		public function get onlineFriends():Vector.<User>
		{
			var list:Vector.<User> = sourceList;
			var result:Vector.<User> = new Vector.<User>;
			const length:uint = list.length;
			for( var i:uint = 0; i < length; i++)
			{
				var user:User = list[i];
				if( user.online )
				{
					result.push(user);
				}
			}
			return result;
		}
		
		public function get offlineFriends():Vector.<User>
		{
			var list:Vector.<User> = sourceList;
			var result:Vector.<User> = new Vector.<User>;
			const length:uint = list.length;
			for( var i:uint = 0; i < length; i++)
			{
				var user:User = list[i];
				if( !user.online )
				{
					result.push(user);
				}
			}
			return result;
		}
		
		public function get sourceList():Vector.<User>
		{
			return model.friendList.list;
		}
	}
}