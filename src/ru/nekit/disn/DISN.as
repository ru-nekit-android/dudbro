package ru.nekit.disn
{
	
	import flash.errors.IllegalOperationError;
	
	import mx.core.FlexGlobals;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	import ru.nekit.disn.controller.*;
	
	public final class DISN extends Facade implements IFacade
	{
		
		private static var _instance:DISN;
		private static var _instanceAllow:Boolean;
		
		public static function get instance():DISN
		{
			if( !_instance )
			{
				_instanceAllow 	= true;
				_instance		= new DISN;
				_instanceAllow	= false;
			}
			return _instance;
		}
		
		public function DISN()
		{
			if( _instanceAllow )
			{
				
			}
			else
			{
				throw new IllegalOperationError("You must use DISN.instance.");
			}
		}
		
		public function startup():void
		{
			sendNotification(NAMES.STARTUP, Main(FlexGlobals.topLevelApplication));
		}
		
		override protected function initializeController():void
		{
			
			super.initializeController();
			
			registerCommand(NAMES.STARTUP, 									StartUpCommand);
			
			registerCommand(NAMES.CONNECTION_CHECK,							ConnectionCheckCommand);
			
			registerCommand(NAMES.MODEL_INIT,								ModelInitCommand);
			
			registerCommand(NAMES.USER_ENTER,								UserEnterCommand);
			registerCommand(NAMES.USER_REGISTER, 							UserRegisterCommand);
			registerCommand(NAMES.USER_LOGIN, 								UserLoginCommand);
			registerCommand(NAMES.USER_INFORMATION_REQUEST,	 				UserInformationRequestCommand);
			
			registerCommand(NAMES.MESSAGE_SEND,								MessageSendCommand);
			
			registerCommand(NAMES.SELECT_MESSAGE, 							SelectMessageCommand);
			registerCommand(NAMES.SELECT_USER, 								SelectUserCommand);
			
			registerCommand(NAMES.FRIENDSHIP_REQUEST_ADD, 					FriendshipRequestAddCommand);
			registerCommand(NAMES.FRIENDSHIP_REQUEST_REMOVE,				FriendshipRequestRemoveCommand);
			registerCommand(NAMES.FRIENDSHIP_REQUEST_CONFIRM,				FriendshipRequestConfirmCommand);
			registerCommand(NAMES.FRIENDSHIP_REQUEST_ABORT,					FriendshipRequestAbortCommand);
			
			registerCommand(NAMES.PHONE_PHONE_CALL,							PhoneCallCommand);
			registerCommand(NAMES.PHONE_SEND_SMS,							PhoneSendSmsCommand);
			
			registerCommand(NAMES.APPLICATION_CLOSE,						ApplicationCloseCommand);
		}
	}
}