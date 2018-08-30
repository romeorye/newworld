package iris.web.knld.rsst.controller;

import java.util.HashMap;
import java.util.List;
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
import org.springframework.web.servlet.ModelAndView;

import devonframe.configuration.ConfigService;
import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.code.service.CodeCacheManager;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.knld.rsst.service.ProductListService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : ProductListController.java
 * DESC : 연구산출물 관리 controller
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.10.10  			최초생성
 *********************************************************************************/

@Controller
public class ProductListController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;

	@Resource(name = "configService")
    private ConfigService configService;

	@Resource(name = "productListService")
	private ProductListService productListService;

	static final Logger LOGGER = LogManager.getLogger(ProductListController.class);

	/*리스트 화면 호출*/
	@RequestMapping(value="/knld/rsst/retrieveProductList.do")
	public String OutsideSpecialistList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("OutsideSpecialistController - OutsideSpecialistList [연구산출물 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/rsst/retrieveProductList";
	}

	/*리스트*/
	@RequestMapping(value="/knld/rsst/getProductList.do")
	public ModelAndView getProductList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ProductListController - getProductList [연구산출물 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 연구산출물 리스트 조회
		List<Map<String,Object>> productListList = productListService.getProductList(input);

		modelAndView.addObject("prdtListDataSet", RuiConverter.createDataset("prdtListDataSet", productListList));
		return modelAndView;
	}


	/*등록,수정 화면 호출*/
	@RequestMapping(value="/knld/rsst/productListRgst.do")
	public String productListRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ProductListController - ProductListRgst [연구산출물 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/rsst/productListRgst";
	}

	/** 등록 **/
	@RequestMapping(value="/knld/rsst/insertProductListInfo.do")
	public ModelAndView insertProductListInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("ProductListController - insertProductListInfo [연구산출물 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("prdtId", "");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> prdtListRgstDataSetList;	// 변경데이터

		try{

			// 저장&수정
			String prdtId = "";
			prdtListRgstDataSetList = RuiConverter.convertToDataSet(request,"prdtListRgstDataSet");

			for(Map<String,Object> productListRgstDataSetMap : prdtListRgstDataSetList) {
				productListRgstDataSetMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				productListService.insertProductListInfo(productListRgstDataSetMap);
				totCnt++;
			}

			rtnMeaasge.put("prdtId", prdtId);

			if(totCnt == 0 ) {
				rtnMeaasge.put("rtnSt", "F");
				rtnMeaasge.put("rtnMsg", "변경된 내용이 없습니다.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "저장이 실패하였습니다.");
		}

		model.addAttribute("inputData", input);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}

	@RequestMapping(value="/knld/rsst/productListInfo.do")
	public String productListInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ProductListController - productListInfo [연구산출물 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/rsst/productListInfo";
	}

	@RequestMapping(value="/knld/rsst/getProductListInfo.do")
	public ModelAndView getProductListInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ProductListController - getProductListInfo [연구산출물 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("prdtListDataSet", null);
        } else {
        	// 연구산출물 상세 조회
	        Map<String,Object> resultMap = productListService.getProductListInfo(input);

	        modelAndView.addObject("prdtListInfoDataSet", RuiConverter.createDataset("prdtListInfoDataSet", resultMap));
        }
		return modelAndView;
	}

	/** 연구산출물 삭제 **/
	@RequestMapping(value="/knld/rsst/deleteProductListInfo.do")
	public ModelAndView deleteProductListInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("ProductListController - deleteProductListInfo [연구산출물 삭제]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("#################################################################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "삭제 되었습니다.");

		int totCnt = 0;    							//전체건수
		try
		{
			productListService.deleteProductListInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}


	/** 게시글 조회건수 증가 */
	@RequestMapping(value="/knld/rsst/updateProductListRtrvCnt.do")
	public ModelAndView updateProductListRtrvCnt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("ProductListController - updateProductListRtrvCnt [연구산출물 조회건수증가]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("#################################################################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "");

		try
		{
			productListService.updateProductListRtrvCnt(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "조회건수 증가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

//	/* 사외전문가 팝업 화면 이동 */
//	@RequestMapping(value="/knld/rsst/productListPopup.do")
//	public String productListPopup(
//			@RequestParam HashMap<String, String> input,
//			HttpServletRequest request,
//			HttpSession session,
//			ModelMap model
//			) throws Exception{
//
//		/* 반드시 공통 호출 후 작업 */
//		checkSession(input, session, model);
//
//		LOGGER.debug("####################################################################################");
//		LOGGER.debug("OutsideSpecialistController - outsideSpecialistPopup [사외전문가 팝업 화면 이동]");
//		LOGGER.debug("input = > " + input);
//		LOGGER.debug("####################################################################################");
//
//		model.addAttribute("inputData", input);
//
//		return "web/knld/pub/outsideSpecialistPopup";
//	}


	@RequestMapping(value="/knld/rsst/knldAffrTreeSrhRsltPopup.do")
	public String knldAffrTreeSrhRsltPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ProductListController - knldAffrTreeSrhRsltPopup 트리 리스트 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");


		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		model.addAttribute("inputData", input);

		return "web/knld/rsst/productListPopup";
	}


	/* 트리 리스트 조회 */
	@RequestMapping(value="/knld/rsst/getKnldProductTreeInfo.do")
	public ModelAndView getKnldProductTreeInfo(
		@RequestParam HashMap<String, Object> input,
		HttpServletRequest request,
		HttpServletResponse response,
		HttpSession session,
		ModelMap model
		){

		LOGGER.debug("###########################################################");
		LOGGER.debug("ProductListController - getKnldProductTreeInfo [트리 리스트 불러오기]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		input.put("isMng", "0");

		Map<String,Object> knldProductInfo = null;
		List<Map<String,Object>> knldProductTreeList = productListService.getKnldProductTreeList(input);

	//	if(!"0".equals(input.get("affrClId"))) {
	//		anlRqprExprInfo = anlRqprService.getAnlRqprExprInfo(input);
	//	}
	//
	//	modelAndView.addObject("anlRqprExprDataSet", RuiConverter.createDataset("anlRqprExprDataSet", anlRqprExprInfo));
		modelAndView.addObject("knldProductTreeDataSet", RuiConverter.createDataset("knldProductTreeDataSet", knldProductTreeList));

		return modelAndView;
	}

	@RequestMapping(value="/knld/rsst/productListInfoSrchView.do")
	public String productListInfoSrchView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ProductListController - productListInfoSrchView [연구산출물 뷰 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/rsst/productListInfoSrchView";
	}

	/**
	 * 통합검색 권한체크
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/knld/rsst/retrieveSrchViewCheck.do")
	public String retrieveSrchViewCheck(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ProductListController - retrieveSrchViewCheck [통합검색내용 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
	
		String authYn =(String) productListService.getMenuAuthCheck(input);
		String rtnUrl = "/web/knld/mgmt/knldRtrvRqDetail";
		//authYn = "N";		
		if(authYn.equals("N")  ){
			rtnUrl = "/web/knld/mgmt/searchAuthFail";
		}
		
		input.put("authYn", authYn);
		model.addAttribute("inputData", input);
		
		return rtnUrl;
	}
	
	
	
}//class end
