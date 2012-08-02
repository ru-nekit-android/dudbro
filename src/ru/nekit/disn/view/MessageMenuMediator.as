package ru.nekit.disn.view
{
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.events.IndexChangedEvent;
	
	import org.puremvc.as3.interfaces.*;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.types.NotificationType;
	import ru.nekit.disn.model.viewDataItem.MenuDataItem;
	import ru.nekit.disn.view.views.*;
	
	import spark.components.Button;
	import spark.events.IndexChangeEvent;
	
	public class MessageMenuMediator extends ViewMediator
	{
		
		public static const NAME:String = "messageMenuView";
		
		public static const ACTION_ALL:String = "all";
		public static const ACTION_NEW:String = "new";
		
		private var _view:MessageMenuView = null;
		private var _newMessageMenuItem:MenuDataItem;
		
		
		public function MessageMenuMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_view = viewComponent as MessageMenuView;
		}
		
		public function get view():MessageMenuView
		{
			return _view;
		}
		
		override protected function get mainMenuButton():Button
		{
			return _view.mainMenu;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NAMES.NOTIFICATION_STATUS_UPDATE,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
			var body:Object = notification.getBody();
			var name:String = notification.getName();
			var type:String	= notification.getType();
			switch( name )
			{			
				
				case NAMES.NOTIFICATION_STATUS_UPDATE:
					
					switch( type )
					{
						
						case NotificationType.NOTIFICATION_MESSAGE:
							
							updateNewMessageMenuItem()
							
							break;
						default:
							break;
						
					}
					
				default:
					break;
				
			}
		}
		
		private function get menuDataProvider():IList
		{
			return new ArrayList(
				[
					updateNewMessageMenuItem(),
					new MenuDataItem("Все", ACTION_ALL),
				]
			);
		}
		
		private function updateNewMessageMenuItem():MenuDataItem
		{
			var count:uint = model.notificationMessageTreeList.length;
			if( !_newMessageMenuItem )
			{
				_newMessageMenuItem = new MenuDataItem("Новые", ACTION_NEW );
			}
			_newMessageMenuItem.hint = count.toString();
			return _newMessageMenuItem;
		}
		
		override protected function onMediatorRegister():void
		{
			
		}
		
		override protected function onViewAdd():void
		{
			_view.menu.dataProvider = menuDataProvider;
		}
		
		override protected function onViewActive():void
		{
			_view.menu.addEventListener(IndexChangeEvent.CHANGE, menuHandler);
		}
		
		private function menuHandler(event:IndexChangeEvent):void
		{
			var action:String = (_view.menu.dataProvider.getItemAt(event.newIndex) as MenuDataItem).action as String;
			sendNotification(NAMES.SET_VIEW_DATA, action);
			sendNotification(NAMES.VIEW_GO, MessageListView);
		}
		
		override protected function onMediatorRemove():void
		{
			_view.menu.removeEventListener(IndexChangedEvent.CHANGE, menuHandler);
			_view = null;
		}
	}
}