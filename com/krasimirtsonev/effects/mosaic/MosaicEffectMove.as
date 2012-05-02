package com.krasimirtsonev.effects.mosaic {
    
    import com.krasimirtsonev.managers.tween.TweenManager;
    import flash.display.MovieClip;
    import com.krasimirtsonev.math.MathHelper;
    
    public class MosaicEffectMove extends MosaicEffect {
        
        private var _applyTweenObj:Object;
        private var _removeTweenObj:Object;
        private var _afterRange:Array;
        
        public function MosaicEffectMove(applyTweenObj:Object = null, removeTweenObj:Object = null, afterRange:Array = null) {
            _applyTweenObj = applyTweenObj || {
                x:{start:"-200", end:"+0", mtd:TweenManager.TYPE_OUT_BACK, steps:25},
                alpha:{start:0, end:1, steps:25}
            };
            _removeTweenObj = removeTweenObj || {
                x:{end:"+200", mtd:TweenManager.TYPE_IN_BACK, steps:25},
                alpha:{end:0, steps:25}
            };
            _afterRange = afterRange;
        }
        public override function apply():void {
            super.apply();
            var numOfRows:int = _parts.length;
            for(var i:int=0; i<numOfRows; i++) {
                var numOfParts:int = _parts[i].length;
                for(var j:int=0; j<numOfParts; j++) {
                    var part:MovieClip = _parts[i][j];
                    prepareTweenObject(_applyTweenObj, onApplyPart, getAfter() || i*j);
                    TweenManager.tween(part, _applyTweenObj);
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
                    prepareTweenObject(_removeTweenObj, onRemovePart, getAfter() || i*j);
                    TweenManager.tween(part, _removeTweenObj);
                }
            }
        }
        private function prepareTweenObject(obj:Object, callback:Function, after:int):void {
            var propertyWithHigherSteps:String = "";
            var higherSteps:int = 0;
            for(var i:* in obj) {
                if((obj[i].steps || 20) > higherSteps) {
                    higherSteps = obj[i].steps || 20;
                    propertyWithHigherSteps = i;
                }
                obj[i].after = after;
            }
            obj[propertyWithHigherSteps].callback = callback;
        }
        private function getAfter():* {
            if(_afterRange) {
                return MathHelper.getRandomNum(_afterRange[0], _afterRange[1]);
            } else {
                return false;
            }
        }
        
    }

}