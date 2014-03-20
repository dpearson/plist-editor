###
	Copyright (c) 2011-2014, David Pearson
	All rights reserved.

	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###

plist = require "../../plist.js/lib/plist"

Object::isa = (type) ->
	typeof this is type.name.toString() or this instanceof type

arrayToHTML = (ar, key, padding) ->
	htmlCont = ""

	i = 0
	while i < ar.length
		if ar[i].isa String
			htmlCont += "<div style=\"width:100%; padding:" + padding + "px; position:relative; left:5%;\">Item " + i + "<input type=\"text\" style=\"position:absolute; left:50%; width:45%; border-width:0px;\" value=\"" + ar[i] + "\" id=\"" + key + "_" + i + "\"></div>"
		else if ar[i].isa plist.Data
			htmlCont += "<div style=\"width:100%; padding:" + padding + "px; position:relative; left:5%;\">Item " + i + "<input type=\"text\" style=\"position:absolute; left:50%; width:45%; border-width:0px;\" value=\"" + ar[i].value + "\" id=\"" + key + "_" + i + "\"></div>"
		else if ar[i].isa Number
			htmlCont += "<div style=\"width:100%; padding:" + padding + "px; position:relative; left:5%;\">Item " + i + "<input type=\"text\" style=\"position:absolute; left:50%; width:45%; border-width:0px;\" value=\"" + ar[i] + "\" id=\"" + key + "_" + i + "\"></div>"
		else if ar[i].isa Date
			htmlCont += "<div style=\"width:100%; padding:" + padding + "px; position:relative; left:5%;\">Item " + i + "<span style=\"position:absolute; left:50%; width:45%; border-width:0px;\"><select id=\"" + key + "_" + i + "month\">"
			months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
			n = 1
			while n <= 12
				htmlCont += "<option value=\"" + n + "\""
				if ar[i].getMonth() + 1 is n
					htmlCont += " selected=\"selected\""

				htmlCont += ">" + months[n - 1] + "</option>"

				n++

			actHours = ar[i].getHours()
			pm = false
			if actHours > 12
				actHours -= 12
				pm = true

			htmlCont += "</select> <input type=\"text\" maxlength=2 size=2 id=\"" + key + "_" + i + "day\" value=\"" + ar[i].getDate() + "\"> <input type=\"text\" maxlength=4 size=4 id=\"" + key + "_" + i + "year\" value=\"" + ar[i].getFullYear() + "\"><blah style=\"padding-left:50px;\"><input type=\"text\" maxlength=2 size=2 id=\"" + key + "_" + i + "hr\" value=\"" + actHours + "\">:<input type=\"text\" maxlength=2 size=2 id=\"" + key + "_" + i + "min\" value=\"" + ar[i].getMinutes() + "\">:<input type=\"text\" maxlength=2 size=2 id=\"" + key + "_" + i + "sec\" value=\"" + ar[i].getSeconds() + "\"> <select id=\"" + key + "_" + i + "tod\"><option value=\"0\">AM</option><option value=\"12\""
			if pm
				htmlCont += " selected=\"selected\""

			htmlCont += ">PM</option></select>"
			htmlCont += "</select></span></div>"
		else if ar[i].isa(Boolean) or ar[i] is false
			checked = " checked=\"checked\""
			unless ar[i]
				checked = ""

			htmlCont += "<div style=\"width:100%; padding:" + padding + "px; position:relative; left:5%;\">Item " + i + "<input type=\"checkbox\" style=\"position:absolute; left:50%; border-width:0px;\" value=\"" + ar[i] + "\" id=\"" + key + "_" + i + "\"" + checked + "></div>"
		else if ar[i].isa Array
			htmlCont += "<div style=\"position:relative; left:5%; width:100%;  padding:" + padding + "px;\"><img src=\"res/arrow-right.png\" style=\"width:12px; position:absolute; left:-12px;\" id=\"" + key + "_" + i + "arrow\" onclick=\"if(document.getElementById('" + key + "_" + i + "cont').style.display=='none'){document.getElementById('" + key + "_" + i + "cont').style.display='';document.getElementById('" + key + "_" + i + "arrow').src='res/arrow-down.png';}else{document.getElementById('" + key + "_" + i + "cont').style.display='none';document.getElementById('" + key + "_" + i + "arrow').src='res/arrow-right.png';}\"> Item " + i + "</div><div style=\"position:relative; left:5%; width:90%;  padding-bottom:" + padding + "px; padding-left:" + padding + "px; padding-right:" + padding + "px; display:none;\" id=\"" + key + "_" + i + "cont\">" + arrayToHTML(ar[i], key + "_" + i, 15) + "</div>"
		else if typeof ar[i] isnt "function"
			htmlCont += "<div style=\"position:relative; left:5%; width:100%;  padding:" + padding + "px;\"><img src=\"res/arrow-right.png\" style=\"width:12px; position:absolute; left:-12px;\" id=\"" + key + "_" + i + "arrow\" onclick=\"if(document.getElementById('" + key + "_" + i + "cont').style.display=='none'){document.getElementById('" + key + "_" + i + "cont').style.display='';document.getElementById('" + key + "_" + i + "arrow').src='res/arrow-down.png';}else{document.getElementById('" + key + "_" + i + "cont').style.display='none';document.getElementById('" + key + "_" + i + "arrow').src='res/arrow-right.png';}\"> Item " + i + "</div><div style=\"position:relative; left:5%; width:90%;  padding-bottom:" + padding + "px; padding-left:" + padding + "px; padding-right:" + padding + "px; display:none;\" id=\"" + key + "_" + i + "cont\">" + dictToHTML(ar[i], key + "_" + i, 15) + "</div>"

		i++

	htmlCont

