//document.onreadystatechange=function()
//{
// if (document.readyState == 'complete')
// {
//	 fnChkObjControl();
//      if (document.all['divShowInstall'])
//        document.all['divShowInstall'].style.visibility = 'hidden';
//  }
//}

var strScripts ="<div id='divWec0' > <OBJECT ID='Wec0' CLASSID='CLSID:1CB7D663-21B7-493E-8E15-80E712ED41DD' WIDTH='900' HEIGHT='300' CodeBase='/iris/namo/NamoWec8.cab#Version=8,0,0,21'>";
strScripts +="<PARAM NAME='UserLang' VALUE=kor>";
strScripts +="<PARAM NAME='InitFileURL' VALUE='As8Init.xml'>";
strScripts +="<PARAM NAME='InitFileVer' VALUE='1.0'>";
strScripts +="<PARAM NAME='InitFileWaitTime' VALUE='3000'>";
strScripts +="<PARAM NAME='EditorAutoSaveInterval' VALUE='10'>";
strScripts +="<PARAM NAME='EditorBackupOnOff' VALUE='True'>";
strScripts +="<PARAM NAME='InstallSourceURL' VALUE='http://comp.namo.co.kr/as8/AS8_update/'>";
strScripts +="</OBJECT></div>";


strScripts +="<div id='divWec1' style='display:none'><OBJECT ID='Wec1' CLASSID='CLSID:1CB7D663-21B7-493E-8E15-80E712ED41DD' WIDTH='900' HEIGHT='300' CodeBase='/iris/namo/NamoWec8.cab#Version=8,0,0,21'>";
strScripts +="<PARAM NAME='UserLang' VALUE=kor>";
strScripts +="<PARAM NAME='InitFileURL' VALUE='As8Init.xml'>";
strScripts +="<PARAM NAME='InitFileVer' VALUE='1.0'>";
strScripts +="<PARAM NAME='InitFileWaitTime' VALUE='3000'>";
strScripts +="<PARAM NAME='EditorAutoSaveInterval' VALUE='10'>";
strScripts +="<PARAM NAME='EditorBackupOnOff' VALUE='True'>";
strScripts +="<PARAM NAME='InstallSourceURL' VALUE='http://comp.namo.co.kr/as8/AS8_update/'>";
strScripts +="</OBJECT></div>";

strScripts +="<div id='divWec2' style='display:none'><OBJECT ID='Wec2' CLASSID='CLSID:1CB7D663-21B7-493E-8E15-80E712ED41DD' WIDTH='900' HEIGHT='300' CodeBase='/iris/namo/NamoWec8.cab#Version=8,0,0,21'>";
strScripts +="<PARAM NAME='UserLang' VALUE=kor>";
strScripts +="<PARAM NAME='InitFileURL' VALUE='As8Init.xml'>";
strScripts +="<PARAM NAME='InitFileVer' VALUE='1.0'>";
strScripts +="<PARAM NAME='InitFileWaitTime' VALUE='3000'>";
strScripts +="<PARAM NAME='EditorAutoSaveInterval' VALUE='10'>";
strScripts +="<PARAM NAME='EditorBackupOnOff' VALUE='True'>";
strScripts +="<PARAM NAME='InstallSourceURL' VALUE='http://comp.namo.co.kr/as8/AS8_update/'>";
strScripts +="</OBJECT></div>";

strScripts +="<div id='divWec3' style='display:none'><OBJECT ID='Wec3' CLASSID='CLSID:1CB7D663-21B7-493E-8E15-80E712ED41DD' WIDTH='900' HEIGHT='300' CodeBase='/iris/namo/NamoWec8.cab#Version=8,0,0,21'>";
strScripts +="<PARAM NAME='UserLang' VALUE=kor>";
strScripts +="<PARAM NAME='InitFileURL' VALUE='As8Init.xml'>";
strScripts +="<PARAM NAME='InitFileVer' VALUE='1.0'>";
strScripts +="<PARAM NAME='InitFileWaitTime' VALUE='3000'>";
strScripts +="<PARAM NAME='EditorAutoSaveInterval' VALUE='10'>";
strScripts +="<PARAM NAME='EditorBackupOnOff' VALUE='True'>";
strScripts +="<PARAM NAME='InstallSourceURL' VALUE='http://comp.namo.co.kr/as8/AS8_update/'>";
strScripts +="</OBJECT></div>";

strScripts +="<div id='divWec4' style='display:none'><OBJECT ID='Wec4' CLASSID='CLSID:1CB7D663-21B7-493E-8E15-80E712ED41DD' WIDTH='900' HEIGHT='300' CodeBase='/iris/namo/NamoWec8.cab#Version=8,0,0,21'>";
strScripts +="<PARAM NAME='UserLang' VALUE=kor>";
strScripts +="<PARAM NAME='InitFileURL' VALUE='As8Init.xml'>";
strScripts +="<PARAM NAME='InitFileVer' VALUE='1.0'>";
strScripts +="<PARAM NAME='InitFileWaitTime' VALUE='3000'>";
strScripts +="<PARAM NAME='EditorAutoSaveInterval' VALUE='10'>";
strScripts +="<PARAM NAME='EditorBackupOnOff' VALUE='True'>";
strScripts +="<PARAM NAME='InstallSourceURL' VALUE='http://comp.namo.co.kr/as8/AS8_update/'>";
strScripts +="</OBJECT></div>";



document.write(strScripts);