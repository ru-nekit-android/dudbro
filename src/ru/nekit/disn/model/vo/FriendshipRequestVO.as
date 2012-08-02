package ru.nekit.disn.model.vo
{
	
	import ru.nekit.disn.manager.entity.IEntity;
	
	[Bindable]
	[Table("friendshipRequests")]
	public class FriendshipRequestVO implements IEntity
	{
		
		[Primary]
		[Type(varchar,32)]
		public var user:String;
		public var text:String;
		public var status:uint; 
		public var date:Date;
		
		public function FriendshipRequestVO(user:String = null, status:uint = 0, text:String = null)
		{
			this.user 	= user;
			this.status = status;
			this.text	= text;
			if( user )
			{
				date = new Date;
			}
		}
	}
}