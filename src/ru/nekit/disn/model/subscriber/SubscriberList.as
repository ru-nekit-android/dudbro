package ru.nekit.disn.model.subscriber
{
	
	import flash.utils.Dictionary;
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.vo.UserDataVO;
	
	public class SubscriberList extends ModelLink
	{
		private var _uidList:Dictionary;
		
		public function SubscriberList()
		{
			_uidList = new Dictionary;
		}
		
		public function updateUserData(data:UserDataVO):void
		{
			sendDataToSubscribers(data, LocalUserProxy.USER, LocalUserProxy.UPDATE_DATA);
		}
		
		public function sendDataToSubscribers(data:*, type:String, command:String):void
		{
			model.p2pUserChannel.sendToAllUsers(data, command);
		}
		
		private function needSubscribe(user:User):Boolean
		{
			return !model.friendList.hasFriend( user );
		}
		
		public function subscribe(user:User):void
		{
			if( needSubscribe( user ) )
			{
				model.p2pUserChannel.sendToAllUsers(null, LocalUserProxy.SUBSCRIBE);
			}
		}
		
		public function unsubscribe(user:User):void
		{
			if( needSubscribe( user ) )
			{
				model.p2pUserChannel.sendToUser(user, null, LocalUserProxy.UNSUBSCRIBE);
			}
		}
		
		public function hasSubscriber(user:User):Boolean
		{
			return user.uid in _uidList;
		}
		
		public function add(user:User):void
		{
			if( !hasSubscriber(user) )
			{
				_uidList[user.uid] = user;	
			}	
		}
		
		public function remove(user:User):void
		{
			if( hasSubscriber(user) )
			{
				delete _uidList[user.uid];	
			}
		}
	}
}