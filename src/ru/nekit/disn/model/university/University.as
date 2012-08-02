package ru.nekit.disn.model.university
{
	
	import flash.utils.ByteArray;
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.vo.UniversityVO;
	
	public class University extends ModelLink
	{
		public function University( vo:UniversityVO )
		{
			super(vo);
		}
		
		public function get vo():UniversityVO
		{
			return data as UniversityVO;
		}
		
		public function set vo(value:UniversityVO):void
		{
			if( data != value )
			{
				data = value;
			}
		}
		
		public function read(ba:ByteArray):void
		{
			var data:Object = ba.readObject();
			if( data )
			{
				this.data = data;
			}
		}
		
		public function write(ba:ByteArray):void
		{
			ba.writeObject(vo);
		}
	}
}