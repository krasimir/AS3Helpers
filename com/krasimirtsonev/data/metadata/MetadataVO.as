package com.krasimirtsonev.data.metadata {
	
	public class MetadataVO {
		
		public static const METADATA_FOR_CLASS:String = "MetadataForClass";
		public static const METADATA_FOR_VARIABLE:String = "MetadataForVariable";
		public static const METADATA_FOR_METHOD:String = "MetadataForMethod";
		
		public var xml:XML;
		public var classObj:*;
		public var metadata:Object = {};
		public var metadataFor:String = "";
		public var name:String = "";
		public var type:String = "";
		public var params:Array;
		public var declaredBy:String = "";
		public var returnType:String = "";
		
	}

}