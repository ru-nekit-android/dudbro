package ru.nekit.disn.model.photo
{
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.vo.PhotoVO;
	
	public class Photo extends ModelLink
	{
		
		private var _library:PhotoLibrary;
		
		public function Photo( vo:PhotoVO )
		{
			super(vo);
		}
		
		public function get vo():PhotoVO
		{
			return data as PhotoVO;
		}
		
		public function set vo(value:PhotoVO):void
		{
			if( data != value )
			{
				data = value;
			}
		}
		
		public function write(ba:ByteArray):void
		{
			if( vo.type == -1 )
			{
				vo.type = model.photoLibrary.defaultUserPhoto.index;
			}
			ba.writeObject(vo);	
		}
		
		public function read(ba:ByteArray):void
		{
			this.data = ba.readObject();
			if( isEmpty() )
			{
				if( vo.type != 0 )
				{
					vo.type = model.photoLibrary.getIconByName(PhotoLibrary.USER_PHOTO).index;
				}
			}
			else
			{
				vo.data.position = 0;
			}
		}
		
		public function isEmpty():Boolean
		{
			return !vo.data;
		}
		
		public function get source():Object
		{
			if( vo.type == 0 )
			{
				if( !isEmpty() )
				{
					var result:BitmapData = new BitmapData(vo.width, vo.height);
					result.setPixels(result.rect, vo.data);
					vo.data.position = 0;
				}
				else
				{
					vo.type = model.photoLibrary.defaultUserPhoto.index;
					return source;
				}
			}
			else
			{
				if( vo.type == -1 )
				{
					vo.type = model.photoLibrary.defaultUserPhoto.index;
				}
				return model.photoLibrary.getIconDPIBitmapDataByIndex(vo.type);
			}
			return null;
		}
		
		public function set type(index:uint):void
		{
			vo.type = index;
		}
		
		public function set bitmapData(value:BitmapData):void
		{
			var result:ByteArray 	= new ByteArray;
			var rect:Rectangle 	= value.rect;
			result.writeBytes(value.getPixels(rect));
			vo.width	= rect.width;
			vo.height 	= rect.height;
			vo.data 	= result;
			vo.data.position = 0;
		}
	}
}