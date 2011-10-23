package com.krasimirtsonev.data.helpers {
	
	import com.krasimirtsonev.utils.Debug;
	import flash.display.Stage;
	
	public class Storage {
			
		private static var _settings:Array;
		private static var _strings:Array;
		private static var _objects:Array;
		private static var _language:String = "default";
		private static var _returnKeyIfNothingFound:Boolean = false;
		
		public static function addSetting(key:String, value:*):void {			
			if(!_settings) {
				_settings = new Array();
			}
			_settings.push({key:key, value:value});			
		}
		public static function getSetting(key:String):* {
			if(_settings) {
				var numOfSettings:int = _settings.length; 
				for(var i:int=0; i<numOfSettings; i++) {
					if(_settings[i].key == key) {
						return _settings[i].value;
					}
				}
			}
			return _returnKeyIfNothingFound ? key : "";
		}
		public static function editSetting(key:String, value:*):void {
			if(_settings) {
				var numOfSettings:int = _settings.length; 
				for(var i:int=0; i<numOfSettings; i++) {
					if(_settings[i].key == key) {
						_settings[i].value = value;
						return;
					}
				}
				Storage.addSetting(key, value);
			} else {
				Debug.echo("Storage missing _settings !");
			}
		}
		public static function addText(key:String, text:String, language:String = "default"):void {
			if(!_strings) {
				_strings = new Array();
			}
			_strings.push({key:key, text:text, language:language});
		}
		public static function getText(key:String):String {
			if(_strings) {
				var numOfString:int = _strings.length; 
				for(var i:int=0; i<numOfString; i++) {
					if(_strings[i].key == key && _strings[i].language == _language) {
						return _strings[i].text;
					}
				}				
			}
			return _returnKeyIfNothingFound ? key : "";
		}
		public static function editText(key:String, text:String, language:String = "default"):void {
			if(_strings) {
				var numOfString:int = _strings.length; 
				for(var i:int=0; i<numOfString; i++) {
					if(_strings[i].key == key && _strings[i].language == language) {
						_strings[i].text = text;
						return;
					}
				}
				Storage.addText(key, text, language);
			} else {
				Debug.echo("Storage missing settings !");
			}
		}
		public static function addObject(key:String, obj:*, language:String = "default"):void {
			if(!_objects) {
				_objects = new Array();
			}
			_objects.push({key:key, obj:obj, language:language});
		}
		public static function getObject(key:String):* {
			if(_objects) {
				var numOfObjects:int = _objects.length; 
				for(var i:int=0; i<numOfObjects; i++) {
					if(_objects[i].key == key && _objects[i].language == _language) {
						return _objects[i].obj;
					}
				}		
			}
			return _returnKeyIfNothingFound ? key : "";
		}
		public static function editObject(key:String, obj:*, language:String = "default"):void {
			if(_objects) {
				var numOfObjects:int = _objects.length; 
				for(var i:int=0; i<numOfObjects; i++) {
					if(_objects[i].key == key && _objects[i].language == language) {
						_objects[i].obj = obj;
						return;
					}
				}
				Storage.addObject(key, obj, language);				
			} else {
				Debug.echo("Storage missing _objects !");
			}
		}
		public static function get language():String {
			return _language;
		}
		public static function set language(l:String):void {
			_language = l;
		}
		public static function set returnKeyIfNothingFound(b:Boolean):void {
			_returnKeyIfNothingFound = b;
		}
		public static function printSettings():void {
			Debug.echo("Storage.printSettings");
			if(_settings) {
				var numOfSettings:int = _settings.length; 
				for(var i:int=0; i<numOfSettings; i++) {
					Debug.echo(i + ". " + _settings[i].key + "=" + _settings[i].value);
				}
			} else {
				Debug.echo("Storage: No settings in Storage");
			}
		}
		public static function printStrings():void {
			Debug.echo("Storage.printStrings");
			if(_strings) {
				var numOfString:int = _strings.length; 
				for(var i:int=0; i<numOfString; i++) {
					Debug.echo((i+1) + "). " + _strings[i].str + " language=" + _strings[i].language + " text=" + _strings[i].text);
				}
			} else {
				Debug.echo("Storage: No strings in Storage");
			}
		}
		public static function clear():void {
			_settings = [];
			_strings = [];
			_objects = [];
		}
		public static function registerSWFVariables(stage:Stage, defaultValues:Object = null):void {
			var parameters:Object = stage.loaderInfo.parameters;
			var added:Array = [];
			if(parameters) {
				if(defaultValues) {
					for(var j:* in defaultValues) {
						Storage.addSetting(j, defaultValues[j]);
						added.push(j);
					}
				}
				for (var i: * in parameters) {
					var numOfAdded:int = added.length;
					var edited:Boolean = false;
					for(var k:int=0; k<numOfAdded; k++) {
						if(added[k] == i) {
							edited = true;
							Storage.editSetting(i, parameters[i]);
						}
					}
					if(!edited) {
						Storage.addSetting(i, parameters[i]);
					}
				}
			}
		}
	}
	
}