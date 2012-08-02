package ru.nekit.disn.model.viewBuilder
{
	
	import mx.collections.ArrayList;
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.dataProvider.DataProviderFunction;
	import ru.nekit.disn.model.message.MessageTree;
	import ru.nekit.disn.model.user.User;
	import ru.nekit.disn.model.viewDataItem.MenuDataItem;
	import ru.nekit.disn.model.viewDataItem.UserMenuDataItem;
	import ru.nekit.disn.model.vo.ExtendedMessageVO;
	
	public class MessageViewBuilder extends ModelLink
	{
		
		private var _mesageDataProviderFunction:DataProviderFunction;
		private var _mesageTreeDataProviderFunction:DataProviderFunction;
		
		public function messageFunction(item:MenuDataItem):String
		{
			return item.message;
		}
		
		public function labelFunction(item:MenuDataItem):String
		{
			return item.label + " ( " + item.hint + " ) ";
		}
		
		public function get messageDataProviderFunction():DataProviderFunction
		{
			if( !_mesageDataProviderFunction	)
			{
				_mesageDataProviderFunction = new DataProviderFunction
					(
						labelFunction
						,
						messageFunction
						,
						null
						,
						null
					)
			}
			return _mesageDataProviderFunction;
		}
		
		public function get messageTreeDataProviderFunction():DataProviderFunction
		{
			if( !_mesageTreeDataProviderFunction )
			{
				_mesageTreeDataProviderFunction = new DataProviderFunction
					(
						function labelFunction(tree:MessageTree):String
						{
							return tree.user.nickname;
						}
						,
						function messageFunction(tree:MessageTree):String
						{
							var message:ExtendedMessageVO = model.messageTreeCursor.actualMessage(tree);
							return message ? message.data as String : "";
						}
						,
						null
						,
						null
					)
			}
			return _mesageTreeDataProviderFunction;
		}
		
		public function convertToMessageDataItem(message:ExtendedMessageVO):UserMenuDataItem
		{
			var userMenuItemData:UserMenuDataItem 		= new UserMenuDataItem;
			if( message.sender == model.localUser.user.vo.uid )
			{
				userMenuItemData.label = "Я";
				userMenuItemData.user = model.localUser.user;
			}
			else
			{
				var user:User = model.userList.getByID(message.sender);
				if( user )
				{
					userMenuItemData.label 	= user.displayName;
					userMenuItemData.user 	= user;
				}
			}
			userMenuItemData.message 	= message.data as String;
			var date:Date 						= new Date;
			date.time 								= message.timestamp;
			userMenuItemData.hint 			= date.toTimeString();
			return userMenuItemData;
		}
		
		public function toTreeDataProvider(list:Vector.<MessageTree>):ArrayList
		{
			var result:Array = new Array;
			for each( var tree:MessageTree in list )
			{
				result.push(tree);		
			}
			return new ArrayList(result);
		}
		
		public function getMessageList(user:User):ArrayList
		{
			var messageTree:MessageTree = model.messageTreeList.getMesageTree(user);
			if( messageTree )
			{
				var value:Vector.<ExtendedMessageVO> = messageTree.list;
				var source:Array = new Array;
				const length:uint = value.length;
				for( var i:uint = 0; i< length; i++)
				{
					source.push(convertToMessageDataItem(value[i]));
				}
				return new ArrayList(source);
			}
			return new ArrayList;
		}
		
	}
}