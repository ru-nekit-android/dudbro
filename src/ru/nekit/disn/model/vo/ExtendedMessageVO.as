package ru.nekit.disn.model.vo
{
	
	import ru.nekit.disn.manager.entity.IEntity;
	
	[RemoteClass("ru.nekit.disn.model.vo.ExtendedMessageVO")]
	[Bindable]
	[Table("messages")]
	public class ExtendedMessageVO implements IEntity
	{
		[Primary]
		[Type(varchar,32)]
		public var uid:String 			= "";
		[Type(varchar,35)]
		public var sender:String 		= "";
		[Type(varchar,35)]
		public var destination:String 	= "";
		public var data:Object;
		public var timestamp:Number;
		[Exclude]
		public var status:uint = 0;
		
		public function ExtendedMessageVO(sender:String = "", destination:String = "", data:Object = null)
		{
			this.sender 		= sender;
			this.destination 	= destination;
			this.data 			= data;
			timestamp			= (new Date).time;
		}
	}
}