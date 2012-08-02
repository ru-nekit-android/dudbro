package ru.nekit.disn.controller
{
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.ane.Device;
	import ru.nekit.disn.model.phone.SMSData;
	import ru.nekit.utils.DataUtil;
	
	public class PhoneSendSmsCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{
			var sms:SMSData = notification.getBody() as SMSData;
			Device.instance.goSMSActivity(DataUtil.normalizePhoneNumber(sms.phoneNumber), sms.body);
		}
	}
}