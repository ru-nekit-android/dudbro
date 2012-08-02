package ru.nekit.disn.controller
{
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.disn.NAMES;
	import ru.nekit.disn.manager.network.NetworkInfoManager;
	import ru.nekit.disn.model.ModelProxy;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.view.views.CheckConnectionView;
	import ru.nekit.disn.view.views.StudentProfileView;
	
	public class UserEnterCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{
			var localUser:LocalUserProxy = (facade.retrieveProxy(ModelProxy.NAME) as ModelProxy).localUser;
			localUser.init();
			var networkInfoManager:NetworkInfoManager = NetworkInfoManager.instance;
			if( true/*networkInfoManager.wifiIsActive*/ )
			{
				localUser.user.online = true;
				sendNotification(NAMES.VIEW_GO, StudentProfileView);
			}
			else
			{
				sendNotification(NAMES.VIEW_GO, CheckConnectionView);
			}
		}	
	}
}