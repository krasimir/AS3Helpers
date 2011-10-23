package com.krasimirtsonev.math {
	
	import flash.geom.Point;

	public class MathHelper {
		
		public static function formatNumOfDigitsAfterDot(digit:Number, digitsAfterDot:Number = 2):Number {
			var str:String = digit.toString();
			var tmp:Array = str.split(".");
			if(tmp.length <= 1) {
				return digit;
			} else {
				return Number(tmp[0] + "." + String(tmp[1]).substr(0, digitsAfterDot));
			}
		}
		public static function distanceBetweenPoints(point1:Point, point2:Point):Number {
			return Math.sqrt(Math.pow(point1.x - point2.x, 2) + Math.pow(point1.y - point2.y, 2));
		}
		public static function getRandomNum(min:Number, max:Number):Number {
			 var num:Number  = Math.floor(Math.random() * (max - min + 1)) + min;
			 return num;
		}
		public static function toRadians(degrees:Number):Number{
			return degrees*Math.PI/180;
		}
		public static function toDegrees(radians:Number):Number{
			return radians*180/Math.PI;
		}
		
	}

}