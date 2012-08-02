package ru.nekit.disn.model.filter
{
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.types.FriendshipRequestStatus;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.vo.FriendshipRequestVO;
	
	public class FriendshipRequestFilter extends ModelLink
	{
		
		public function get toME():Vector.<User>
		{
			return sourceList.filter(function(user:User, index:int, vector:Vector.<User>):Boolean
			{
				var request:FriendshipRequestVO = model.friendshipRequestList.getRequest(user);
				return request && isToMe(request);
			}
			);
		}
		
		public function get fromME():Vector.<User>
		{
			return sourceList.filter(function(user:User, index:int, vector:Vector.<User>):Boolean
			{
				var request:FriendshipRequestVO =  model.friendshipRequestList.getRequest(user);
				return request && isFromMe(request);
			}
			);
		}
		
		public function get confirmFromME():Vector.<User>
		{
			return sourceList.filter(function(user:User, index:int, vector:Vector.<User>):Boolean
			{
				var request:FriendshipRequestVO =  model.friendshipRequestList.getRequest(user);
				return request && isConfirmedFromMe(request.status);
			}
			);
		}
		
		public function isFromMe(request:FriendshipRequestVO):Boolean
		{
			return (request.status == FriendshipRequestStatus.FROM_ME_SUCCESS || request.status == FriendshipRequestStatus.FROM_ME) && !isRemoved(request);
		}
		
		public function isToMe(request:FriendshipRequestVO):Boolean
		{
			return request.status == FriendshipRequestStatus.TO_ME;
		}
		
		public function isConfirmedToMe(request:FriendshipRequestVO):Boolean
		{
			return request.status == FriendshipRequestStatus.CONFIRM_TO_ME;
		}
		
		public function isConfirmedFromMe(request:FriendshipRequestVO):Boolean
		{
			return request.status == FriendshipRequestStatus.CONFIRM_FROM_ME;
		}
		
		public function isAborted(request:FriendshipRequestVO):Boolean
		{
			return request.status == FriendshipRequestStatus.ABORTED;
		}
		
		public function isAbortedFromMe(request:FriendshipRequestVO):Boolean
		{
			return request.status == FriendshipRequestStatus.ABORTED_FROM_ME;
		}
		
		public function isRemoved(request:FriendshipRequestVO):Boolean
		{
			return request.status == FriendshipRequestStatus.REMOVED;
		}
		
		public function isActive(request:FriendshipRequestVO):Boolean
		{
			return isFromMe(request) || isToMe(request) || isConfirmedFromMe(request) || isConfirmedToMe(request);
		}
		
		public function get sourceList():Vector.<User>
		{
			return  model.friendshipRequestList.list;
		}
	}
}