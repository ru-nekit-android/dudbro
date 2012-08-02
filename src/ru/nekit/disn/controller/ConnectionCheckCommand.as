package ru.nekit.disn.controller
{
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.disn.manager.network.NetworkInfoManager;
	
	public class ConnectionCheckCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{
			var networkInfoManager:NetworkInfoManager = NetworkInfoManager.instance;
			if( networkInfoManager.wifiIsActive )
			{
				
				
			}
			else
			{
				
			}
		}
	}
}