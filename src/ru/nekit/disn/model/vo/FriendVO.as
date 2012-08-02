package ru.nekit.disn.model.vo
{
	
	import ru.nekit.disn.manager.entity.IEntity;
	
	[Bindable]
	[Table("friends")]
	public class FriendVO implements IEntity
	{
		
		[Primary]
		[Type(varchar,32)]
		public var user:String;
		
		public function FriendVO(user:String = null)
		{
			this.user = user;
		}
	}
}