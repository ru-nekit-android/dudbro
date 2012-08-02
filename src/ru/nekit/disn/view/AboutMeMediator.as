package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.types.UserPrivateRule;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.view.views.AboutMeView;
	
	public class AboutMeMediator extends ViewMediator
	{
		
		public static const NAME:String = "aboutMeView";
		
		private var _view:AboutMeView = null;
		private var _localUser:LocalUserProxy; 
		
		public function AboutMeMediator(viewComponent:Object=null)
		{
			_view = viewComponent as AboutMeView;
			super(NAME, viewComponent);
		}
		
		public function get view():AboutMeView
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
			_view.stage.focus = null;
			_view.field.setFocus();
			var text:String  = _localUser.user.vo.aboutMe || "";
			_view.field.selectRange(text.length, text.length);
		}
		
		override protected function onMediatorRemove():void
		{
			_view.saveCall.removeEventListener(MouseEvent.CLICK, saveCallHandler);
			_view.cancelCall.removeEventListener(MouseEvent.CLICK, cancelCallHandler);
		}
		
		override protected function onViewAdd():void
		{
			_view.field.prompt 		= CONST.ABOUT_ME_PROMPT;
			_view.field.text 		= _localUser.user.vo.aboutMe;
			_view.rule.selected 	= _localUser.hasDataAccessByField( UserPrivateRule.ALLOW_ABOUT_ME );
		}
		
		private function cancelCallHandler(event:MouseEvent):void
		{
			_view.field.text = _localUser.user.vo.aboutMe;
			back();
		}
		
		private function saveCallHandler(event:MouseEvent):void
		{
			_localUser.user.vo.aboutMe	= _view.field.text;
			_localUser.user.vo.rule		= _localUser.user.vo.rule | ( _view.rule.selected ? UserPrivateRule.ALLOW_ABOUT_ME : 0 );
			_localUser.update();
			back();
		}
	}
}