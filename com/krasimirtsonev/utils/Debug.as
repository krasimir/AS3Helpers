/**
 * Debug
 */
package com.krasimirtsonev.utils {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.*;
	import flash.net.*;
	import flash.external.ExternalInterface;
	import flash.utils.setTimeout;
	import flash.events.KeyboardEvent;

	public class Debug {
		
		public static var enable:Boolean = true;
		public static var enableTime:Boolean = false;		
		public static var textFieldAsOutput:TextField;
		public static var allDebugText:String = "";
		private static var debugHolder:MovieClip;
		private static var root:MovieClip;
		
		public static var sendToJavascript:Boolean = false;
		
		public static function echo(str:Object, colorize:int = 1):void {
			if(checkEneble()){
				var echoStr:String = "";
				if(enableTime) {
					var d:Date = new Date();
					echoStr += d.hours + ":" + d.minutes + ":" + d.seconds + " ";
				}
				allDebugText += echoStr + " " + str + "\n";
				if(colorize < 0) {
					trace("------------------------------------------------------------------------------------------");
				}
				trace(colorize + ":" + echoStr + " " + str);
				if(colorize < 0) {
					trace("------------------------------------------------------------------------------------------");
				}
				if(textFieldAsOutput) {
					var tmp:String = textFieldAsOutput.text;
					textFieldAsOutput.text = echoStr + " " + str + "\n" + tmp;
				}
				if(sendToJavascript) {
					ExternalInterface.call("debug", (echoStr+" "+str));
				}
				checkDebugHolderPosition();
			}
		}
		public static function toBrowser(str:Object):void {
			if(checkEneble()){
				var echoStr:String = "";
				if(enableTime) echoStr += "=>";
				navigateToURL(new URLRequest("javascript:alert('"+echoStr+" "+str+"')"));
			}
		}
		public static function checkEneble():Boolean{
			return enable;
		}
		public static function enableAIRDebug(rootMovie:MovieClip, txtWidth:Number = 400, txtHeight:Number = 400, bgAlpha:Number = 0.9, autoShow:Boolean = true, fontColor:uint = 0x999999):void {
			root = rootMovie;
			debugHolder = new MovieClip();
			debugHolder.name = "deb";
			var bg:MovieClip = new MovieClip();
			bg.graphics.beginFill(0xFFFFFF, bgAlpha);
			bg.graphics.drawRect(0, 0, txtWidth, txtHeight);
			var txt:TextField = new TextField();
			var tf:TextFormat = new TextFormat();
			tf.font = "Verdana";
			tf.size = 9;
			tf.color = fontColor;
			txt.defaultTextFormat = tf;
			txt.width = txtWidth;
			txt.height = txtHeight;
			debugHolder.addChild(bg);
			debugHolder.addChild(txt);
			root.addChild(debugHolder);
			textFieldAsOutput = txt;
			root.stage.addEventListener(KeyboardEvent.KEY_DOWN, onRootKeyDown);
			setTimeout(checkDebugHolderPosition, 500);
			if(!autoShow) {
				debugHolder.visible = false;
			}
		}
		public static function printJSON(o:Object, deep:Number = -1):void {
			if(o) {
				echo(parseJSON(o, 1, deep));
			} else {
				echo("o=" + o);
			}
		}
		private static function getTypeof(o:*):String {
			if(typeof(o) == "object") {
				if(o.length == null) {
					return "object";
				} else if(typeof(o.length) == "number") {
					return "array";
				} else {
					return "object";
				}
			} else {
				return typeof(o);
			}
		}
		private static function checkDebugHolderPosition():void {
			if(debugHolder) {					
				if(root.getChildAt(root.numChildren-1) != debugHolder) {
					if(root.contains(debugHolder)) {
						root.removeChild(debugHolder);
					}
					root.addChildAt(debugHolder, root.numChildren-1);
				}
			}
		}
		private static function onRootKeyDown(e:KeyboardEvent):void {			
			if(e.ctrlKey && e.keyCode == 123) {
				if(debugHolder) {
					if(debugHolder.visible) {
						debugHolder.visible = false;
					} else {
						debugHolder.visible = true;
					}
				}
			}
		}		
		private static function parseJSON(o:*, spaces:int = 1, deep:Number = -1):String {
			if(deep == spaces) {
				return "";
			}
			var str:String = "";
			if(getTypeof(o) == "object") {
				str += "{\n";
				for(var i:* in o) {
					str += getSpaces(spaces) + i + "=";
					if(getTypeof(o[i]) == "object" || getTypeof(o[i]) == "array") {
						str += parseJSON(o[i], spaces + 1, deep) + "\n";
					} else {
						var type:String = getTypeof(o[i]);
						if(type == "string") {
							str += "\"" + o[i] + "\"\n";
						} else if(type == "number") {
							str += o[i] + "\n";
						} else {
							str += o[i] + "\n";
						}
					}
				}
				str += getSpaces(spaces - 1 < 0 ? 0 : spaces - 1) + "}";
			} else if(getTypeof(o) == "array") {
				str += "[\n";
				var n:int = o.length;
				for(i=0; i<n; i++) {
					str += getSpaces(spaces) + "[" + i + "]=";
					if(getTypeof(o[i]) == "object" || getTypeof(o[i]) == "array") {
						str += parseJSON(o[i], spaces + 1, deep) + "\n";
					} else {
						type = getTypeof(o[i]);
						if(type == "string") {
							str += "\"" + o[i] + "\"";
						} else if(type == "number") {
							str += o[i];
						} else {
							str += o[i];
						}
						str += "\n";
					}
				}
				str += getSpaces(spaces - 1 < 0 ? 0 : spaces - 1) + "]";
			}
			return str;
		}
		private static function getSpaces(n:int):String {
			var str:String = "";
			for(var i:int=0; i<n; i++) {
				str += "  ";
			}
			return str;
		}
	}
}