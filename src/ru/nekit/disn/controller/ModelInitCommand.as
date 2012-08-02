package ru.nekit.disn.controller
{
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.disn.NAMES;
	import ru.nekit.disn.model.ModelProxy;
	
	public class ModelInitCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{
			
			var model:ModelProxy = facade.retrieveProxy(ModelProxy.NAME) as ModelProxy;
			model.init();
			
			facade.removeCommand(NAMES.STARTUP);
			facade.removeCommand(NAMES.USER_REGISTER);
			facade.removeCommand(NAMES.USER_LOGIN);
			facade.removeCommand(NAMES.USER_ENTER);
			facade.removeCommand(NAMES.MODEL_INIT);
			
			sendNotification(NAMES.MODEL_INIT_COMPLETE);
			
		}	
	}
}