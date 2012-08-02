package ru.nekit.disn.model.filter
{
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.message.MessageTree;
	
	public class MessageFilter extends ModelLink
	{
		
		public function get newMessages():Vector.<MessageTree>
		{
			var list:Object = model.messageTreeList.list;
			var result:Vector.<MessageTree> = new Vector.<MessageTree>;
			for each( var messageTree:MessageTree in list )
			{	
				if( messageTree.isNew )
				{
					if( messageTree.length != 0 )
					{
						result.push(messageTree);
					}
				}
			}
			return result;
		}
		
		public function get oldMessages():Vector.<MessageTree>
		{
			var list:Object = model.messageTreeList.list;
			var result:Vector.<MessageTree> = new Vector.<MessageTree>;
			for each( var messageTree:MessageTree in list )
			{	
				if( messageTree.isNew )
				{
					if( messageTree.length != 0 )
					{
						result.push(messageTree);
					}
				}
			}
			return result;
		}
		
		public function get allMessages():Vector.<MessageTree>
		{
			return sourceList;
		}
		
		public function get sourceList():Vector.<MessageTree>
		{
			var list:Object = model.messageTreeList.list;
			var result:Vector.<MessageTree> = new Vector.<MessageTree>;
			for each( var messageTree:MessageTree in list )
			{	
				result.push(messageTree);
			}
			return result;
		}
	}
}