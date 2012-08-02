package ru.nekit.disn.model.vo
{
	
	import flash.utils.ByteArray;
	
	import ru.nekit.disn.manager.entity.IEntity;
	
	[RemoteClass("ru.nekit.disn.model.vo.UserDataVO")]
	[Bindable]
	[Table("users")]
	public class UserDataVO implements IEntity
	{
		[Type(varchar,8)]
		public var version:String;
		[Primary]
		[Type(varchar,32)]
		public var uid:String;
		[Type(varchar,32)]
		public var nickname:String;
		[Type(varchar,255)]
		public var status:String;
		public var rule:uint;
		[Type(varchar,255)]
		public var name:String;
		public var mood:int;
		public var sex:int;
		public var birthDay:Date;
		[Type(varchar,12)]
		public var phone:String;
		public var extension:Object;
		public var photo:PhotoVO;
		public var aboutMe:String;
		public var accounts:AccountListVO;
		[Type(object)]
		public var university:UniversityVO;
		
		public function set(value:UserDataVO):void
		{
			version			= value.version;
			uid 			= value.uid;
			nickname = value.nickname;
			name		= value.name;
			status 		= value.status;
			mood 		= value.mood;
			sex 			= value.sex;
			birthDay	= value.birthDay;
			phone		= value.phone;
			rule			= value.rule;
			extension = value.extension;
			photo.set(value.photo);
			accounts.set(value.accounts);
			university.set(value.university);
			aboutMe		= value.aboutMe;
		}
	}
}