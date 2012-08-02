package ru.nekit.disn.model.user.base
{
	
	import ru.nekit.disn.model.user.user_internal;
	import ru.nekit.disn.model.vo.AccountListVO;
	import ru.nekit.disn.model.vo.PhotoVO;
	import ru.nekit.disn.model.vo.UniversityVO;
	import ru.nekit.disn.model.vo.UserDataVO;
	
	use namespace user_internal;
	
	public class BaseUser
	{
		
		public static const NAME_SPLIT_SYMBOL:String = " ";
		
		user_internal var _vo:UserDataVO;
		
		protected var _sirname:String;
		protected var _firstname:String;
		protected var _middlename:String;
		
		public var type:uint;
		public var active:Boolean;
		
		public function BaseUser()
		{
			_vo = new UserDataVO;
			_vo.photo = new PhotoVO;
			_vo.accounts = new AccountListVO;
			_vo.university = new UniversityVO;
		}
		
		public function get uid():String
		{
			return _vo.uid;
		}
		
		public function set uid(value:String):void
		{
			if( _vo.uid != value )
			{
				_vo.uid = value;
			}
		}
		
		public function get status():String
		{
			return _vo.status;
		}
		
		public function set status(value:String):void
		{
			if( _vo.status != value )
			{
				_vo.status= value;
			}
		}
		
		public function get nickname():String
		{
			return _vo.nickname;
		}
		
		public function set nickname(value:String):void
		{
			if( _vo.nickname != value )
			{
				_vo.nickname= value;
			}
		}
		
		protected function getNamePart(position:uint= 0 ):String
		{
			var name:String = _vo.name || "";
			var parts:Array = name.split(NAME_SPLIT_SYMBOL);
			if( parts.length - 1 < position )
			{
				return "";
			}
			return parts[position];
		}
		
		public function get photoVO():PhotoVO
		{
			return _vo.photo;
		}
		
		public function get accountsVO():AccountListVO
		{
			return _vo.accounts;
		}
		
		public function get universityVO():UniversityVO
		{
			return _vo.university;
		}
		
		protected function setBaseUser(value:BaseUser):void
		{
			_vo.set(value._vo);
			type		= value.type;
		}
	}
}