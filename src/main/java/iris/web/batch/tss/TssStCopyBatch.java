package iris.web.batch.tss;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import iris.web.batch.tss.service.TssStCopyService;
import iris.web.common.util.StringUtil;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.system.base.IrisBaseController;


/********************************************************************************
 * NAME : TssStCopyBatch.java
 * DESC : 과제 copy
 * PROJ : N/A
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR            DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.21  	 			 최초생성
 *********************************************************************************/

@Controller
public class TssStCopyBatch extends IrisBaseController {

	static final Logger LOGGER = LogManager.getLogger(TssStCopyBatch.class);

	Calendar cal = Calendar.getInstance();
	SimpleDateFormat date_formatter = new SimpleDateFormat("yyyyMMdd", new Locale("ko", "KOREA"));
	SimpleDateFormat month_formatter = new SimpleDateFormat("yyyyMM", new Locale("ko", "KOREA"));


	@Resource(name = "tssStCopyService")
	private TssStCopyService tssStCopyService;


	@Resource(name = "genTssPlnService")
	private GenTssPlnService genTssPlnService;

	@Transactional
	public void batchProcess() throws SQLException, ClassNotFoundException {

		String toDate = date_formatter.format(cal.getTime());
		LOGGER.debug("GenTssCopyBatch_START-" + toDate);

		String userId = "Batch";
		HashMap<String, Object> input;

		input = new HashMap<String, Object>();

		input.put("userId", userId);

		input = StringUtil.toUtf8(input);

		Map<String, Object> rtnMap = new HashMap<String, Object>(); // 메시지

		try {
			//1. 과제 및 통합결재 조회 결제 (결제 요청상태 과제 목록 103,503, 603)
			List<Map<String, Object>> retrieveTssComItgRdcs = tssStCopyService.retrieveTssComItgRdcs();
			LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>retrieveTssComItgRdcs  : " + retrieveTssComItgRdcs.size());
			
			//2. 과제 상태 변경 -> 104
			for (Map<String, Object> data : retrieveTssComItgRdcs) {
				LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>과재 품의 대상  : " + data);
				
				//결재상태코드 A01: 결재요청, A02: 최종승인완료 , A03: 반려, A04: 취소
				String aprdocstate = String.valueOf(data.get("aprdocstate")); 

				if (!StringUtil.isNullString(aprdocstate)) {
					String tssSt = "103";							//103	품의요청
					boolean rst = false;

					input.put("tssCd", data.get("affrCd")); //과제코드

					if ("A02".equals(aprdocstate)) {	//최종승인완료(IRIS_COM_ITG_RDCS)
						if ("503".equals(String.valueOf(data.get("tssSt")))) {	//정산품의요청
							tssSt = "504"; //504 정산품의완료,
						} else if ("603".equals(String.valueOf(data.get("tssSt")))) { //초기유동품의요청
						    tssSt = "604"; //604 초기유동품의완료,
						} else {
						    if ("Y".equals(String.valueOf(data.get("initFlowYn")))) { //초기유동작성중
						        tssSt = "600"; //600 초기유동작성중,
						    } else {
						        tssSt = "104"; //104 품의완료,
						    }
							rst = true;
						}

						input.put("tssSt", tssSt); //상태 코드
						
						int result = genTssPlnService.updateGenTssPlnMstTssSt(input);        //tssSt update
						
					} else if ("A03".equals(aprdocstate) || "A04".equals(aprdocstate)) {	//반려, 취소
						if (data.get("tssScnCd").equals("N")) {
							if (data.get("finYn").equals("Y") || (data.get("tssNosSt").equals("1") && data.get("pgsStepCd").equals("PL"))) {
								tssSt = "102"; //GRS완료
							} else {
								tssSt = "100"; //진행중
							}
						 }else{ 
							 if( data.get("pgsStepCd").equals("PL")){
								 if ( data.get("tssScnCd").equals("M") ){
									 tssSt = "100"; // GRS평가완료
								 }else{
									 tssSt = "302"; // GRS평가완료
								 }
							}else{
								tssSt = "100"; // GRS평가완료
							}
						}
						
						input.put("tssSt", tssSt); //상태 코드

						genTssPlnService.updateGenTssPlnMstTssSt(input); //tssSt update
					}

					if (rst) {
						data.put("userId", userId);
						//2.2 상태에 따른 tsscd 생성
						tssStCopyService.insertTssCopy(data);
					}
				}
			}

			LOGGER.debug("TssStCopyBatch_End-" + toDate);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}


}


