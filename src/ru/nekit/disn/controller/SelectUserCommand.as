package ru.nekit.disn.controller
{
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.disn.model.ModelProxy;
	import ru.nekit.disn.model.user.User;
	
	public class SelectUserCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{
			var model:ModelProxy = facade.retrieveProxy(ModelProxy.NAME) as ModelProxy;
			if( model.currentUser.user.user )
			{
				model.subscriberList.unsubscribe(model.currentUser.user.user);
			}
			model.currentUser.user.user = notification.getBody() as User;
			model.subscriberList.subscribe(model.currentUser.user.user);
		}
	}
}