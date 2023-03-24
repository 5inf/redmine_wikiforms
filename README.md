Redmine Wikiforms Macro Plugin
==================================

This plugin provides macros for displaying input fields on and a simple report generation functionality for redmine wiki pages.

Requirements
------------

Redmine 3.0.x, 3.1.x, 4.0.x, 4.1.x or 5.0.x
Other versions are not tested but may work.

Installation
------------
1. Download archive and extract to /your/path/to/redmine/plugins/
2. Restart Redmine

Login to Redmine and go to Administration->Plugins. You should now see 'Redmine Wikiforms'. Enjoy!

Usage
------------

### checkbox macro

This macro displays a html checkbox on a wiki page.
The checkbox status does not get stored on the wiki page. It is just used for visualization and for generating a report without reloading the page.

Syntax:

    {{checkbox}}
    {{checkbox([size=SIZE,checked=CHECKED,label=LABEL,name=NAME])}}
    SIZE = The size of the checkbox. Can be used to enlarge the box for touch display usage.
    CHECKED = The initial status of the checkbox (true or false)
    LABEL = The label printed behind the checkbox
    NAME = The name displayed in the report
  
Examples:

    {{checkbox}}
    {{checkbox(size=50px)}}
    {{checkbox(size=5em,checked=true)}}
    {{checkbox(checked=true)}}
    {{checkbox(checked=true)}}
    {{checkbox(checked=true,label=Task perfomed,name=T1ok)}}
 
### rangefield macro

This macro displays a html ramge input field on the wiki page.
The value of this field does not get stored on the wiki page. It is just used for visualization and for generating a report as long as the page does not get reloaded.

Syntax:

    {{rangefield}}
    {{rangefield([label=LABEL,name=NAME,unit=UNIT,min=MIN,max=MAX,target=TARGET,value=VALUE])}}
    LABEL = The label printed in front of the field
    NAME = The name displayed in the report
    UNIT = The unit associated with the fields value. Displayed behind the field.
    MIN = The minimal value of the field. Values outside of this range are displayed on red background. The range is printed behind the field in brackets.
    MAX = The maximal value of the field. Values outside of this range are displayed on red background.
    TARGET = The desired value, which is displayed as  placeholder text when the field is empty
    VALUE = A predefined value for this field
  
Examples:

	{{rangefield}}
	{{rangefield([label=Value of Parameter X,name=paramX,min=10,max=20,target=15,unit=Volts])}}
  
### stringfield macro

This macro displays a html text input field on the wiki page.
The value of this field does not get stored on the wiki page. It is just used for visualization and for generating a report as long as the page does not get reloaded.

Syntax:

    {{stringfield}}
    {{stringfield([label=LABEL,name=NAME])}}
    LABEL = The label printed in front of the field
    NAME = The name displayed in the report
    PLACEHOLDER = placeholder text displayed when the field is empty
    VALUE = predefined value for this field

Examples:
  	
    {{stringfield}}
    {{stringfield([label=Value of Parameter Y,name=paramY,placeholder=parmY])}}
    
### textarea macro
    
This macro displays a html text area field on the wiki page.
The value of this field does not get stored on the wiki page. It is just used for visualization and for generating a report as long as the page does not get reloaded.

Syntax:

	{{textarea}}
	{{textarea([label=LABEL,name=NAME,placeholder=PLACEHOLDER,value=VALUU])}}
	LABEL = The label printed in front of the field
	NAME = The name displayed in the report
	PLACEHOLDER = placeholder text displayed when the field is empty
	VALUE = predefined value for this field
Examples:

	{{textarea}}
	{{textarea([label=Value of Parameter Y,name=paramY,placeholder=parmY])}}

### requestfield macro

This macro displays a html text input field on the wiki page.
In addition this field has a button behind, which can be used to request a value for the field via javascript code
The value of this field does not get stored on the wiki page. It is just used for visualization and for generating a report as long as the page does not get reloaded.

Syntax:

    {{requestfield}}
    {{requestfield([label=LABEL,name=NAME])}}
    LABEL = The label printed in front of the field
    NAME = The name displayed in the report
    PLACEHOLDER = placeholder text displayed when the field is empty
    VALUE = predefined value for this field
    REQUESTCODE = (unused) defines which action to perform when the request button is pressed.

Examples:
    
    {{requestfield}}
    {{requestfield([label=Serial Number,name=Serial,placeholder=ABC,requestcode=getSN])}}

### reloadbutton macro

This macro displays a html button to reload the page and reset all the input fields on the wiki page.

Syntax:

    {{reloadbutton}}
    {{reloadbutton([label=LABEL,ask=ASK])}}
    LABEL = The label printed on the button.
    ASK = Ask before reloading to prevent accidtial reloading and thus clearing of the input fields. The value can be true or false.

Examples:

    {{reloadbutton}}
    {{reloadbutton([label=Next Round,ask=true])}}

### protocolbutton macro

This macro displays a html button that runs a javascript reporting the values of all field on the wiki page.

Syntax:

    {{protocolbutton}}
    {{protocolbutton([label=LABEL])}}
    LABEL = The label printed on the button

Examples:
  
    {{protocolbutton}}
    {{protocolbutton([label=Create Protocol])}}
