package com.krasimirtsonev.managers.tween {
	
	import com.krasimirtsonev.math.MathHelper;
	import flash.events.EventDispatcher;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import com.krasimirtsonev.math.Ease;

	public class TweenManager {
		
		public static const TYPE_IN_BACK:String = "InBack";
		public static const TYPE_OUT_BACK:String = "OutBack";
		public static const TYPE_IN_OUT_BACK:String = "InOutBack";
		public static const TYPE_OUT_BOUNCE:String = "OutBounce";
		public static const TYPE_IN_BOUNCE:String = "InBounce";
		public static const TYPE_IN_OUT_BOUNCE:String = "InOutBounce";
		public static const TYPE_IN_CIRC:String = "InCirc";
		public static const TYPE_OUT_CIRC:String = "OutCirc";
		public static const TYPE_IN_OUT_CIRC:String = "InOutCirc";
		public static const TYPE_IN:String = "In";
		public static const TYPE_OUT:String = "Out";
		public static const TYPE_IN_OUT:String = "InOut";
		public static const TYPE_IN_ELASTIC:String = "InElastic";
		public static const TYPE_OUT_ELASTIC:String = "OutElastic";
		public static const TYPE_IN_OUT_ELASTIC:String = "InOutElastic";
		public static const TYPE_IN_EXPO:String = "InExpo";
		public static const TYPE_OUT_EXPO:String = "OutExpo";
		public static const TYPE_IN_OUT_EXPO:String = "InOutExpo";
		public static const TYPE_LINEAR:String = "Linear";
		public static const TYPE_IN_LINEAR:String = "InLinear";
		public static const TYPE_OUT_LINEAR:String = "OutLinear";
		public static const TYPE_IN_OUT_LINEAR:String = "InOutLinear";
		public static const TYPE_IN_QUAD:String = "InQuad";
		public static const TYPE_OUT_QUAD:String = "OutQuad";
		public static const TYPE_IN_OUT_QUAD:String = "InOutQuad";
		public static const TYPE_IN_QUART:String = "InQuart";
		public static const TYPE_OUT_QUART:String = "OutQuart";
		public static const TYPE_IN_OUT_QUART:String = "InOutQuart";
		public static const TYPE_IN_QUINT:String = "InQuint";
		public static const TYPE_OUT_QUINT:String = "OutQuint";
		public static const TYPE_IN_OUT_QUINT:String = "InOutQuint";
		public static const TYPE_IN_SINE:String = "InSine";
		public static const TYPE_OUT_SINE:String = "OutSine";
		public static const TYPE_IN_OUT_SINE:String = "InOutSine";
		
		private static var _loopMovie:MovieClip;
		private static var _items:Array;
		private static var _isLooping:Boolean;
		
		private static function init():void {
			_loopMovie = new MovieClip();
			_items = new Array();
			_isLooping = false;
		}
		public static function loop(e:Event):void {
			var numOfItems:int = _items.length;
			for (var i:int = 0; i < numOfItems; i++) {
				var target:Object = _items[i].target;
				var tweenObj:Object = _items[i].tweenObj;
				if(!tweenObj.endAnimation){
					switch(tweenObj.type) {
						case "normal":	
							if(tweenObj.iterator >= tweenObj.after){
								if (tweenObj.iterator <= (tweenObj.steps + tweenObj.after)) {
									target[tweenObj.propName] = tweenObj.posArray[tweenObj.iterator - tweenObj.after];
									if(tweenObj.onStepCallback) {
										tweenObj.onStepCallback(tweenObj.posArray[tweenObj.iterator - tweenObj.after]);
									}
								} else {
									tweenObj.endAnimation = true;
									if (tweenObj.callback != null) {
										callCallback(tweenObj.callback);
										tweenObj.callback = null;
									}
								}
							}
							tweenObj.iterator++;
						break;
						case "frame":
							if (tweenObj.iterator >= tweenObj.after) {								
								if (tweenObj.iterator <= (tweenObj.posArray.length + tweenObj.after)) {
									if(target && tweenObj){
										var index:int = tweenObj.iterator - tweenObj.after - 1 < 0 ? 0 : tweenObj.iterator - tweenObj.after - 1;
										target.gotoAndStop(tweenObj.posArray[index]);
									}
								}else{
									tweenObj.endAnimation = true;
									if (tweenObj.callback != null) {
										callCallback(tweenObj.callback);
										tweenObj.callback = null;
									}
								}
							}
							tweenObj.iterator++;
						break;
						case "color":
							if (tweenObj.iterator >= tweenObj.after) {
								if (tweenObj.colorIterator <= 1) {
									target.transform.colorTransform = interpolateColor(tweenObj.start, tweenObj.end, tweenObj.colorIterator);
									tweenObj.colorIterator += 1 / tweenObj.steps;
								} else {
									tweenObj.endAnimation = true;
									if (tweenObj.callback != null) {
										callCallback(tweenObj.callback);
										tweenObj.callback = null;
									}
								}
							}
							tweenObj.iterator++;
						break;
					}
				}
			}
			clear();
		}		
		private static function clear():void {
			var numOfItems:int = _items.length;
			var ended:int = 0;
			for (var i:int = 0; i < numOfItems; i++) {
				var target:Object = _items[i].target;
				var tweenObj:Object = _items[i].tweenObj;
				if (tweenObj.endAnimation) {
					ended++;
				}
			}
			if (ended == _items.length) {
				_loopMovie.removeEventListener(Event.ENTER_FRAME, loop);
				_items = new Array();	
				_isLooping = false;
			}
		}
		public static function tween(target: *, properties:Object, autoStop:Boolean = true):void {			
			if (!_loopMovie || !_items) {
				init();
			}
			
			if(autoStop) {
				stop(target);
			}
			
			// add to list
			for (var propName:* in properties) {
				var prop:Object = properties[propName];
				var tweenObj:Object = {};
				tweenObj.start = prop.start == null ? target[propName] : prop.start;
				tweenObj.end = prop.end == null ? target[propName] : prop.end;
				tweenObj.steps = prop.steps == null ? 20 : prop.steps;
				tweenObj.mtd = prop.mtd == null ? TweenManager.TYPE_LINEAR : prop.mtd;
				tweenObj.after = prop.after == null ? 0 : prop.after;
				tweenObj.callback = prop.callback;
				tweenObj.after = checkTweenProp(tweenObj.after, propName, target);
				tweenObj.start = checkTweenProp(tweenObj.start, propName, target);
				tweenObj.end = checkTweenProp(tweenObj.end, propName, target);
				tweenObj.iterator = 0;
				tweenObj.endAnimation = false;
				tweenObj.posArray = calcValues(tweenObj.start, tweenObj.end, tweenObj.steps, tweenObj.mtd);
				tweenObj.type = "normal";
				tweenObj.propName = propName;
				tweenObj.onStepCallback = prop.onStepCallback;
				target[propName] = tweenObj.start;
				_items.push(
					{
						target:target,
						propName:propName,
						tweenObj:tweenObj,
						properties:properties
					}
				);
			}	
			if (!_isLooping) {
				_loopMovie.addEventListener(Event.ENTER_FRAME, loop);
			}
		}
		public static function gotoFrame(target: *, properties:Object):void {
			if (!_loopMovie || !_items) {
				init();
			}
						
			stop(target, "frame");
			
			var tweenObj:Object = {};
			tweenObj.start = properties.start == null ? 1 : properties.start;
			tweenObj.end = properties.end == null ? target.totalFrames : properties.end;
			tweenObj.after = properties.after == null ? 0 : properties.after;
			tweenObj.callback = properties.callback;
			tweenObj.iterator = 0;
			tweenObj.endAnimation = false;
			tweenObj.type = "frame";
			target.gotoAndStop(tweenObj.start);
			var posArray:Array = new Array();
			var i:int = tweenObj.start;
			while (i != tweenObj.end) {
				posArray.push(i);
				if (tweenObj.start > tweenObj.end) {
					i--;
				} else {
					i++;
				}
			}	
			posArray.push(i);
			tweenObj.posArray = posArray;
			_items.push(
				{
					target:target,
					tweenObj:tweenObj,
					properties:properties
				}
			);
			if (!_isLooping) {
				_loopMovie.addEventListener(Event.ENTER_FRAME, loop);
			}
		}
		public static function color(target: *, properties:Object):void {
			if (!_loopMovie || !_items) {
				init();
			}
			
			stop(target, "color");
			
			var tweenObj:Object = {};
			var startColor:ColorTransform = new ColorTransform();
			var endColor:ColorTransform = new ColorTransform();
			startColor.color = properties.start;			
			endColor.color = properties.end;
			tweenObj.iterator = 0;
			tweenObj.colorIterator = 0;
			tweenObj.steps = properties.steps || 20;
			tweenObj.start = startColor;
			tweenObj.end = endColor;
			tweenObj.type = "color";
			tweenObj.after = properties.after == null ? 0 : properties.after;
			target.transform.colorTransform = tweenObj.start;
			_items.push(
				{
					target:target,
					tweenObj:tweenObj,
					properties:properties
				}
			);
			if (!_isLooping) {
				_loopMovie.addEventListener(Event.ENTER_FRAME, loop);
			}
		}
		public static function stop(target: *, type:String = "normal"):Object {
			if(_items){
				var numOfItems:int = _items.length;
				if(numOfItems > 0){
					for (var i:int = 0; i < numOfItems; i++) {
						if (_items[i].target == target && _items[i].tweenObj.type == type) {
							_items[i].tweenObj.callback = null;
							_items[i].tweenObj.endAnimation = true;
							return {
								stepsToEnd: _items[i].tweenObj.posArray.length - _items[i].tweenObj.iterator,
								currentStepsIterator: _items[i].tweenObj.iterator,
								totalSteps: _items[i].tweenObj.posArray.length
							};
						}
					}
				}
			}
			return null;
		}
		public static function currentStepsLeft(target:*, propName:String, type:String = "normal"):Number {
			if(_items){
				var numOfItems:int = _items.length;
				if(numOfItems > 0){
					for (var i:int = 0; i < numOfItems; i++) {
						if (_items[i].target == target && _items[i].tweenObj.type == type && _items[i].propName.toString() == propName) {
     						return _items[i].tweenObj.iterator - _items[i].tweenObj.after;
						}
					}
				}
			}
			return 0;
		}
		public static function isTweening(target: *, type:String = "normal"):Boolean {
			if(_items){
				var numOfItems:int = _items.length;
				if(numOfItems > 0){
					for (var i:int = 0; i < numOfItems; i++) {
						if (_items[i].target == target && _items[i].tweenObj.type == type) {
							if(!_items[i].tweenObj.endAnimation) {
								return true;
							}
						}
					}
				}
			}
			return false;
		}
		public static function alpha(target: *, start:* = null, end:* = null, after:Number = 0, steps:Number = 20, callback:Function = null):void {
			TweenManager.tween(
				target,
				{
					alpha:{start:start, end:end, after:after, steps:steps, callback:callback}
				}
			);
		}
		public static function get items():Number {
			if(_items) {
				return _items.length;
			} else {
				return 0;
			}
		}
		public static function calculateTween(start:Number, end:Number, steps:Number, mtd:String):Array {
			return calcValues(start, end, steps, mtd);
		}
		// ADDITIONAL FUNCTIONS
		private static function interpolateColor(start:ColorTransform, end:ColorTransform, t:Number):ColorTransform {			
			var result:ColorTransform = new ColorTransform();			
			result.redMultiplier = start.redMultiplier + (end.redMultiplier - start.redMultiplier)*t;
			result.greenMultiplier = start.greenMultiplier + (end.greenMultiplier - start.greenMultiplier)*t;
			result.blueMultiplier = start.blueMultiplier + (end.blueMultiplier - start.blueMultiplier)*t;
			result.alphaMultiplier = start.alphaMultiplier + (end.alphaMultiplier - start.alphaMultiplier)*t;
			result.redOffset = start.redOffset + (end.redOffset - start.redOffset)*t;
			result.greenOffset = start.greenOffset + (end.greenOffset - start.greenOffset)*t;
			result.blueOffset = start.blueOffset + (end.blueOffset - start.blueOffset)*t;
			result.alphaOffset = start.alphaOffset + (end.alphaOffset - start.alphaOffset) * t;
			return result;
		}
		private static function calcValues(startPos:Number, endPos:Number, steps:Number, mtd:String):Array {
			
			var arr:Array = new Array();
			var calcEndPos:Number;
			
			for(var i:Number=0; i<=steps; i++){
				calcEndPos = (endPos-startPos);
				switch(mtd){
					case "InBack": arr[i] = Ease.InBack(i, startPos, calcEndPos, steps, 1.70158); break;
					case "OutBack": arr[i] = Ease.OutBack(i,startPos,calcEndPos,steps, 1.70158); break;
					case "InOutBack": arr[i] = Ease.InOutBack(i,startPos,calcEndPos,steps, 1.70158); break;
					case "OutBounce": arr[i] = Ease.OutBounce(i,startPos,calcEndPos,steps); break;
					case "InBounce": arr[i] = Ease.InBounce(i,startPos,calcEndPos,steps); break;
					case "InOutBounce": arr[i] = Ease.InOutBounce(i,startPos,calcEndPos,steps); break;
					case "InCirc": arr[i] = Ease.InCirc(i,startPos,calcEndPos,steps); break;
					case "OutCirc": arr[i] = Ease.OutCirc(i,startPos,calcEndPos,steps); break;
					case "InOutCirc": arr[i] = Ease.InOutCirc(i,startPos,calcEndPos,steps); break;
					case "In": arr[i] = Ease.In(i,startPos,calcEndPos,steps); break;
					case "Out": arr[i] = Ease.Out(i,startPos,calcEndPos,steps); break;
					case "InOut": arr[i] = Ease.InOut(i,startPos,calcEndPos,steps); break;
					case "InElastic": arr[i] = Ease.InElastic(i,startPos,calcEndPos,steps, 0, 0); break;
					case "OutElastic": arr[i] = Ease.OutElastic(i,startPos,calcEndPos,steps, 0, 0); break;
					case "InOutElastic": arr[i] = Ease.InOutElastic(i,startPos,calcEndPos,steps, 0, 0); break;
					case "InExpo": arr[i] = Ease.InExpo(i,startPos,calcEndPos,steps); break;
					case "OutExpo": arr[i] = Ease.OutExpo(i,startPos,calcEndPos,steps); break;
					case "InOutExpo": arr[i] = Ease.InOutExpo(i,startPos,calcEndPos,steps); break;
					case "Linear": arr[i] = Ease.Linear(i,startPos,calcEndPos,steps); break;
					case "InLinear": arr[i] = Ease.InLinear(i,startPos,calcEndPos,steps); break;
					case "OutLinear": arr[i] = Ease.OutLinear(i,startPos,calcEndPos,steps); break;
					case "InOutLinear": arr[i] = Ease.InOutLinear(i,startPos,calcEndPos,steps); break;
					case "InQuad": arr[i] = Ease.InQuad(i,startPos,calcEndPos,steps); break;
					case "OutQuad": arr[i] = Ease.OutQuad(i,startPos,calcEndPos,steps); break;
					case "InOutQuad": arr[i] = Ease.InOutQuad(i,startPos,calcEndPos,steps); break;
					case "InQuart": arr[i] = Ease.InQuart(i,startPos,calcEndPos,steps); break;
					case "OutQuart": arr[i] = Ease.OutQuart(i,startPos,calcEndPos,steps); break;
					case "InOutQuart": arr[i] = Ease.InOutQuart(i,startPos,calcEndPos,steps); break;
					case "InQuint": arr[i] = Ease.InQuint(i,startPos,calcEndPos,steps); break;
					case "OutQuint": arr[i] = Ease.OutQuint(i,startPos,calcEndPos,steps); break;
					case "InOutQuint": arr[i] = Ease.InOutQuint(i,startPos,calcEndPos,steps); break;
					case "InSine": arr[i] = Ease.InQuint(i,startPos,calcEndPos,steps); break;
					case "OutSine": arr[i] = Ease.OutQuint(i,startPos,calcEndPos,steps); break;
					case "InOutSine": arr[i] = Ease.InOutQuint(i,startPos,calcEndPos,steps); break;
					default: trace("Wrong name of the Method !!!"); break;
				}
			}
			return arr;
		}
		private static function checkTweenProp(o: *, propName:String, target:Object): * {
			switch(typeof(o)) {
				case "string":
					return target[propName] + Number(o);
				break;
				case "object":
					switch(o.type) {
						case "random":
							return MathHelper.getRandomNum(o.min, o.max);
						break;
					}
				break;
				default:
					return o;
				break;
			}
		}	
		private static function callCallback(callback:*):void {
			if(getTypeof(callback) == "array") {
				var numOfCallbacks:int = (callback as Array).length;
				for(var i:int=0; i<numOfCallbacks; i++) {
					callback[i]();
				}
			} else {
				callback();
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
	}
	
}
