package ru.nekit.disn.manager.entity
{
	
	import flash.data.SQLColumnSchema;
	import flash.data.SQLConnection;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLStatement;
	import flash.data.SQLTableSchema;
	import flash.errors.IllegalOperationError;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	
	public class EntityManager{
		
		private static var _instance:EntityManager;        
		private static var localInstantiation:Boolean = false;
		
		private var _metadataMap:Vector.<EntityItemInfo> = new Vector.<EntityItemInfo>;
		private var _metadataIndex:Array = new Array;
		private var _sqlConnection:SQLConnection;
		
		public var dataBaseName:String;
		
		public function EntityManager()
		{
			if (!localInstantiation)
			{
				throw new IllegalOperationError("EntityManager is a singleton. Use EntityManager.instance to obtain an instance of this class.");
			}
		}
		
		public static function get instance():EntityManager
		{
			if (!_instance)
			{
				localInstantiation = true;
				_instance = new EntityManager;
				localInstantiation = false;
			}
			return _instance;
		}
		
		public function metadataMap(c:Class):EntityItemInfo{
			if( _metadataIndex[c] )
			{
				return _metadataMap[int(_metadataIndex[c]) - 1];
			}
			return null;
		}
		
		public function selectAll(c:Class):Array
		{
			if (!metadataMap(c)) loadMetadata(c);
			var stmt:SQLStatement = metadataMap(c).selectAllStmt;
			stmt.itemClass = c;
			stmt.execute();
			return stmt.getResult().data;
		}
		
		public function drop(c:Class):void
		{
			if (!metadataMap(c)) loadMetadata(c);
			var stmt:SQLStatement = metadataMap(c).dropStmt;
			stmt.execute();
		}
		
		public function save(o:IEntity):void
		{
			var c:Class = Class(getDefinitionByName(getQualifiedClassName(o)));
			if (!metadataMap(c)) loadMetadata(c);
			createItem(o,c);
		}
		
		public function update(o:IEntity):void
		{
			var c:Class = Class(getDefinitionByName(getQualifiedClassName(o)));
			if (!metadataMap(c)) loadMetadata(c);
			updateItem(o,c);
		}
		
		private function updateItem(o:IEntity, c:Class):void
		{
			var stmt:SQLStatement = metadataMap(c).updateStmt;
			var fields:ArrayCollection = metadataMap(c).fields;
			var exludeFields:Array = new Array;
			for (var i:int = 0; i<fields.length; i++)
			{
				var field:String = fields.getItemAt(i).field;
				stmt.parameters[":" + field] = o[field];
			}
			stmt.execute();
		}
		
		private function createItem(o:IEntity, c:Class):void
		{
			var stmt:SQLStatement = metadataMap(c).insertStmt;
			var identity:PrimaryKey = metadataMap(c).identity;
			var fields:ArrayCollection = metadataMap(c).fields;
			for (var i:int = 0; i<fields.length; i++)
			{
				var field:String = fields.getItemAt(i).field;
				if ( !identity.autoincrement || field != identity.field )
				{
					stmt.parameters[":" + field] = o[field];
				}
			}
			stmt.execute();
			if( identity.autoincrement )
			{
				o[identity.field] = stmt.getResult().lastInsertRowID;
			}
		}
		
		public function remove(o:IEntity):void
		{
			var c:Class = Class(getDefinitionByName(getQualifiedClassName(o)));
			if (!metadataMap(c)) loadMetadata(c);
			var identity:Object = metadataMap(c).identity;
			var stmt:SQLStatement = metadataMap(c).deleteStmt;
			stmt.parameters[":"+identity.field] = o[identity.field];
			stmt.execute();
		}
		
		private function getValue(value:*):*
		{
			if( value is String )
			{
				value = "'" + value + "'";
			}
			return value;
		}
		
		public function removeList(c:Class, list:Vector.<IEntity>):void
		{
			if (!metadataMap(c)) loadMetadata(c);
			var identity:Object = metadataMap(c).identity;
			var stmt:SQLStatement = metadataMap(c).deleteListStmt;
			var stmtList:Vector.<String> = new Vector.<String>;
			const length:uint = list.length;
			for( var i:uint = 0 ; i < length; i++ )
			{
				stmtList.push(getValue(list[i][identity.field]));
			}
			stmt.text += "(" + stmtList.join(",") + ")";
			stmt.execute();
		}
		
		public function removeAll(c:Class):void
		{
			if (!metadataMap(c)) loadMetadata(c);
			metadataMap(c).deleteAllStmt.execute();
		}
		
		public function select(o:IEntity):IEntity
		{
			var c:Class = Class(getDefinitionByName(getQualifiedClassName(o)));
			if (!metadataMap(c)) loadMetadata(c);
			var identity:Column = metadataMap(c).identity;
			var stmt:SQLStatement = metadataMap(c).selectStmt;
			stmt.itemClass = c;
			stmt.parameters[":"+identity.field] = getValue(o[identity.field]);
			stmt.execute();
			var result:Array = stmt.getResult().data;
			if( result )
			{
				return null;
			}
			return result[0];
		}
		
		private function loadMetadata(c:Class):void
		{
			_metadataMap.push(new EntityItemInfo);
			_metadataIndex[c] = _metadataMap.length;
			var xml:XML = describeType(new c());
			var tableName:String = xml.metadata.(@name=="Table").arg.(@key=="").@value;
			if( dataBaseName ){
				tableName = dataBaseName+ "." + tableName;
			}
			metadataMap(c).table = tableName;
			metadataMap(c).fields = new ArrayCollection();
			var variables:XMLList = xml.accessor;
			
			var insertParams:String = "";
			var updateSQL:String = "UPDATE " + tableName + " SET ";
			var insertSQL:String = "INSERT INTO " + tableName + " (";
			var createSQL:String = "CREATE TABLE IF NOT EXISTS " + tableName + " (";
			var selectSQL:String = "SELECT * FROM " + tableName;
			var length:uint = variables.length();
			var sourceColumns:Array = new Array;
			var columnTypeList:Object = new Object;
			for (var i:int = 0 ; i < length; i++) 
			{
				var type:String = null;
				var typeLength:uint = 0;
				var field:String = variables[i].@name.toString();
				var columnName:String; 
				var typeNode:XMLList = variables[i].metadata.(@name=="Type");
				if (typeNode.length()>0)
				{
					type = typeNode.arg[0].@value;
					if( typeNode.arg[1] )
					{
						typeLength = Number(typeNode.arg[1].@value);
					}
				}
				var columnNode:XMLList = variables[i].metadata.(@name=="Column");
				if ( columnNode.length()>0)
				{
					columnName = columnNode.arg[0].@value; 
				} 
				else
				{
					if (variables[i].metadata.(@name=="Exclude").length()>0)
					{
						continue;
					}
					else
					{
						columnName = field;
					}
				}
				sourceColumns.push(columnName);
				metadataMap(c).fields.addItem( new Column(field, columnName) );
				
				if (variables[i].metadata.(@name=="Id").length()>0)
				{
					metadataMap(c).identity = new PrimaryKey(field, columnName);
					createSQL += columnName + " INTEGER PRIMARY KEY AUTOINCREMENT,";
				}
				else if (variables[i].metadata.(@name=="Primary").length()>0)
				{
					metadataMap(c).identity = new PrimaryKey(field, columnName);	
					createSQL += columnName + " " + getSQLType(variables[i].@type) + " UNIQUE,";
					insertSQL += columnName + ",";
					insertParams += ":" + field + ",";
					metadataMap(c).identity.autoincrement = false;
				}
				else                
				{
					insertSQL += columnName + ",";
					insertParams += ":" + field + ",";
					updateSQL += columnName + "=:" + field + ",";
					if( type == null )
					{
						createSQL += columnName + " " + ( type = getSQLType(variables[i].@type) ) + ",";
					}
					else
					{
						createSQL += columnName + " " + type.toUpperCase() + ( typeLength == 0 ? "" : "(" + typeLength +")" ) + ",";
					}
				}
				columnTypeList[columnName] = new ColumnType(type, typeLength);
			}
			
			createSQL = createSQL.substring(0, createSQL.length-1) + ")";
			
			insertSQL = insertSQL.substring(0, insertSQL.length-1) + ") VALUES (" + insertParams;
			insertSQL = insertSQL.substring(0, insertSQL.length-1) + ")";
			
			updateSQL = updateSQL.substring(0, updateSQL.length-1);
			updateSQL += " WHERE " + metadataMap(c).identity.column + "=:" + metadataMap(c).identity.field;
			
			selectSQL += " WHERE " + metadataMap(c).identity.column + "=:" + metadataMap(c).identity.field;
			
			var deleteSQL:String = "DELETE FROM " + tableName + " WHERE " + metadataMap(c).identity.column + "=:" + metadataMap(c).identity.field;
			
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = insertSQL;
			metadataMap(c).insertStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = updateSQL;
			metadataMap(c).updateStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = deleteSQL;
			metadataMap(c).deleteStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = "SELECT * FROM " + tableName;
			metadataMap(c).selectAllStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = selectSQL;
			metadataMap(c).selectStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = "DROP TABLE " + tableName;
			metadataMap(c).dropStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = "DELETE FROM " + tableName;
			metadataMap(c).deleteAllStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = "DELETE FROM " + tableName + " WHERE " +  metadataMap(c).identity.column + " IN ";
			metadataMap(c).deleteListStmt = stmt;
			
			stmt = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = createSQL;
			stmt.execute();
			
			sqlConnection.loadSchema();
			var schema:SQLSchemaResult = sqlConnection.getSchemaResult();
			var tables:Array = schema.tables;
			var table:SQLTableSchema;
			for each( table in tables )
			{
				if( table.name == tableName )
				{
					var needAlterExecution:Boolean = false;
					var alterStatementList:Array = new Array;
					var columns:Array = new Array;
					table.columns.forEach(
						function(item:SQLColumnSchema,  position:uint, list:Array):void
						{
							columns.push(item.name);
						}
					);
					for each( var column:String in sourceColumns)
					{
						if( columns.indexOf(column) == -1)
						{
							needAlterExecution = true;
							var columnType:ColumnType = columnTypeList[column];
							alterStatementList.push( "ADD COLUMN " + column + " " + columnType.type.toUpperCase() + ( columnType.length == 0 ? "" : "(" + columnType.length +")" ));
						}
					}
					if( needAlterExecution )
					{
						stmt = new SQLStatement();
						stmt.sqlConnection = sqlConnection;
						stmt.text = "ALTER TABLE " + tableName + " " + alterStatementList.join(", ");
						stmt.execute();
					}
					break;
				}
			}
		}
		
		public function createSelect(c:Class, name:String, column:Array, field:Array, condition:Array):void
		{
			if (!metadataMap(c)) loadMetadata(c);
			metadataMap(c).addSelectStatement(_sqlConnection, name, column, field, condition);
		}
		
		public function executeSelect(c:Class, name:String, value:Array):Array
		{
			if (!metadataMap(c)) loadMetadata(c);
			var identity:SelectableColumn = metadataMap(c).getSelectField(name);
			var stmt:SQLStatement = metadataMap(c).getSelectStatement(name);
			stmt.itemClass = c;
			const length:uint = identity.field.length;
			for( var i:uint = 0 ; i < length; i++)
			{
				stmt.parameters[":"+identity.field[i]] = value[i];
			}
			stmt.execute();
			return stmt.getResult().data;
		}
		
		private function typeObject(o:Object, c:Class):Object
		{
			var instance:Object = new c();
			var fields:ArrayCollection = metadataMap(c).fields;
			
			for (var i:int; i<fields.length; i++)
			{
				var item:Object = fields.getItemAt(i);
				instance[item.field] = o[item.column];    
			}
			return instance;
		}
		
		private function getSQLType(asType:String):String
		{
			if (asType == "int" || asType == "uint")
				return "INTEGER";
			else if (asType == "Number")
				return "REAL";
			else if( asType == "Date")
				return "DATETIME";
			else if (asType == "flash.utils::ByteArray" || asType == "Object" )
				return "BLOB";
			else
				return "TEXT";                
		}
		
		public function set sqlConnection(sqlConnection:SQLConnection):void
		{
			_sqlConnection = sqlConnection;
		}
		
		public function get sqlConnection():SQLConnection
		{
			return _sqlConnection;
		}
	}
}

