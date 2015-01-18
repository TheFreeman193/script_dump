// ==UserScript==
// @name        ButtonLibrary
// @namespace   TheFreeman193
// @include     *
// @version     1.0.2
// @grant		unsafeWindow
// ==/UserScript==

buttons = {
	//usage:
	//button_object: [normW,normH,clickW,clickH,normBack,normBorder,normTxtCol,hoverBack,hoverBorder,hoverTxtCol],
};
unsafeWindow.BUTTON_LIST = cloneInto(buttons,unsafeWindow);//for global access

//Update so button centers when resizing..use x/ydif and fr/fb
prevstate = 0;
blib_btnc = function(obj, m)
{
	var dt=buttons[obj],top=obj.style.top,bottom=obj.style.bottom,left=obj.style.left,right=obj.style.right,fr,fb,xdif=dt[0]-dt[2],ydif=dt[1]-dt[3];
	fr=(!left&&right&&true);
	fb=(!top&&bottom&&true);
	switch(m)
	{
	case 1:
		if (prevstate==1) return;
		if (prevstate!=2)
		{
			obj.style.background=dt[7];
			obj.style.border=dt[8];
			obj.style.color=dt[9];
		}
		else if (prevstate==2){
			obj.style.width=dt[0]+"px";
			obj.style.height=dt[1]+"px";
		};
		break;
	case 2:
		if (prevstate==2) return;
		obj.style.width=dt[2]+'px';
		obj.style.height=dt[3]+'px';
		if (prevstate!=1)
		{
			obj.style.background=dt[7];
			obj.style.border=dt[8];
			obj.style.color=dt[9];
		}
		break;
	default:
		if (prevstate!=1&&prevstate!=2) return;
		obj.style.background=dt[4];
		obj.style.border=dt[5];
		obj.style.color=dt[6];
		if (prevstate==2)
		{
			obj.style.width=dt[0]+'px';
			//if (fr) obj.style.right=parseInt(obj.style.right)
			obj.style.height=dt[1]+'px';
		};
	};
	prevstate=m;
};

exportFunction(function blib_addatt(btn)
{
	btn.setAttribute("onmouseover", "blib_btnc(this,1)");
	btn.setAttribute("onmouseout", "blib_btnc(this,0)");
	btn.setAttribute("onmousedown", "blib_btnc(this,2)");
	btn.setAttribute("onmouseup", "blib_btnc(this,1)");
},unsafeWindow,{defineAs:"blib_addatt"});

function LoadButton(text, x, xFR, y, yFB, w, h, nw, nh, rad, zindex, back, border, textc, hvback, hvborder, hvtextc, font, fsize, cursor, attach, func)
{
	var con = document.createElement("div");
	con.style.position="absolute";
	if (xFR) con.style.right=x+"px";
	else con.style.left=x+"px";
	if (yFB) con.style.bottom=y+"px";
	else con.style.top=y+"px";
	con.style.zIndex=zindex;
	con.style.background=back;
	con.style.cursor=cursor;
	con.setAttribute("id", "blib_button");
	unsafeWindow.blib_addatt(con);
	//con.setAttribute("onmouseover", "blib_btnc(this,1)");
	//con.setAttribute("onmouseout", "blib_btnc(this,0)");
	//con.setAttribute("onmousedown", "blib_btnc(this,2)");
	//con.setAttribute("onmouseup", "blib_btnc(this,1)");
	con.onclick=func;
	con.style.border=border;
	con.style.borderRadius=rad;
	con.style.textAlign="center";
	con.style.width=w+"px";
	con.style.height=h+"px";
	//con.style.paddingTop="-2px";
	buttons[con] = [w,h,nw,nh,back,border,textc,hvback,hvborder,hvtextc];
	
	var txt = document.createElement("span");
	txt.style.fontSize=fsize;
	txt.style.fontWeight="bold";
	txt.style.textAlign="center";
	txt.style.color=textc;
	
	txt.style.fontFamily=font;
	txt.innerHTML=text;
	
	con.appendChild(txt);
	//unsafeWindow.BUTTON_LIST = buttons;//for global access
	if (attach) document.body.appendChild(con);
	if (console) console.info("Added New Button: "+text);
	return con;
}

