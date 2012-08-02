package ru.nekit.disn.view
{
	
	import mx.collections.ArrayList;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.message.MessageTree;
	import ru.nekit.disn.view.views.MessageListView;
	import ru.nekit.disn.view.views.MessageView;
	
	import spark.components.Button;
	import spark.events.IndexChangeEvent;
	
	public class MessageListMediator extends ViewMediator
	{
		
		public static const NAME:String = "messageListView";
		
		private var _view:MessageListView = null;
		
		private var _messageTreeList:Vector.<MessageTree>;
		private var _action:String;
		
		public function MessageListMediator(viewComponent:Object=null)
		{
			_view = viewComponent as MessageListView;
			super(NAME, viewComponent);
			hasMenu = true;
		}
		
		override protected function get backButton():Button
		{
			return _view.backCall;
		}
		
		override protected function get mainMenuButton():Button
		{
			return _view.mainMenu;
		}
		
		public function get view():MessageListView
		{
			return _view;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NAMES.MESSAGE_RECEIVED
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
			var body:Object = notification.getBody();
			var name:String = notification.getName();
			
			switch( name )
			{
				
				case NAMES.MESSAGE_RECEIVED:
					
					updateMessageTreeList();
					currentState = "normal";
					_view.list.dataProvider	= model.messageViewBuilder.toTreeDataProvider(_messageTreeList);
					
					break;
				
				default:
					break;
				
			}
			
		}
		
		public function get messageListDataProvider():ArrayList
		{
			return ArrayList(_view.list.dataProvider);
		}	
		
		private function updateMessageTreeList():void
		{
			switch( _action )
			{
				
				case MessageMenuMediator.ACTION_ALL:
					
					_messageTreeList = model.messageFilter.allMessages;
					
					break;
				
				case MessageMenuMediator.ACTION_NEW:
					
					_messageTreeList = model.messageFilter.newMessages;
					
					break;
				
				default:
					break;
			}
		}
		
		override protected function stateChangeComplete(state:String):void
		{
			if( state == "normal" )
			{
				if( !_view.list.hasEventListener(IndexChangeEvent.CHANGE) )
				{
					_view.list.addEventListener(IndexChangeEvent.CHANGE, menuHandler);
				}
			}
		}
		
		override protected function onMediatorRegister():void
		{
			MessageListView.dataProviderFunction 	= model.messageViewBuilder.messageTreeDataProviderFunction;
			_action = data as String;
			updateMessageTreeList();
		}
		
		override protected function onViewActive():void
		{
			if( _view.list )
			{
				_view.list.addEventListener(IndexChangeEvent.CHANGE, menuHandler);
			}
		}
		
		override protected function onViewAdd():void
		{
			switch( _action )
			{
				
				case MessageMenuMediator.ACTION_ALL:
					
					title = "Все сообщения";
					
					break;
				
				case MessageMenuMediator.ACTION_NEW:
					
					title = "Новые сообщения";
					
					break;
				
				default:
					break;
				
			}
			if( _messageTreeList.length == 0 )
			{
				currentState = "empty";
			}
			else
			{
				currentState = "normal";
			}
			if( _view.list )
			{
				_view.list.dataProvider	= model.messageViewBuilder.toTreeDataProvider(_messageTreeList);
			}
			else
			{
				_view.list.dataProvider	= new ArrayList;
			}
		}
		
		private function menuHandler(event:IndexChangeEvent):void
		{
			sendNotification(NAMES.SELECT_MESSAGE, (_view.list.dataProvider.getItemAt(event.newIndex) as MessageTree).user);
			sendNotification(NAMES.VIEW_GO, MessageView);
		}
		
		override protected function onMediatorRemove():void
		{
			if( _view.list )
			{
				_view.list.removeEventListener(IndexChangeEvent.CHANGE, menuHandler);
			}
		}
		
		override protected function onViewRemove():void
		{
			if( _view.list )
			{
				_view.list.dataProvider.removeAll();
				_view.list.dataProvider = null;
			}
			_view = null;
		}
	}
}