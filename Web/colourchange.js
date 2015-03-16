//Old-style JS moodlight; iteration example
//I wouldn't suggest you actually use this, this is only an example and there are far better ways to do it.
jMode = 1;
jRed = 0;
jGreen = 0;
jBlue = 0;

function RunJava() {
	if (jMode == 1) {		//Up Red
		jRed = jRed + 1;
		if (jRed == 255)	jMode = 2;
	};
	if (jMode==2) {	//Up Green
		jGreen = jGreen+1;
		if (jGreen == 255) jMode = 3;
	};
	if (jMode==3) { //Down Red
		jRed = jRed-1;
		if (jRed == 0) jMode = 4;
	};
	if (jMode == 4) {	//Up Blue
		jBlue = jBlue+1;
		if (jBlue == 255) jMode = 5;
	};
	if (jMode == 5) {	//Down Green
		jGreen = jGreen-1;
		if (jGreen == 0) jMode = 6;
	};
	if (jMode == 6) {		//Up Red
		jRed = jRed+1;
		if (jRed == 255) jMode = 7;
	};
	if (jMode == 7) {	//Down Blue and Red
		jBlue = jBlue-1;
		jRed = jRed-1;
		if (jRed==0 && jBlue==0) jMode = 1;
	};
	JNr = jRed.toString();JNg = jGreen.toString();JNb = jBlue.toString();JNr = d2h(jRed);JNg = d2h(jGreen);JNb = d2h(jBlue);
	if (JNr.length == 1) JNr = "0" + JNr;
	if (JNg.length == 1) JNg = "0" + JNg;
	if (JNb.length == 1) JNb = "0" + JNb;
	document.body.style.backgroundColor = "#" + JNr + JNg + JNb;
};