dictToHTML = (dict, parent, padding) ->
	htmlCont = ""
	for i of dict
		if dict[i].isa String or dict[i].isa Number
			htmlCont += "<div style=\"width:100%; padding:" + padding + "px; position:relative; left:5%;\"><input type=\"text\" style=\"width:45%; border-width:0px; font-size:13px;\" value=\"" + i + "\" id=\"" + i + "_" + parent + "key\"><input type=\"text\" style=\"position:absolute; left:50%; width:45%; border-width:0px;\" value=\"" + dict[i] + "\" id=\"" + i + "_" + parent + "val\"></div>"
		else if dict[i].isa plist.Data
			htmlCont += "<div style=\"width:100%; padding:" + padding + "px; position:relative; left:5%;\"><input type=\"text\" style=\"width:45%; border-width:0px; font-size:13px;\" value=\"" + i + "\" id=\"" + i + "_" + parent + "key\"><input type=\"text\" style=\"position:absolute; left:50%; width:45%; border-width:0px;\" value=\"" + dict[i].value + "\" id=\"" + i + "_" + parent + "val\"></div>"
		else if dict[i].isa Date
			htmlCont += "<div style=\"width:100%; padding:" + padding + "px; position:relative; left:5%;\"><input type=\"text\" style=\"width:45%; border-width:0px; font-size:13px;\" value=\"" + i + "\" id=\"" + i + "_" + parent + "key\"><span style=\"position:absolute; left:50%; width:45%; border-width:0px;\"><select id=\"" + i + "_" + parent + "month\">"
			months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
			n = 1
			while n <= 12
				htmlCont += "<option value=\"" + n + "\""
				if dict[i].getMonth() + 1 is n
					htmlCont += " selected=\"selected\""

				htmlCont += ">" + months[n - 1] + "</option>"

				n++

			actHours = dict[i].getHours()
			pm = false
			if actHours > 12
				actHours -= 12
				pm = true

			htmlCont += "</select> <input type=\"text\" maxlength=2 size=2 id=\"" + i + "_" + parent + "day\" value=\"" + dict[i].getDate() + "\"> <input type=\"text\" maxlength=4 size=4 id=\"" + i + "_" + parent + "year\" value=\"" + dict[i].getFullYear() + "\"><blah style=\"padding-left:50px;\"><input type=\"text\" maxlength=2 size=2 id=\"" + i + "_" + parent + "hr\" value=\"" + actHours + "\">:<input type=\"text\" maxlength=2 size=2 id=\"" + i + "_" + parent + "min\" value=\"" + dict[i].getMinutes() + "\">:<input type=\"text\" maxlength=2 size=2 id=\"" + i + "_" + parent + "sec\" value=\"" + dict[i].getSeconds() + "\"> <select id=\"" + i + "_" + parent + "tod\"><option value=\"0\">AM</option><option value=\"12\""
			if pm
				htmlCont += " selected=\"selected\""

			htmlCont += ">PM</option></select>"
			htmlCont += "</select></span></div>"
		else if dict[i].isa(Boolean) or dict[i] is false
			checked = " checked=\"checked\""
			unless dict[i]
				checked = ""

			htmlCont += "<div style=\"width:100%; padding:" + padding + "px; position:relative; left:5%;\"><input type=\"text\" style=\"width:45%; border-width:0px; font-size:13px;\" value=\"" + i + "\" id=\"" + i + "_" + parent + "key\"><input type=\"checkbox\" style=\"position:absolute; left:50%; border-width:0px;\"" + checked + "\" id=\"" + i + "_" + parent + "val\"></div>"
		else if dict[i].isa Array
			htmlCont += "<div style=\"position:relative; left:5%; width:100%;  padding:" + padding + "px;\"><img src=\"res/arrow-right.png\" style=\"width:12px; position:absolute; left:-12px; top:20px;\" id=\"" + i + "_" + parent + "arrow\" onclick=\"if(document.getElementById('" + i + "_" + parent + "cont').style.display=='none'){document.getElementById('" + i + "_" + parent + "cont').style.display='';document.getElementById('" + i + "_" + parent + "arrow').src='res/arrow-down.png';}else{document.getElementById('" + i + "_" + parent + "cont').style.display='none';document.getElementById('" + i + "_" + parent + "arrow').src='res/arrow-right.png';}\"> <input type=\"text\" style=\"width:45%; border-width:0px; font-size:13px;\" value=\"" + i + "\" id=\"" + i + "_" + parent + "key\"></div><div style=\"position:relative; left:5%; width:90%;  padding-bottom:" + padding + "px; padding-left:" + padding + "px; padding-right:" + padding + "px; display:none;\" id=\"" + i + "_" + parent + "cont\">" + arrayToHTML(dict[i], i + "_" + parent, 15) + "</div>"
		else if typeof dict[i] isnt "function"
			htmlCont += "<div style=\"position:relative; left:5%; width:100%;  padding:" + padding + "px;\"><img src=\"res/arrow-right.png\" style=\"width:12px; position:absolute; left:-12px; top:20px;\" id=\"" + i + "_" + parent + "arrow\" onclick=\"if(document.getElementById('" + i + "_" + parent + "cont').style.display=='none'){document.getElementById('" + i + "_" + parent + "cont').style.display='';document.getElementById('" + i + "_" + parent + "arrow').src='res/arrow-down.png';}else{document.getElementById('" + i + "_" + parent + "cont').style.display='none';document.getElementById('" + i + "_" + parent + "arrow').src='res/arrow-right.png';}\"> <input type=\"text\" style=\"width:45%; border-width:0px; font-size:13px;\" value=\"" + i + "\" id=\"" + i + "_" + parent + "key\"></div><div style=\"position:relative; left:5%; width:90%;  padding-bottom:" + padding + "px; padding-left:" + padding + "px; padding-right:" + padding + "px; display:none;\" id=\"" + i + "_" + parent + "cont\">" + dictToHTML(dict[i], i + "_" + parent, 15) + "</div>"

	htmlCont

