package com.krasimirtsonev.utils {
	
	import flash.system.Capabilities;
	
	public class Browser {
		
		public static function flashIs():Boolean {
			return Capabilities.playerType == "External" ? false : true;
		}
		public static function flexIs():Boolean {
			return Capabilities.playerType == "StandAlone" ? false : true;
		}
		
	}

}