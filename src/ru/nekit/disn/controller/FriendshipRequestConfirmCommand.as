package ru.nekit.disn.controller
{
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.disn.NAMES;
	import ru.nekit.disn.model.ModelProxy;
	import ru.nekit.disn.model.types.FriendshipRequestStatus;
	import ru.nekit.disn.model.types.NotificationType;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.vo.FriendshipRequestVO;
	
	public class FriendshipRequestConfirmCommand extends SimpleCommand implements ICommand
	{
		
		private static var model:ModelProxy;
		
		override public function execute(notification:INotification):void
		{
			if( !model )
			{
				model = facade.retrieveProxy(ModelProxy.NAME) as ModelProxy;
			}
			var user:User = model.currentUser.user.user;
			if( user ) 
			{
				if( model.friendList.hasFriend(user) )
				{
					return;
				}
				var request:FriendshipRequestVO = model.friendshipRequestList.getRequest(user);
				if( request && !model.friendshipRequestFilter.isRemoved(request) )
				{
					model.friendList.add(user);
					model.friendshipRequestList.save(user, FriendshipRequestStatus.CONFIRM_TO_ME);
					model.p2pUserChannel.friendshipConfirmRequest(user);
					sendNotification(NAMES.NOTIFICATION_STATUS_UPDATE, user, NotificationType.NOTIFICATION_FRIENDSHIP);
				}
			}
			else
			{
				
			}
		}
	}
}