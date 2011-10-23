package com.krasimirtsonev.managers.sound {
	
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import flash.events.SampleDataEvent;
	
	public class PitchSound extends EventDispatcher {
		
		private var _sound:Sound;
		private var _bytes:ByteArray;
		private var _dynamicSound:Sound;
		private var _numSamples:int;
		private var _phase:Number;
		private var _speed:Number = 1; 
		private var _channel:SoundChannel;
		private var _volume:Number = 1;
		private var _loops:Number = 0;
		private var _maxLoops:Number = 1;
		
		public function PitchSound(sound:Sound):void {
			_sound = sound;
			_bytes = new ByteArray();
			_sound.extract(_bytes, int(_sound.length * 44.1));
		}
		public function play(loops:int = 1, volumeValue:Number = 1, speed:Number = 1, sndTransform:SoundTransform = null):void {
			_dynamicSound = new Sound();
			_dynamicSound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
			_numSamples = _bytes.length / 8;
			_phase = 0;
			_speed = speed;
			_maxLoops = loops;
			_channel = _dynamicSound.play(0, loops, sndTransform);
			if(volumeValue != 1) {
				volume = volumeValue;
			}
		}
		public function stop():void {
			if(_dynamicSound) {
				_dynamicSound.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
				_dynamicSound = null;
			}
		}
		public function set speed(s:Number):void {
			_speed = s;
		}
		public function get speed():Number {
			return _speed;
		}
		public function get channel():SoundChannel {
			return _channel;
		}
		public function get volume():Number {
			return _volume;
		}
		public function set volume(value:Number):void {
			if(value >=0 && value <= 1) {
				_volume = value;
				var sndTransform:SoundTransform = new SoundTransform();
				sndTransform.volume = _volume;
				_channel.soundTransform = sndTransform;
			}
		}
		private function onSampleData(e:SampleDataEvent):void {
			var l:Number;
			var r:Number;
			var outputLength:int = 0;
			while(outputLength < 2048) {
				_bytes.position = int(_phase) * 8;
				l = _bytes.readFloat();
				r = _bytes.readFloat();
				e.data.writeFloat(l);
				e.data.writeFloat(r);
				outputLength++;
				_phase += _speed;
				if(_phase < 0) {					
					_phase += _numSamples;
					increaseLoop();
				} else if(_phase >= _numSamples) {
					_phase -= _numSamples;
					increaseLoop();
				}
			}
		}
		private function increaseLoop():void {
			_loops += 1;
			if(_loops == _maxLoops) {
				stop();
			}
		}
		
	}

}