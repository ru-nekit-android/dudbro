package ru.nekit.utils
{
	
	import flash.utils.ByteArray;
	
	public class ByteArrayUtil
	{
		
		public static function writeUTF(ba:ByteArray, value:String):void
		{
			if( !value)
			{
				value = "";
			}
			ba.writeUTF(value);
		}
		
		public static function writeInt(ba:ByteArray, value:int):void
		{
			if( !value)
			{
				value = -1;
			}
			ba.writeInt(value);
		}
		
		public static function writeUnsignedInt(ba:ByteArray, value:uint):void
		{
			if( !value)
			{
				value = 0;
			}
			ba.writeUnsignedInt(value);
		}
		
		public static function writeObject(ba:ByteArray, value:Object):void
		{
			if( !value)
			{
				value = new Object;
			}
			ba.writeObject(value);
		}
		
		public static function writeBytes(ba:ByteArray, value:ByteArray):void
		{
			if( !value)
			{
				value = new ByteArray;
			}
			value.position = 0;
			ba.writeBytes(value, 0, value.length);
		}
		
		public static function readDate(ba:ByteArray):Date
		{
			var date:*		= ba.readObject();
			if( date is Date )
			{
				return date;
			}
			return null;
		}
		
		public static function readBytes(ba:ByteArray):ByteArray
		{
			var value:ByteArray = new ByteArray;
			ba.readBytes(value);
			if( value.length != 0 )
			{
				return value;
			}
			return null;
		}
	}
}