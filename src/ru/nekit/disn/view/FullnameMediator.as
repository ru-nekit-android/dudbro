package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.types.UserPrivateRule;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.view.views.FullnameView;
	
	public class FullnameMediator extends  ViewMediator
	{
		
		public static const NAME:String = "nameView";
		
		private var _view:FullnameView = null;
		private var _localUser:LocalUserProxy; 
		
		public function FullnameMediator(viewComponent:Object=null)
		{
			_view = viewComponent as FullnameView;
			super(NAME, viewComponent);
		}
		
		public function get view():FullnameView
		{
			return _view;
		}
		
		override protected function onMediatorRegister():void
		{			
			_localUser = model.localUser;
		}
		
		private function setFocus():void
		{
			_view.focusManager.setFocus(_view.firstname);
			var text:String = _localUser.user.firstname;
			_view.firstname.selectRange(text.length, text.length);
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
		}
		
		override protected function onViewAdd():void
		{
			_view.sirname.text 		= _localUser.user.sirname;
			_view.firstname.text 	= _localUser.user.firstname;
			_view.middlename.text 	= _localUser.user.middlename;
			_view.rule.selected 	= _localUser.hasDataAccessByField( UserPrivateRule.ALLOW_NAME );
		}
		
		private function cancelCallHandler(event:MouseEvent):void
		{
			_view.sirname.text 			= _localUser.user.sirname;
			_view.firstname.text 		= _localUser.user.firstname;
			_view.middlename.text 		= _localUser.user.middlename;
			back();
		}
		
		private function saveCallHandler(event:MouseEvent):void
		{
			_localUser.user.sirname 		= _view.sirname.text;
			_localUser.user.firstname 		= _view.firstname.text;
			_localUser.user.middlename 		= _view.middlename.text;
			_localUser.user.vo.rule			= _localUser.user.vo.rule | ( _view.rule.selected ? UserPrivateRule.ALLOW_NAME : 0 );
			_localUser.update();
			back();
		}
	}
}