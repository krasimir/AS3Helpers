package com.krasimirtsonev.effects.mosaic {
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import com.krasimirtsonev.display.DisplayHelper;
    
    public class Mosaic {
        
        private var _target:MovieClip;
        private var _mask:MovieClip;
        private var _partSize:Rectangle;
        private var _parts:Array;
        
        public function Mosaic(targetToAnimate:MovieClip, partSize:Rectangle = null) {
            _target = targetToAnimate;
            _partSize = partSize || new Rectangle(0, 0, 10, 10);
        }
        public function prepare():void {
            if(!_parts) {
                _parts = [];
                var w:Number = _target.width;
                var h:Number = _target.height;
                var horizontalElements:int = Math.ceil(w / _partSize.width);
                var verticalElements:int = Math.ceil(h / _partSize.height);
                for(var i:int=0; i<horizontalElements; i++) {
                    var row:Array = [];
                    for(var j:int=0; j<verticalElements; j++) {
                        var part:MovieClip = new MovieClip();
                        var bd:BitmapData = new BitmapData(_partSize.width, _partSize.height, true, 0x000000);
                        bd.draw(_target, new Matrix(1, 0, 0, 1, - i * _partSize.width, - j * _partSize.height));
                        var b:Bitmap = new Bitmap(bd);
                        part.addChild(b);
                        part.x = i * _partSize.width;
                        part.y = j * _partSize.height;
                        row.push(part);
                    }
                    _parts.push(row);
                }
                DisplayHelper.removeAllChildren(_target);
                _target.graphics.clear();
                for(i=0; i<_parts.length; i++) {
                    for(j=0; j<_parts[i].length; j++) {
                        _target.addChild(_parts[i][j]);
                    }
                }
            }
        }
        public function apply(effect:MosaicEffect, callback:Function = null):void {
            if(callback != null) {
                effect.addEventListener(MosaicEffect.ON_APPLY, callback);
            }
            effect.parts = _parts;
            effect.partSize = _partSize;
            effect.target = _target;
            effect.apply();
        }
        public function remove(effect:MosaicEffect, callback:Function = null):void {
            if(callback != null) {
                effect.addEventListener(MosaicEffect.ON_REMOVE, callback);
            }
            effect.remove();
        }
        
    }

}