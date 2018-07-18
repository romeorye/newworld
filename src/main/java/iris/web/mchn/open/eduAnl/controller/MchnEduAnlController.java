package iris.web.mchn.open.eduAnl.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import devonframe.configuration.ConfigService;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.CommonUtil;
import iris.web.common.util.NamoMime;
import iris.web.common.util.StringUtil;
import iris.web.mchn.open.edu.service.MchnEduService;
import iris.web.mchn.open.eduAnl.service.MchnEduAnlService;
import iris.web.system.base.IrisBaseController;

@Controller
public class MchnEduAnlController  extends IrisBaseController {

	@Resource(name="mchnEduAnlService")
	private MchnEduAnlService mchnEduAnlService;

	@Resource(name="mchnEduService")
	private MchnEduService mchnEduService;

	@Resource(name = "configService")
    private ConfigService configService;

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	static final Logger LOGGER = LogManager.getLogger(MchnEduAnlController.class);


	/**
	 *  open기기 > 기기교육 > 기기교육관리목록 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/eduAnl/retrieveEduAdmListList.do")
	public String retrieveEduList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		
		model.addAttribute("inputData", input);
		
		return  "web/mchn/open/eduAnl/mchnEduAnlList";
	}

	/**
	 *  open기기 > 기기교육 > 기기교육관리 목록조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/eduAnl/retrieveMchnEduAnlSearchList.do")
	public ModelAndView retrieveMchnEduAnlSearchList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

       	List<Map<String, Object>> resultList = mchnEduAnlService.retrieveMchnEduAnlSearchList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

		return  modelAndView;
	}

	/**
	 *  open기기 > 기기교육 > 기기교육관리 등록및 수정화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/eduAnl/retrieveMchnEduAnlInfo.do")
	public String retrieveMchnEduAnlInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		ModelAndView modelAndView = new ModelAndView("ruiView");
		checkSessionObjRUI(input, session, model);
		
		
		model.addAttribute("inputData", input);

		return  "web/mchn/open/eduAnl/mchnEduAnlInfo";
	}

	/**
	 *  open기기 > 기기교육 > 기기교육관리 상세조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/eduAnl/retrieveEduInfo.do")
	public ModelAndView retrieveEduInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);
		LOGGER.debug("#############################input######################################################## : "+ input);
		
		HashMap<String, Object> result = mchnEduAnlService.retrieveEduInfo(input);

		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", result));
		return  modelAndView;
	}

	/**
	 *  open기기 > 기기교육 > 기기교육관리 > 분석기기 팝업 화면 호출
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/eduAnl/retrieveMchnInfoPop.do")
	public String retrieveMchnInfoPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		return  "web/mchn/open/eduAnl/mchnInfoPop";
	}

	/**
	 *  open기기 > 기기교육 > 기기교육관리 > 신규등록 > 분석기기 팝업 목록조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/eduAnl/retrieveMachineList.do")
	public ModelAndView retrieveMachineList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

		List<Map<String, Object>> resultList = mchnEduAnlService.retrieveMachineList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

		return  modelAndView;
	}

	/**
	 *  open기기 > 기기교육 > 기기교육관리 > 신규등록 > 기기교육 삭제
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/eduAnl/updateEduInfo.do")
	public ModelAndView updateEduInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		String rtnSt ="F";
		String rtnMsg = "";
		
		try{
			mchnEduAnlService.updateEduInfo(input);
			
			rtnMsg = "삭제되었습니다.";
			rtnSt= "S";
			
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg ="처리중 오류가발생했습니다. 관리자에게 문의해주십시오.";
        }
		
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return  modelAndView;
	}

	/**
	 *  open기기 > 기기교육 > 기기교육관리 > 신규등록 > 기기교육 등록 및 수정
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/eduAnl/saveEduInfo.do")
	public ModelAndView saveEduInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		NamoMime mime = new NamoMime();
		
		String dtlSbcHtml = "";
		String dtlSbcHtml_temp = "";
		String rtnSt ="F";
		String rtnMsg = "";
		
		try{

			String uploadPath = "";
            String uploadUrl = "";

            uploadUrl =  configService.getString("KeyStore.UPLOAD_URL") + configService.getString("KeyStore.UPLOAD_MCHN");   // 파일명에 세팅되는 경로
            uploadPath = configService.getString("KeyStore.UPLOAD_BASE") + configService.getString("KeyStore.UPLOAD_MCHN");  // 파일이 실제로 업로드 되는 경로

            mime.setSaveURL(uploadUrl);
            mime.setSavePath(uploadPath);
            mime.decode(input.get("dtlSbc").toString());                  // MIME 디코딩
            mime.saveFileAtPath(uploadPath+File.separator);

            dtlSbcHtml = mime.getBodyContent();
            dtlSbcHtml_temp = CommonUtil.replaceSecOutput(CommonUtil.replace(CommonUtil.replace(dtlSbcHtml, "<", "@![!@"),">","@!]!@"));

			input.put("dtlSbc", dtlSbcHtml);

			mchnEduAnlService.saveEduInfo(input);
			
			rtnMsg = "저장되었습니다.";
			rtnSt= "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg ="처리중 오류가발생했습니다. 관리자에게 문의해주십시오.";
        }
		
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return  modelAndView;
	}


	/**
	 *  open기기 > 기기교육 > 기기교육관리 > 교육신청관리 화면 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/eduAnl/retrieveEduRgstList.do")
	public String retrieveEduRgstList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		model.addAttribute("inputData", input);
		
		return  "web/mchn/open/eduAnl/mchnEduAnlRgstList";
	}

	/**
	 *  open기기 > 기기교육 > 기기교육관리 > 교육신청관리 화면 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/eduAnl/retrieveMchnEduAnlRgstInfo.do")
	public ModelAndView retrieveMchnEduAnlRgstInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		List<Map<String, Object>> resultList = mchnEduAnlService.retrieveMchnEduAnlRgstList(input);
    	List<Map<String, Object>> excelList1 = mchnEduAnlService.retrieveMchnEduAnlRgstListExcel(input);
    	Map<String, Object> result = mchnEduService.retrieveEduInfo(input);
		
    	modelAndView.addObject("mchnInfoDataSet", RuiConverter.createDataset("mchnInfoDataSet", result));
    	modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));
        modelAndView.addObject("excelDataSet", RuiConverter.createDataset("excelDataSet", excelList1));		//엑셀전체 다운로드용

        return  modelAndView;
	}

	/**
	 *  open기기 > 기기교육 > 기기교육관리 > 교육신청관리 수료, 미수료 업데이트
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/eduAnl/updateEduDetailInfo.do")
	public ModelAndView updateEduDetailInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		String arrChkDtlId[] = String.valueOf(input.get("chkDtlId")).split(",");
		List<Map<String,Object>> inputList = new ArrayList<Map<String,Object>>();
		Map<String,Object> tmpMap = new HashMap<String, Object>();

		String tmpStr1 = "";
		String rtnMsg = "";
		String rtnSt = "F";
		String eduStNm = "";

		try{
			if(input.get("eduStCd").equals("CCS")){
				eduStNm = "수료";
			}else{
				eduStNm = "미수료";
			}
			input.put("eduStNm", eduStNm);
			
			for(int i = 0; i < arrChkDtlId.length; i++){
				tmpStr1 = arrChkDtlId[i];

				tmpMap = new HashMap<String, Object>();
				tmpMap.put("eduDtlId", tmpStr1);
				tmpMap.put("eduStCd", input.get("eduStCd"));
				tmpMap.put("_userSabun", String.valueOf(input.get("_userSabun")));
				tmpMap.put("_userId", String.valueOf(input.get("_userId")));
				inputList.add(tmpMap);
			}

			mchnEduAnlService.updateEduDetailInfo(inputList, input);

			rtnMsg =  eduStNm+" 처리되었습니다.";
			rtnSt = "S";
			
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "처리중 오류가발생했습니다. 담당자에게 문의해주세요";
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		
		return  modelAndView;
	}


}
