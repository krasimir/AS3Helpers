package com.krasimirtsonev.data.helpers {
	
	import flash.net.SharedObject;
	import com.krasimirtsonev.utils.Debug;
	
	public class Session {
		
		public static var storageName:String = "OutsetData";
		
		public static function getSession(variableName:String):* {
			var so:SharedObject = SharedObject.getLocal(storageName);
			if(so.data[variableName]) {
				return so.data[variableName];
			} else {
				null;
			}
		}
		public static function setSession(variableName:String, value:*):void {
			var so:SharedObject = SharedObject.getLocal(storageName);
			so.data[variableName] = value;
			so.flush();
		}
		public static function clear():void {
			var so:SharedObject = SharedObject.getLocal(storageName);
			so.clear();
		}
		public static function printAllSessions():void {
			var so:SharedObject = SharedObject.getLocal(storageName);
			for(var i:* in so.data) {
				Debug.echo(i + "=" + so.data[i]);
			}
		}
	}
	
}