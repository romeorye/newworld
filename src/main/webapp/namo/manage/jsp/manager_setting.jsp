<%@page contentType="text/html;charset=utf-8" %>
<%@include file = "manager_util.jsp"%>
<%@include file = "./include/session_check.jsp"%>
<%
	String fileRealFolder = "";
	String ContextPath = request.getContextPath();
	String urlPath = rootFolderPath(request.getRequestURI());
	urlPath = urlPath.substring(0, urlPath.indexOf("manage/jsp"));

	ServletContext context = getServletConfig().getServletContext();
	fileRealFolder = context.getRealPath(urlPath);

	//2013.08.26 [2.0.5.23] mwhong tomcat8.0 에서 getRealPath가 null을 리턴하여 수정
	if(/*fileRealFolder == null &&*/ urlPath != null && ContextPath != null){
		fileRealFolder = context.getRealPath(urlPath.substring(ContextPath.length()));
	}

	if (ContextPath != null && !ContextPath.equals("") && !ContextPath.equals("/")){
		File tempFileRealDIR = new File(fileRealFolder);
		if(!tempFileRealDIR.exists()){
			if (urlPath != null && urlPath.indexOf(ContextPath) != -1){
				String rename_image_temp = urlPath.substring(ContextPath.length());
				fileRealFolder = context.getRealPath(rename_image_temp);
			}
		}
	}

	if (fileRealFolder.lastIndexOf(File.separator) != fileRealFolder.length() - 1){
		fileRealFolder = fileRealFolder + File.separator;
	}

	String url = xmlUrl(fileRealFolder);
	Element root = configXMlLoad(url);
	Hashtable settingValue = childValueList(root);

	String encodingStyleValue = "";
	String EncodingValue = "";

	if (settingValue.get("UploadFileNameType") != null){
		String FileNameType = (String)settingValue.get("UploadFileNameType");
	
		if (FileNameType != ""){
			if(FileNameType.indexOf(",")!= -1){
				String FileNameTypeArr[] = FileNameType.split(",");
				encodingStyleValue = FileNameTypeArr[0];
				if(FileNameTypeArr.length > 1) EncodingValue = FileNameTypeArr[1];
			}
			else{
				encodingStyleValue = FileNameType;
			}
		}
	}

	String userAddMenuList = "";
	
	if(settingValue.get("AddMenuCheck").equals("true")){
		if(settingValue.get("AddMenu") != ""){
			List addMenuListValue = (List)settingValue.get("AddMenu");
			for(int i=0; i<addMenuListValue.size(); i++){
				if(userAddMenuList.equals("")) userAddMenuList = (String)addMenuListValue.get(i);
				else userAddMenuList += "|" + (String)addMenuListValue.get(i);
			}
		}
	}
	
	if (settingValue.get("AccessibilityOption") == null  || settingValue.get("AccessibilityOption") == "" ) settingValue.put("AccessibilityOption", "0");
	if (settingValue.get("UploadFileSubDir") == null || settingValue.get("UploadFileSubDir") == "") settingValue.put("UploadFileSubDir", "true");
	if (settingValue.get("HideAddImageCheckbox") == null || settingValue.get("HideAddImageCheckbox") == "") settingValue.put("HideAddImageCheckbox", "false");
	if (settingValue.get("DisplayLoadingBar") == null || settingValue.get("DisplayLoadingBar") == "") settingValue.put("DisplayLoadingBar", "true");
	if (settingValue.get("SupportBrowser") == null || settingValue.get("SupportBrowser") == "") settingValue.put("SupportBrowser", "");
	
	//CE3 추가된 요소들
	if (settingValue.get("UploadFileExtBlockList") == null|| settingValue.get("UploadFileExtBlockList") == "") settingValue.put("UploadFileExtBlockList", "0|jsp,exe,php");
	if (settingValue.get("UploadImageFileExtBlockList") == null|| settingValue.get("UploadImageFileExtBlockList") == "") settingValue.put("UploadImageFileExtBlockList", "0|gif,jpeg,jpg,png,bmp");
	if (settingValue.get("AttributeBlockList") == null || settingValue.get("AttributeBlockList") == "") settingValue.put("AttributeBlockList", "0|onclick,onerror");
	if (settingValue.get("TagBlockList") == null || settingValue.get("TagBlockList") == "") settingValue.put("TagBlockList", "0|iframe,meta");
	if (settingValue.get("FontColor") == null || settingValue.get("FontColor") == "") settingValue.put("FontColor", "#000000");
	if (settingValue.get("FontSizeList") == null || settingValue.get("FontSizeList") == "") settingValue.put("FontSizeList", "7.5pt,8pt,9pt,10pt,11pt,12pt,14pt,16pt,18pt,20pt,22pt,24pt,26pt,28pt,36pt");
	if (settingValue.get("Font") == null || settingValue.get("Font") == "") settingValue.put("Font", "");
	if (settingValue.get("LineHeightList") == null || settingValue.get("LineHeightList") == "") settingValue.put("LineHeightList", "100%,120%,140%,150%,160%,180%,200%");
	if (settingValue.get("IndentPaddingValue") == null || settingValue.get("IndentPaddingValue") == "") settingValue.put("IndentPaddingValue", "40");
	if (settingValue.get("ImgLineColor") == null || settingValue.get("ImgLineColor") == "") settingValue.put("ImgLineColor", "#000000");
	if (settingValue.get("TableLineColor") == null || settingValue.get("TableLineColor") == "") settingValue.put("TableLineColor", "#000000");
	if (settingValue.get("TableBGColor") == null || settingValue.get("TableBGColor") == "") settingValue.put("TableBGColor", "#FFFFFF");
	
	if (settingValue.get("DefaultFont") == null || settingValue.get("DefaultFont") == "") settingValue.put("DefaultFont", "");
	if (settingValue.get("DefaultFontSize") == null || settingValue.get("DefaultFontSize") == "") settingValue.put("DefaultFontSize", "");
	if (settingValue.get("Placeholder") == null || settingValue.get("Placeholder") == "") settingValue.put("Placeholder", "");

	// BlockList 적용 체크(적용:UploadFileExtBlockListChecked, 목록:UploadFileExtBlockListTextarea)
	String[] UploadFileExtBlockListArr;
	if (settingValue.get("UploadFileExtBlockList") != null && settingValue.get("UploadFileExtBlockList").toString().indexOf("|") != -1) {
		UploadFileExtBlockListArr = settingValue.get("UploadFileExtBlockList").toString().split("\\|");
		settingValue.put("UploadFileExtBlockListChecked", ("0".equals(UploadFileExtBlockListArr[0]) ? "" : " checked=\"checked\" ")) ;
		
		if(UploadFileExtBlockListArr.length > 1){
			settingValue.put("UploadFileExtBlockListTextarea", UploadFileExtBlockListArr[1]);
		}else{
			settingValue.put("UploadFileExtBlockListTextarea", "");
		}
		
	}

	String[] UploadImageFileExtBlockListArr;
	if (settingValue.get("UploadImageFileExtBlockList") != null && settingValue.get("UploadImageFileExtBlockList").toString().indexOf("|") != -1) {
		UploadImageFileExtBlockListArr = settingValue.get("UploadImageFileExtBlockList").toString().split("\\|");
		settingValue.put("UploadImageFileExtBlockListChecked", ("0".equals(UploadImageFileExtBlockListArr[0]) ? "" : " checked=\"checked\" ")) ;
		
		if(UploadImageFileExtBlockListArr.length > 1){
			settingValue.put("UploadImageFileExtBlockListTextarea", UploadImageFileExtBlockListArr[1]);
		}else{
			settingValue.put("UploadImageFileExtBlockListTextarea", "");
		}
		
	}

	String[] AttributeBlockListArr;
	if (settingValue.get("AttributeBlockList") != null && settingValue.get("AttributeBlockList").toString().indexOf("|") != -1) {
		AttributeBlockListArr = settingValue.get("AttributeBlockList").toString().split("\\|");
		settingValue.put("AttributeBlockListChecked", ("0".equals(AttributeBlockListArr[0]) ? "" : " checked=\"checked\" ")) ;
		
		if(AttributeBlockListArr.length > 1){
			settingValue.put("AttributeBlockListTextarea", AttributeBlockListArr[1]);
		}else{
			settingValue.put("AttributeBlockListTextarea", "");
		}	
	}
	
	String[] TagBlockListArr;
	if (settingValue.get("TagBlockList") != null && settingValue.get("TagBlockList").toString().indexOf("|") != -1) {
		TagBlockListArr = settingValue.get("TagBlockList").toString().split("\\|");
		settingValue.put("TagBlockListChecked", ("0".equals(TagBlockListArr[0]) ? "" : " checked=\"checked\" ")) ;
		
		if(TagBlockListArr.length > 1){
			settingValue.put("TagBlockListTextarea", TagBlockListArr[1]);
		}else{
			settingValue.put("TagBlockListTextarea", "");
		}	
	}
	
	//줄바꾸기설정
	settingValue.put("ReturnKeyActionBRChecked", ("false".equals(settingValue.get("ReturnKeyActionBR")) ? "" : " checked=\"checked\" ")) ;

	// 아이콘 비활성화
	/*
	String[] DisableToolbarButtonsArr;
	if (settingValue.get("DisableToolbarButtons") != null && settingValue.get("DisableToolbarButtons").toString().indexOf("|") != -1) {
		DisableToolbarButtonsArr = settingValue.get("DisableToolbarButtons").toString().split("\\|");
		settingValue.put("DisableToolbarButtonsChecked", ("0".equals(DisableToolbarButtonsArr[0]) ? "" : " checked=\"checked\" ")) ;
		
		if(DisableToolbarButtonsArr.length > 1){
			settingValue.put("DisableToolbarButtonsLists", DisableToolbarButtonsArr[1]);
		}
		
	}
*/
	//템플릿 설정//////////////////////////////////////////////////////
	String[] TemplateListArr;
	TemplateListArr = new String[1];
	if (settingValue.get("Template") != null && settingValue.get("Template").toString().indexOf(",") != -1) {
		TemplateListArr = settingValue.get("Template").toString().split(",");
	}else if(settingValue.get("Template") != null) {
		
		TemplateListArr[0] = settingValue.get("Template").toString();
	}
	///////////////////////////////////////////////////////////////////
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>Namo CrossEditor : Admin</title>
	<script type="text/javascript">var pe_DF="pe_Ws"; </script>
	<script type="text/javascript" src="../../lib/jquery-1.7.2.min.js"> </script>
	<script type="text/javascript">var ce$=namo$.noConflict(true); </script>
	<script type="text/javascript" src="../manage_common.js"> </script>
	<script type="text/javascript" language="javascript" src="../../js/namo_cengine.js"> </script>
	<script type="text/javascript" language="javascript" src="../manager.js"> </script>
	<script type="text/javascript" src="../jscolor/jscolor.js"> </script>
	<link type="text/css" rel="stylesheet" href="../../css/namose_general.css" />
	<link type="text/css" rel="stylesheet" href="../css/common.css" />
	<style>.icon{margin:1px 1px 1px 1px;padding:0px;width:18px;height:18px;cursor:pointer;}</style>
