package iris.web.common.MarkAny;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.markany.nt.WDSCryptAll;

import devonframe.configuration.ConfigService;
import iris.web.system.attach.controller.AttachFileController;

public class MarkAnyDrm {

	static final String sDrmServerIp = "165.244.161.89";
	static final String sEnterpriseId = "LGHAUSYSGROUP-B875-0C6F-4FD3";
	static final String sCompanyId = "LGHAUSYS-E27C-66AF-E088";
	static final String sCompanyName = "LG하우시스";
	
	static final Logger LOGGER = LogManager.getLogger(AttachFileController.class);

	@Resource(name = "configService")
    private ConfigService configService;
	
	WDSCryptAll m_enc_dec = null;
	
	
	//암호화
	public int fncEncyto(Map<String, Object> attachFileInfo, HashMap<String, Object> input, Map<String, Object> drmCfgMap) {
		
		m_enc_dec = new WDSCryptAll();
		SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMddHHmmss");
		
		m_enc_dec.sDrmServerIp = MarkAnyDrm.sDrmServerIp;
		m_enc_dec.sSourceFilePath = attachFileInfo.get("filPath").toString(); 									//파일을 포함하는 풀 경로(절대 경로)
		//LOGGER.debug("encode  path ======================== = > " + "\\\\165.244.161.122\\e\\encode\\"+attachFileInfo.get("filPath").toString().substring(attachFileInfo.get("filPath").toString().lastIndexOf("\\") + 1, attachFileInfo.get("filPath").toString().length()));
		
		m_enc_dec.sDestFilePath =  "\\\\165.244.161.122\\e\\encode\\"+attachFileInfo.get("filPath").toString().substring(attachFileInfo.get("filPath").toString().lastIndexOf("\\") + 1, attachFileInfo.get("filPath").toString().length());			//파일을 포함하는 풀 경로(절대 경로)
		
		m_enc_dec.sUserId = input.get("_userId").toString();			// [필수] 사용자 아이디 또는 사번
		m_enc_dec.sEnterpriseId = MarkAnyDrm.sEnterpriseId;				// [필수] 그룹아이디
		m_enc_dec.sEnterpriseName = MarkAnyDrm.sCompanyName; 
		m_enc_dec.sCompanyId = MarkAnyDrm.sCompanyId;						// [필수] 회사아이디
		m_enc_dec.sCompanyName = MarkAnyDrm.sCompanyName;
		m_enc_dec.sDocId = formatter.format(new java.util.Date())+"_"+input.get("_userId")+"_"+attachFileInfo.get("filNm").toString();		// [필수] 파일별 Unique해야함 (로그 분석 시 사용되는 키값)
		//m_enc_dec.sDocGrade = "대외비"; // [선택] 문서 등급명
		m_enc_dec.sServerOrigin = "IRIS"; 										// [필수] 서버명 또는 시스템 약어
		m_enc_dec.sEncryptedBy = "0";											//0:서버 암호화, 1:자동 암호화
		
		int clipboardValue = 0;
		if(input.get("_userId").toString().equals(input.get("lastMdfyId"))     ){
			clipboardValue = 1;
		}
		m_enc_dec.iClipboardOption =  clipboardValue;										//암호화 문서의 클립보드 제어(0:클립보드 제어, 1:제어하지 않음)
		
		m_enc_dec.iDocOpenLog = 1;												//오픈 시 로그 전송 (1:전송, 0:미전송)
		m_enc_dec.iDocSaveLog = 1;												//저장 시 로그 전송 (1:전송, 0:미전송)
		m_enc_dec.iDocPrintLog =1;												//인쇄 시 로그 전송 (1:전송, 0:미전송)
		m_enc_dec.sServerInfo_Log = "";	//로그 전송 url:port
		m_enc_dec.iOnlineAclControl = 0;												//실시간 권한 제어(0:미사용, 1:사용)
		
		int pos = attachFileInfo.get("filNm").toString().lastIndexOf( "." );
		String ext = attachFileInfo.get("filNm").toString().substring( pos + 1 );
		m_enc_dec.sDocType = ext;																	//파일명 확장자
		m_enc_dec.sSecurityLevel = "0";																//보안 등급 코드 (동희산업의 경우 0:암호화, 1:대외비)
		m_enc_dec.sSecurityLevelName = "";															//보안 등급명
		m_enc_dec.sValidPeriodType = "0";															//1:sDocValidPeriod의 값을 숫자로 표기, 0:sDocValidPeriod의 값을 yyyymmddhhmmss로 표기
		m_enc_dec.sFileName = attachFileInfo.get("filNm").toString(); 								// [필수] 파일명칭 (암호화 헤더에 들어가는 파일명)
		
		m_enc_dec.sDocExchangePolicy = drmCfgMap.get("sDocExchangePolicy").toString();				//문서 교환정책 (0:개인한, 1:사내한, 2:부서한)
		m_enc_dec.sDocValidPeriod = drmCfgMap.get("sDocValidPeriod").toString();					//sValidPeriodType 값이 1이면 숫자형식, 값이 2이면 yyyymmddhhmmss
		m_enc_dec.iCanSave =  Integer.parseInt(drmCfgMap.get("iCanSave").toString());				//저장 가능 여부 (0:저장 불가능, 1:저장 가능)
		m_enc_dec.iCanEdit =  Integer.parseInt(drmCfgMap.get("iCanEdit").toString());				//편집 가능 여부 (0:편집 불가능, 1:편집 가능)
		m_enc_dec.iImageSafer = Integer.parseInt(drmCfgMap.get("iImageSafer").toString());			//화면캡쳐 방지 여부 (1:방지, 0:허용 or 방지하지않음)
		m_enc_dec.iDocOpenCount = Integer.parseInt(drmCfgMap.get("iDocOpenCount").toString());		//오픈 횟수 (0~999 입력, -99 : 무제한)
		m_enc_dec.iVisiblePrint = Integer.parseInt( drmCfgMap.get("iVisiblePrint").toString());		//워터마크 적용 여부 (0:적용 안함, 1:적용함)
		m_enc_dec.iDocPrintCount = Integer.parseInt(drmCfgMap.get("iDocPrintCount").toString());	//인쇄 횟수 (0~999 입력, -99 : 무제한)
		
		int enc_rs = m_enc_dec.iEncrypt();
		LOGGER.debug("암호화 결과======================== = > " + enc_rs);
		String su ="성공";
		String er ="오류";
		String enc = enc_rs == 0?su:er;
		LOGGER.debug("암호화 결과======================== = > " + enc);
		
		return enc_rs;
	}

