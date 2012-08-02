package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.types.UserPrivateRule;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.view.views.PrivateRuleView;
	
	public class PrivateRuleMediator extends ViewMediator
	{
		
		public static const NAME:String = "privateRuleView";
		
		private var _view:PrivateRuleView = null;
		private var _localUser:LocalUserProxy; 
		
		public function PrivateRuleMediator(viewComponent:Object=null)
		{
			_view = viewComponent as PrivateRuleView;
			super(NAME, viewComponent);
		}
		
		public function get view():PrivateRuleView
		{
			return _view;
		}
		
		override protected function onMediatorRegister():void
		{
			_localUser = model.localUser;
		}
		
		override protected function onViewActive():void
		{			
			_view.saveCall.addEventListener(MouseEvent.CLICK, saveCallHandler);
			_view.cancelCall.addEventListener(MouseEvent.CLICK, cancelCallHandler);
		}
		
		override protected function onMediatorRemove():void
		{
			_view.saveCall.removeEventListener(MouseEvent.CLICK, saveCallHandler);
			_view.cancelCall.removeEventListener(MouseEvent.CLICK, cancelCallHandler);
			_view = null;
		}
		
		override protected function onViewAdd():void
		{
			_view.titleContainer.height = dpi.getAutoSize(60);
			updateRuleView();
		}
		
		private function updateRuleView():void
		{
			_view.ruleBirthday.selected 		= _localUser.hasDataAccessByField( UserPrivateRule.ALLOW_BIRTHDAY);
			_view.ruleSex.selected 				= _localUser.hasDataAccessByField( UserPrivateRule.ALLOW_SEX);
			_view.rulePhone.selected  			= _localUser.hasDataAccessByField( UserPrivateRule.ALLOW_PHONE);
			_view.ruleName.selected  			= _localUser.hasDataAccessByField( UserPrivateRule.ALLOW_NAME);
		}
		
		private function cancelCallHandler(event:MouseEvent):void
		{
			updateRuleView();
			back();	
		}
		
		private function saveCallHandler(event:MouseEvent):void
		{
			_localUser.user.vo.rule =   
				( _view.ruleBirthday.selected ? UserPrivateRule.ALLOW_BIRTHDAY : 0)
				| ( _view.ruleSex.selected ?  UserPrivateRule.ALLOW_SEX : 0)
				| ( _view.rulePhone.selected ?   UserPrivateRule.ALLOW_PHONE : 0)
				| ( _view.ruleName.selected ? UserPrivateRule.ALLOW_NAME : 0);
			_localUser.update();
			back();	
		}
	}
}