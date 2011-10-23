package com.krasimirtsonev.data.helpers {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLLoader
	import flash.net.URLRequestMethod;
	import com.krasimirtsonev.utils.Debug;
	
	public class Loader extends EventDispatcher {
		
		public static const ON_DATA_LOADED:String = "LoaderOnDataLoaded";
		public static const ON_DATA_FAILED:String = "LoaderOnDataFailed";
		
		private var _url:String;
		private var _variablesArr:Array;
		private var _variables:URLVariables;
		private var _loader:URLLoader;
		private var _request:URLRequest;
		private var _failedError:String = "";
		private var _data:*;
		
		public function Loader(url:String) {
			_url = url;
			_variablesArr = new Array();
			_variables = new URLVariables();
			_loader = new URLLoader();
			_request = new URLRequest(_url);
			_request.method = URLRequestMethod.POST;
		}
		public function submit():void {
			_request.data = _variables;
			_loader.addEventListener(Event.COMPLETE, onDatesLoad);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onDataFiledToLoad);
			_loader.addEventListener(IOErrorEvent.NETWORK_ERROR, onDataFiledToLoad);
			_loader.addEventListener(IOErrorEvent.VERIFY_ERROR, onDataFiledToLoad);
			_loader.addEventListener(IOErrorEvent.DISK_ERROR, onDataFiledToLoad);
			_loader.load(_request);
		}
		public function addVariable(name:String, value:String):void {
			_variablesArr.push({name:name, value:value});
			_variables[name] = value;
		}
		public function printVariables():void {
			var numOfVariables:int = _variablesArr.length;
			for(var i:int=0; i<numOfVariables; i++) {
				Debug.echo(_variablesArr[i].name + "=" + _variablesArr[i].value);
			}
		}
		private function onDatesLoad(e:Event):void {
			_data = e.target.data;
			dispatchEvent(new Event(ON_DATA_LOADED));
		}
		private function onDataFiledToLoad(e:IOErrorEvent):void {
			_failedError = e.text;
			dispatchEvent(new Event(ON_DATA_FAILED));
		}
		public function get failedError():String {
			return _failedError;
		}
		public function get data():* {
			return _data;
		}
	}
	
}