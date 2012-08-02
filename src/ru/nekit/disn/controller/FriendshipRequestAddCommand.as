package ru.nekit.disn.controller
{
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.disn.CONST;
	import ru.nekit.disn.NAMES;
	import ru.nekit.disn.model.ModelProxy;
	import ru.nekit.disn.model.types.FriendshipRequestStatus;
	import ru.nekit.disn.model.types.NotificationType;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.vo.FriendshipRequestVO;
	import ru.nekit.utils.DataUtil;
	
	public class FriendshipRequestAddCommand extends SimpleCommand implements ICommand
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
				var text:String = notification.getBody() as String;
				if( DataUtil.isEmpty(text) )
				{
					text = CONST.FRIENDSHIP_REQUEST_ADD_TEXT;
				}
				if( model.friendList.hasFriend(user) )
				{
					return;
				}
				var request:FriendshipRequestVO = model.friendshipRequestList.getRequest(user);		
				if( request && ( model.friendshipRequestFilter.isFromMe(request) || model.friendshipRequestFilter.isToMe(request) ) )
				{
					return;
				}
				model.friendshipRequestList.save(user, FriendshipRequestStatus.FROM_ME, text);
				model.p2pUserChannel.friendshipAddRequest(user, text);
				sendNotification(NAMES.NOTIFICATION_STATUS_UPDATE, user, NotificationType.NOTIFICATION_FRIENDSHIP);
			}
		}
	}
}