package ru.nekit.disn.model.vo
{
	
	import flash.utils.ByteArray;

	[RemoteClass("ru.nekit.disn.model.vo.PhotoVO")]
	public class PhotoVO
	{
	
		public var type:int = -1;
		public var width:uint;
		public var height:uint;
		public var data:ByteArray;
		
		public function set(value:PhotoVO):void
		{
			type 	= value.type;
			width 	= value.width;
			height	= value.height;
			data	= value.data;
		}
	}
}