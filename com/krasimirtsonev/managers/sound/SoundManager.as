package com.krasimirtsonev.managers.sound {
	
	import com.krasimirtsonev.managers.tween.TweenManager;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.events.*;
	import flash.utils.setTimeout;
	import com.krasimirtsonev.utils.Delegate;
	
	/**
	 * Dispatch: Event.COMPLETE, Event.ID3, IOErrorEvent.IO_ERROR, ProgressEvent.PROGRESS
	 */
	public class SoundManager extends EventDispatcher {
		
		private var _sounds:Array;
		private var _currentSoundName:String = "";
		private var _currentSound:Sound;
		
		public function SoundManager() {
			_sounds = new Array();
		}
		/**
		 * 
		 * @param	obj		URLRequest object or Classh from library
		 * @param	name	name of the sound that you can use in functions like getSound, getChannel etc.
		 */
		public function addSound(obj:*, name:String, volume:Number = 1, loops:Number = 1):void {
			if(!obj) {
				throw Error("Wront obj parameter !!!");
			}
			var sndTransform:SoundTransform = new SoundTransform();
			sndTransform.volume = volume;
			if(String(obj) == "[object URLRequest]") {
				_sounds.push(
					{
						type:"external",
						request:obj,
						name:name,
						sound:new Sound(),
						channel:null,
						sndTransform:sndTransform,
						loops:loops,
						loopsIndex:1,
						initialVolume:volume
					}
				);
			} else {
				_sounds.push(
					{
						type:"internal",
						name:name,
						sound:obj,
						channel:null,
						sndTransform:sndTransform,
						loops:loops,
						loopsIndex:1,
						initialVolume:volume
					}
				);
			}
		}
		public function removeSound(name:String):void {
			setVolume(name, 0);
			var tmp:Array = [];
			var numOfSounds:int = _sounds.length;
			for(var i:int=0; i<numOfSounds; i++) {
				if(_sounds[i].name != name) {
					tmp.push(_sounds[i]);
				}
			}
			_sounds = tmp;
		}
		public function stop(name:String):void {
			var channel:SoundChannel = getChannel(name);
			if(channel) {
				channel.stop();
			}
		}
		public function stopAllSounds():void {
			var numOfSounds:int = _sounds.length;
			for(var i:int=0; i<numOfSounds; i++) {
				setVolume(_sounds[i].name, 0);				
			}
		}
		public function stopWithTween(name:String, steps:Number = 20):void {
			var channel:SoundChannel = getChannel(name);
			var tmp:Object = {volume:getVolume(name)};
			if(channel) {
				TweenManager.tween(
					tmp,
					{
						volume:{
							end:0, 
							steps:steps, 
							callback:function():void { 
								channel.stop() 
							},
							onStepCallback:function(value:Number):void {
								var tmp:SoundTransform = new SoundTransform();
								tmp.volume = value;
								channel.soundTransform = tmp;
							}
						}
					}
				);
			}
		}
		public function playAllSounds():void {
			var numOfSounds:int = _sounds.length;
			for(var i:int=0; i<numOfSounds; i++) {
				setVolume(_sounds[i].name, _sounds[i].initialVolume);
			}
		}
		public function play(name:String, smoothPlay:Boolean = false, steps:Number = 20, keepVolume:Boolean = false):void {
			var numOfSounds:int = _sounds.length;
			for(var i:int=0; i<numOfSounds; i++) {
				if(_sounds[i].name == name) {
					if(_sounds[i].type == "internal") {
						_sounds[i].channel = _sounds[i].sound.play(0, _sounds[i].loops, _sounds[i].sndTransform);
						_sounds[i].channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
						if(smoothPlay) {
							setVolume(name, 0);
							setTimeout(tweenVolume, 200, name, 0, _sounds[i].initialVolume, steps);
						}
						return;
					} else {
						if(keepVolume) {
							var oldVolume:Number = getVolume(name);
						}
						_sounds[i].sound = new Sound();
						_sounds[i].sound.addEventListener(Event.COMPLETE, completeHandler);
						_sounds[i].sound.addEventListener(Event.ID3, id3Handler);
						_sounds[i].sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
						_sounds[i].sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
						_sounds[i].sound.load(_sounds[i].request);
						_sounds[i].channel = _sounds[i].sound.play();
						_sounds[i].channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
						if(keepVolume) {
							setVolume(name, oldVolume);
						}
						return;
					}
					if(_sounds[i].newVolume) {
						setVolume(name, _sounds[i].newVolume);
					}
				}
			}
			throw Error("Missing sound '" + name + "' !!!");
		}
		public function setVolume(name:String, value:Number):void {
			var tmp:SoundTransform = new SoundTransform();
			tmp.volume = value;
			if(getChannel(name)) {
				getChannel(name).soundTransform = tmp;
			}
			getByName(name).sndTransform = tmp;
		}
		public function getVolume(name:String):Number {
			return getChannel(name).soundTransform.volume;
		}
		public function tweenVolume(name:String, start:*, end:*, steps:Number = 20):void {
			var tmpSound:Object = new Object();
			tmpSound.soundName = name;
			tmpSound.start = start;
			tmpSound.end = end;
			tmpSound.steps = steps;
			if(tmpSound.start == null) {
				tmpSound.start = getChannel(name).soundTransform.volume;
			}
			if(tmpSound.end == null) {
				tmpSound.end = getChannel(name).soundTransform.volume;
			}
			tmpSound.index = 0;
			setTimeout(tweenVolumeLoop, 50, tmpSound);
			//tmpSound.addEventListener(Event.ENTER_FRAME, tweenVolumeLoop);
		}
		public function clear():void {
			_sounds = new Array();			
			_currentSound = null;
		}
		public function getSound(name:String):Sound {
			return getByName(name).sound;
		}
		public function getChannel(name:String):SoundChannel {
			var obj:Object = getByName(name);
			if(obj) {
				return obj.channel;
			} else {
				return null;
			}
		}
		public function get currentSoundName():String {
			return _currentSoundName;
		}
		public function get currentSound():Sound {
			return _currentSound;
		}
		public function set enabled(e:Boolean):void {	
			if(e) {
				numberOfSounds = _sounds.length;
				for(i=0; i<numberOfSounds; i++) {
					 setVolume(_sounds[i].name, _sounds[i].tempVolume || _sounds[i].sndTransform.volume);
				}
			} else {
				var numberOfSounds:int = _sounds.length;
				for(var i:int=0; i<numberOfSounds; i++) {	
					_sounds[i].tempVolume = _sounds[i].sndTransform.volume;
					setVolume(_sounds[i].name, 0);
				}
			}
		}
		private function getByName(name:String):Object {
			var numOfSounds:int = _sounds.length;
			for(var i:int=0; i<numOfSounds; i++) {
				if(_sounds[i].name == name) {
					return _sounds[i];
				}
			}
			//throw Error("Missing sound !!!");
			return null;
		}
		private function getBySound(sound:Sound):Object {
			var numOfSounds:int = _sounds.length;
			for(var i:int=0; i<numOfSounds; i++) {
				if(_sounds[i].sound == sound) {
					return _sounds[i];
				}
			}
			//throw Error("Missing sound !!!");
			return null;
		}
		private function completeHandler(e:Event):void {
			var obj:Object = getBySound(e.target as Sound);
			_currentSoundName = obj.name;
			_currentSound = e.target as Sound;
			dispatchEvent(e);
			
		}
		private function id3Handler(e:Event):void {
			_currentSoundName = getBySound(e.target as Sound).name;
			_currentSound = e.target as Sound;
			dispatchEvent(e);
		}
		private function ioErrorHandler(e:IOErrorEvent):void {
			_currentSoundName = getBySound(e.target as Sound).name;
			_currentSound = e.target as Sound;
			dispatchEvent(e);
		}
		private function progressHandler(e:ProgressEvent):void {
			_currentSoundName = getBySound(e.target as Sound).name;
			_currentSound = e.target as Sound;
			dispatchEvent(e);
		}
		private function tweenVolumeLoop(tmpSound:Object):void {			
			if(tmpSound.index <= tmpSound.steps) {
				var value:Number = tmpSound.start + ((tmpSound.end - tmpSound.start) * (tmpSound.index / tmpSound.steps));
				tmpSound.index++;
				setVolume(tmpSound.soundName, value);
				setTimeout(tweenVolumeLoop, 50, tmpSound);
			} else {			
				tmpSound = null;
			}
		}
		private function onSoundComplete(e:Event):void {
			var numOfSounds:int = _sounds.length;
			for(var i:int=0; i<numOfSounds; i++) {
				if(_sounds[i].channel == e.target && _sounds[i].type != "internal") {
					if(_sounds[i].loopsIndex < _sounds[i].loops) {
						_sounds[i].loopsIndex += 1;
						setTimeout(Delegate.create(play, _sounds[i].name, false, 20, true), 1000);
					}
				}
			}
		}
	}
	
}