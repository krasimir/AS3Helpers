package com.krasimirtsonev.display {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import mx.core.UIComponent;
	import flash.utils.getDefinitionByName;
	import flash.filters.BitmapFilterQuality;
	
	public class DisplayHelper {
		
		public static function wrapInUIComponent(obj:*):UIComponent {
			var c:UIComponent = new UIComponent();
			c.addChild(obj);
			return c;
		}
		public static function createObjectByClassName(className:String):* {
			var ClassRef:Class = getDefinitionByName(className) as Class;
			return new ClassRef();
		}
		public static function removeAllChildren(movie:MovieClip):void {
			var numOfChilds:int = movie.numChildren;
			while(movie.numChildren > 0) {
				if(movie.getChildAt(0)) {
					if(movie.contains(movie.getChildAt(0))) {
						movie.removeChild(movie.getChildAt(0));
					}
				}
			}
		}
		public static function addOutline(obj:DisplayObject, color:uint, thickness:int = 2):void {
			var outline:GlowFilter = new GlowFilter();
			outline.blurX = outline.blurY = thickness;
			outline.color = color;
			outline.quality = BitmapFilterQuality.HIGH;
			outline.strength = 100;
			var filterArray:Array = new Array();
			filterArray.push(outline);
			obj.filters = filterArray;
		}
		public static function duplicateDisplayObject(target:DisplayObject, autoAdd:Boolean = false):DisplayObject {
			// create duplicate
			var targetClass:Class = Object(target).constructor;
			var duplicate:DisplayObject = new targetClass();
		   
			// duplicate properties
			duplicate.transform = target.transform;
			duplicate.filters = target.filters;
			duplicate.cacheAsBitmap = target.cacheAsBitmap;
			duplicate.opaqueBackground = target.opaqueBackground;
			if (target.scale9Grid) {
				var rect:Rectangle = target.scale9Grid;
				// Flash 9 bug where returned scale9Grid is 20x larger than assigned
				rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				duplicate.scale9Grid = rect;
			}
		   
			// add to target parent's display list
			// if autoAdd was provided as true
			if (autoAdd && target.parent) {
				target.parent.addChild(duplicate);
			}
			return duplicate;
		}
		public static function createRaster(mc:*):MovieClip {
			var b:BitmapData = new BitmapData(mc.width, mc.height, true, 0x00000000);
			b.draw(mc, new Matrix());
			var bit:Bitmap = new Bitmap(b);
			var tmp:MovieClip = new MovieClip();
			tmp.addChild(bit);
			return tmp;
		}
		public static function colorHexToString(color:uint):String {
			return color.toString(16);
		}
		public static function colorStringToHex(color:String):uint {
			return uint("0x" + color.replace("#", ""));
		}
		
	}

}