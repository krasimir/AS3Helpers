package com.krasimirtsonev.data.helpers {
	
	import com.krasimirtsonev.utils.Delegate;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.krasimirtsonev.data.helpers.Loader;
	import com.krasimirtsonev.utils.Debug;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import mx.utils.Base64Encoder;
    import mx.utils.Base64Decoder;
	import com.krasimirtsonev.math.MathHelper;

	public class Secure {
		
		private static var _alphabet1:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz123456789";
		private static var _alphabet2:String = "qwertyuiopasdfghjklzxcvbnm1234567890QWERTYUIOASDFGHJKLZXCVBNM";
		
		public static function crypt(str:String):String {
			var numOfLetters:int = str.length;
			var numOfAlphabetLetters:int = _alphabet1.length;
			var result:String = "";
			for(var i:int=0; i<numOfLetters; i++) {
				var char:String = str.charAt(i);
				var newChar:String = "";
				for(var j:int=0; j<numOfAlphabetLetters; j++) {
					if(char == _alphabet1.charAt(j)) {
						newChar = _alphabet2.charAt(j);
					}
				}
				if(newChar == "") {
					newChar = char;
				}
				result += newChar;
			}
			return result;
		}
		public static function decrypt(str:String):String {
			var result:String = "";
			var numOfLetters:int = str.length;
			var numOfAlphabetLetters:int = _alphabet1.length;
			for(var i:int=0; i<numOfLetters; i++) {
				var char:String = str.charAt(i);
				var newChar:String = "";
				for(var j:int=0; j<numOfAlphabetLetters; j++) {
					if(char == _alphabet2.charAt(j)) {
						newChar = _alphabet1.charAt(j);
					}
				}
				if(newChar == "") {
					newChar = char;
				}
				result += newChar;
			}
			return result;
		}

		/***********************************************************************************************/
		
		private static var KEY:String = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOASDFGHJKLZXCVBNM";
 
        public static function xor(source:String):String {
            var key:String = KEY;
            var result:String = new String();
            for(var i:Number = 0; i < source.length; i++) {
                if(i > (key.length - 1)) {
                    key += key;
                }
                result += String.fromCharCode(source.charCodeAt(i) ^ key.charCodeAt(i));
            }
            return result;
        }
		
		// security url
		public static function protectMyWork(url:String, value:String, clipToHide:DisplayObject, hideOnFailed:Boolean = true):void {
			Debug.echo("protectMyWorkd url=" + url);
			if(url.indexOf("?") >= 0) {
				url += "&r=" + MathHelper.getRandomNum(0, 10000000);
			} else {
				url += "?r=" + MathHelper.getRandomNum(0, 10000000);
			}
			var dl:Loader = new Loader(url);
			dl.addEventListener(Loader.ON_DATA_LOADED, Delegate.create(onProtectMyWork, value, clipToHide));
			dl.addEventListener(Loader.ON_DATA_FAILED, Delegate.create(onProtectMyWorkFailed, hideOnFailed, clipToHide));
			dl.submit();
		}
		private static function onProtectMyWork(e:Event, value:String, clipToHide:DisplayObject):void {
			Debug.echo("onProtectMyWork " + value + " == " + e.target.data + " --> " + (value == String(e.target.data)));
			if(value != String(e.target.data)) {
				clipToHide.visible = false;
			}
		}
		private static function onProtectMyWorkFailed(e:Event, hideOnFailed:Boolean, clipToHide:DisplayObject):void {
			Debug.echo("onProtectMyWorkFailed hideOnFailed=" + hideOnFailed);
			if(hideOnFailed) {
				clipToHide.visible = false;
			}
		}
	}

}