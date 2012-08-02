package ru.nekit.disn.model.vo
{
	
	import ru.nekit.disn.manager.entity.IEntity;
	
	[Bindable]
	[Table("notificationMessageTree")]
	public class NotificationMessageTreeVO implements IEntity 
	{
		
		[Primary]
		[Type(varchar,35)]
		public var uid:String;
		public var timestamp:Number;
		
	}
}