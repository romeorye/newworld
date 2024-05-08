	function getClipboardPanel(el) {
	    return top.document.getElementById(el);
    }

	var d = top.document.createElement('div');
	d.id = 'clipboardEventDiv';
	d.style.display = 'none';
	top.document.body.insertBefore(d);
	
    var dp = top.document.createElement('div');
	dp.id = 'clipboardPasteEventDiv';
	dp.style.display = 'none';
	top.document.body.insertBefore(dp);

	d.addEventListener('clipboardEvent', function() {
		var d = getClipboardPanel('clipboardEventDiv');	
		var eventData = d.innerText;
		chrome.extension.sendRequest({
			"text" : eventData,
			"senderType" : "copy"
		});
		dp.focus(); 
	});

	dp.addEventListener('clipboardPasteEvent', function() {				
		chrome.extension.sendRequest({
			method : "getClipData"
		}, function(response) {					
			dp.innerText = response.data;
		});

	}, false);