</head>

<body>

<%@include file = "../include/top.html"%>

<form method="post" id="adminSetForm" name="adminSetForm" action="manager_proc.jsp" onsubmit="return pe_bD();">



<div id="pe_aNh">
	<table class="pe_zy">
		<tr>
			<td class="pe_kt">

				<table id="Info">
					<tr>
						<td style="padding:0 0 0 10px;height:30px;text-align:left">
						<font style="font-size:14pt;color:#3e77c1;font-weight:bold;text-decoration:none;"><span id="pe_KF"></span></font></td>
						<td id="InfoText"><span id="pe_Ce"></span></td>
					</tr>
					<tr>
						<td colspan="2"><img id="pe_Mb" src="../images/title_line.jpg" alt="" /></td>
					</tr>
				</table>

				<table class="pe_ru">
					<tr>
						<td class="pe_aOI">				
							<ul>
								<li class="pe_nV pe_TP"><input type="button" id="setting_base" value="" style="width:110px;height:28px;" class="pe_zK pe_jD" /></li>
								<li class="pe_nV"><input type="button" id="setting_edit" value="" style="width:110px;height:28px;" class="pe_zK pe_jD" /></li>
								<li class="pe_nV"><input type="button" id="setting_view" value="" style="width:110px;height:28px;" class="pe_zK pe_jD" /></li>
								<li class="pe_nV"><input type="button" id="setting_ab" value="" style="width:110px;height:28px;" class="pe_zK pe_jD" /></li>
							</ul>
						
						</td>
					</tr>
					<tr>
						<td class="pe_pE pe_lo"><font style="font-size:9pt;color:#FF9F4B;font-weight:bold;"><span id="pe_OQ"></span></font></td>
					</tr>
				</table>

			</td>
		</tr>
		
		<tr>
			<td class="pe_kt">
				<div id="pe_aph">
					<table class="pe_Am">
						<tr>
							<td>
								<table class="pe_ft"><tr><td class="pe_ic" colspan="3"></td></tr>
								</table>
							 
								<table class="pe_ft">
								
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Mf"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='WebServerOS' id='WebServerOS' class="inputSelectStyle">
												<option value=''></option>
												<option value='WINDOW' <% if(settingValue.get("WebServerOS").equals("WINDOW")) out.println("selected=\"selected\"");%>>WINDOW</option>
												<option value='LINUX' <% if(settingValue.get("WebServerOS").equals("LINUX"))out.println("selected=\"selected\"");%>>LINUX</option>
												<option value='UNIX' <% if(settingValue.get("WebServerOS").equals("UNIX")) out.println("selected=\"selected\"");%>>UNIX</option>
											</select>
										</td>
									</tr>
									
									<tr>
										<td class = "pe_eL" colspan="3"></td>
									</tr>

									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_La"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='WebServerInfo' id='WebServerInfo' class="inputSelectStyle">
												<option value=''></option>
												<option value='IIS' <% if(settingValue.get("WebServerInfo").equals("IIS")) out.println("selected=\"selected\"");%>>IIS</option>
												<option value='Apache' <% if(settingValue.get("WebServerInfo").equals("Apache"))out.println("selected=\"selected\"");%>>Apache</option>
												<option value='Tomcat' <% if(settingValue.get("WebServerInfo").equals("Tomcat")) out.println("selected=\"selected\"");%>>Tomcat</option>
												<option value='Resin' <% if(settingValue.get("WebServerInfo").equals("Resin")) out.println("selected=\"selected\"");%>>Resin</option>
												<option value='Jeus' <% if(settingValue.get("WebServerInfo").equals("Jeus")) out.println("selected=\"selected\"");%>>Jeus</option>
												<option value='WebLogic' <% if(settingValue.get("WebServerInfo").equals("WebLogic")) out.println("selected=\"selected\"");%>>WebLogic</option>
												<option value='WebSphere' <% if(settingValue.get("WebServerInfo").equals("WebSphere")) out.println("selected=\"selected\"");%>>WebSphere</option>
												<option value='iPlanet' <% if(settingValue.get("WebServerInfo").equals("iPlanet")) out.println("selected=\"selected\"");%>>iPlanet</option>
											</select>
										</td>
									</tr>
									
									<tr>
										<td class = "pe_eL" colspan="3"></td>
									</tr>
									
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_KZ"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='WebLanguage' id='WebLanguage' class="inputSelectStyle">
												<option value=''></option>
												<option value='ASP' <% if(settingValue.get("WebLanguage").equals("ASP")) out.println("selected=\"selected\"");%>>ASP</option>
												<option value='JSP' <% if(settingValue.get("WebLanguage").equals("JSP")) out.println("selected=\"selected\"");%>>JSP</option>
												<option value='PHP' <% if(settingValue.get("WebLanguage").equals("PHP")) out.println("selected=\"selected\"");%>>PHP</option>
												<option value='ASP.NET' <% if(settingValue.get("WebLanguage").equals("ASP.NET")) out.println("selected=\"selected\"");%>>ASP.NET</option>
												<option value='SERVLET' <% if(settingValue.get("WebLanguage").equals("SERVLET")) out.println("selected=\"selected\"");%>>SERVLET</option>
											</select>
										</td>
									</tr>
									
									<tr>
										<td class = "pe_eL" colspan="3"></td>
									</tr>
									
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Ih"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<input type="text" id="ImageSavePath" class="pe_oV" name="ImageSavePath" value="<%=settingValue.get("ImageSavePath")%>" /> ex) http:// www.mysite.com/image
										</td>
									</tr>
									
									<tr>
										<td class = "pe_eL" colspan="3"></td>
									</tr>

									<% if (settingValue.get("UploadFileNameType") != null){ %>
									
									<div id="pe_azF">
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_KS"></span></b></td>
										<td class="pe_eg"></td>
										<td >
											<table class="pe_ft">
												<tr>
													<td class="pe_es"> &nbsp;&nbsp;
														<input type="radio" name="encodingStyle" id="pe_abp" value="real" /><span id="pe_KH"></span>
														<input type="hidden" id="UploadFileNameType" name="UploadFileNameType" value="" />
													</td>
												</tr>
												<tr>
													<td class = "pe_eL" colspan="3"></td>
												</tr>
												<tr>
													<td class="pe_es"> &nbsp;&nbsp;
													<input type="radio" name="encodingStyle" id="pe_apX" value="trans" /><span id="pe_Ls"></span>
													</td>
												</tr>
												<tr>
													<td class = "pe_eL" colspan="3"></td>
												</tr>
												<tr>
													<td class="pe_es"> &nbsp;&nbsp;
														<input type="radio" name="encodingStyle" id="pe_aqt" value="random" /><span id="pe_PV"></span>
													</td>
												</tr>
											</table>
										</td>
									</tr>

									<tr>
										<td class = "pe_eL" colspan="3"></td>
									</tr>
									</div>

									<% } %>

									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_MA"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es"> &nbsp;
											<input type="hidden" id="UploadFileSubDir" name ="UploadFileSubDir" value="<%=settingValue.get("UploadFileSubDir")%>" />
											<input type="radio" id="pe_RE" name="pe_apV" value="true" /><label for="pe_RE"><span id="pe_Qn"></span></label>&nbsp;&nbsp;
											<input type="radio" id="pe_Sb" name="pe_apV" value="false" /><label for="pe_Sb"><span id="pe_Pd"></span></label>
										</td>
									</tr>

									<tr>
										<td class = "pe_eL" colspan="3"></td>
									</tr>

									
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_HA"></span></b></td>
										<td class="pe_eg"></td>
										<td >
											<table class="pe_ft">
												<tr>
													<td >&nbsp;&nbsp;<span id="pe_HJ"></span></td>
													<td class="pe_eg"></td>
													<td class="pe_es">
                                                        <input type="text" id="Width" name="Width" class="inputStyleChange" maxlength="10" value="<% if(settingValue.get("Width").toString().contains("%") == true) out.println(settingValue.get("Width").toString().substring(0,settingValue.get("Width").toString().length()-1)); else out.println(settingValue.get("Width")) ;%>" />
                                                        <select id='WidthUnit' name='WidthUnit' style='width:45px;height:20px'>
                                                            <option value='px'>px</option>
                                                            <option value ='%' <% if(settingValue.get("Width").toString().contains("%")) out.println("selected=\"selected\""); %>>%</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class = "pe_eL" colspan="3"></td>
                                                </tr>
                                                <tr>
                                                    <td >&nbsp;&nbsp;<span id="pe_Gz"></span></td>
                                                    <td class="pe_eg"></td>
                                                    <td class="pe_es"><input type="text" id="Height" name="Height" class="pe_sf" maxlength="10" value="<%=settingValue.get("Height")%>" /> px
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>

								<table class="pe_ft"><tr><td class="pe_ic" colspan="3"></td></tr>
								</table>
											
							</td>
						</tr>
						<tr>
							<td class="pe_pE pe_lo"><font style="font-size:9pt;color:#FF9F4B;font-weight:bold;"><span id="pe_Qz"></span></font></td>
						</tr>

						<tr>
							<td>
						
								<table class="pe_ft"><tr><td class="pe_ic" colspan="3"></td></tr>
								</table>

								<table class="pe_ft">
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_OG"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='SetFocus' id='SetFocus' class="inputSelectStyle">
												<option value='true' <% if(settingValue.get("SetFocus").equals("true")) out.println("selected=\"selected\"");%>>true</option>
												<option value='false' <% if(settingValue.get("SetFocus").equals("false")) out.println("selected=\"selected\"");%>>false</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_PZ"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='LineHeight' id='LineHeight' class="inputSelectStyle">
												<option value=''></option>
												<option value='100%' <% if(settingValue.get("LineHeight").equals("100%")) out.println("selected=\"selected\"");%>>100%</option>
												<option value='120%' <% if(settingValue.get("LineHeight").equals("120%")) out.println("selected=\"selected\"");%>>120%</option>
												<option value='140%' <% if(settingValue.get("LineHeight").equals("140%")) out.println("selected=\"selected\"");%>>140%</option>
												<option value='160%' <% if(settingValue.get("LineHeight").equals("160%")) out.println("selected=\"selected\"");%>>160%</option>
												<option value='180%' <% if(settingValue.get("LineHeight").equals("180%")) out.println("selected=\"selected\"");%>>180%</option>	
												<option value='200%' <% if(settingValue.get("LineHeight").equals("200%")) out.println("selected=\"selected\"");%>>200%</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Oj"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='UnloadWarning' id='UnloadWarning' class="inputSelectStyle">
												<option value='false' <% if(settingValue.get("UnloadWarning").equals("false")) out.println("selected=\"selected\"");%>>false</option>
												<option value='true' <% if(settingValue.get("UnloadWarning").equals("true")) out.println("selected=\"selected\"");%>>true</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_OI"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='SetDebug' id='SetDebug' class="inputSelectStyle">
												<option value='false' <% if(settingValue.get("SetDebug").equals("false")) out.println("selected=\"selected\"");%>>false</option>
												<option value='true' <% if(settingValue.get("SetDebug").equals("true")) out.println("selected=\"selected\"");%>>true</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_PK"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='HTMLTabByTableLock' id='HTMLTabByTableLock' class="inputSelectStyle">
												<option value='false' <% if(settingValue.get("HTMLTabByTableLock").equals("false")) out.println("selected=\"selected\"");%>>false</option>
												<option value='true' <% if(settingValue.get("HTMLTabByTableLock").equals("true")) out.println("selected=\"selected\"");%>>true</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Pu"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='HTMLTabContents' id='HTMLTabContents' class="inputSelectStyle">
												<option value='html' <% if(settingValue.get("HTMLTabContents").equals("html")) out.println("selected=\"selected\"");%>>html</option>
												<option value='body' <% if(settingValue.get("HTMLTabContents").equals("body")) out.println("selected=\"selected\"");%>>body</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Rl"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='AllowContentScript' id='AllowContentScript' class="inputSelectStyle">
												<option value='true' <% if(settingValue.get("AllowContentScript").equals("true")) out.println("selected=\"selected\"");%>>true</option>
												<option value='false' <% if(settingValue.get("AllowContentScript").equals("false")) out.println("selected=\"selected\"");%>>false</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_RB"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='AllowContentIframe' id='AllowContentIframe' class="inputSelectStyle">
												<option value='true' <% if(settingValue.get("AllowContentIframe").equals("true")) out.println("selected=\"selected\"");%>>true</option>
												<option value='false' <% if(settingValue.get("AllowContentIframe").equals("false")) out.println("selected=\"selected\"");%>>false</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Sc"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='CharSet' id='CharSet' class="inputSelectStyle">
												<option value=''></option>
												<option value='auto' <% if(settingValue.get("CharSet").equals("auto")) out.println("selected=\"selected\"");%>></option>
												<option value='utf-8' <% if(settingValue.get("CharSet").equals("utf-8")) out.println("selected=\"selected\"");%>>utf-8</option>
												<option value='euc-kr' <% if(settingValue.get("CharSet").equals("euc-kr")) out.println("selected=\"selected\"");%>>euc-kr</option>
												<option value='ks_c_5601-1987' <% if(settingValue.get("CharSet").equals("ks_c_5601-1987")) out.println("selected=\"selected\"");%>>ks_c_5601-1987</option>
												<option value='ms949' <% if(settingValue.get("CharSet").equals("ms949")) out.println("selected=\"selected\"");%>>ms949</option>
												<option value='iso-8859-1' <% if(settingValue.get("CharSet").equals("iso-8859-1")) out.println("selected=\"selected\"");%>>iso-8859-1</option>
												<option value='iso-8859-2' <% if(settingValue.get("CharSet").equals("iso-8859-2")) out.println("selected=\"selected\"");%>>iso-8859-2</option>
												<option value='euc-jp' <% if(settingValue.get("CharSet").equals("euc-jp")) out.println("selected=\"selected\"");%>>euc-jp</option>
												<option value='shift_jis' <% if(settingValue.get("CharSet").equals("shift_jis")) out.println("selected=\"selected\"");%>>shift_jis</option>
												<option value='gb2312' <% if(settingValue.get("CharSet").equals("gb2312")) out.println("selected=\"selected\"");%>>gb2312</option>
												<option value='gbk' <% if(settingValue.get("CharSet").equals("gbk")) out.println("selected=\"selected\"");%>>gbk</option>
												<option value='big5' <% if(settingValue.get("CharSet").equals("big5")) out.println("selected=\"selected\"");%>>big5</option>
												<option value='big5-hkscs' <% if(settingValue.get("CharSet").equals("big5-hkscs")) out.println("selected=\"selected\"");%>>big5-hkscs</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Mi"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<input type="text" id="DocBaseURL" name="DocBaseURL" class="pe_oV" value="<%=settingValue.get("DocBaseURL")%>" /> ex) http://www.mysite.com/doc.html 
										</td>
									</tr>
									
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>

									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Uf"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='ResizeBar' id='ResizeBar' class="inputSelectStyle">
												<option value='true' <% if(settingValue.get("ResizeBar").equals("true")) out.println("selected=\"selected\"");%>>true</option>
												<option value='false' <% if(settingValue.get("ResizeBar").equals("false")) out.println("selected=\"selected\"");%>>false</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>


									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Sw"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='Menu' id='Menu' class="inputSelectStyle">
												<option value='true' <% if(settingValue.get("Menu").equals("true")) out.println("selected=\"selected\"");%>>true</option>
												<option value='false' <% if(settingValue.get("Menu").equals("false")) out.println("selected=\"selected\"");%>>false</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Ug"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='QuickMenu' id='QuickMenu' class="inputSelectStyle">
												<option value='true' <% if(settingValue.get("QuickMenu").equals("true")) out.println("selected=\"selected\"");%>>true</option>
												<option value='false' <% if(settingValue.get("QuickMenu").equals("false")) out.println("selected=\"selected\"");%>>false</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>


									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Ej"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='ServerUrl' id='ServerUrl' class="inputSelectStyle">
												<option value='' <% if(settingValue.get("ServerUrl").equals("")) out.println("selected=\"selected\"");%>></option>
												<option value='1' <% if(settingValue.get("ServerUrl").equals("1")) out.println("selected=\"selected\"");%>>domain</option>
												<option value='2' <% if(settingValue.get("ServerUrl").equals("2")) out.println("selected=\"selected\"");%>>absolute</option>
											</select>
										</td>
									</tr>
								
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>

									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_WC"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='DisplayLoadingBar' id='DisplayLoadingBar' class="inputSelectStyle">
												<option value='true' <% if(settingValue.get("DisplayLoadingBar").equals("true")) out.println("selected=\"selected\"");%>>true</option>
												<option value='false' <% if(settingValue.get("DisplayLoadingBar").equals("false")) out.println("selected=\"selected\"");%>>false</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>

									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_XJ"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<input type="number" min="0" max="60" style="ime-mode:disabled;" id="AutoSavePeriod" name="AutoSavePeriod" class="pe_oV" value="<%=settingValue.get("AutoSavePeriod")%>" /><b><span id="pe_Np"></span></b>&nbsp;&nbsp;<span id="pe_Xg"></span>
										</td>
									</tr>
									
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>

									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Qh"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='HideAddImageCheckbox' id='HideAddImageCheckbox' class="inputSelectStyle">
												<option value='true' <% if(settingValue.get("HideAddImageCheckbox").equals("true")) out.println("selected=\"selected\"");%>>true</option>
												<option value='false' <% if(settingValue.get("HideAddImageCheckbox").equals("false") || settingValue.get("HideAddImageCheckbox").equals("")) out.println("selected=\"selected\"");%>>false</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>

									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Wq"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='SupportBrowser' id='SupportBrowser' class="inputSelectStyle">
												<option value='' <% if(settingValue.get("SupportBrowser").equals("")) out.println("selected=\"selected\"");%>></option>
												<option value='1' <% if(settingValue.get("SupportBrowser").equals("1")) out.println("selected=\"selected\"");%>></option>
												<option value='11' <% if(settingValue.get("SupportBrowser").equals("11")) out.println("selected=\"selected\"");%>></option>
												<option value='10' <% if(settingValue.get("SupportBrowser").equals("10")) out.println("selected=\"selected\"");%>></option>
												<option value='9' <% if(settingValue.get("SupportBrowser").equals("9")) out.println("selected=\"selected\"");%>></option>
												<option value='8' <% if(settingValue.get("SupportBrowser").equals("8")) out.println("selected=\"selected\"");%>></option>
												<option value='7' <% if(settingValue.get("SupportBrowser").equals("7")) out.println("selected=\"selected\"");%>></option>
											</select>
										</td>
									</tr>
									<tr id="pe_aMS">
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_XN"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='PasteSelectFormat' id='PasteSelectFormat' class="inputSelectStyle">
												<option value='true' <% if(settingValue.get("PasteSelectFormat").equals("true")) out.println("selected=\"selected\"");%>>true</option>
												<option value='false' <% if(settingValue.get("PasteSelectFormat").equals("false") || settingValue.get("PasteSelectFormat").equals("")) out.println("selected=\"selected\"");%>>false</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>

									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_WB"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='UseTagCleaner' id='UseTagCleaner' class="inputSelectStyle">
												<option value='true' <% if(settingValue.get("UseTagCleaner").equals("true")) out.println("selected=\"selected\"");%>>true</option>
												<option value='false' <% if(settingValue.get("UseTagCleaner").equals("false") || settingValue.get("UseTagCleaner").equals("")) out.println("selected=\"selected\"");%>>false</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>

									<tr id="noUseLayerTracker">
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_aXv"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='NoUseLayerTracker' id='NoUseLayerTracker' class="inputSelectStyle">
												<option value='true' <% if(settingValue.get("NoUseLayerTracker").equals("true")) out.println("selected=\"selected\"");%>>true</option>
												<option value='false' <% if(settingValue.get("NoUseLayerTracker").equals("false") || settingValue.get("NoUseLayerTracker").equals("")) out.println("selected=\"selected\"");%>>false</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
								</table>

								
							
							</td>
						</tr> 						
						<tr>
							<td class="pe_pE pe_lo"><font style="font-size:9pt;color:#FF9F4B;font-weight:bold;"><span id="pe_Rv"></span></font></td>
						</tr>

						<tr>
							<td>
								<table class="pe_ft"><tr><td class="pe_ic" colspan="3"></td></tr>
								</table>
								
								<table class="pe_ft">

									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="AdminPageUploadFileExtBlockList"><span id="pe_zR"></span></b></td>
										<td class="pe_eg"></td>
										<td>
											<table class="pe_ft">
												<input type="hidden" name="UploadImageFileExtBlockList" value="<%=settingValue.get("UploadImageFileExtBlockList")%>" />
												<tr>
													<td class="pe_es"><input type="checkbox" id="UploadImageFileExtBlockListChecked" <%=settingValue.get("UploadImageFileExtBlockListChecked")%>/><span id="pe_uo"></span></td>
												</tr>
												<tr>
													<td class="pe_es"><textarea id="UploadImageFileExtBlockListTextarea" cols="70" rows="2"><%=settingValue.get("UploadImageFileExtBlockListTextarea")%></textarea><br /><span id="pe_Ho"></span></td>
												</tr>	
											</table>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="AdminPageUploadFileExtBlockList"></span></b></td>
										<td class="pe_eg"></td>
										<td>
											<table class="pe_ft">
												<input type="hidden" name="UploadFileExtBlockList" value="<%=settingValue.get("UploadFileExtBlockList")%>" />
												<tr>
													<td class="pe_es"><input type="checkbox" id="UploadFileExtBlockListChecked" <%=settingValue.get("UploadFileExtBlockListChecked")%>/><span id="pe_uo"></span></td>
												</tr>
												<tr>
													<td class="pe_es"><textarea id="UploadFileExtBlockListTextarea" cols="70" rows="2"><%=settingValue.get("UploadFileExtBlockListTextarea")%></textarea><br /><span id="pe_Ho"></span></td>
												</tr>	
											</table>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>

									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Rn"></span></b></td>
										<td class="pe_eg"></td>
										<td >
											<table class="pe_ft">
												<input type="hidden" name="AttributeBlockList" value="<%=settingValue.get("AttributeBlockList")%>" />
												<tr>
													<td class="pe_es"><input type="checkbox" id="AttributeBlockListChecked" <%=settingValue.get("AttributeBlockListChecked")%>/><span id="pe_uo"></span></td>
												</tr>
												<tr>
													<td class="pe_es"><textarea id="AttributeBlockListTextarea" cols="70" rows="2"><%=settingValue.get("AttributeBlockListTextarea") %></textarea><br /><span id="pe_An"></span></td>
												</tr>	
											</table>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Nj"></span></b></td>
										<td class="pe_eg"></td>
										<td >
											<table class="pe_ft">
												<input type="hidden" name="TagBlockList" value="<%=settingValue.get("TagBlockList")%>" />
												<tr>
													<td class="pe_es"><input type="checkbox" id="TagBlockListChecked" <%=settingValue.get("TagBlockListChecked")%>/><span id="pe_uo"></span></td>
												</tr>
												<tr>
													<td class="pe_es"><textarea id="TagBlockListTextarea" cols="70" rows="2"><%=settingValue.get("TagBlockListTextarea") %></textarea><br /><span id="pe_An"></span></td>
												</tr>	
											</table>
										</td>
									</tr>

									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
								</table>
								
							</td>
						</tr>

												
						

					</tr> 						
						<tr>
							<td class="pe_pE pe_lo"><font style="font-size:9pt;color:#FF9F4B;font-weight:bold;"><span id="pe_NI"></span></font></td>
						</tr>

						<tr>
							<td>
								<table class="pe_ft"><tr><td class="pe_ic" colspan="3"></td></tr>
								</table>
								
								<table class="pe_ft" >
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Oe"></span></b></td>
										<td class="pe_eg"></td>
										<td>
											<table class="pe_ft">
												<input type="hidden" name="Template" id="Template" value="<%=settingValue.get("Template")%>" />
												<tr>
													<td class="pe_es"><input type="button" id="pe_bdC" value="+" onClick="pe_by(this)"/></td>
													<td class="pe_es">&nbsp;</td>
													<td class="pe_es">&nbsp;</td>
												</tr>
												<tr style="background-color:#B2EBF4;">
													<td class="pe_es"><b>Title</b></td>
													<td class="pe_es"><b>URL</b></td>
													<td class="pe_es"><b>Encoding</b></td>
												</tr>
						
											<%	
											
											for(int i=0; i<TemplateListArr.length ; i++){
												String templateName;
												String templateUrl;
												String templateEncoding;
												if(TemplateListArr[i] == null || TemplateListArr[i] == ""){
													templateName = "";
													templateUrl = "";
													templateEncoding = "";
												}else{
													templateName = TemplateListArr[i].split("\\|")[0];
													templateUrl = TemplateListArr[i].split("\\|")[1];							
													templateEncoding = TemplateListArr[i].split("\\|")[2];

													%>
														<tr>
															<td><input type="text"  name="pe_apw"  value="<%=templateName %>" style="width:100px"/></td>
															<td><input type="text"  name="pe_ars"  value="<%=templateUrl %>" style="width:320px"/></td>
															<td><input type="text"  name="pe_avI"  value="<%=templateEncoding %>" style="width:90px"/><input type="button" value="-" onclick="pe_R(this)"/></td>
						
														</tr>
													<% 
												}
												
											
											}
											%>
											</table>
										</td>
									</tr>


									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
								</table>
								
							</td>
						</tr>

						
						
					</table>
				</div>	
				
			</td>
		</tr>	
		
		

		<tr>
			<td class="pe_kt">
				<div id="pe_aoB">
					<table class="pe_Am">
						<tr>
							<td>
								<table class="pe_ft"><tr><td class="pe_ic" colspan="3"></td></tr>
								</table>
								
								<table class="pe_ft">
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Pl"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<table>
											<tr>
											<td>
											<input type="text" id="pe_afO" class="color{hash:true,valueElement:'FontColor',pickerFaceColor:'transparent',pickerFace:3,pickerBorder:0,pickerInsetColor:'black'}" style="width:20px;"></td>
											<td><input id="FontColor" name="FontColor" value="<%=settingValue.get("FontColor") %>"></td>
											<td style="padding-left:0px">
											<ul style="width:140px;">
											<li class="pe_kE">
											<input type="button" class="pe_lh pe_jD" value="default" style="width:80px;height:26px;" onclick="document.getElementById('pe_afO').color.fromString('#000000');">
											</li>
											</ul></td>
											</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Qk"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
										<textarea name="FontSizeList" id="FontSizeList" cols="70" rows="2"><%=settingValue.get("FontSizeList") %></textarea></td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Rd"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
										<textarea name="Font" id="Font" cols="70" rows="2"><%=settingValue.get("Font") %></textarea><br /><span id="pe_Su"></span><br /><span id="pe_TW"></span></td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Qq"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
										<textarea name="LineHeightList" id="LineHeightList" cols="70" rows="2"><%=settingValue.get("LineHeightList") %></textarea>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Qg"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<input type="text" id="IndentPaddingValue" name="IndentPaddingValue" class="inputStyleChange" maxlength="3" value="<%=settingValue.get("IndentPaddingValue") %>" style="width:30px;" /> px 
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<input type="hidden" name="ReturnKeyActionBR">
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Oa"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es"><input type="checkbox" id="ReturnKeyActionBRChecked" <%=settingValue.get("ReturnKeyActionBRChecked")%>/><label for="ReturnKeyActionBR"><span id="pe_OS"></span></label></td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>

									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_WV"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<input type="text" id="DefaultFont" name="DefaultFont" class="inputStyleChange" maxlength="30" value="<%=settingValue.get("DefaultFont") %>" style="width:170px;" /> 
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Wh"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<input type="text" id="DefaultFontSize" name="DefaultFontSize" class="inputStyleChange" maxlength="5" value="<%=settingValue.get("DefaultFontSize") %>" style="width:30px;" />
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_WI"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<input type="text" id="Placeholder" name="Placeholder" class="inputStyleChange" maxlength="200" value="<%=settingValue.get("Placeholder") %>" style="width:443px;" /> 
										</td>
									</tr>

									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>


								</table>


								<table class="pe_ft">
									<tr>
										<td class="pe_pE pe_lo"><font style="font-size:9pt;color:#FF9F4B;font-weight:bold;"><span id="pe_zR"></span></font></td>
									</tr>

									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_OU"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<table>
											<tr>
											<td>
											<input type="text" id="pe_alg" class="color{hash:true,valueElement:'ImgLineColor',pickerFaceColor:'transparent',pickerFace:3,pickerBorder:0,pickerInsetColor:'black'}" style="width:20px;"></td>
											<td><input id="ImgLineColor" name="ImgLineColor" value="<%=settingValue.get("ImgLineColor") %>"></td>
											<td style="padding-left:0px">
											<ul style="width:140px;">
											<li class="pe_kE">
											<input type="button" class="pe_lh pe_jD" value="default" style="width:80px;height:26px;" onclick="document.getElementById('pe_alg').color.fromString('#000000');">
											</li>
											</ul></td>
											</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
								</table>



								<table class="pe_ft">				
									<tr>
										<td class="pe_pE pe_lo"><font style="font-size:9pt;color:#FF9F4B;font-weight:bold;"><span id="pe_MN"></span></font></td>
									</tr>

									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Nz"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<table>
											<tr>
											<td>
											<input type="text" id="pe_aoO" class="color{hash:true,valueElement:'TableLineColor',pickerFaceColor:'transparent',pickerFace:3,pickerBorder:0,pickerInsetColor:'black'}" style="width:20px;"></td>
											<td><input id="TableLineColor" name="TableLineColor" value="<%=settingValue.get("TableLineColor") %>"></td>
											<td style="padding-left:0px">
											<ul style="width:140px;">
											<li class="pe_kE">
											<input type="button" class="pe_lh pe_jD" value="default" style="width:80px;height:26px;" onclick="document.getElementById('pe_aoO').color.fromString('#000000');">
											</li>
											</ul></td>
											</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Oh"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<table>
											<tr>
											<td>
											<input type="text" id="pe_aoK" class="color{hash:true,valueElement:'TableBGColor',pickerFaceColor:'transparent',pickerFace:3,pickerBorder:0,pickerInsetColor:'black'}" style="width:20px;"></td>
											<td><input id="TableBGColor" name="TableBGColor" value="<%=settingValue.get("TableBGColor") %>"></td>
											<td style="padding-left:0px">
											<ul style="width:140px;">
											<li class="pe_kE">
											<input type="button" class="pe_lh pe_jD" value="default" style="width:80px;height:26px;" onclick="document.getElementById('pe_aoK').color.fromString('#FFFFFF');">
											</li>
											</ul></td>
											</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
								</table>

	
											
							</td>
						</tr>
					</table>
				</div>	
			</td>
		</tr>

		
		
		<tr>
			<td class="pe_kt">
				<div id="pe_apg">
					<table class="pe_Am">
						<tr>
							<td>
								<table class="pe_ft"><tr><td class="pe_ic" colspan="3"></td></tr>
								</table>
								 
								<table class="pe_ft">
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_ND"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<% out.println(skinDirectory(fileRealFolder, (String)settingValue.get("Skin"))); %>
										</td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_TE"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<% out.println(iconColorSelect((String)settingValue.get("IconColor"))); %>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_LZ"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<input type="text" id="Css" name="Css" class="pe_oV" value="<%=settingValue.get("Css")%>" />  ex) http://www.mysite.com/common.css 
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Ro"></span></b>
											<input type="hidden" id="UserSkinColor" name="UserSkinColor" value="<%=settingValue.get("UserSkinColor")%>" />
										</td>
											
										<td class="pe_eg"></td>
										<td >
											<table class="pe_ft">
												<tr>
													<td class="pe_zw">&nbsp;&nbsp;<span id="pe_Ng"></span></td>
													<td class="pe_eg"></td>
													<td class="pe_es">
														<input type="text" id="outlinecolor" name="outlinecolor" class="pe_zF" value="" />  ex) #000000 or black 
													</td>
												</tr>
												<tr>
													<td class="pe_eL" colspan="3"></td>
												</tr>
												
												<tr>
													<td class="pe_zw">&nbsp;&nbsp;<span id="pe_ON"></span></td>
													<td class="pe_eg"></td>
													<td class="pe_es">
														<input type="text" id="innerlineColor" name="innerlineColor" class="pe_zF" value="" />
													</td>
												</tr>
												<tr>
													<td class="pe_eL" colspan="3"></td>
												</tr>
												<tr>
													<td class="pe_zw">&nbsp;&nbsp;<span id="pe_Se"></span></td>
													<td class="pe_eg"></td>
													<td class="pe_es">
														<input type="text" id="skinfontColor" name="skinfontColor" class="pe_zF" value="" />
													</td>
												</tr>
												<tr>
													<td class="pe_eL" colspan="3"></td>
												</tr>
												<tr>
													<td class="pe_zw">&nbsp;&nbsp;<span id="pe_MZ"></span></td>
													<td class="pe_eg"></td>
													<td class="pe_es">
														<input type="text" id="toolbarBackgroundColor" name="toolbarBackgroundColor" class="pe_zF" value="" />
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Rp"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<input type="hidden" id="CreateTab" name ="CreateTab" value="<%=settingValue.get("CreateTab")%>" />
											<input type="checkbox" id="pe_Mx" name="pe_AJ" value="0" /><label for="pe_Mx"><span id="wysiwyg"></span></label>&nbsp;&nbsp;
											<input type="checkbox" id="pe_LQ" name="pe_AJ" value="1" /><label for="pe_LQ"><span id="html"></span></label>&nbsp;&nbsp;
											<input type="checkbox" id="pe_LD" name="pe_AJ" value="2" /><label for="pe_LD"><span id="preview"></span></label>
										</td>
									</tr>
								</table>
									
								<table class="pe_ft"><tr><td class="pe_ic" colspan="3"></td></tr>
								</table>
							</td>
						</tr>

						<tr>
							<td class="pe_pE pe_lo"><font style="font-size:9pt;color:#FF9F4B;font-weight:bold;"><span id="pe_NN"></span></font></td>
						</tr>
						<tr>
							<td>
								<table class="pe_ft"><tr><td class="pe_ic" colspan="3"></td></tr>
								</table>
									
								<table class="pe_ft">
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Qy"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<select name='UserToolbar' id='UserToolbar' class="inputSelectStyle">
												<option value='false' <% if(settingValue.get("UserToolbar").equals("false")) out.println("selected=\"selected\"");%>>false</option>
												<option value='true' <% if(settingValue.get("UserToolbar").equals("true")) out.println("selected=\"selected\"");%>>true</option>
											</select>
											<input type="hidden" id="CreateToolbar" name="CreateToolbar" value="<%=settingValue.get("CreateToolbar")%>" >
											<input type="hidden" id="Name" name="Name" value="<%=settingValue.get("Name")%>">
											<input type="hidden" id="Logo" name="Logo" value="<%=settingValue.get("Logo")%>">
											<input type="hidden" id="Help" name="Help" value="<%=settingValue.get("Help")%>">
											<input type="hidden" id="Info" name="Info" value="<%=settingValue.get("Info")%>">
											<input type="hidden" id="UserAddMenu" name="UserAddMenu" value="<%=userAddMenuList%>" />
											<input type="hidden" id="AddMenuCheck" name="AddMenuCheck" value="<%=settingValue.get("AddMenuCheck")%>" />
											<input type="hidden" id="Tab" name="Tab" value="" />

											<input type="hidden" id="UploadFileViewer" name="UploadFileViewer" value="<%=settingValue.get("UploadFileViewer")%>" />
											<input type="hidden" id="UploadFileSizeLimit" name="UploadFileSizeLimit" value="<%=settingValue.get("UploadFileSizeLimit")%>" />
											<input type="hidden" id="ProfanityStr" name="ProfanityStr" value="<%=settingValue.get("ProfanityStr")%>" />
											<input type="hidden" id="Csslist" name="Csslist" value="<%=settingValue.get("Csslist")%>" />
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
										
								</table>	
							</td>		
						</tr>			
					</table>

					<div id="pe_adl">
						<table class="pe_ru">
							<tr>
								<td>
									<table class="pe_ft">
										<tr>
											<td class="pe_eL" colspan="5"></td>
										</tr>
										<tr>
											<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Pc"></span></b></td>
											<td class="pe_eg"></td>
											<td>
												<table class="pe_ft">
													<tr>
														<td class="pe_Ca" >&nbsp;&nbsp;<span id="pe_Pn"></span></td>
														<td class="pe_eg"></td>
														<td class="pe_es">
															<input type="text" id="AdminPageUserMenuIdInput" name="AdminPageUserMenuIdInput" class="pe_oV" value="" /> 
														</td>
													</tr>
													<tr>
														<td class="pe_eL" colspan="3"></td>
													</tr>
													<tr>
														<td class="pe_Ca">&nbsp;&nbsp;<span id="pe_No"></span></td>
														<td class="pe_eg"></td>
														<td class="pe_es">
															<input type="radio" name="AdminPageUserMenuPlayKindRadio" id="pe_Wg" value="function" /><label for="pe_Wg"><span id="pe_Pi"></span></label>&nbsp;&nbsp;<input type="radio" name="AdminPageUserMenuPlayKindRadio" id="pe_WE" value="plugin" /><label for="pe_WE"><span id="pe_Sa"></span></label>
														</td>
													</tr>
													<tr>
														<td class="pe_eL" colspan="3"></td>
													</tr>
													<tr>
														<td class="pe_Ca">&nbsp;&nbsp;<span id="pe_NS"></span></td>
														<td class="pe_eg"></td>
														<td class="pe_es" height="50px">
															<input type="text" id="AdminPageUserMenuButtonImgPathInput" name="AdminPageUserMenuButtonImgPathInput" class="pe_oV" value="" />
															<br/>ex) http://www.mysite.com/image/MenuIcon.jpg
														</td>
													</tr>
													<tr>
														<td class="pe_eL" colspan="3"></td>
													</tr>
													<tr>
														<td class="pe_Ca">&nbsp;&nbsp;<span id="pe_Sg"></span></td>
														<td class="pe_eg"></td>
														<td class="pe_es">	
															<input type="text" id="AdminPageUserMenuTitleInput" name="AdminPageUserMenuTitleInput" class="pe_oV" value="" />
														</td>
													</tr>
												</table>
											</td>
											<td class="pe_eg"></td>
											<td style="text-align:center;vertical-align:middle;"><input type="button" id="pe_Hp" value="" class="" style="width:60px;height:60px;"/>
											</td>
										</tr>
										<tr>
											<td class="pe_eL" colspan="5"></td>
										</tr>
										<tr>
											<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Rs"></span></b></td>
											<td class="pe_eg"></td>
											<td class="pe_es" colspan="2">
												<div id="pe_aLd">&nbsp;</div>
											</td>
										</tr>
										<tr>
											<td class="pe_eL" colspan="5"></td>
										</tr>
									</table>	
								</td>		
							</tr>
						</table>
					</div>
		
					<div id = "pe_ft">
						
						<table class="pe_ru">	
							<tr>
								<td id="pe_abs" class="pe_lo">
									
									<table>
										<tr>
											<td id="pe_aKG">
												<span id="pe_Qs"></span>: <br>
												<div id="pe_auN" >
													<span id="pe_EN"></span> <br> 
													<span id="pe_Lv"></span><br>
													<span id="pe_DU"></span><br>
												</div>
											</td>
											<td id="pe_aOu">
											<span id="pe_Ok"></span>:<br>
												<div id="pe_amH" ></div>
											</td> 
											<td valign="bottom">
												<ul style="margin:0 auto;width:340px;">
													<li class="pe_kE">
														<input type="button" id="spacebar" value="" class="pe_lh pe_jD" style="width:80px;height:26px;" />
													</li>
													<li class="pe_kE"><input type="button" id="space" value="" class="pe_lh pe_jD" style="width:68px;height:26px;"></li>
													<li class="pe_kE"><input type="button" id="enter" value="" class="pe_lh pe_jD" style="width:66px;height:26px;"></li>
												</ul>
											</td>
										</tr>
										<tr>
											<td colspan="3">
												<br />
												<span id="pe_Sk"></span>
											</td>
										</tr>	
									</table>							
								</td>
							</tr>
							<tr>
								<td>
									<table class="pe_ft">
										<tr><td class="pe_ic" colspan="3"></td></tr>
									</table>
								</td>
							</tr>
						</table>	
				
						<table id="pe_nb" class="pe_ru">
							
							<tr>
								<td id="pe_abs" class="pe_lo">
									<span id="preview"></span>:<br>
									<div id="pe_ayg"></div>
									<br />
									<span id="pe_Rc"></span>
								</td>
							</tr>
						</table>
						
					
					
					

					</div>
				</div>	

			</td>
		</tr>
		<tr>
			<td class="pe_kt">
				<div id="pe_apf">
					<table class="pe_Am">
						<tr>
							<td>
								<table class="pe_ft"><tr><td class="pe_ic" colspan="3"></td></tr>
								</table>
								 
								<table class="pe_ft">
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Ri"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<input type="text" id="DocTitle" name="DocTitle" class="pe_oV" value="<%=settingValue.get("DocTitle")%>" />
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_fM">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_OR"></span></b></td>
										<td class="pe_eg"></td>
										<td class="pe_es">
											<input type="hidden" id="AccessibilityOption" name ="AccessibilityOption" value="<%=settingValue.get("AccessibilityOption")%>" />
											<input type="radio" id="pe_VA" name="pe_MM" value="0" /><label for="pe_VA"><span id="pe_OF"></span></label>&nbsp;&nbsp;
											<input type="radio" id="pe_Vl" name="pe_MM" value="1" /><label for="pe_Vl"><span id="pe_RA"></span></label>&nbsp;&nbsp;
											<input type="radio" id="pe_Uq" name="pe_MM" value="2" /><label for="pe_Uq"><span id="pe_RZ"></span></label>
										</td>
									</tr>
									<tr>
										<td class="pe_eL" colspan="3"></td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
