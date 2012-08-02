package ru.nekit.disn.view
{
	
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.user.LocalUserProxy;
	import ru.nekit.disn.view.views.*;
	import ru.nekit.utils.DataUtil;
	
	import spark.components.Button;
	
	public class StudentProfileMediator extends ViewMediator
	{
		
		public static const NAME:String = "studentProfileView";
		
		private var _view:StudentProfileView = null;
		private var _localUser:LocalUserProxy;
		
		public function StudentProfileMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_view = viewComponent as StudentProfileView;
			hasMenu = true;
		}
		
		public function get view():StudentProfileView
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
			var fullname:String					= _localUser.user.fullname;
			var university:String				= _localUser.university.vo.name;
			var universityDescription:String	= _localUser.university.vo.description;
			var institute:String				= _localUser.university.vo.institute;
			var instituteDescription:String		= _localUser.university.vo.institute_description;
			var cathedra:String					= _localUser.university.vo.cathedra;
			var cathedraDescription:String		= _localUser.university.vo.cathedra_description;
			var group:String					= _localUser.university.vo.group;
			var status:String					= _localUser.user.status;
			_view.photo.source 					= _localUser.photo.source;
			if( !fullname )
			{
				_view.fullname.setStyle("fontStyle", "italic");
				_view.fullname.text	= CONST.FULLNAME_EMPTY;
			}
			else
			{
				_view.fullname.text	=  fullname;
			}
			if( !university && !universityDescription )
			{
				_view.university.setStyle("fontStyle", "italic");	
				_view.university.text 	= CONST.UNIVERSITY_EMPTY;
			}
			else
			{	
				_view.university.text = university || universityDescription;
			}
			_view.universityDescription.visible = _view.universityDescription.includeInLayout = !DataUtil.isEmpty( universityDescription );
			_view.universityDescription.text 	= universityDescription;
			if( !group )
			{
				_view.universityGroup.setStyle("fontStyle", "italic");	
				_view.universityGroup.text 	= CONST.GROUP_EMPTY;
			}
			else
			{	
				_view.universityGroup.text = group;
			}
			if( !institute )
			{
				_view.institute.setStyle("fontStyle", "italic");	
				_view.institute.text 	= CONST.INSTITUTE_EMPTY;
			}
			else
			{	
				_view.institute.text = institute;
			}
			if( !cathedra )
			{
				_view.cathedra.setStyle("fontStyle", "italic");	
				_view.cathedra.text 	= CONST.CATHEDRA_EMPTY;
			}
			else
			{	
				_view.cathedra.text = cathedra;
			}
		}
		
		override protected function onMediatorRegister():void
		{
			_localUser = model.localUser;
		}
		
		override protected function onViewAdd():void
		{
			initView();
		}
		
		
		override protected function get mainMenuButton():Button
		{
			return _view.mainMenu;
		}
		
		override protected function onViewActive():void
		{
			
		}
		
		override protected function onMediatorRemove():void
		{
			
		}
		
		override protected function onViewRemove():void
		{
			_view = null;
		}
	}
}