package ru.nekit.disn.controller
{
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.utils.DataUtil;
	
	public class PhoneCallCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{
			navigateToURL(new URLRequest("tel:"+ DataUtil.normalizePhoneNumber(notification.getBody() as String)));
		}
		
	}
}