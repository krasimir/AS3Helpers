package com.krasimirtsonev.data.metadata {
	
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;
	import flash.system.ApplicationDomain;
	
	public class MetadataParser {
		
		private static var _xml:XML;
		private static var _classObj:*;
		
		public static function init(classObj:*, Analizer:Class):void {
			_xml = describeType(ApplicationDomain.currentDomain.getDefinition(getQualifiedClassName(classObj).replace("::", ".")));
			_classObj = classObj;
			var data:Array = [];
			data = data.concat(parse(_xml.factory.metadata.(@name == "*")));
			data = data.concat(parse(_xml.factory.variable.metadata.(@name == "*")));
			data = data.concat(parse(_xml.factory.method.metadata.(@name == "*")));
			new Analizer(data);
		}
		private static function parse(metadata:XMLList):Array {
			var data:Array = [];
			var vo:MetadataVO;
			var metadata:XMLList = metadata;	
			var metadataLength:int = metadata.length();
			for (var i:int=0; i<metadataLength; i++) {
				var args:XMLList = metadata[i].arg;
				var argsLength:int = args.length();
				switch (metadata[i].parent().name().toString()) {
					case "factory":
						vo = new MetadataVO();
						vo.metadataFor = MetadataVO.METADATA_FOR_CLASS;
						vo.xml = _xml;
						vo.classObj = _classObj;
						vo.metadata = {};
						for(var j:int=0; j<argsLength; j++) {
							vo.metadata[metadata[i].arg[j].@key.toString()] = metadata[i].arg[j].@value.toString();
						}
						data.push(vo);
					break;
					case "variable":
						vo = new MetadataVO();
						vo.metadataFor = MetadataVO.METADATA_FOR_VARIABLE;
						vo.xml = _xml;
						vo.classObj = _classObj;
						vo.metadata = {};
						for(j=0; j<argsLength; j++) {
							vo.metadata[metadata[i].arg[j].@key.toString()] = metadata[i].arg[j].@value.toString();
						}
						vo.name = metadata[i].parent().@name.toString();
						vo.type = metadata[i].parent().@type.toString();
						data.push(vo);
					break;
					case "method":
						vo = new MetadataVO();
						vo.metadataFor = MetadataVO.METADATA_FOR_VARIABLE;
						vo.xml = _xml;
						vo.classObj = _classObj;
						vo.metadata = {};
						vo.name = metadata[i].parent().@name.toString();
						vo.declaredBy = metadata[i].parent().@declaredBy.toString();
						vo.returnType = metadata[i].parent().@returnType.toString();
						for(j=0; j<argsLength; j++) {
							vo.metadata[metadata[i].arg[j].@key.toString()] = metadata[i].arg[j].@value.toString();
						}
						var params:Array = [];
						var paramsList:XMLList = metadata[i].parent().parameter;
						var numOfParams:int = paramsList.length();
						for(j=0; j<numOfParams; j++) {
							params.push(
								{
									index:metadata[i].parent().parameter[j].@index.toString(),
									type:metadata[i].parent().parameter[j].@type.toString(),
									optional:metadata[i].parent().parameter[j].@optional.toString()
								}
							);
						}
						vo.params = params;
						data.push(vo);
					break;
				}
			}
			return data;
		}
		
	}

}