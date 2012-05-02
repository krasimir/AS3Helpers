package com.krasimirtsonev.effects.mosaic {
    
    import com.krasimirtsonev.managers.tween.TweenManager;
    import flash.display.MovieClip;
    import com.krasimirtsonev.math.MathHelper;
    
    public class MosaicEffectAlphaRandom extends MosaicEffect {
        
        private var _startAfter:int;
        private var _duration:int;
        private var _steps:int;
        
        public function MosaicEffectAlphaRandom(startAfter:int = 0, duration:int = 30, steps:int = 15) {
            _startAfter = startAfter;
            _duration = duration;
            _steps = steps;
        }
        public override function apply():void {
            super.apply();
            var numOfRows:int = _parts.length;
            for(var i:int=0; i<numOfRows; i++) {
                var numOfParts:int = _parts[i].length;
                for(var j:int=0; j<numOfParts; j++) {
                    var part:MovieClip = _parts[i][j];
                    TweenManager.alpha(part, 0, 1, _startAfter + MathHelper.getRandomNum(0, _duration), _steps, onApplyPart);
                }
            }
        }
        public override function remove():void {
            super.remove();
            var numOfRows:int = _parts.length;
            for(var i:int=0; i<numOfRows; i++) {
                var numOfParts:int = _parts[i].length;
                for(var j:int=0; j<numOfParts; j++) {
                    var part:MovieClip = _parts[i][j];
                    TweenManager.alpha(part, null, 0, _startAfter + MathHelper.getRandomNum(0, _duration), _steps, onRemovePart);
                }
            }
        }
        
    }

}