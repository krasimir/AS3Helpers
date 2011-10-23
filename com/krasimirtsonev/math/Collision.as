package com.krasimirtsonev.math {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.display.BitmapDataChannel;
	import com.krasimirtsonev.math.Vector;

	public class Collision {
		
		/**
		 * Check collision between segments (lines)
		 * @param	p1 Object in the form of {x: <x-coor>, y: <y-coor>}, starting point of 1st line segment
		 * @param	S1 Vector together with the starting point this vector defines the 1st line segment
		 * @param	p2 Object in the form of {x: <x-coor>, y: <y-coor>}, starting point of 2nd line segment
		 * @param	S2 Vector together with the starting point this vector defines the 2nd line segment
		 * @return
		 */
		public static function SegmentVsSegment(p1:Object, S1:Vector, p2:Object, S2:Vector):Number {
			var div:Number = -S2.x * S1.y + S1.x * S2.y;
			var s:Number = (-S1.y * (p1.x - p2.x) + S1.x * (p1.y - p2.y)) / div;
			var t:Number = (S2.x * (p1.y - p2.y) - S2.y * (p1.x - p2.x)) / div;
			if (t >= 0 && t <= 1 && s >= 0 && s <= 1) {
				return t;
			} else {
				return -1;
			}
		}
		public static function CircleVsCircle(circleA:MovieClip, circleB:MovieClip):Object {
			var r1:Number = (circleA.width || circleA.w) / 2;
			var r2:Number = (circleB.width || circleB.w) / 2;
			var dist:Number = new Vector(circleB.x - circleA.x, circleB.y - circleA.y).magnitude();
			var diff:Number = (r1 + r2) - dist;
			if (diff > 0) {
				return {
					depth:diff
				};
			} else {
				return {}
			}
		}
		public static function BoxVsBox(boxA:MovieClip, boxB:MovieClip):Object {
			
			var boxAWidth:Number = boxA.width || boxA.w;
			var boxAHeight:Number = boxA.height || boxA.h;
			var boxBWidth:Number = boxB.width || boxB.w;
			var boxBHeight:Number = boxB.height || boxB.h;
			
			var boxAvx:Vector = new Vector(boxAWidth / 2, 0);
			var boxAvy:Vector = new Vector(0, boxAHeight / 2);
			var boxBvx:Vector = new Vector(boxBWidth / 2, 0);
			var boxBvy:Vector = new Vector(0, boxBHeight / 2);
			var dist:Vector = new Vector(boxB.x - boxA.x, boxB.y - boxA.y);
			
			var v1:Vector = boxAvx.project(boxBvx);
			var v2:Vector = boxBvx.project(boxBvx);
			var d:Vector = dist.project(boxBvx);
			var diff:Number = (v1.magnitude() + v2.magnitude()) - d.magnitude();
						
			if(diff > 0){
				v1 = boxAvy.project(boxBvy);
				v2 = boxBvy.project(boxBvy);
				d = dist.project(boxBvy);
				var tempDiff:Number = (v1.magnitude() + v2.magnitude()) - d.magnitude();
				if (tempDiff > 0) {
					if (diff <= tempDiff) {
						var typeOfCollision:String = boxA.x < boxB.x ? "left" : "right";
						return { 
							depth:diff,
							vector:new Vector( boxA.x < boxB.x ? -diff : diff, 0),
							type:typeOfCollision
						}
					} else {
						typeOfCollision = boxA.y < boxB.y ? "top" : "bottom";
						return { 
							depth:tempDiff,
							vector:new Vector( 0, boxA.y < boxB.y ? -tempDiff : tempDiff),
							type:typeOfCollision
						}
					}					
				} else {
					return {};
				}
			} else {
				return {};
			}
		}
		public static function BoxVsCircle(box:MovieClip, circle:MovieClip):Object {
			var boxA:MovieClip = box;
			var boxB:MovieClip = circle;
			
			var boxAWidth:Number = boxA.width || boxA.w;
			var boxAHeight:Number = boxA.height || boxA.h;
			var boxBWidth:Number = boxB.width || boxB.w;
			var boxBHeight:Number = boxB.height || boxB.h;
			
			var radius:Number = circle.width / 2;
			var boxAvx:Vector = new Vector(boxAWidth / 2, 0);
			var boxAvy:Vector = new Vector(0, boxA.height / 2);
			var boxBvx:Vector = new Vector(boxB.width / 2, 0);
			var boxBvy:Vector = new Vector(0, boxB.height / 2);
			var dist:Vector = new Vector(boxB.x - boxA.x, boxB.y - boxA.y);
			
			var v1:Vector = boxAvx.project(boxBvx);
			var v2:Vector = boxBvx.project(boxBvx);
			var d:Vector = dist.project(boxBvx);
			var diff:Number = (v1.magnitude() + v2.magnitude()) - d.magnitude();
						
			if(diff > 0){
				v1 = boxAvy.project(boxBvy);
				v2 = boxBvy.project(boxBvy);
				d = dist.project(boxBvy);
				var tempDiff:Number = (v1.magnitude() + v2.magnitude()) - d.magnitude();
				if (tempDiff > 0) {
					if (diff + tempDiff < radius) {
						var cornerPos:Array = [
							[circle.x, circle.y, (box.x - box.width / 2), (box.y - box.height / 2)],
							[circle.x, circle.y, (box.x + box.width / 2), (box.y - box.height / 2)],
							[circle.x, circle.y, (box.x - box.width / 2), (box.y + box.height / 2)],
							[circle.x, circle.y, (box.x + box.width / 2), (box.y + box.height / 2)]							
						];
						var lt:Vector = new Vector(cornerPos[0][2] - cornerPos[0][0], cornerPos[0][3] - cornerPos[0][1]);
						var rt:Vector = new Vector(cornerPos[1][2] - cornerPos[1][0], cornerPos[1][3] - cornerPos[1][1]);
						var bl:Vector = new Vector(cornerPos[2][2] - cornerPos[2][0], cornerPos[2][3] - cornerPos[2][1]);
						var br:Vector = new Vector(cornerPos[3][2] - cornerPos[3][0], cornerPos[3][3] - cornerPos[3][1]);
						var corner:Object = Vector.getMinVector(lt, rt, bl, br);
						var boxV:Vector = new Vector(box.x - cornerPos[corner.index][2], box.y - cornerPos[corner.index][3]);
						dist = new Vector(box.x - circle.x, box.y - circle.y);
						tempDiff = (boxV.project(corner.vector).magnitude() + radius) - dist.project(corner.vector).magnitude();
						if (tempDiff > 0) {
							diff = diff > tempDiff ? tempDiff : diff;
							return diff;
						} else {
							return 0;
						}				
					} else {
						if (diff < tempDiff) {
							var typeOfCollision:String = boxA.x < boxB.x ? "left" : "right";
							return { 
								depth:diff,
								vector:new Vector( -diff, 0),
								type:typeOfCollision
							}
						} else {
							typeOfCollision = boxA.y < boxB.y ? "top" : "bottom";
							return { 
								depth:tempDiff,
								vector:new Vector( 0, -tempDiff),
								type:typeOfCollision
							}
						}
					}
				} else {
					return {}
				}
			} else {
				return {}
			}
		}
		/**
		 * Get collision between two rectangles
		 * @param	rect1 {x:rectX, y:rectY, width:rectWidth, height:rectHeight}
		 * @param	rect2 {x:rectX, y:rectY, width:rectWidth, height:rectHeight}
		 * @param 	center topleft | center
		 */
		public static function RectVsRect(rect1:Object, rect2:Object, center:String = "topleft"):Object {
			
			if (center == "topleft") {
				rect1.x += rect1.width / 2;
				rect1.y += rect1.height / 2;
				rect2.x += rect2.width / 2;
				rect2.y += rect2.height / 2;
			}
			
			
			var boxAWidth:Number = rect1.width;
			var boxAHeight:Number = rect1.height;
			var boxBWidth:Number = rect2.width;
			var boxBHeight:Number = rect2.height;
			
			var boxAvx:Vector = new Vector(boxAWidth / 2, 0);
			var boxAvy:Vector = new Vector(0, boxAHeight / 2);
			var boxBvx:Vector = new Vector(boxBWidth / 2, 0);
			var boxBvy:Vector = new Vector(0, boxBHeight / 2);
			var dist:Vector = new Vector(rect2.x - rect1.x, rect2.y - rect1.y);
						
			var v1:Vector = boxAvx.project(boxBvx);
			var v2:Vector = boxBvx.project(boxBvx);
			var d:Vector = dist.project(boxBvx);
			var diff:Number = (v1.magnitude() + v2.magnitude()) - d.magnitude();
						
			if(diff > 0){
				v1 = boxAvy.project(boxBvy);
				v2 = boxBvy.project(boxBvy);
				d = dist.project(boxBvy);
				var tempDiff:Number = (v1.magnitude() + v2.magnitude()) - d.magnitude();
				if (tempDiff > 0) {
					if (diff <= tempDiff) {
						var typeOfCollision:String = rect1.x < rect2.x ? "left" : "right";
						return { 
							depth:diff,
							vector:new Vector( rect1.x < rect2.x ? -diff : diff, 0),
							type:typeOfCollision
						}
					} else {
						typeOfCollision = rect1.y < rect2.y ? "top" : "bottom";
						return { 
							depth:tempDiff,
							vector:new Vector( 0, rect1.y < rect2.y ? -tempDiff : tempDiff),
							type:typeOfCollision
						}
					}					
				} else {
					return {};
				}
			} else {
				return {};
			}
		}
		public static function pixelCollision(ob1:DisplayObject, ob2:DisplayObject):Boolean {
			
			var bd1:BitmapData = new BitmapData(ob1.width, ob1.height, true, 0x000000);
			var point1:Point = new Point(ob1.x, ob1.y);
			var bd2:BitmapData = new BitmapData(ob2.width, ob2.height, true, 0x000000);
			var point2:Point = new Point(ob2.x, ob2.y);
			
			bd1.draw(ob1);
			bd2.draw(ob2);
			
			return bd1.hitTest(point1, 255, bd2, point2, 255);
			
		}
	}
}
	