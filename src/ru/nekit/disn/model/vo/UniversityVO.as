package ru.nekit.disn.model.vo
{
	
	[RemoteClass("ru.nekit.disn.model.vo.UniversityVO")]
	public class UniversityVO
	{
		
		public var name:String;
		public var description:String;
		public var institute:String;
		public var institute_id:uint;
		public var institute_description:String;
		public var cathedra:String;
		public var cathedra_id:uint;
		public var cathedra_description:String;
		public var group:String;
		public var group_id:uint;
		
		public function set(value:UniversityVO):void
		{
			if( value )
			{
				name 					= value.name;
				description 			= value.description;
				institute 				= value.institute;
				institute_id 			= value.institute_id;
				institute_description 	= value.institute_description;
				cathedra 				= value.cathedra;
				cathedra_id 			= value.cathedra_id;
				cathedra_description 	= value.cathedra_description;
				group					= value.group;
				group_id				= value.group_id;
			}		
		}
	}
}