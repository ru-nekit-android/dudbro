package ru.nekit.disn.model.user
{
	
	import ru.nekit.disn.model.user.base.BaseUser;
	import ru.nekit.disn.model.vo.UserDataVO;
	
	use namespace user_internal;
	
	public class LocalUser extends BaseUser
	{
		//connected to p2p 
		public var connected:Boolean = false;
		//connect to wifi
		public var online:Boolean = false;
		
		public function LocalUser()
		{
			super();
		}
		
		public function get vo():UserDataVO
		{
			return _vo;
		}
		
		public function get sirname():String
		{
			return _sirname || getNamePart(0);
		}
		
		public function get firstname():String
		{
			return _firstname || getNamePart(1);
		}
		
		public function get middlename():String
		{
			return _middlename || getNamePart(2);
		}
		
		public function set sirname(value:String):void
		{
			_sirname = value;	
		}
		
		public function set firstname(value:String):void
		{
			_firstname = value;	
		}
		
		public function set middlename(value:String):void
		{
			_middlename = value;	
		}
		
		public function get fullname():String
		{
			var result:Array = new Array;
			if( sirname )
			{
				result.push(sirname);
			}
			if( firstname )
			{
				result.push(firstname);
			}
			if( middlename )
			{
				result.push(middlename);
			}
			return result.join(NAME_SPLIT_SYMBOL);
		}
		
		public function update():void
		{
			vo.name = fullname;
		}
	}
}