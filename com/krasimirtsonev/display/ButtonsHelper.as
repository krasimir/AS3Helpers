package com.krasimirtsonev.display {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.krasimirtsonev.managers.tween.TweenManager;
	import com.krasimirtsonev.utils.Delegate;
	
	public class ButtonsHelper {
		
		public static function setEvents(target:*, overT:Object = null, outT:Object = null, passEvent:Boolean = false, onClickC:Function = null, onOverC:Function = null, onOutC:Function = null, autoStopTween:Boolean = true):void {
			target.buttonMode = true;
			target.mouseChildren = false;
			target.addEventListener(MouseEvent.CLICK, Delegate.create(onClick, onClickC, passEvent));
			target.addEventListener(MouseEvent.MOUSE_OVER, Delegate.create(onOver, overT, onOverC, passEvent, autoStopTween));
			target.addEventListener(MouseEvent.MOUSE_OUT, Delegate.create(onOut, outT, onOutC, passEvent, autoStopTween));
		}
		public static function disableEvents(target:*, alpha:Number = 0.5):void {
			target.alpha = alpha;
			target.buttonMode = false;
			target.mouseChildren = false;
		}
		public static function enableEvents(target:*, alpha:Number = 1):void {
			target.alpha = alpha;
			target.buttonMode = true;
			target.mouseChildren = false;
		}
		private static function onClick(e:Event, onClickC:Function = null, passEvent:Boolean = false):void {
			if(e.target.buttonMode) {
				if(onClickC != null) {
					if(passEvent) {
						onClickC(e);
					} else {
						onClickC();
					}
				}
			}
		}
		private static function onOver(e:Event, overT:Object = null, onOverC:Function = null, passEvent:Boolean = false, autoStopTween:Boolean = true):void {
			if(e.target.buttonMode) {
				if(overT != null) {
					TweenManager.tween(e.target, overT, autoStopTween);
				} else {
					TweenManager.tween(
						e.target,
						{
							alpha:{end:0.5, steps:5}
						},
						autoStopTween
					);
				}
				if(onOverC != null) {
					if(passEvent) {
						onOverC(e);
					} else {
						onOverC();
					}
				}
			}
		}
		private static function onOut(e:Event, outT:Object = null, onOutC:Function = null, passEvent:Boolean = false, autoStopTween:Boolean = true):void {
			if(e.target.buttonMode) {
				if(outT != null) {
					TweenManager.tween(e.target, outT, autoStopTween);
				} else {
					TweenManager.tween(
						e.target,
						{
							alpha:{end:1, steps:5}
						},
						autoStopTween
					);
				}
				if(onOutC != null) {
					if(passEvent) {
						onOutC(e);
					} else {
						onOutC();
					}
				}
			}
		}
	}
	
}