package com.krasimirtsonev.data.helpers {

	public class Validate {
		
		public static function email(email:String):Boolean {
			var EMAIL_REGEX:RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
            return Boolean(email.match(EMAIL_REGEX));
        }
		public static function date(day:Number, month:Number, year:Number):Boolean {
			var date:Date = new Date(year, month, day);
			if(date.getMonth() == month) {
				return true;
			} else {
				return false;
			}
		}
		
	}

}