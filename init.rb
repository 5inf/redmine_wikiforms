# encoding: utf-8

require 'redmine'


Redmine::Plugin.register :redmine_wikiforms do

	name 'Redmine Wiki forms plugin'
	author '5inf'
	description 'This plugin provides for displaying input fields on and a simple report generation functionality for redmine wiki pages.'
	version '0.0.0'
	url 'https://github.com/5inf/redmine_wikiforms'
	author_url 'https://github.com/5inf/'

	Redmine::WikiFormatting::Macros.register do

	desc <<-DESCRIPTION
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
DESCRIPTION
		macro :checkbox do |obj, args|
			#tmp = "args: "
			#args.each_with_index {|val, index| tmp << ''+val+'=>'+index.to_s+',' }

			args, options = extract_macro_options(args, :size, :checked, :label, :name)

			#tmp << "opt: "
			#options.each_with_index {|val, index| tmp << '(-'+val.to_s+'=>'+index.to_s+'-)' }

			#tmp << "args2: "
			#args.each_with_index {|val, index| tmp << ''+val+'=>'+index.to_s+',' }

			id = "wikicheckbox" + SecureRandom.urlsafe_base64(8)
			size	= options[:size] || ""
			label	 = options[:label] || ""
			name	= options[:name] ||	 options[:label] || id
			

			checked = (options[:checked].present? && options[:checked] == 'true') ? 'checked' : ''

			if obj.is_a?(WikiContent) || obj.is_a?(WikiContent::Version)
				out = "".html_safe
				if size != ""
				tag = "<input type='checkbox' class='wikicheckbox' name='"+name+"' id='"+id+"' style='width:"+size+";height:"+size+";+' "+checked+">"+label
			else
				tag = "<input type='checkbox' class='wikicheckbox' name='"+name+"' id='"+id+"' "+checked+">"+label
			end
				out << tag.html_safe
				#out << tmp
				out
			else
				raise 'This macro can be called from wiki pages only.'
			end
		end
	
	desc <<-DESCRIPTION
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
DESCRIPTION
		macro :rangefield do |obj, args|
			args, options = extract_macro_options(args, :label, :min, :max, :unit, :name, :value, :target)

			id = "rangefield" + SecureRandom.urlsafe_base64(8)

			value = options[:value] || ""
			name = options[:name] || options[:label] || id
			label = options[:label] || options[:name] || id
			unit	= options[:unit] || ""
			max	 = options[:max] || ""
			min	 = options[:min] || ""
			target	= options[:target] || ""

			if obj.is_a?(WikiContent) || obj.is_a?(WikiContent::Version)
				out = content_tag(:label, label+" " , :for => name, :class => "rangefieldlabel")
				out << content_tag(:input, "", :name=>name, :id=>id, :class=>"rangefield", :type => "number", :step=>"0.1", :min => min, :max => max, :value => value, :placeholder => target, :onchange => "{if(parseFloat(this.value)<parseFloat(this.min)||parseFloat(this.value)>parseFloat(this.max)){this.style.backgroundColor='\#ff0000cc';}else{this.style.backgroundColor='\#ffffffff';}}")
				tag = " "+unit
				tag +=	min != "" ? " ("+min+" "+unit+", ... ": " (..."
				tag += target != "" ? ", "+target+" "+unit+", ... " : ""
				tag += max != "" ? ", "+max+" "+unit+")" : ")"
				out << tag.html_safe
				out
			else
				raise 'This macro can be called from wiki pages only.'
			end
		end
		
	desc <<-DESCRIPTION
This macro displays a html text input field on the wiki page.
The value of this field does not get stored on the wiki page. It is just used for visualization and for generating a report as long as the page does not get reloaded.
Syntax:
	{{stringfield}}
	{{stringfield([label=LABEL,name=NAME,placeholder=PLACEHOLDER,value=VALUU])}}
	LABEL = The label printed in front of the field
	NAME = The name displayed in the report
	PLACEHOLDER = placeholder text displayed when the field is empty
	VALUE = predefined value for this field
Examples:
	{{stringfield}}
	{{stringfield([label=Value of Parameter Y,name=paramY,placeholder=parmY])}}
