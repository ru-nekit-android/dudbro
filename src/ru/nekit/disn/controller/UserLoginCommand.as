package ru.nekit.disn.controller
{
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.ane.Device;
	import ru.nekit.disn.NAMES;
	import ru.nekit.disn.model.auth.Auth;
	import ru.nekit.disn.model.ModelProxy;
	
	public class UserLoginCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{
			var auth:Auth = (facade.retrieveProxy(ModelProxy.NAME) as ModelProxy).auth;
			var result:Boolean = auth.login(auth.vo.login, notification.getBody() as String);
			if( result )
			{
				sendNotification(NAMES.USER_ENTER);
			}
			else
			{
				sendNotification(NAMES.USER_LOGIN_FAULT);
				try{
					Device.instance.vibrate(500);
				}
				catch(error:Error)
				{
				}
			}
		}
	}
}