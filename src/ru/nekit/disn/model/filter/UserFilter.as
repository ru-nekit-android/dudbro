package ru.nekit.disn.model.filter
{
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.user.*;
	import ru.nekit.disn.model.vo.FriendshipRequestVO;
	
	public class UserFilter extends ModelLink
	{
		
		public function get allUsers():Vector.<User>
		{
			return sourceList;
		}
		
		public function get onlineUsers():Vector.<User>
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
		
		public function get offlineUsers():Vector.<User>
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
			return  model.userList.list;
		}
		
		public function get unusedUsers():Vector.<User>
		{
			var list:Vector.<User> =  sourceList;
			var result:Vector.<User> = new Vector.<User>;
			for each( var user:User in list )
			{
				var nonremoveble:Boolean = model.friendList.hasFriend( user ) 
					|| model.favoriteUserList.hasFavorite(user)
					|| model.messageTreeList.hasMesageTree(user);
				var request:FriendshipRequestVO = model.friendshipRequestList.getRequest(user);
				if( request )
				{
					nonremoveble ||=  model.friendshipRequestFilter.isActive(request);
				}
				if( !nonremoveble )
				{
					result.push(user);
				}
			}
			return result;	
		}
	}
}