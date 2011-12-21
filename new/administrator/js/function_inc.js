function emailCheck(emailStr) {
	// checks if the e-mail address is valid
	if(emailStr != ""){
		var emailPat = /^(\".*\"|[A-Za-z]\w*)@(\[\d{1,3}(\.\d{1,3}){3}]|[A-Za-z]\w*(\.[A-Za-z]\w*)+)$/;
		var matchArray = emailStr.match(emailPat);

		if (matchArray == null) {
			return false;
		}
	}
}

//check for valid date :pass in format(dd-mm-yyyy)
function IsDate(objName){
	var strDate;
	var strDateArray;
	var strDay;
	var strMonth;
	var strYear;
	var intday;
	var intMonth;
	var intYear;
	var booFound = false;
	var datefield = objName;
	var strSeparatorArray = new Array("-"," ","/",".");
	var intElementNr;
	var err = 0;
	strDate = datefield;
		
	if (strDate.length < 1) {
		return true;
	}
	
	for (intElementNr = 0; intElementNr < strSeparatorArray.length; intElementNr++) {
		if (strDate.indexOf(strSeparatorArray[intElementNr]) != -1) {
			strDateArray = strDate.split(strSeparatorArray[intElementNr]);
			if (strDateArray.length != 3) {
				err = 1;
				return false;
			} else {
				strDay = strDateArray[0];
				strMonth = strDateArray[1];
				strYear = strDateArray[2];
			}
			booFound = true;
	   	}
	}
	
	if (booFound == false) {
		if (strDate.length>5) {
			strDay = strDate.substr(0, 2);
			strMonth = strDate.substr(2, 2);
			strYear = strDate.substr(4);
	   	}
	}
	
	if (strYear.length == 2) {
		strYear = '20' + strYear;
	}
	
	intday = parseInt(strDay, 10);
	
	if (isNaN(intday)) {
		err = 2;
		return false;
	}
	
	intMonth = parseInt(strMonth, 10);	
	intYear = parseInt(strYear, 10);
	
	if (isNaN(intYear)) {
		err = 4;
		return false;
	}
	
	if (intMonth>12 || intMonth<1) {
		err = 5;
		return false;
	}
	
	if ((intMonth == 1 || intMonth == 3 || intMonth == 5 || intMonth == 7 || intMonth == 8 || intMonth == 10 || intMonth == 12) && (intday > 31 || intday < 1)) {
		err = 6;
		return false;
	}
	
	if ((intMonth == 4 || intMonth == 6 || intMonth == 9 || intMonth == 11) && (intday > 30 || intday < 1)) {
		err = 7;
		return false;
	}
	
	if (intMonth == 2) {
		if (intday < 1) {
			err = 8;
			return false;
		}
		
		if (LeapYear(intYear) == true) {
			if (intday > 29) {
				err = 9;
				return false;
			}
		} else {
			if (intday > 28) {
				err = 10;
				return false;
			}
		}
	}
	
	datefield = strDay + "-" + strMonth + "-" + strYear;	
	return true;
}

function LeapYear(intYear) {
	if (intYear % 100 == 0) {
		if (intYear % 400 == 0) { return true; }
	} else {
		if ((intYear % 4) == 0) { return true; }
	}
	return false;
}
