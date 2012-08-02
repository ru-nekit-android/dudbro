package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.types.UserPrivateRule;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.view.views.PhoneView;
	
	public class PhoneMediator extends ViewMediator
	{
		
		public static const NAME:String = "phoneView";
		
		private var _view:PhoneView = null;
		private var _localUser:LocalUserProxy; 
		
		public function PhoneMediator(viewComponent:Object=null)
		{
			_view = viewComponent as PhoneView;
			super(NAME, viewComponent);
			hasMenu = true;
		}
		
		public function get view():PhoneView
		{
			return _view;
		}
		
		override protected function onMediatorRegister():void
		{			
			_localUser = model.localUser;
		}
		
		private function setFocus():void
		{
			_view.focusManager.setFocus(_view.phone);
			var text:String = _localUser.user.vo.phone;
			_view.phone.selectRange(text.length, text.length);
		}
		
		override protected function onViewActive():void
		{			
			_view.saveCall.addEventListener(MouseEvent.CLICK, saveCallHandler);
			_view.cancelCall.addEventListener(MouseEvent.CLICK, cancelCallHandler);
			setFocus();
		}
		
		override protected function onMediatorRemove():void
		{
			_view.saveCall.removeEventListener(MouseEvent.CLICK, saveCallHandler);
			_view.cancelCall.removeEventListener(MouseEvent.CLICK, cancelCallHandler);
			_view = null;
		}
		
		override protected function onViewAdd():void
		{
			_view.phone.text = _localUser.user.vo.phone;
			_view.rule.selected = _localUser.hasDataAccessByField( UserPrivateRule.ALLOW_PHONE ); 
		}
		
		private function cancelCallHandler(event:MouseEvent):void
		{
			_view.phone.text = _localUser.user.vo.phone;
			back();
		}
		
		private function saveCallHandler(event:MouseEvent):void
		{
			_localUser.user.vo.rule		= _localUser.user.vo.rule | ( _view.rule.selected ? UserPrivateRule.ALLOW_PHONE : 0 );
			_localUser.user.vo.phone 	= _view.phone.text;
			_localUser.update();
			back();
		}
	}
}