</table>

<table class="pe_zy">
	<tr id="pe_ZA">
		<td id="pe_Yj">
			<ul style="margin:0 auto;width:170px;">
				<li class="pe_kE">
					<input type="submit" id="pe_UZ" value="" class="pe_lh pe_jD" style="width:66px;height:26px;" />
				</li>
				<li class="pe_kE"><input type="button" id="pe_GN" value="" class="pe_lh pe_jD" style="width:66px;height:26px;"></li>
			</ul>
		</td>
	</tr>
</table>
	
</div>



<input type="hidden" id="CanvasWidth" name="CanvasWidth" value="<%=settingValue.get("CanvasWidth")%>" />
<input type="hidden" id="CanvasHeight" name="CanvasHeight" value="<%=settingValue.get("CanvasHeight")%>" />
<input type="hidden" id="MenuInEditor" name="MenuInEditor" value="<%=settingValue.get("MenuInEditor")%>" />
<input type="hidden" id="LimitClipboardNodeCount" name="LimitClipboardNodeCount" value="<%=settingValue.get("LimitClipboardNodeCount")%>" />
<input type="hidden" id="ContextMenuPasteText" name="ContextMenuPasteText" value="<%=settingValue.get("ContextMenuPasteText")%>" />
<input type="hidden" id="RemoveScriptBlock" name="RemoveScriptBlock" value="<%=settingValue.get("RemoveScriptBlock")%>" />
<input type="hidden" id="ClipBoardFontFamily" name="ClipBoardFontFamily" value="<%=settingValue.get("ClipBoardFontFamily")%>" />
<input type="hidden" id="ClipBoardFontSize" name="ClipBoardFontSize" value="<%=settingValue.get("ClipBoardFontSize")%>" />
<input type="hidden" id="MSOfficeTranON" name="MSOfficeTranON" value="<%=settingValue.get("MSOfficeTranON")%>" />
<input type="hidden" id="DefaultDocType" name="DefaultDocType" value="<%=settingValue.get("DefaultDocType")%>" />
<input type="hidden" id="ShowRuler" name="ShowRuler" value="<%=settingValue.get("ShowRuler")%>" />
<input type="hidden" id="Version" name="Version" value="<%=settingValue.get("Version")%>" />
<input type="hidden" id="Version_daemon" name="Version_daemon" value="<%=settingValue.get("Version_daemon")%>" />
<input type="hidden" id="Version_com" name="Version_com" value="<%=settingValue.get("Version_com")%>" />
<input type="hidden" id="MimeEncodeFileScope" name="MimeEncodeFileScope" value="<%=settingValue.get("MimeEncodeFileScope")%>" />
<input type="hidden" id="MimeEncodeFilter" name="MimeEncodeFilter" value="<%=settingValue.get("MimeEncodeFilter")%>" />
<input type="hidden" id="MimeEncodeIncludeUrl" name="MimeEncodeIncludeUrl" value="<%=settingValue.get("MimeEncodeIncludeUrl")%>" />
<input type="hidden" id="MimeEncodeRange" name="MimeEncodeRange" value="<%=settingValue.get("MimeEncodeRange")%>" />
<input type="hidden" id="MimeEncodeType" name="MimeEncodeType" value="<%=settingValue.get("MimeEncodeType")%>" />