createButton = function(label, attach, x, y, func, /*optional-->*/ w, h, clkw, clkh, cornerrad, zindex, back, border, textc, hvback, hvborder, hvtextc, font, fsize, cursor)
{
	if (!(label&&x&&y)) return "Error: Missing args!";
	if (typeof label + typeof x + typeof y != "stringnumbernumber") return "Error: Incorrect variable types!";
	var fromR = (x<0);
	var fromB = (y<0);
	x=Math.abs(x);
	y=Math.abs(y);
	w=(w||90);
	h=(h||22);
	clkw=(clkw||w-2);
	clkh=(clkh||h-2);
	cornerrad=(cornerrad||2)+"px";
	zindex=""+(zindex||1002);
	back=(back||"-moz-linear-gradient(center bottom , #F8F8F8, #CDCDCD)");
	hvback=(hvback||"-moz-linear-gradient(center top , #FFF, #ECECEC)");
	border=(border||"1px solid #cdcdcd");
	hvborder=(hvborder||border);
	textc=(textc||"#555");
	textc=(textc.search(/^#/)<0 ? "#"+textc : textc);
	hvtextc=(hvtextc||textc);
	hvtextc=(hvtextc.search(/^#/)<0 ? "#"+hvtextc : hvtextc);
	font=(font||"arial,sans-serif");
	cursor=(cursor||"pointer");
	fsize=(fsize?""+fsize:"12px");
	fsize=(fsize.search(/px$/)<0 ? fsize+"pt" : fsize);
	attach=(attach?true:false);
	if (typeof w + typeof h + typeof clkw + typeof clkh + typeof cornerrad + typeof zindex + typeof back + typeof border + typeof textc + typeof font + typeof fsize + typeof cursor 
	+ typeof hvback + typeof hvborder + typeof hvtextc + typeof func !="numbernumbernumbernumberstringstringstringstringstringstringstringstringstringstringstringfunction") 
	return "Error: Incorrect variable types!";
	
	return LoadButton(label, x, fromR, y, fromB, w, h, clkw, clkh, cornerrad, zindex, back, border, textc, hvback, hvborder, hvtextc, font, fsize, cursor, attach, func);
};

removeButton = function(obj)
{
	if (typeof obj != "object") return false;
	if (obj.parentNode && obj.getAttribute && obj.getAttribute("id")==="blib_button") 
	{
		buttons[obj] = null;
		obj.parentNode.removeChild(obj);
		obj = null;
		if (console) console.info("Removed 1 Button.");
		return true;
	};
};

clearButtons = function()
{
	var t = document.getElementsByTagName("div");
	var nt=[];
	for (var i=0;i<t.length;i++)
	{
		if (t[i].id==="blib_button") nt.push(t[i]);
	};
	var num=nt.length;
	for (var i=0;i<num;i++)
	{
		var obj=nt[i];
		buttons[obj] = null;
		obj.parentNode.removeChild(obj);
		obj = null;
	};
	if (console) console.info("Removed "+num+" Button"+(num>1?"s":"")+".");
};


blib_help = function()
{
	var helpstring = "Meanings:\n\tSTR\tString value, text\n\tBOOL\tBoolean, true/false\n\tINT\t\tInteger, Whole number value\n\tFUNC\tFunction\n\tOBJ\t\tObject\n\n\tOPT\tOptional argument\n\nFunctions:\n\tcreateButton(label, attach, x, y, func[, w, h, clkw, clkh, cornerrad, zindex, back, border, textc, hvback, hvborder, hvtextc, font, fsize, cursor])\n\t  Creates a button.\t\n\t\t-label/STR:\t\t\t  The button text.\n\t\t-attach/BOOL:\t\t  Append the button to the body tree.\n\t\t-x,y/INT:\t\t\t\t  The absolute coordinates on the page (in px, negative numbers will cause bottom/right anchor).\n\t\t-func/FUNC:\t\t\t  The function to be called upon click release.\n\t\t-w,h/INT/OPT:\t\t  Obvious. No, seriously.\n\t\t-clkw,clkh/INT/OPT:\t  The width/height when the button is clicked.\n\t\t-cornerrad/INT/OPT:\t  The border-radius property for rounded corners. 0 = no roundness.\n\t\t-zindex/INT/OPT:\t\t  The display priority of the button (see CSS z-index for info).\n\t\t-back/STR/OPT:\t\t  The background (color/image) of the button.\n\t\t-border/STR/OPT:\t  The CSS border properties of the button.\n\t\t-textc/STR/OPT:\t\t  The button's label/text colour.\n\t\t-hvback/STR/OPT:\t  The background when the cursor is over the button.\n\t\t-hvborder/STR/OPT:\t  The border when the cursor is over the button.\n\t\t-hvtextc/STR/OPT:\t  The text colour when the cursor is over the button.\n\t\t-font/STR/OPT:\t\t  The font (family) of the button's text.\n\t\t-fsize/STR/OPT:\t\t  The font size of the text.\n\t\t-cursor/STR/OPT:\t\t  The CSS cursor property (when hovering, see CSS reference for info).\n\n\t\tRETURNS: OBJ (the HTML object)\n\n\tremoveButton(obj)\n\t  Removes/destroys a button.\n\t\t-obj/OBJ:\t\t\t  The HTML object.\n\n\t\tRETURNS: BOOL (Successfully removed/not)\n\n\tclearButtons()\n\t  Removes all ButtonLib buttons from the window.\n\n\t  RETURNS: null";
	if (alert) alert(helpstring);
	if (console && console.info) console.info(helpstring);
};

//Export to window
exportFunction(createButton,unsafeWindow,{defineAs:"createButton"});
exportFunction(removeButton,unsafeWindow,{defineAs:"removeButton"});
exportFunction(clearButtons,unsafeWindow,{defineAs:"clearButtons"});
exportFunction(blib_help,unsafeWindow,{defineAs:"blib_help"});
exportFunction(blib_btnc,unsafeWindow,{defineAs:"blib_btnc"});