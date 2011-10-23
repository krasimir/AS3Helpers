package com.krasimirtsonev.managers.sound {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.media.SoundMixer;
	
	public class SoundSpectrum extends EventDispatcher {
		
		public static const ON_SPECTRUM_DATA:String = "_ON_SPECTRUM_DATA";
		
		private var _leftChannel:Vector.<Number>;
		private var _rightChannel:Vector.<Number>
		private var _ba:ByteArray;
		private var _FFTMode:Boolean = false;
		private var _stretchFactor:int = 0;
		private var _tmpMovie:MovieClip;
		
		public function SoundSpectrum() {
			_ba = new ByteArray();
			_tmpMovie = new MovieClip();
		}
		public function get FFTMode():Boolean {
			return _FFTMode;
		}
		public function set FFTMode(value:Boolean):void {
			_FFTMode = value;
		}
		public function get stretchFactor():int {
			return _stretchFactor;
		}
		public function set stretchFactor(value:int):void {
			_stretchFactor = value;
		}
		public function get leftChannel():Vector.<Number> {
			return _leftChannel;
		}
		public function get rightChannel():Vector.<Number> {
			return _leftChannel;
		}
		public function start():void {
			_tmpMovie.addEventListener(Event.ENTER_FRAME, collect);
		}
		public function stop():void {
			_tmpMovie.removeEventListener(Event.ENTER_FRAME, collect);
		}
		private function collect(e:Event):void {
			SoundMixer.computeSpectrum(_ba, _FFTMode, _stretchFactor);
			_leftChannel = new Vector.<Number>();
			_rightChannel = new Vector.<Number>();
			for(var i:int=0; i<512; i++) {
				if(i < 256) {
					_leftChannel.push(_ba.readFloat());
				} else {
					_rightChannel.push(_ba.readFloat());
				}
			}
			dispatchEvent(new Event(ON_SPECTRUM_DATA));
		}
		
	}

}