<input type="hidden" id="NewToolbar" name="NewToolbar" value="<%=settingValue.get("NewToolbar")%>" />
<input type="hidden" id="ThemeIconColor" name="ThemeIconColor" value="<%=settingValue.get("ThemeIconColor")%>" />
<input type="hidden" id="ThemeBgColor" name="ThemeBgColor" value="<%=settingValue.get("ThemeBgColor")%>" />
<input type="hidden" id="ThemeBorderColor" name="ThemeBorderColor" value="<%=settingValue.get("ThemeBorderColor")%>" />
<input type="hidden" id="ThemeButtonHoverColor" name="ThemeButtonHoverColor" value="<%=settingValue.get("ThemeButtonHoverColor")%>" />
<input type="hidden" id="ThemeButtonSelectColor" name="ThemeButtonSelectColor" value="<%=settingValue.get("ThemeButtonSelectColor")%>" />
<input type="hidden" id="ThemeButtonSelectIconColor" name="ThemeButtonSelectIconColor" value="<%=settingValue.get("ThemeButtonSelectIconColor")%>" />
<input type="hidden" id="ThemeButtonSize" name="ThemeButtonSize" value="<%=settingValue.get("ThemeButtonSize")%>" />
<input type="hidden" id="ThemeOutlineColor" name="ThemeOutlineColor" value="<%=settingValue.get("ThemeOutlineColor")%>" />

</form>
<%@include file = "../include/bottom.html"%>
<script>var webPageKind='<%=detectXSSEx(session.getAttribute("webPageKind").toString())%>';var encodingStyleChecked='<%=encodingStyleValue%>';topInit();managerInit('<% if(detectXSSEx(request.getParameter("Tab")) != null) out.print(detectXSSEx(request.getParameter("Tab")));%>'); </script>

</body> 
</html>