package ru.nekit.disn.model.user.base
{
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.account.Account;
	import ru.nekit.disn.model.photo.Photo;
	import ru.nekit.disn.model.university.University;
	import ru.nekit.disn.model.user.user_internal;
	
	use namespace user_internal;
	
	public class BaseUserProxy extends ModelLink
	{
		
		protected var _baseUser:BaseUser;
		
		protected var _photo:Photo;
		protected var _account:Account;
		protected var _university:University;
		
		public function BaseUserProxy(user:BaseUser)
		{
			_baseUser = user;
		}
		
		public function get ageString():String 
		{
			var birthday:Date = _baseUser._vo.birthDay;
			if( birthday )
			{
				var now:Date 		= new Date();
				var ageValue:uint 	= Number(now.fullYear) - Number(birthday.fullYear);
				if ( birthday.month >= now.month && birthday.date >= now.date) 
				{
					ageValue--;
				}
				var ageAdd:String = " лет";
				if( ageValue < 10 ||  ageValue > 20 )
				{
					if( ( ageValue%10 ) < 5)
					{
						ageAdd = " года";
					}
				}
				return ageValue.toString() + ageAdd;
			}
			return null;
		}
		
		public function get sexString():String
		{
			var sex:int = _baseUser._vo.sex;
			if( sex == -1 )
			{
				return null;
			}
			return sex == 1 ? "Парень" : "Девушка";
		}
		
		public function hasDataAccessByField(rule:uint):Boolean
		{
			return (_baseUser._vo.rule & rule) != 0;
		}
		
		public function get photo():Photo
		{
			return _photo;
		}
		
		public function get account():Account
		{
			return _account;
		}
		
		public function get university():University
		{
			return _university;
		}
	}
}