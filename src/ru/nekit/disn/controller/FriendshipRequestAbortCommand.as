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
	
	public class FriendshipRequestAbortCommand extends SimpleCommand implements ICommand
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
				if( request )
				{
					if( request.status == FriendshipRequestStatus.TO_ME )
					{
						model.friendshipRequestList.save(user, FriendshipRequestStatus.ABORTED);
						model.p2pUserChannel.friendshipAbortRequest(user);
						sendNotification(NAMES.NOTIFICATION_STATUS_UPDATE, user, NotificationType.NOTIFICATION_FRIENDSHIP);
					}
				}
			}
		}
	}
}