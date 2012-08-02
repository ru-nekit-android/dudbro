package ru.nekit.disn.view
{
	
	import flash.events.ErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.MouseEvent;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.media.MediaType;
	
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.view.views.*;
	
	import spark.components.Button;
	
	public class MeMediator extends ViewMediator
	{
		
		public static const NAME:String = "meView";
		
		private static const STATE_NORMAL:String = "normal";
		private static const STATE_EDIT:String 	= "edit";
		
		private static var state:String;
		
		private var _view:MeView = null;
		private var _localUser:LocalUserProxy;
		private var _camera:CameraUI;
		
		public function MeMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_view = viewComponent as MeView;
			hasMenu = true;
		}
		
		public function get view():MeView
		{
			return _view;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NAMES.MODEL_INIT_COMPLETE,
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
			var body:Object = notification.getBody();
			
			switch( notification.getName() )
			{
				
				case NAMES.MODEL_INIT_COMPLETE:
					
					removeNotificationInterest(NAMES.MODEL_INIT_COMPLETE);
					currentState = STATE_NORMAL;
					registerMainMenuButton();
					
					break;
				
				default:
					
					break;
				
			}
		}
		
		private function allDataClickHandler(event:MouseEvent):void
		{
			sendNotification(NAMES.VIEW_GO, AllDataView);
		}
		
		private function initView():void
		{
			_view.fullnameContainer.minHeight 	= dpi.getAutoSize(64);
			_view.nicknameContainer.minHeight 	= dpi.getAutoSize(30);
			_view.allData.height				= dpi.getAutoSize(42);
			var fullname:String					= _localUser.user.fullname;
			var age:String						= _localUser.ageString;
			var sex:String						= _localUser.sexString;
			var phone:String					= _localUser.user.vo.phone;
			var status:String					= _localUser.user.status;
			_view.photo.source 					= _localUser.photo.source;
			_view.nickname.text					= _localUser.nickname;
			if( !fullname )
			{
				_view.fullname.setStyle("fontStyle", "italic");
				_view.fullname.text	= CONST.FULLNAME_EMPTY;
			}
			else
			{
				_view.fullname.text	=  fullname;
			}
			if( !age )
			{
				_view.age.setStyle("fontStyle", "italic");	
				_view.age.text 	= CONST.AGE_EMPTY;
			}
			else
			{
				_view.age.text	= age;
			}
			if( !sex )
			{
				_view.sex.setStyle("fontStyle", "italic");	
				_view.sex.text 	= CONST.SEX_EMPTY;
			}
			else
			{
				_view.sex.text	= sex;
			}
			if( !status )
			{
				_view.status.setStyle("fontStyle", "italic");	
				_view.status.text 	= CONST.STATUS_EMPTY;
			}
			else
			{	
				_view.status.text = status;
			}
			if( !phone )
			{
				_view.phone.setStyle("fontStyle", "italic");	
				_view.phone.text 	= CONST.PHONE_EMPTY;
			}
			else
			{	
				_view.phone.text = "+7 " + phone;
			}
		}
		
		override protected function onMediatorRegister():void
		{
			_localUser = model.localUser;
		}
		
		override protected function onViewAdd():void
		{
			_view.addEventListener(FlexEvent.STATE_CHANGE_COMPLETE, stateChangeCompleteHandler);
			if( !facade.hasCommand(NAMES.MODEL_INIT) )
			{
				currentState = STATE_NORMAL;
			}
			if( state )
			{
				currentState = state;
				editStateEventActived = state == STATE_EDIT;
				state = null;
			}
			initView();
		}
		
		private function stateChangeCompleteHandler(event:FlexEvent):void
		{
			_view.callLater(function():void
			{
				eventActived = true;
			}
			);
		}
		
		private function set eventActived(value:Boolean):void
		{
			if( value )
			{
				if( currentState == STATE_NORMAL )
				{
					_view.editCall.addEventListener(MouseEvent.CLICK, editCallHandler);
				}else if( currentState == STATE_EDIT )
				{
					_view.cancelCall.addEventListener(MouseEvent.CLICK, cancelCallHandler);
				}
			}
			else
			{
				if( currentState == STATE_NORMAL )
				{
					_view.editCall.removeEventListener(MouseEvent.CLICK, editCallHandler);
				}else if( currentState == STATE_EDIT )
				{
					_view.cancelCall.removeEventListener(MouseEvent.CLICK, cancelCallHandler);
				}
			}
		}
		
		override protected function get mainMenuButton():Button
		{
			return _view.mainMenu;
		}
		
		override protected function onViewActive():void
		{
			_view.allData.addEventListener(MouseEvent.CLICK, allDataClickHandler);
			if( CameraUI.isSupported )
			{
				_camera = new CameraUI;
				_camera.addEventListener(MediaEvent.COMPLETE, onComplete); 
				_camera.addEventListener(ErrorEvent.ERROR, onError);
			}
			eventActived = true;
		}
		
		private function editCallHandler(event:MouseEvent):void
		{
			eventActived = false;
			currentState = "edit";
			editStateEventActived = true;
		}
		
		private function set editStateEventActived(value:Boolean):void
		{
			if( value )
			{
				_view.nicknameArrow.addEventListener(MouseEvent.CLICK, viewGoHandler);
				_view.fullnameArrow.addEventListener(MouseEvent.CLICK, viewGoHandler);
				_view.sexArrow.addEventListener(MouseEvent.CLICK, viewGoHandler);
				_view.ageArrow.addEventListener(MouseEvent.CLICK, viewGoHandler);
				_view.statusArrow.addEventListener(MouseEvent.CLICK, viewGoHandler);
				_view.phoneArrow.addEventListener(MouseEvent.CLICK, viewGoHandler);
				_view.photoContainer.addEventListener(MouseEvent.CLICK, photoClickHandler);	
			}
			else
			{
				_view.nicknameArrow.removeEventListener(MouseEvent.CLICK, viewGoHandler);
				_view.fullnameArrow.removeEventListener(MouseEvent.CLICK, viewGoHandler);
				_view.sexArrow.removeEventListener(MouseEvent.CLICK, viewGoHandler);
				_view.ageArrow.removeEventListener(MouseEvent.CLICK, viewGoHandler);
				_view.statusArrow.removeEventListener(MouseEvent.CLICK, viewGoHandler);
				_view.phoneArrow.removeEventListener(MouseEvent.CLICK, viewGoHandler);
				_view.photoContainer.removeEventListener(MouseEvent.CLICK, photoClickHandler);
			}
		}
		
		private function photoClickHandler(event:MouseEvent):void
		{
			_camera.launch(MediaType.IMAGE);
		}
		
		private function onComplete(event:MediaEvent):void 
		{ 
			var mediaPromise:MediaPromise = event.data; 
			_view.photo.source = mediaPromise.file.url;
		}
		
		private function onError(event:ErrorEvent):void 
		{	
			trace("error has occurred");
		}
		
		private function viewGoHandler(event:MouseEvent):void
		{
			editStateEventActived = false;
			state = currentState;
			var target:Object = event.currentTarget;
			if( target == _view.nicknameArrow )
			{
				sendNotification(NAMES.VIEW_GO, NicknameView);
			}else if( target == _view.fullnameArrow )
			{
				sendNotification(NAMES.VIEW_GO, FullnameView);
			}else if( target == _view.sexArrow )
			{
				sendNotification(NAMES.VIEW_GO, SexView);
			}else if( target == _view.ageArrow )
			{
				sendNotification(NAMES.VIEW_GO, BirthdayView);
			}else if( target == _view.statusArrow )
			{
				sendNotification(NAMES.VIEW_GO, StatusView);
			}else if( target == _view.phoneArrow )
			{
				sendNotification(NAMES.VIEW_GO, PhoneView);
			}
		}
		
		override protected function onMediatorRemove():void
		{
			_view.removeEventListener(FlexEvent.STATE_CHANGE_COMPLETE, stateChangeCompleteHandler);
			_view.allData.removeEventListener(MouseEvent.CLICK, allDataClickHandler);
			eventActived = false;
		}
		
		override protected function onViewRemove():void
		{
			_view = null;
		}
		
		private function cancelCallHandler(event:MouseEvent):void
		{
			editStateEventActived 	= false;
			eventActived 			= false;
			currentState 			= "normal";
		}
	}
}