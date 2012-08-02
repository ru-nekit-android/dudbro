package ru.nekit.disn.model.message
{
	
	import flash.utils.Dictionary;
	
	import ru.nekit.disn.model.ModelLink;
	import ru.nekit.disn.model.vo.ExtendedMessageVO;
	
	public class MessageList extends ModelLink
	{
		
		private var _list:Vector.<ExtendedMessageVO>;
		private var _dictionary:Dictionary;
		
		public function MessageList()
		{
			_list 			= new Vector.<ExtendedMessageVO>;
			_dictionary 	= new Dictionary;
		}
		
		public function init():void
		{
			//reset();
			model.db.createSelect(ExtendedMessageVO, "selectByDst", ["destination"], 	["destination"], ["="]);
			model.db.createSelect(ExtendedMessageVO, "selectBySrc", ["sender"], 		["sender"], 	["="]);
			model.db.createSelect(ExtendedMessageVO, "selectBySrcAndTimestamp", 		["sender", "timestamp"], 		["sender", "timestamp"], 	["=", ">="]);
		}
		
		public function add(message:ExtendedMessageVO):void
		{
			model.db.save(message);
		}
		
		public function reset():void
		{
			model.db.removeAll(ExtendedMessageVO);
		}
		
		public function read():void
		{
			var list:Array 	= model.db.selectAll(ExtendedMessageVO);
			var i:uint 		= _list.length;
			for each (var message:ExtendedMessageVO in list) 
			{
				_dictionary[message.uid] 	= message;
				_list[i++] 					= message;
			}
		}
		
		public function getByID(id:String):ExtendedMessageVO
		{
			if( id in _dictionary )
			{
				return _dictionary[id];
			}
			return null;
		}
		
		public function readBySender(sender:String):Vector.<ExtendedMessageVO>
		{
			return toVector(model.db.executeSelect(ExtendedMessageVO, "selectBySrc", [sender]));
		}
		
		public function readByDestination(destination:String):Vector.<ExtendedMessageVO>
		{
			return toVector(model.db.executeSelect(ExtendedMessageVO, "selectByDst", [destination]));
		}
		
		public function readBySenderAndTimestampMoreThat(sender:String, timestamp:Number):Vector.<ExtendedMessageVO>
		{
			return toVector(model.db.executeSelect(ExtendedMessageVO, "selectBySrcAndTimestamp", [sender, timestamp]));
		}
		
		private function toVector(array:Array):Vector.<ExtendedMessageVO>
		{
			var vector:Vector.<ExtendedMessageVO> = new Vector.<ExtendedMessageVO>;
			var i:uint = 0;
			for each( var message:ExtendedMessageVO in array)
			{
				vector[i++] = message;
			}
			return vector;
		}
		
		public function get list():Vector.<ExtendedMessageVO>
		{
			return _list;
		}
	}
}