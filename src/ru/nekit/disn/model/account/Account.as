package ru.nekit.disn.model.account
{
	
	import flash.utils.ByteArray;
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.vo.AccountListVO;
	
	public class Account extends ModelLink
	{
		public function Account( vo:AccountListVO )
		{
			super(vo);
		}
		
		public function get vo():AccountListVO
		{
			return data as AccountListVO;
		}
		
		public function set vo(value:AccountListVO):void
		{
			if( data != value )
			{
				data = value;
			}
		}
		
		public function read(ba:ByteArray):void
		{
			this.data = ba.readObject();
		}
		
		public function write(ba:ByteArray):void
		{
			ba.writeObject(vo);
		}
	}
}