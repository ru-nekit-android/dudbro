package ru.nekit.disn.view
{
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.user.UserProxy;
	import ru.nekit.disn.view.views.AboutView;
	
	import spark.components.Button;
	
	public class AboutMediator extends ViewMediator
	{
		
		public static const NAME:String = "aboutView";
		
		private var _view:AboutView = null;
		private var _remoteUser:UserProxy; 
		
		public function AboutMediator(viewComponent:Object=null)
		{
			_view = viewComponent as AboutView;
			super(NAME, viewComponent);
		}
		
		public function get view():AboutView
		{
			return _view;
		}
		
		override protected function onMediatorRegister():void
		{			
			_remoteUser = model.currentUser.user;
		}
		
		override protected function get backButton():Button
		{
			return _view.backCall;
		}
		
		override protected function onViewAdd():void
		{
			_view.field.text =  _remoteUser.aboutMe;
			title = "О " + _remoteUser.user.nickname + "...";
		}
	}
}