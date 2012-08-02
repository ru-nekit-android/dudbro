package ru.nekit.disn.model.viewDataItem
{
	
	import ru.nekit.disn.model.user.base.BaseUser;
	
	public class UserMenuDataItem extends MenuDataItem
	{
		
		public var user:BaseUser;
		
		public function UserMenuDataItem(label:String=null, action:String=null, icon:*=null, message:String=null, hint:String=null)
		{
			super(label, action, icon, message, hint);
		}
	}
}