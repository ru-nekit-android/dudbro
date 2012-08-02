package ru.nekit.disn.controller
{
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import ru.nekit.disn.NAMES;
	import ru.nekit.disn.model.ModelProxy;
	import ru.nekit.disn.model.events.ExtendedMessageEvent;
	import ru.nekit.disn.model.p2p.P2PUserChannel;
	
	public class MessageSendCommand extends SimpleCommand implements ICommand
	{
		
		private static var model:ModelProxy;
		private static var channel:P2PUserChannel;
		
		override public function execute(notification:INotification):void
		{
			if( !model )
			{
				model					= facade.retrieveProxy(ModelProxy.NAME) as ModelProxy;
			}
			if( !channel )
			{
				channel = model.p2pUserChannel;
				channel.addEventListener(ExtendedMessageEvent.SENT_SUCCESS, sendSuccessHandler);
			}
			channel.sendMessage(notification.getBody(),  model.currentUser.message.user);
		}
		
		private static function sendSuccessHandler(event:ExtendedMessageEvent):void
		{
			model.sendNotification(NAMES.MESSAGE_SEND_SUCCESS, event.message);
		}
	}
}