	//암호화 체크
	public int EncryptFileCheck(String filePath){
		m_enc_dec = new WDSCryptAll();
		LOGGER.debug("암호화 체크 =======EncryptFileCheck=====filePath============ = > " + filePath);
		m_enc_dec.sSourceFilePath = filePath; 
		int chkNum = m_enc_dec.iEncCheck();
		
		LOGGER.debug("암호화 체크 결과============chkNum============ = > " + chkNum);
		String cryto ="암호화";
		String deCryto ="평문화";
		String enc = chkNum == 1?cryto:deCryto;
		
		LOGGER.debug("암호화 체크 결과=============enc=========== = > " + enc);
        return chkNum;
     }
	 
	//복호화 
	public int DecryptFile(String filePath){
		m_enc_dec = new WDSCryptAll();
		
		m_enc_dec.sSourceFilePath = filePath;
		m_enc_dec.sDestFilePath = filePath;
		
		// 복호화 함수 호출
		int dec_rs = m_enc_dec.iDecrypt();
		LOGGER.debug("복호화 결과======================== = > " + dec_rs);
		String su ="성공";
		String er ="오류";
		String enc = dec_rs == 0?su:er;
		
		LOGGER.debug("복호화 결과======================== = > " + enc);
		return dec_rs;
	}
}
