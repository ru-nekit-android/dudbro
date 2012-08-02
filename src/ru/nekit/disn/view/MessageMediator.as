package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	
	import mx.collections.ArrayList;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.phone.SMSData;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.viewDataItem.UserMenuDataItem;
	import ru.nekit.disn.model.vo.*;
	import ru.nekit.disn.view.views.MessageView;
	import ru.nekit.utils.DataUtil;
	
	import spark.components.Button;
	import spark.renderers.MessageFromMeItemRenderer;
	import spark.renderers.MessageToMeItemRenderer;
	
	public class MessageMediator extends ViewMediator
	{
		
		public static const NAME:String = "messageView";
		
		private var _view:MessageView = null;
		private var _messageToMeClassFactory:IFactory;
		private var _messageFromMeClassFactory:IFactory;
		private var _softKeyboardActive:Boolean;
		
		public function MessageMediator(viewComponent:Object=null)
		{
			_view = viewComponent as MessageView;
			super(NAME, viewComponent);
			_messageFromMeClassFactory 	= new ClassFactory(MessageFromMeItemRenderer);
			_messageToMeClassFactory 	= new ClassFactory(MessageToMeItemRenderer);
		}
		
		public function get view():MessageView
		{
			return _view;
		}
		
		override protected function get backButton():Button
		{
			return _view.backCall;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NAMES.MESSAGE_SEND_SUCCESS,
				NAMES.MESSAGE_RECEIVED,
				NAMES.USER_ADD,
				NAMES.USER_EXIT,
				NAMES.USER_PING,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
			var body:Object = notification.getBody();
			var name:String = notification.getName();
			var user:User;
			var eMessage:ExtendedMessageVO;
			switch( name )
			{
				
				case NAMES.MESSAGE_SEND_SUCCESS:
				case NAMES.MESSAGE_RECEIVED:
					
					eMessage = ExtendedMessageVO(body);
					messageListDataProvider.addItem(model.messageViewBuilder.convertToMessageDataItem(eMessage));
					user = model.userList.getByID(eMessage.sender);
					if( user && user.uid == model.currentUser.message.user.uid )
					{
						updateCurrentState();
					}
					
					break;
				
				case NAMES.USER_ADD:
					
					user = body as User;
					if( user.uid == model.currentUser.message.user.uid )
					{
						currentState = "online";
						model.currentUser.message.ping.start();
					}
					
					break;
				
				case NAMES.USER_EXIT:
					
					user = body as User;
					if( user.uid == model.currentUser.message.user.uid )
					{
						currentState = "offline";
						model.currentUser.message.ping.stop();
					}
					
					break;
				
				case NAMES.USER_PING:
					
					user = body as User;
					if( user.uid == model.currentUser.message.user.uid )
					{
						updateCurrentState();
					}
					
					break;
				
				default:
					break;
				
			}
		}
		
		private function updateCurrentState():void
		{
			currentState = model.currentUser.message.online ? "online" : "offline";
		}
		
		override protected function get actionInterests():Array
		{
			return[
				_view.sendCall,
			]
		}
		
		override protected function onViewAdd():void
		{
			MessageView.dataProviderFunction = model.messageViewBuilder.messageDataProviderFunction;
			title = "Чат с " + model.currentUser.message.nickname;
			updateCurrentState();
			_view.list.itemRendererFunction = messageItemRendererFunction;
			_view.list.dataProvider = model.messageViewBuilder.getMessageList(model.currentUser.message.user);
		}
		
		private function messageItemRendererFunction(data:UserMenuDataItem):IFactory
		{
			if( data.user == model.localUser.user )
			{
				return _messageFromMeClassFactory;
			}
			return _messageToMeClassFactory;
		}
		
		override protected function onViewActive():void
		{
			_view.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,softKeyboardActivateHandler);
			_view.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, softKeyboardDeactivateHandler);
		}
		
		private function softKeyboardDeactivateHandler(event:SoftKeyboardEvent):void
		{
			_softKeyboardActive = false;
		}
		
		private function softKeyboardActivateHandler(event:SoftKeyboardEvent):void
		{
			_softKeyboardActive = true;
		}
		
		private function get messageListDataProvider():ArrayList
		{
			return ArrayList(_view.list.dataProvider);
		}
		
		override protected function onViewRemove():void
		{
			_view.list.dataProvider.removeAll();
			_view.list.dataProvider =  null;
			_view = null;
		}
		
		override protected function onMediatorRemove():void
		{
			model.currentUser.message.ping.stop();
			_view.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE,softKeyboardActivateHandler);
			_view.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, softKeyboardDeactivateHandler);
		}
		
		override protected function actionCallHandler(event:MouseEvent):void
		{
			var target:Object = event.currentTarget;
			if( target == _view.sendCall )
			{	
				if( !DataUtil.isEmpty(_view.messageInput.text) )
				{
					if( model.currentUser.message.online ) 
					{
						sendNotification(NAMES.MESSAGE_SEND, _view.messageInput.text);
						_view.messageInput.text = "";
						_view.messageInput.setFocus();
					}
					else
					{
						if( _softKeyboardActive )
						{
							_view.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, keyboardDeactivateHandler);
							_view.sendCall.setFocus();
						}
						else
						{
							showSMSMenu();	
						}
					}
				}
			}
		}
		
		private function showSMSMenu():void
		{
			if( !DataUtil.isEmpty( model.currentUser.message.phone ) )
			{
				sendNotification(NAMES.MENU_OPEN);
				_view.smsCall.addEventListener(MouseEvent.CLICK, smsClickHandler);
			}
		}
		
		private function keyboardDeactivateHandler(event:SoftKeyboardEvent):void
		{
			_view.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, keyboardDeactivateHandler);
			showSMSMenu();
		}
		
		private function smsClickHandler(event:MouseEvent):void
		{
			_view.smsCall.removeEventListener(MouseEvent.CLICK, smsClickHandler);
			sendNotification(NAMES.PHONE_SEND_SMS, new SMSData(model.currentUser.message.phone, _view.messageInput.text));
		}
	}
}