plroot = null

savearray = (ar, key) ->
	i = 0
	while i < ar.length
		if ar[i].isa(String) or ar[i].isa(Number)
			elem = document.getElementById(key + "_" + i)
			if elem isnt null
				ar[i] = elem.value
		else if ar[i].isa Date
			d = new Date()
			year = document.getElementById(key + "_" + i + "year").value
			month = document.getElementById(key + "_" + i + "month").value - 1
			day = document.getElementById(key + "_" + i + "day").value

			d.setFullYear year, month, day

			hours = parseInt document.getElementById(key + "_" + i + "hr").value
			offset = parseInt document.getElementById(key + "_" + i + "tod").value
			hours += offset

			minutes = document.getElementById(key + "_" + i + "min").value
			seconds = document.getElementById(key + "_" + i + "sec").value

			d.setHours hours, minutes, seconds

			ar[i] = d
		else if ar[i].isa Boolean
			elem = document.getElementById(key + "_" + i)
			if elem isnt null
				ar[i] = elem.checked
		else if ar[i].isa Array
			elem = document.getElementById(key + "_" + i + "cont")
			if elem isnt null
				ar[i] = savearray(ar[i], key + "_" + i)
		else if typeof ar[i] isnt "function"
			elem = document.getElementById(key + "_" + i + "cont")
			if elem isnt null
				ar[i] = savedict(ar[i], key + "_" + i)

		i++

	ar

