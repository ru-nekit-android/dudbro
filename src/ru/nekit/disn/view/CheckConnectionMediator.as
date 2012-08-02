package ru.nekit.disn.view
{
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.photo.PhotoLibrary;
	import ru.nekit.disn.view.views.CheckConnectionView;
	
	public class CheckConnectionMediator extends ViewMediator
	{
		
		public static const NAME:String = "checkConnectionView";
		
		private var _view:CheckConnectionView = null;
		
		public function CheckConnectionMediator(viewComponent:Object=null)
		{
			_view = viewComponent as CheckConnectionView;
			super(NAME, viewComponent);
		}
		
		public function get view():CheckConnectionView
		{
			return _view;
		}
		
		override protected function onMediatorRegister():void
		{
			_view.image.source = model.photoLibrary.getIconDPIBitmapDataByName(PhotoLibrary.MY_WIFI, 2);
		}
		
		override protected function onMediatorRemove():void
		{
			
		}
		
		override protected function onViewAdd():void
		{
			
		}
	}
}