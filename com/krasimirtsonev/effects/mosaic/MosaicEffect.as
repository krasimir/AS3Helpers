package com.krasimirtsonev.effects.mosaic {
    
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.geom.Rectangle;
    
    public class MosaicEffect extends EventDispatcher {
        
        public static const ON_APPLY:String = "_ON_APPLY";
        public static const ON_REMOVE:String = "_ON_REMOVE";
        
        protected var _parts:Array;
        protected var _numOfParts:int;
        protected var _animatedParts:int = 0;
        protected var _partSize:Rectangle;
        protected var _target:MovieClip;
        
        public function MosaicEffect() {
            
        }
        public function set parts(partsArr:Array):void {
            _parts = partsArr;
            _numOfParts = _parts.length * _parts[0].length;
        }
        public function apply():void {
            _animatedParts = 0;
        }
        public function remove():void {
            _animatedParts = 0;
        }
        public function get partSize():Rectangle {
            return _partSize;
        }
        public function set partSize(value:Rectangle):void {
            _partSize = value;
        }
        public function get target():MovieClip {
            return _target;
        }
        public function set target(value:MovieClip):void {
            _target = value;
        }
        protected function onApply():void {
            dispatchEvent(new Event(ON_APPLY));
        }
        protected function onRemove():void {
            dispatchEvent(new Event(ON_REMOVE));
        }
        protected function onApplyPart():void {
            if(++_animatedParts == _numOfParts) {
                onApply();
            }
        }
        protected function onRemovePart():void {
            if(++_animatedParts == _numOfParts) {
                onRemove();
            }
        }
        
    }

}