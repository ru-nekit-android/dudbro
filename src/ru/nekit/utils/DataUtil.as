package ru.nekit.utils
{
	public class DataUtil
	{
		
		public static const PHONE_PREFIX:String = "+7";
		
		public static function isEmpty(value:*):Boolean
		{
			if( value is String )
			{
				return value == null || (textWithoutSpaces(value) == "");
			}
			return value == null;
		}
		
		public static function normalizePhoneNumber(value:String):String
		{
			value = textWithoutSpaces(value);
			if( value.indexOf(PHONE_PREFIX) == 0 )
			{
				return value;
			}
			return PHONE_PREFIX + value;
		}
		
		public static function textWithoutSpaces(value:String):String
		{
			if( value )
			{
				return String(value).split(" ").join("");
			}
			return "";
		}
	}
}