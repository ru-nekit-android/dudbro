package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.types.UserPrivateRule;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.view.views.BirthdayView;
	
	import spark.formatters.DateTimeFormatter;
	
	public class BirthdayMediator extends ViewMediator
	{
		
		public static const NAME:String = "birthdayView";
		
		private var _view:BirthdayView = null;
		private var _date:Date;
		private var _localUser:LocalUserProxy; 
		
		public function BirthdayMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_view = viewComponent as BirthdayView;
			waitOnBack = true;
			waitTime = 500;
		}
		
		public function get view():BirthdayView
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
			_view.birthdayContainer.addEventListener(MouseEvent.CLICK, birthdayClickHanlder);
			_view.okDateCall.addEventListener(MouseEvent.CLICK, okDateClickHandler);
			_view.cancelDateCall.addEventListener(MouseEvent.CLICK, cancelDateClickHandler);
		}
		
		private function cancelDateClickHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.MENU_CLOSE);
		}
		
		private function okDateClickHandler(event:MouseEvent):void
		{
			_date = _view.birthdayChoice.selectedDate;
			updateBirtdayLabel(_date);
			sendNotification(NAMES.MENU_CLOSE);
		}
		
		private function birthdayClickHanlder(event:MouseEvent):void
		{
			sendNotification(NAMES.MENU_OPEN);
			if( _date )
			{
				_view.birthdayChoice.selectedDate = _date;
			}
			else
			{
				_view.birthdayChoice.selectedDate = _localUser.user.vo.birthDay || new Date;
			}
		}
		
		override protected function onMediatorRemove():void
		{
			_view.saveCall.removeEventListener(MouseEvent.CLICK, saveCallHandler);
			_view.cancelCall.removeEventListener(MouseEvent.CLICK, cancelCallHandler);
			_view.birthdayContainer.removeEventListener(MouseEvent.CLICK, birthdayClickHanlder);
			_view.okDateCall.removeEventListener(MouseEvent.CLICK, okDateClickHandler);
			_view.cancelDateCall.removeEventListener(MouseEvent.CLICK, cancelDateClickHandler);
		}
		
		override protected function onViewAdd():void
		{
			updateBirtdayLabel(_localUser.user.vo.birthDay);
			_view.rule.selected 		= _localUser.hasDataAccessByField( UserPrivateRule.ALLOW_BIRTHDAY ); 
			_view.okDateCall.height 	= dpi.getAutoSize(46);
			_view.cancelDateCall.height = dpi.getAutoSize(46);
		}
		
		private function cancelCallHandler(event:MouseEvent):void
		{
			updateBirtdayLabel(_localUser.user.vo.birthDay);
			back();	
		}
		
		private function updateBirtdayLabel(date:Date):void
		{
			if( date )
			{
				var formatter:DateTimeFormatter = new DateTimeFormatter;
				formatter.dateTimePattern ="dd MMMM yyyy"
				_view.birthday.text = formatter.format(date);
			}
			else
			{
				_view.birthday.text = null;
			}
		}
		
		private function saveCallHandler(event:MouseEvent):void
		{
			if( _date )
			{
				_localUser.user.vo.birthDay = _date;
			}
			_localUser.user.vo.rule			= _localUser.user.vo.rule | ( _view.rule.selected ? UserPrivateRule.ALLOW_BIRTHDAY : 0 );
			_localUser.update();
			back();
		}
	}
}