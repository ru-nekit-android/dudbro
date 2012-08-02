package ru.nekit.disn.controller
{
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.disn.NAMES;
	import ru.nekit.disn.model.ModelProxy;
	import ru.nekit.disn.model.vo.AuthVO;
	
	public class UserRegisterCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{
			var model:ModelProxy = facade.retrieveProxy(ModelProxy.NAME) as ModelProxy;
			var authData:AuthVO = notification.getBody() as AuthVO;
			model.auth.register(authData.login, authData.password, false);
			model.localUser.register(model.auth.vo.login, model.auth.vo.password);
			sendNotification(NAMES.USER_ENTER);
		}	
	}
}