DESCRIPTION
		macro :stringfield do |obj, args|
			args, options = extract_macro_options(args, :size, :name, :value, :label, :placeholder)

			id = "stringfield" + SecureRandom.urlsafe_base64(8)

			name = options[:name] || options[:label] || id
			label = options[:label] || options[:name] ||	id
			placeholder = options[:placeholder] || ""
			value = options[:value] || ""

			if obj.is_a?(WikiContent) || obj.is_a?(WikiContent::Version)
				out = "".html_safe
				tag = "<label for='"+name+"' class='stringfieldlabel'>"+label+" </label>\n"
				tag << "<input type='text' class='stringfield' id='"+id+"' name='"+name+"' value='"+value+"' placeholder='"+placeholder+"'>\n"
				out << tag.html_safe
				out
			else
					raise 'This macro can be called from wiki pages only.'
			end
		end

	desc <<-DESCRIPTION
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
DESCRIPTION
		macro :textarea do |obj, args|
			args, options = extract_macro_options(args, :size, :name, :value, :label, :placeholder)

			id = "textarea" + SecureRandom.urlsafe_base64(8)

			name = options[:name] || options[:label] || id
			label = options[:label] || options[:name] ||	id
			placeholder = options[:placeholder] || ""
			value = options[:value] || ""

			if obj.is_a?(WikiContent) || obj.is_a?(WikiContent::Version)
				out = "".html_safe
				tag = "<label for='"+name+"' class='textfieldlabel'>"+label+" </label>\n"
				tag << "<textarea class='textarea' id='"+id+"' name='"+name+"' placeholder='"+placeholder+"'>"+value+"</textarea>\n"
				out << tag.html_safe
				out
			else
					raise 'This macro can be called from wiki pages only.'
			end
		end

	desc <<-DESCRIPTION
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
DESCRIPTION
		macro :requestfield do |obj, args|
			args, options = extract_macro_options(args, :size, :name, :value, :label, :placeholder, :requestcode)

			id = "requestfield" + SecureRandom.urlsafe_base64(8)

			name = options[:name] || options[:label] || id
			label = options[:label] || options[:name] ||	id
			placeholder = options[:placeholder] || ""
			value = options[:value] || ""

			if obj.is_a?(WikiContent) || obj.is_a?(WikiContent::Version)
				out = "".html_safe
				tag = "<label for='"+name+"' class='stringfieldlabel'>"+label+" </label>\n"
				tag << "<input type='text' class='stringfield' id='"+id+"' name='"+name+"' value='"+value+"' placeholder='"+placeholder+"'>\n"
				out << tag.html_safe
				out << content_tag(:button, 'Anfordern', :class => 'requestfieldbutton', :id=>"button"+id, :name=>"button"+id, :onClick => "sn=getElementById('"+id+"');if(confirm('Obtain number?')){sn.value=sn.placeholder+'12345';}")
				out
			else
					raise 'This macro can be called from wiki pages only.'
			end
		end

	desc <<-DESCRIPTION
This macro displays a html button to reload the page and reset all the input fields on the wiki page.
Syntax:
	{{reloadbutton}}
	{{reloadbutton([label=LABEL,ask=ASK])}}
	LABEL = The label printed on the button.
	ASK = Ask before reloading to prevent accidtial reloading and thus clearing of the input fields. The value can be true or false.
Examples:
	{{reloadbutton}}
	{{reloadbutton([label=Next Round,ask=true])}}
DESCRIPTION
		macro :reloadbutton do |obj, args|
			args, options = extract_macro_options(args, :label, :ask)
			label = options[:label] || "Reload"
			ask= options[:ask]=="true"? "true" : "false"
			id = "reloadbutton" + SecureRandom.urlsafe_base64(8)
			if obj.is_a?(WikiContent) || obj.is_a?(WikiContent::Version)
			out = "".html_safe
			tag = " <button type='button' onClick='if("+ask+"){if(confirm()){location.reload()}}else{location.reload();}' class='reloadbutton' id='"+id+"' name='"+id+"' value='reload'>"+label+"</button>\n"
			out << tag.html_safe
				out
			else
				raise 'This macro can be called from wiki pages only.'
			end
		end
		
	desc <<-DESCRIPTION
This macro displays a html button that runs a javascript reporting the values of all field on the wiki page.
Syntax:
	{{protocolbutton}}
	{{protocolbutton([label=LABEL])}}
	LABEL = The label printed on the button
Examples:
	{{protocolbutton}}
	{{protocolbutton([label=Create Protocol])}}
DESCRIPTION
		macro :protocolbutton do |obj, args|
			args, options = extract_macro_options(args, :label)
			label = options[:label] || "Create protocol"
			id = "protocolbutton" + SecureRandom.urlsafe_base64(8)
			if obj.is_a?(WikiContent) || obj.is_a?(WikiContent::Version)
				out = "".html_safe
				javascriptcode = <<-SCRIPTCODE
				function protocolbuttonPressed(){
						//alert('bla');
						var rangefields = document.getElementsByClassName('rangefield');
						var stringfields = document.getElementsByClassName('stringfield');
						var checkboxes = document.getElementsByClassName('wikicheckbox');
						var html='<html><head></head><body><p>Testreport</p>';
						for (var i = 0; i < rangefields.length; i++) {html+='<p>name: '+rangefields.item(i).name+' value: '+rangefields.item(i).value+'</p>';}
						for (var i = 0; i < stringfields.length; i++) {html+='<p>name: '+stringfields.item(i).name+' value: '+stringfields.item(i).value+'</p>';}
						for (var i = 0; i < checkboxes.length; i++) {html+='<p>name: '+checkboxes.item(i).name+' value: '+checkboxes.item(i).checked+'</p>';}
						html += '</body>';
						var tab = window.open('about:blank', '_blank');
						tab.document.write(html); // where 'html' is a variable containing your HTML
						tab.print();
						//tab.document.close(); // to finish loading the page
						//var data = "<p>This is 'myWindow'</p>";
						//myWindow = window.open("data:text/html," + encodeURIComponent(data),"_blank", "width=200,height=100");
						//myWindow.focus();
					}
				SCRIPTCODE
				out << javascript_tag(javascriptcode)
				tag = " <button type='button' onClick='protocolbuttonPressed()' class='protocolbutton' id='"+id+"' name='"+id+"' value='protocol'>"+label+"</button>\n"
				out << tag.html_safe
				out
			else
			 raise 'This macro can be called from wiki pages only.'
			end
		end
	#Plugin end
	end
end

