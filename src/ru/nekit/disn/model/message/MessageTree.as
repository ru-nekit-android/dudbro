package ru.nekit.disn.model.message
{
	
	import ru.nekit.disn.model.user.base.BaseUser;
	import ru.nekit.disn.model.vo.ExtendedMessageVO;
	
	public class MessageTree
	{
		
		public var isRead:Boolean = false;
		public var user:BaseUser;
		public var list:Vector.<ExtendedMessageVO>;
		
		public var isNew:Boolean = false;
		
		public function MessageTree(user:BaseUser)
		{
			this.user = user;
			list = new Vector.<ExtendedMessageVO>;
		}
		
		public function get length():uint
		{
			return list.length;
		}
	}
}