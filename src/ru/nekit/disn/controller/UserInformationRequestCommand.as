package ru.nekit.disn.controller
{
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.disn.NAMES;
	import ru.nekit.disn.model.ModelProxy;
	import ru.nekit.disn.model.events.UserEvent;
	import ru.nekit.disn.model.p2p.P2PUserChannel;
	import ru.nekit.disn.model.user.User;
	
	public class UserInformationRequestCommand extends SimpleCommand implements ICommand
	{
		
		private var channel:P2PUserChannel;
		
		override public function execute(notification:INotification):void
		{
			var user:User = notification.getBody() as User;
			channel = (facade.retrieveProxy(ModelProxy.NAME) as ModelProxy).p2pUserChannel;
			if( user.online )
			{	
				channel.addEventListener(UserEvent.GET_INFORMATION, getInformationHandler);
				channel.requestInformation(user);
			}
			else
			{
			}
		}
		
		private function getInformationHandler(event:UserEvent):void
		{
			sendNotification(NAMES.USER_GET_INFORMATION, event.user);
			channel.removeEventListener(UserEvent.GET_INFORMATION, getInformationHandler);
			channel = null;
		}
	}
}