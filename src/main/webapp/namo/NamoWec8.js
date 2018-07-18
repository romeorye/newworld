document.onreadystatechange=function()
{
 if (document.readyState == 'complete')
 {
      if (document.all['divShowInstall'])
        document.all['divShowInstall'].style.visibility = 'hidden';
  }
}

function createNamoEdit(id, w, h, targetId) {
	
	var strScripts ="<OBJECT ID='" + id + "' CLASSID='CLSID:1CB7D663-21B7-493E-8E15-80E712ED41DD' WIDTH='" + w + "' HEIGHT='" + h + "' "+"CodeBase='/iris/namo/NamoWec8.cab#Version=8,0,0,21'>";
	strScripts +="<PARAM NAME='UserLang' VALUE=kor>";
	strScripts +="<PARAM NAME='InitFileURL' VALUE='/iris/namo/As8Init.xml'>";
	strScripts +="<PARAM NAME='InitFileVer' VALUE='1.3'>";
	strScripts +="<PARAM NAME='InitFileWaitTime' VALUE='3000'>";
	strScripts +="<PARAM NAME='EditorAutoSaveInterval' VALUE='10'>";
	strScripts +="<PARAM NAME='EditorBackupOnOff' VALUE='True'>";
	strScripts +="<PARAM NAME='InstallSourceURL' VALUE='http://comp.namo.co.kr/as8/AS8_update/'>";
	strScripts +="</OBJECT>";

	$('#' + targetId).html(strScripts);
}