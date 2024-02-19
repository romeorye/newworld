/********************************************************************************
 * NAME : AttachFileController.java
 * DESC : 첨부파일
 * PROJ : IRIS UPGRADE 1�� ������Ʈ
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.07.25  ������	���ʻ���
 *********************************************************************************/

package iris.web.system.attach.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import devonframe.configuration.ConfigService;
import devonframe.filedownload.view.FileDownloadView;
import devonframe.fileupload.FileUpload;
import devonframe.fileupload.model.UploadFileInfo;
import iris.web.common.MarkAny.MarkAnyDrm;
import iris.web.common.converter.RuiConverter;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

@Controller
public class AttachFileController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "fileUpload")
    private FileUpload fileUpload;

	@Resource(name = "attachFileService")
	private AttachFileService attachFileService;

	@Resource(name = "configService")
    private ConfigService configService;


	static final Logger LOGGER = LogManager.getLogger(AttachFileController.class);

	@RequestMapping(value="/system/attach/attachFilePopup.do")
	public String attachFilePopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AttachFileController - attachFilePopup 첨부파일 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/common/attachFilePopup";
	}

	@RequestMapping(value="/system/attach/attachFilePopup3.do")
	public String attachFilePopup3(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AttachFileController - attachFilePopup 첨부파일 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/common/attachFilePopup3";
	}


	@RequestMapping(value="/system/attach/attachFilePopup2.do")
	public String attachFilePopup2(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AttachFileController - attachFilePopup2 첨부파일 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/common/attachFilePopup2";
	}


	@RequestMapping(value="/system/attach/getAttachFileList.do")
	public ModelAndView getAttachFileList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AttachFileController - getAttachFileList 첨부파일 리스트 조회");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String,Object>> attachFileList = attachFileService.getAttachFileList(input);

		modelAndView.addObject("attachFileDataSet", RuiConverter.createDataset("attachFileDataSet", attachFileList));

		return modelAndView;
	}

	@RequestMapping(value="/system/attach/attachFileUpload.do")
	public String attachFileUpload(
			@RequestParam HashMap<String, Object> input,
			@RequestPart("attachFiles") MultipartHttpServletRequest attachFiles,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AttachFileController - attachFileUpload 첨부파일 업로드");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		Iterator<String> fileNames = attachFiles.getFileNames();
		List<UploadFileInfo> fileInfos = new ArrayList<UploadFileInfo>();
		MarkAnyDrm markAnyDrm = new MarkAnyDrm();
		Calendar cal = new GregorianCalendar(Locale.KOREA);

		try {
			MultipartFile multipartFile = null;
			UploadFileInfo uploadFileInfo = null;
			HashMap<String, Object> attachFileInfo = null;
			List<Map<String, Object>> insertList = new ArrayList<Map<String, Object>>();
			int seq = 1;
			String policy = (String)input.get("policy");
			String attcFilId = (String)input.get("attcFilId");

			if(attcFilId.equals("")) {
				attcFilId = attachFileService.getAttachFileId();
			} else {
				seq = attachFileService.getAttachFileSeq(attcFilId);
			}

			String  yyDir = String.valueOf(cal.get(cal.YEAR));
			String  mmDir = "";

			if( cal.get(cal.MONTH)+1 < 10 ){
				mmDir = "0"+String.valueOf(cal.get(cal.MONTH)+1);
			}else{
				mmDir = String.valueOf(cal.get(cal.MONTH)+1);
			}

			String subDir = yyDir+File.separator+mmDir+File.separator;

			while(fileNames.hasNext()) {
				multipartFile = attachFiles.getFile((String)fileNames.next());

				uploadFileInfo = fileUpload.upload(multipartFile, policy, subDir);
		/*
				//첨부파일이 암호화인지 체크  
				if( markAnyDrm.EncryptFileCheck((String) uploadFileInfo.getServerPath()) == 0){
				
				}else if( markAnyDrm.EncryptFileCheck((String) uploadFileInfo.getServerPath()) == 1){		//1 : 암호화 -암호화 파일이면 복호화 한다
					if( markAnyDrm.DecryptFile((String)uploadFileInfo.getServerPath()) != 0){
						throw new Exception("첨부파일 복호화중 오류가 발생하였습니다.");
					}
				}else{
					throw new Exception("암호화 체크중 오류가 발생하였습니다.");
				}
		*/		
				fileInfos.add(uploadFileInfo);

				attachFileInfo = new HashMap<String, Object>();

				attachFileInfo.put("attcFilId", attcFilId);
				attachFileInfo.put("seq", seq++);
				attachFileInfo.put("menuType", policy);
				attachFileInfo.put("filNm", uploadFileInfo.getFile().getOriginalFilename());
				attachFileInfo.put("filPath", uploadFileInfo.getServerPath());
				attachFileInfo.put("filSize", uploadFileInfo.getSize());
				attachFileInfo.put("userId", input.get("_userId"));

				insertList.add(attachFileInfo);
			}

			attachFileService.insertAttachFile(insertList);

			model.addAttribute("contents", "parent.saveSuccess('" + attcFilId + "');");

		} catch(Exception e){
			fileUpload.cleanupTransferedFile(fileInfos);
			e.printStackTrace();
			model.addAttribute("contents", "parent.saveFail();");
		}

		return "web/common/print";
	}

	@RequestMapping(value="/system/attach/deleteAttachFile.do")
	public ModelAndView deleteAttachFile(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AttachFileController - deleteAttachFile 첨부파일 삭제");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			List<String> seqList = new ArrayList<String>();
			List<Map<String, Object>> attachFileDataSet = RuiConverter.convertToDataSet(request, "attachFileDataSet");

			for(Map<String, Object> data : attachFileDataSet) {
				data.put("userId", input.get("_userId"));
				seqList.add((String)data.get("seq"));
			}

			input.put("attcFilId", attachFileDataSet.get(0).get("attcFilId"));
			input.put("seqList", seqList);

			attachFileService.updateAttachFile(attachFileDataSet);

			List<Map<String, Object>> deleteAttachFileInfoList = attachFileService.getAttachFileInfoList(input);

			for(Map<String, Object> attachFileInfo : deleteAttachFileInfoList) {
				File file = new File((String)attachFileInfo.get("filPath"));

				file.delete();
			}

			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 삭제되었습니다.");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

		return modelAndView;
	}

	@RequestMapping(value="/system/attach/downloadAttachFile.do")
	public FileDownloadView downloadAttachFile(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		MarkAnyDrm markAnyDrm = new MarkAnyDrm();
		Map<String, Object> drmCfgMap = null;

		LOGGER.debug("###########################################################");
		LOGGER.debug("AttachFileController - downloadAttachFile 첨부파일 다운로드");
		LOGGER.debug("###########################################################");

		Map<String, Object> attachFileInfo = attachFileService.getAttachFileInfo(input);
		String menuRole = (String)attachFileInfo.get("menuType");

		input.put("menuRole", menuRole);
		input.put("lastMdfyId", attachFileInfo.get("lastMdfyId"));
		drmCfgMap = attachFileService.retrieveDrmConfig(input);

		String encodePath = "D:\\encode\\"+attachFileInfo.get("filPath").toString().substring(attachFileInfo.get("filPath").toString().lastIndexOf("\\") + 1, attachFileInfo.get("filPath").toString().length());

		/* 운영반영시 해제
		if( CommonUtil.getExtension((String)attachFileInfo.get("filNm"))  ){
			if(  markAnyDrm.EncryptFileCheck(attachFileInfo.get("filPath").toString() ) > 0 ){		//암호화 체크
				//암호화일 경우 복호화 후에 다시 암호화
				if(markAnyDrm.DecryptFile((String) attachFileInfo.get("filPath")) == 0 ){
					if( markAnyDrm.fncEncyto(attachFileInfo, input, drmCfgMap) > 0 ){
						throw new Exception("첨부파일 암호화 중 오류가 발생하였습니다.");
					}
				}else{
					throw new Exception("첨부파일 복호화 중 오류가 발생하였습니다.");
				}

				FileDownloadView fileDownloadView = new FileDownloadView(encodePath, (String)attachFileInfo.get("filNm"));
				return fileDownloadView;
			}else{
				if( markAnyDrm.fncEncyto(attachFileInfo, input, drmCfgMap) == 0 ){
					FileDownloadView fileDownloadView = new FileDownloadView(encodePath, (String)attachFileInfo.get("filNm"));
					return fileDownloadView;
				}else{
					throw new Exception("첨부파일 암호화 중 오류가 발생하였습니다.");
				}
			}
			
		}else{
			FileDownloadView fileDownloadView = new FileDownloadView((String)attachFileInfo.get("filPath"), (String)attachFileInfo.get("filNm"));
			return fileDownloadView;
		}
		*/
		
		/* 개발시 해제*/
		FileDownloadView fileDownloadView = new FileDownloadView((String)attachFileInfo.get("filPath"), (String)attachFileInfo.get("filNm"));
		return fileDownloadView;
		
	}


}