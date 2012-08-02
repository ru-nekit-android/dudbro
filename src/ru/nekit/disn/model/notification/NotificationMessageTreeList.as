package ru.nekit.disn.model.notification
{
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.message.MessageTree;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.vo.NotificationMessageTreeVO;
	
	public class NotificationMessageTreeList extends ModelLink
	{
		
		private var _uidList:Object;
		private var _length:uint;
		
		public function NotificationMessageTreeList()
		{
			_uidList 	= new Object;
			_length 	= 0;
		}
		
		public function init():void
		{
			//destroy();
			var data:Array 			= model.db.selectAll(NotificationMessageTreeVO);
			var user:User;
			for each ( var notificationMessageTree:NotificationMessageTreeVO in data )
			{
				user = model.userList.getByID(notificationMessageTree.uid);
				if( user )
				{
					addTree(notificationMessageTree);
					model.messageTreeList.create(user, model.messageList.readBySenderAndTimestampMoreThat(notificationMessageTree.uid, notificationMessageTree.timestamp));
				}
			}
		}
		
		private function addTree(notificationTree:NotificationMessageTreeVO):void
		{
			_uidList[notificationTree.uid] = notificationTree;
			var messageTree:MessageTree  = model.messageTreeList.getByUserUID(notificationTree.uid);
			if( !messageTree )
			{
				var user:User = model.userList.getByID(notificationTree.uid);
				if( user )
				{
					messageTree = model.messageTreeList.create(user);
				}
			}
			messageTree.isNew = true;
			_length++;
		}
		
		public function getByUid(uid:String):NotificationMessageTreeVO
		{
			return _uidList[uid];
		}
		
		private function removeTree(uid:String):void
		{
			var notificationTree:NotificationMessageTreeVO = _uidList[uid];
			var messageTree:MessageTree = model.messageTreeList.getByUserUID(uid);
			if( messageTree )
			{
				model.db.remove(notificationTree);
				messageTree.isNew = false;
			}
			delete _uidList[uid];
			_length--;
		}
		
		public function remove(uid:String):void
		{
			if( uid in _uidList )
			{
				removeTree(uid);
			}
		}
		
		public function add(uid:String, timestamp:Number):void
		{
			if( !(uid in _uidList) )
			{
				var notificationTree:NotificationMessageTreeVO 	= new NotificationMessageTreeVO;
				notificationTree.uid 													= uid;
				notificationTree.timestamp 										= timestamp;
				addTree(notificationTree);
				model.db.save(notificationTree);
			}
		}
		
		public function reset():void
		{
			_uidList = new Object;
			_length = 0;
			model.db.removeAll(NotificationMessageTreeVO);
		}
		
		public function destroy():void
		{
			model.db.drop(NotificationMessageTreeVO);
		}
		
		public function get length():uint
		{
			return _length;
		}
	}
}