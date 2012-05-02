package com.krasimirtsonev.effects.mosaic {
    
    import com.krasimirtsonev.managers.tween.TweenManager;
    import flash.display.MovieClip;
    import com.krasimirtsonev.math.MathHelper;
    
    public class MosaicEffectAlpha extends MosaicEffect {
        
        private var _startAfter:int;
        private var _steps:int;
        
        public function MosaicEffectAlpha(startAfter:int = 0, steps:int = 15) {
            _startAfter = startAfter;
            _steps = steps;
        }
        public override function apply():void {
            super.apply();
            var numOfRows:int = _parts.length;
            for(var i:int=0; i<numOfRows; i++) {
                var numOfParts:int = _parts[i].length;
                for(var j:int=0; j<numOfParts; j++) {
                    var part:MovieClip = _parts[i][j];
                    TweenManager.alpha(part, 0, 1, _startAfter + (i*j), _steps, onApplyPart);
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
                    TweenManager.alpha(part, null, 0, _startAfter + (i*j), _steps, onRemovePart);
                }
            }
        }
        
    }

}