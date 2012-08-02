package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.view.views.LoginView;
	
	import spark.events.TextOperationEvent;
	import spark.layouts.MultiDPIVerticalLayout;
	import spark.layouts.VerticalLayout;
	
	public class LoginMediator extends ViewMediator
	{
		
		public static const NAME:String = "loginView";
		
		private var _view:LoginView = null;
		private var chromeColor:Number;
		
		public function LoginMediator(viewComponent:Object=null)
		{
			_view = viewComponent as LoginView;
			super(NAME, viewComponent);
		}
		
		public function get view():LoginView
		{
			return _view;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NAMES.USER_LOGIN_FAULT
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
			var body:Object = notification.getBody();
			var name:String = notification.getName();
			
			switch( name )
			{
				
				case NAMES.USER_LOGIN_FAULT:
					
					chromeColor = _view.passwordContainer.getStyle("chromeColor") as Number;
					_view.passwordContainer.setStyle("chromeColor", 0xFF0000);
					
					break;
				
				default:
					break;
				
			}
		}
		
		override protected function onMediatorRegister():void
		{
			_view.loginCall.addEventListener(MouseEvent.CLICK, loginCallHandler);
			_view.password.addEventListener(TextOperationEvent.CHANGE, textInputHandler);
		}
		
		private function textInputHandler(event:TextOperationEvent):void
		{
			if( chromeColor > 0 )
			{
				_view.passwordContainer.setStyle("chromeColor", chromeColor);
			}
		}
		
		override protected function onMediatorRemove():void
		{
			_view.loginCall.removeEventListener(MouseEvent.CLICK, loginCallHandler);
		}
		
		override protected function onViewAdd():void
		{
			cacheAsBitmap(_view.mainContainer);
			_view.loginCall.height = dpi.getAutoSize(50);
			_view.titleContainer.height = dpi.getAutoSize(60);
			if( !dpi.is160 )
			{
				MultiDPIVerticalLayout(_view.layoutContainer.layout).verticalAlign = "middle";
			}
		}
		
		private function setBottomSpacerSize(zero:Boolean = false):void
		{
			if( zero )
			{
				_view.bottomSpacer.height = 0;
			}
			else
			{
				_view.bottomSpacer.height = _view.height - _view.mainContainer.height - (_view.layoutContainer.layout as VerticalLayout).gap*2;	
			}
		}
		
		override protected function onViewActive():void
		{
			if( dpi.is160 )
			{	
				setBottomSpacerSize();
			}
		}
		
		private function loginCallHandler(event:MouseEvent = null):void
		{
			sendNotification(NAMES.USER_LOGIN, _view.password.text);	
		}
	}
}