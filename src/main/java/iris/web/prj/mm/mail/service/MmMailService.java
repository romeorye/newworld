package iris.web.prj.mm.mail.service;

import java.util.HashMap;
import java.util.List;

/********************************************************************************
 * NAME : MmMailService.java
 * DESC : 메일 Service
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.10.20  IRIS04	최초생성
 *********************************************************************************/

public interface MmMailService {

	/** 메일 히스토리 등록 **/
	void insertMailSndHis(List<HashMap<String, Object>> mailSndList);
}