package ru.nekit.disn.model.cursor
{
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.message.MessageTree;
	import ru.nekit.disn.model.vo.ExtendedMessageVO;
	import ru.nekit.disn.model.vo.NotificationMessageTreeVO;
	
	public class MessageTreeCursor extends ModelLink
	{
		
		public function MessageTreeCursor()
		{
			super();
		}
		
		public function actualMessage(tree:MessageTree):ExtendedMessageVO
		{
			if( tree.isNew )
			{
				
				var ntree:NotificationMessageTreeVO = model.notificationMessageTreeList.getByUid(tree.user.uid);
				if( ntree )
				{
					for each( var message:ExtendedMessageVO in tree.list )
					{
						if( message.destination == model.localUser.user.uid && message.timestamp >= ntree.timestamp )
						{
							return message;
						}
					}
				}
			}
			return lastMessage(tree);
		}
		
		public function lastMessage(tree:MessageTree):ExtendedMessageVO
		{
			const length:uint = tree.length;
			if( length )
			{
				return tree.list[length - 1];
			}
			return null;
		}
	}
}