import flash.data.SQLConnection;
import flash.data.SQLStatement;

import mx.collections.ArrayCollection;

class EntityItemInfo{
	
	public var table:String;
	public var fields:ArrayCollection;
	public var identity:PrimaryKey;
	public var insertStmt:SQLStatement;
	public var updateStmt:SQLStatement;
	public var deleteStmt:SQLStatement;
	public var deleteListStmt:SQLStatement;
	public var deleteAllStmt:SQLStatement;
	public var selectAllStmt:SQLStatement;
	public var selectStmt:SQLStatement;
	public var dropStmt:SQLStatement;
	
	public var selectStatements:Object;
	public var selectFieldStatements:Object;
	
	public function EntityItemInfo()
	{
		selectStatements = new Object;
		selectFieldStatements = new Object;
	}
	
	public function addSelectStatement(sqlConnection:SQLConnection, name:String, column:Array, field:Array, condition:Array):SQLStatement
	{
		if( !(name in selectStatements) )
		{
			var statement:SQLStatement 	= new SQLStatement;
			statement.sqlConnection 	= sqlConnection;
			selectStatements[name] 		= statement;
			selectFieldStatements[name] = new SelectableColumn(field, column, condition);
			statement.text = "SELECT * FROM " + table + " WHERE ";
			var length:uint = column.length;
			var text:String = "";
			for( var i:uint = 0 ; i < length; i++)
			{
				text += column[i] + condition[i] + ":" + field[i];
				if( i <  length - 1 )
				{
					text += " AND ";
				}
			}
			statement.text += text;
			return statement;
		}
		return null;
	}
	
	public function getSelectStatement(name:String):SQLStatement
	{
		if( name in selectStatements )
		{
			return selectStatements[name];
		}
		return null;
	}
	
	public function getSelectField(name:String):SelectableColumn
	{
		if( name in selectFieldStatements )
		{
			return selectFieldStatements[name];
		}
		return null;
	}
}

class Column
{
	
	public function Column(field:String, column:String)
	{
		this.field 			= field;
		this.column 		= column;
	}
	
	public var field:String;
	public var column:String;
	
}

class ColumnType
{
	
	public function ColumnType(type:String, length:uint)
	{
		this.type 			= type;
		this.length 		= length;
	}
	
	public var type:String;
	public var length:uint;
	
}

class SelectableColumn
{
	
	public var field:Array;
	public var column:Array;
	public var condition:Array;
	
	public function SelectableColumn(field:Array, column:Array, condition:Array)
	{
		this.field 			= field;
		this.column 		= column;
		this.condition 		= condition;
	}
	
}

class PrimaryKey extends Column
{
	
	public var autoincrement:Boolean = true;
	
	public function PrimaryKey(field:String, column:String)
	{
		super(field, column);
	}
	
}