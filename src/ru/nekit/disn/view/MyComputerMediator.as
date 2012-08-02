package ru.nekit.disn.view
{
	
	import ru.nekit.disn.*;
	import ru.nekit.disn.model.desktop.Desktop;
	import ru.nekit.disn.model.desktop.DesktopProxy;
	import ru.nekit.disn.view.views.MyComputerView;
	
	public class MyComputerMediator extends ViewMediator
	{
		
		public static const NAME:String = "myComputerView";
		
		private var _view:MyComputerView = null;
		
		public function MyComputerMediator(viewComponent:Object=null)
		{
			_view = viewComponent as MyComputerView;
			super(NAME, viewComponent);
		}
		
		public function get view():MyComputerView
		{
			return _view;
		}
		
		override protected function onMediatorRegister():void
		{			
			
		}
		
		override protected function onViewActive():void
		{		
			var desktop:Desktop = model.desktopList.getDesktopAt(0);
			if( desktop )
			{
				model.p2pDesktopChannel.openChannel(desktop);
			}
		}
		
		override protected function onMediatorRemove():void
		{
			
		}
		
		override protected function onViewAdd():void
		{
			
		}
		
	}
}