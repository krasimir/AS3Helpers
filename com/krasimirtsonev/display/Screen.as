package com.krasimirtsonev.display {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Screen {
		
		private static var _root:DisplayObject;
		private static var _onResizeListeners:Array;
		
		public static function set root(r:DisplayObject):void {
			_onResizeListeners = [];
			_root = r;
			_root.addEventListener(Event.RESIZE, onResize);
		}
		public static function get root():DisplayObject {
			return _root;
		}
		public static function get width():Number {
			return _root.stage.stageWidth;
		}
		public static function get height():Number {
			return _root.stage.stageHeight;
		}
		public static function addOnResizeListener(func:Function):void {
			_onResizeListeners.push(func);
		}
		public static function removeOnResizeListener(func:Function):void {
			var numOfListeners:int = _onResizeListeners.length;
			var newArr:Array = [];
			for(var i:int=0; i<numOfListeners; i++) {
				if(func != _onResizeListeners[i]) {
					newArr = _onResizeListeners[i];
				}
			}
			_onResizeListeners = newArr;
		}
		private static function onResize(e:Event):void {
			var numOfListeners:int = _onResizeListeners.length;			
			for(var i:int=0; i<numOfListeners; i++) {
				_onResizeListeners[i](e);
			}
		}
	}

}