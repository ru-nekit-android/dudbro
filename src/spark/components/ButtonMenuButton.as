package spark.components
{
	
	import ru.nekit.disn.model.viewDataItem.MenuDataItem;
	
	public class ButtonMenuButton extends ButtonBarButton
	{
		
		public function ButtonMenuButton()
		{
			super();
		}
		
		public function get hint():String
		{
			if( data is MenuDataItem )
			{
				var item:MenuDataItem = data as MenuDataItem;
				return item.hint;
			}
			return null;
		}
	}
}