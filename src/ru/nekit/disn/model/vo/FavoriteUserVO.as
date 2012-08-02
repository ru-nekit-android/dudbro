package ru.nekit.disn.model.vo
{
	
	import ru.nekit.disn.manager.entity.IEntity;
	
	[Bindable]
	[Table("favoriteUsers")]
	public class FavoriteUserVO implements IEntity
	{
		
		[Primary]
		[Type(varchar,35)]
		public var user:String;
		
		public function FavoriteUserVO(user:String = null)
		{
			this.user = user;
		}
		
	}
}