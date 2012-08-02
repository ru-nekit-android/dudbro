package ru.nekit.disn.controller
{
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.disn.NAMES;
	import ru.nekit.disn.model.ModelProxy;
	import ru.nekit.disn.model.types.NotificationType;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.user.user_internal;
	
	use namespace user_internal;
	
	public class SelectMessageCommand extends SimpleCommand implements ICommand
	{
		
		private static var model:ModelProxy;
		
		override public function execute(notification:INotification):void
		{
			if( !model )
			{
				model					= facade.retrieveProxy(ModelProxy.NAME) as ModelProxy;
			}
			var user:User 				= notification.getBody() as User;
			model.currentUser.message.user 	= user;
			model.notificationMessageTreeList.remove(user.uid);
			sendNotification(NAMES.NOTIFICATION_STATUS_UPDATE, null, NotificationType.NOTIFICATION_MESSAGE);
		}
	}
}