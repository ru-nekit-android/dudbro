package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.vo.AuthVO;
	import ru.nekit.disn.view.views.*;
	
	import spark.layouts.MultiDPIVerticalLayout;
	
	public class RegisterMediator extends ViewMediator
	{
		
		public static const NAME:String = "registerView";
		
		private var _view:RegisterView = null;
		
		public function RegisterMediator(viewComponent:Object=null)
		{
			_view = viewComponent as RegisterView;
			super(NAME, viewComponent);
		}
		
		public function get view():RegisterView
		{
			return _view;
		}
		
		override protected function onMediatorRegister():void
		{
			_view.registerCall.addEventListener(MouseEvent.CLICK, registerCallHandler);
			_view.password.addEventListener(FlexEvent.ENTER, textEnterHandler);
			_view.login.addEventListener(FlexEvent.ENTER, textEnterHandler);
		}
		
		override protected function onMediatorRemove():void
		{
			_view.registerCall.removeEventListener(MouseEvent.CLICK, registerCallHandler);
			_view.password.removeEventListener(FlexEvent.ENTER, textEnterHandler);
			_view.login.removeEventListener(FlexEvent.ENTER, textEnterHandler);
		}
		
		override protected function onViewAdd():void
		{
			_view.registerCall.height = dpi.getSize(56, 84, 112);
			_view.titleContainer.height = dpi.getSize(60, 90, 120);
			if( !dpi.is160 )
			{	
				MultiDPIVerticalLayout(_view.layoutContainer.layout).verticalAlign = "middle";
			}
		}
		
		override protected function onViewActive():void
		{
			if( dpi.is160 )
			{		
				setBottomSpacerSize()
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
				_view.bottomSpacer.height = _view.height - _view.mainContainer.height + 10;	
			}
		}
		
		private function registerCallHandler(event:MouseEvent = null):void
		{
			var authData:AuthVO 	= new AuthVO;
			authData.login 				= _view.login.text;
			authData.password			= _view.password.text;
			sendNotification(NAMES.USER_REGISTER, authData);
			sendNotification(NAMES.VIEW_GO, RememberMeView);
		}
		
		private function textEnterHandler(event:FlexEvent):void
		{
			registerCallHandler();
		}
	}
}