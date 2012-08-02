package ru.nekit.disn.model.vo
{
	
	[RemoteClass("ru.nekit.disn.model.vo.AccountListVO")]
	public class AccountListVO
	{
		
		private var _list:Vector.<AccountItemVO>;
		
		public function AccountListVO()
		{
			_list = new Vector.<AccountItemVO>;
		}
		
		public function add(item:AccountItemVO):void
		{
			_list.push(item);
		}
		
		public function set(value:AccountListVO):void
		{
			//_list = value.list;	
		}

		public function get list():Vector.<AccountItemVO>
		{
			return _list;
		}
	}
}