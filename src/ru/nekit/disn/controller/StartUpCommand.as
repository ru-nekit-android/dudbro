package ru.nekit.disn.controller
{
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.disn.NAMES;
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.ModelProxy;
	import ru.nekit.disn.model.auth.Auth;
	import ru.nekit.disn.view.ApplicationMediator;
	import ru.nekit.disn.view.views.LoginView;
	import ru.nekit.disn.view.views.RegisterView;
	
	public class StartUpCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{
			facade.registerMediator(new ApplicationMediator(notification.getBody()));
			facade.registerProxy(ModelLink.model = new ModelProxy);
			var auth:Auth = ModelLink.model.auth;
			//auth.reset();
			auth.init();
			if( auth.isFirstLogin )
			{
				sendNotification(NAMES.VIEW_GO, RegisterView);
			}
			else
			{
				if( auth.vo.remember )
				{
					sendNotification(NAMES.USER_ENTER);
				}
				else
				{
					sendNotification(NAMES.VIEW_GO, LoginView);
				}
			}
			sendNotification(NAMES.INIT_COMPLETE);
		}
	}
}