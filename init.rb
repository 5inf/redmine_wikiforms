# encoding: utf-8

require 'redmine'


Redmine::Plugin.register :redmine_wikiforms do

  name 'Redmine Wiki checkbox plugin'
  author '5inf'
  description 'This macro provides checkboxes on wiki pages.'
  version '0.0.0'
  url 'https://github.com/5inf/redmine_wikicheckbox'
  author_url 'https://github.com/5inf/'

  Redmine::WikiFormatting::Macros.register do
  desc <<-DESCRIPTION
  Provides a macro to display a html checkbox on a wiki page.
  The checkbox status does not get stored anywhere. It is just used for visualization.
  Syntax:
     {{checkbox}}
     {{checkbox([size=SIZE,checked=CHECKED])}}
  Examples:
     {{checkbox}}
     {{checkbox(size=50px)}}
     {{checkbox(size=50px,checked=true)}}
     {{checkbox(checked)}}

  DESCRIPTION

macro :checkbox do |obj, args|
        #tmp = "args: "
        #args.each_with_index {|val, index| tmp << ''+val+'=>'+index.to_s+',' }

        args, options = extract_macro_options(args, :size, :checked)

        #tmp << "opt: "
        #options.each_with_index {|val, index| tmp << '(-'+val.to_s+'=>'+index.to_s+'-)' }

        #tmp << "args2: "
        #args.each_with_index {|val, index| tmp << ''+val+'=>'+index.to_s+',' }

        size  = options[:size] || ""

        checked = (options[:checked].present? && options[:checked] == 'true') ? 'checked' : ''

        if obj.is_a?(WikiContent) || obj.is_a?(WikiContent::Version)
                out = "".html_safe
                id = "wikicheckbox" + SecureRandom.urlsafe_base64(8)
                if size != ""
                        tag = "<input type='checkbox' class='wikicheckbox' name='"+id+"' id='"+id+"' style='width:"+size+";height:"+size+";+' "+checked+">"
                else
                        tag = "<input type='checkbox' class='wikicheckbox' name='"+id+"' id='"+id+"' "+checked+">"
                end
                out << tag.html_safe
#               out << tmp
                out
        else
                raise 'This macro can be called from wiki pages only.'
        end

    end

macro :rangefield do |obj, args|
        args, options = extract_macro_options(args, :size, :min, :max, :unit, :name, :value)

        id = "rangefield" + SecureRandom.urlsafe_base64(8)

        value = options[:value] || ""
        name = options[:name] || id
        unit  = options[:unit] || ""
        max  = options[:max] || ""
        min  = options[:min] || ""

        if obj.is_a?(WikiContent) || obj.is_a?(WikiContent::Version)
                out = "".html_safe

                tag = "<label for='"+name+"' class='rangefieldlabel'>"+name+" </label>\n"
                tag << " <input type='number' step='0.1'  onchange='{if(parseFloat(this.value)<parseFloat(this.min)||parseFloat(this.value)>parseFloat(this.max)){this.style.backgroundColor=\"\#ff0000cc\";}else{this.style.backgroundColor$

                out << tag.html_safe
                out
        else
                raise 'This macro can be called from wiki pages only.'
        end

    end

macro :stringfield do |obj, args|
        args, options = extract_macro_options(args, :size, :name, :value)

        value = options[:value] || ""

        id = "stringfield" + SecureRandom.urlsafe_base64(8)

        name = options[:name] || id

        if obj.is_a?(WikiContent) || obj.is_a?(WikiContent::Version)
                out = "".html_safe

                tag = "<label for='"+name+"' class='stringfieldlabel'>"+name+" </label>\n"
                tag << " <input type='text' class='stringfield' id='"+id+"' name='"+name+"' value='"+value+"' placeholder='"+name+"'>\n"
                out << tag.html_safe
                out
        else
                raise 'This macro can be called from wiki pages only.'
        end

    end

macro :reloadbutton do |obj, args|
        args, options = extract_macro_options(args, :label)

        label = options[:label] || "Reload"

        id = "reloadbutton" + SecureRandom.urlsafe_base64(8)

        if obj.is_a?(WikiContent) || obj.is_a?(WikiContent::Version)
                out = "".html_safe

                tag = " <button type='button' onClick='location.reload()' class='reloadbutton' id='"+id+"' name='"+id+"' value='reload'>"+label+"</button>\n"
                out << tag.html_safe
                out
        else
                raise 'This macro can be called from wiki pages only.'
        end

    end
macro :protocolbutton do |obj, args|
        args, options = extract_macro_options(args, :label)

        label = options[:label] || "Create protocol"

        id = "protocolbutton" + SecureRandom.urlsafe_base64(8)

        if obj.is_a?(WikiContent) || obj.is_a?(WikiContent::Version)
                out = "".html_safe

                javascriptcode = <<-SCRIPTCODE
                        function protocolbuttonPressed(){
                                alert('bla');
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
                tag = " <button type='button' onClick='protocolbuttonPressed()' class='reloadbutton' id='"+id+"' name='"+id+"' value='reload'>"+label+"</button>\n"
                out << tag.html_safe
                out



        else
                raise 'This macro can be called from wiki pages only.'
        end

    end


#Plugin end
  end
end

