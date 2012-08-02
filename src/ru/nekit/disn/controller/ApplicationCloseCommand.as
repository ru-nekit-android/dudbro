package ru.nekit.disn.controller
{
	
	import flash.desktop.NativeApplication;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.disn.model.ModelProxy;
	
	public class ApplicationCloseCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{
			var model:ModelProxy = facade.retrieveProxy(ModelProxy.NAME) as ModelProxy;
			if( model.properties.vo.removeUnusedUsersAfterExit )
			{
				model.userList.removeList(model.userFilter.unusedUsers);
			}
			model.localUser.exit();
			setTimeout(function():void{
				model.p2p.close();
				NativeApplication.nativeApplication.exit();
			}, 500);
		}
	}
}