savedict = (dict, key) ->
	for i of dict
		keyElem = document.getElementById(i + "_" + key + "key")
		valElem = document.getElementById(i + "_" + key + "val")
		if dict[i].isa(String) or dict[i].isa(Number)
			if keyElem isnt null and valElem isnt null
				keyval = keyElem.value
				val = valElem.value
				if keyval isnt i
					dict[keyval] = dict[i]
					delete dict[i]

				if val isnt dict[i]
					dict[keyval] = val
		else if dict[i].isa Boolean
			if keyElem isnt null and valElem isnt null
				keyval = keyElem.value
				val = valElem.checked
				if keyval isnt i
					dict[keyval] = dict[i]
					delete dict[i]

				if val isnt dict[i]
					dict[keyval] = val
		else if dict[i].isa Date
			keyval = keyElem.value
			if keyval isnt i
				dict[keyval] = dict[i]
				delete dict[i]

			d = new Date()

			year = document.getElementById(i + "_" + key + "year").value
			month = document.getElementById(i + "_" + key + "month").value - 1
			day = document.getElementById(i + "_" + key + "day").value

			d.setFullYear year, month, day

			hours = parseInt document.getElementById(i + "_" + key + "hr").value
			offset = parseInt document.getElementById(i + "_" + key + "tod").value
			hours += offset

			minutes = document.getElementById(i + "_" + key + "min").value
			seconds = document.getElementById(i + "_" + key + "sec").value

			d.setHours hours, minutes, seconds

			dict[i] = d
		else if dict[i].isa Array
			if keyElem isnt null
				keyval = keyElem.value
				if keyval isnt i
					dict[keyval] = dict[i]
					delete dict[i]

				dict[keyval] = savearray(dict[i], i + "_" + key)
		else if typeof dict[i] isnt "function"
			if keyElem isnt null
				keyval = keyElem.value
				if keyval isnt i
					dict[keyval] = dict[i]
					delete dict[i]

				dict[keyval] = savedict(dict[i], i + "_" + key)

	dict

save = ->
	alert(savedict(plroot, "root").exportXML())
	alert(savedict(plroot, "root").exportASCII())

dragOver = (e) ->
	e.stopPropagation()
	e.preventDefault()

fload = (e) ->
	loadimg = document.getElementById "loadimg"
	if loadimg?
		loadimg.style.display = ""

	dict = plist.parse e.target.result
	if dict isnt null and dict instanceof Object
		plroot = dict
		document.getElementById("doc").innerHTML = dictToHTML dict, "root", 15
		if loadimg?
			loadimg.style.display = "none"

		document.getElementById("toolbar").style.display = ""
	else
		document.getElementById("start").innerHTML = "That isn't a valid plist..."
		setTimeout showLaunch, 2000

drop = (e) ->
	e.stopPropagation()
	e.preventDefault()

	files = e.dataTransfer.files
	f = files[0]
	if f.name.split(".plist").length is 1
		document.getElementById("start").innerHTML = "That isn't a plist..."
		setTimeout showLaunch, 2000
		return

	if window.FileReader?
		fr = new FileReader()
		fr.onload = fload

		fr.readAsText f

fselect = (e) ->
	e.stopPropagation()
	e.preventDefault()

	files = e.target.files
	f = files[0]
	if f.name.split(".plist").length is 1
		document.getElementById("start").innerHTML = "That isn't a plist..."
		setTimeout showLaunch, 2000
		return

	fr = new FileReader()
	fr.onload = fload

	fr.readAsText f

urlselect = ->
	url = document.getElementById("fileselect").value
	if url.split("file://").length is 1 and url.split("http://").length is 1 and url.split("https://").length is 1 and url.split("//").length is 1
		url = "file://" + url

	xr = new XMLHttpRequest()

	xr.onreadystatechange = ->
		if res?
			dict = plist.parse xr.responseText
			plroot = dict
			document.getElementById("doc").innerHTML = dictToHTML dict, "root", 15

	xr.open "GET", url, true
	xr.send()

showLaunch = ->
	startElem = document.getElementById "start"
	unless window.File? or window.FileList? or window.FileReader?
		startElem.innerHTML = "Sorry, but it doesn't look like your browser is supported.\
		<br/><br/>May I recommend the latest version of either Firefox, Chrome, or Opera?"
		#document.getElementById("start").innerHTML="<input type=\"url\" id=\"fileselect\" style=\"width:80%; height:50px; position:absolute; left:10%; font-size:26px; border-width:0px;\" placeholder=\"Full File Path\">";
		#document.getElementById("fileselect").addEventListener("change", urlselect, false);
		#document.getElementById("fileselect").focus();
	else
		start.innerHTML = "<input type=\"file\" id=\"fileselect\" style=\"width:80%; \
							height:50px; position:absolute; left:10%;\">"
		document.getElementById("fileselect").addEventListener "change", fselect, false
	#else
	#	document.getElementById("start").innerHTML="Drag a File Here to Start";

document.body.addEventListener "dragenter", dragOver, false
document.body.addEventListener "dragover", dragOver, false
document.body.addEventListener "drop", drop, false

document.getElementById "savebutton"
	.addEventListener "click", save, false

showLaunch()