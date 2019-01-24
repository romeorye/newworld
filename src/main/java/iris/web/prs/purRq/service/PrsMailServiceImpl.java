package iris.web.prs.purRq.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;

/********************************************************************************
 * NAME : PrsMailServiceImpl.java
 * DESC : M/M 관리 - M/M 입력 Service Interface
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.10.20  IRIS04	최초생성
 *********************************************************************************/

@Service("prsMailService")
public class PrsMailServiceImpl implements PrsMailService {

	static final Logger LOGGER = LogManager.getLogger(PrsMailServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	/** 메일 히스토리 등록 
	 * mailTitl : 메일제목
	 * adreMail : 받는사람 메일주소
	 * trrMail : 보내는사람 메일주소
	 * _userId : 등록자ID,수정저ID, 전송자ID
	 * **/
	@Override
	public void insertMailSndHis(List<HashMap<String, Object>> mailSndList) {
		commonDao.batchInsert("open.prsReq.insertMailHis", mailSndList);
	}
}