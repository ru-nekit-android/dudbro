package ru.nekit.disn.view
{
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import ru.nekit.disn.NAMES;
	import ru.nekit.disn.model.ModelProxy;
	import ru.nekit.disn.model.user.User;
	
	import spark.components.Button;
	
	public class MainMenuButtonMediator extends Mediator
	{
		
		public static const NAME:String = "mainMenuButton";
		
		private static var model:ModelProxy;
		
		public function MainMenuButtonMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			if( !model )
			{
				model = facade.retrieveProxy(ModelProxy.NAME) as ModelProxy;
			}
			updateStatus();
		}
		
		public function get button():Button
		{
			return viewComponent as Button;
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
			var user:User;	
			switch( name )
			{	
				
				case NAMES.NOTIFICATION_STATUS_UPDATE:
					
					updateStatus();
					
					break;
				
				default:
					break;
				
			}
		}
		
		private function updateStatus():void
		{
			var count:uint = model.notificationMessageTreeList.length;
			count += model.friendshipRequestFilter.toME.length;
			button.label = count ?  "+" + count : null;
		}
	}
}