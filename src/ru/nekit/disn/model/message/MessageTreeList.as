package ru.nekit.disn.model.message
{
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.user.*;
	import ru.nekit.disn.model.vo.ExtendedMessageVO;
	
	use namespace user_internal;
	
	public class MessageTreeList extends ModelLink
	{
		
		private var _messageTreeList:Object;
		
		public function MessageTreeList()
		{
			_messageTreeList 	= new Object;
		}
		
		public function getHistoryMessageTree(user:User):MessageTree
		{
			var destination:String = user.uid;
			var messageTree:MessageTree;
			var newMessages:Vector.<ExtendedMessageVO>;
			if( destination in _messageTreeList )
			{
				messageTree = getByUserUID(destination);
				if( messageTree.isRead )
				{
					return messageTree;
				}
				if( messageTree.list.length > 0 )
				{
					newMessages = messageTree.list.concat();
				}
			}
			else
			{
				messageTree = new MessageTree(user);
				_messageTreeList[destination] = messageTree;
			}
			if( messageTree.list.length > 0 )
			{
				messageTree.list = new Vector.<ExtendedMessageVO>;
			}
			var result:Vector.<ExtendedMessageVO> = model.messageList.readByDestination(destination).concat(model.messageList.readBySender(destination));
			if( newMessages && newMessages.length > 0 )
			{
				result = result.concat(newMessages);
			}
			result.sort(
				function comp( a:ExtendedMessageVO, b:ExtendedMessageVO ):Number 
				{
					return a.timestamp - b.timestamp;
				}
			);
			messageTree.isRead = true;
			return messageTree;
		}
		
		public function create(user:User, messages:Vector.<ExtendedMessageVO> = null):MessageTree
		{
			var messageTree:MessageTree;
			var destination:String = user.uid;
			if( destination in _messageTreeList )
			{
				messageTree = _messageTreeList[destination];
				if( messages )
				{
					messageTree.list = messageTree.list.concat(messages);
				}
			}
			else
			{
				messageTree = new MessageTree(user);
				if( messages )
				{
					messageTree.list = messages;
				}
				_messageTreeList[destination] = messageTree;
			}
			return messageTree;
		}
		
		public function getMesageTree(user:User):MessageTree
		{
			if( hasMesageTree(user) )
			{
				return getByUserUID(user.uid);
			}
			return null;
		}
		
		public function hasMesageTree(user:User):Boolean
		{
			if( user.uid in _messageTreeList )
			{
				return true
			}
			return false;
		}
		
		public function addMessage(message:ExtendedMessageVO):void
		{
			var destination:String = destination(message);
			var messageTree:MessageTree;
			if( destination in _messageTreeList )
			{
				messageTree = getByUserUID(destination);
			}
			else
			{
				var user:User = model.userList.getByID(destination);
				if( user )
				{
					messageTree = new MessageTree(user);
					_messageTreeList[destination] = messageTree;
				}
			}
			messageTree.list.push(message);
		}
		
		private function destination(message:ExtendedMessageVO):String
		{
			if( model.localUser.user.vo.uid == message.sender )
			{
				return message.destination;
			}
			return message.sender;
		}
		
		public function getByUserUID(uid:String):MessageTree
		{
			return _messageTreeList[uid] as MessageTree;
		}
		
		public function get list():Object
		{
			return _messageTreeList;
		}
	}
}