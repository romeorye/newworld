package iris.web.prj.tss.ousdcoo.service;

import java.util.HashMap;

/*********************************************************************************
 * NAME : OusdCooTssCmplService.java
 * DESC : 프로젝트 - 과제관리 - 대외협력과제 완료(Cmpl) service
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.21  IRIS04	최초생성
 *********************************************************************************/

public interface OusdCooTssCmplService {
    /** 대외협력 완료 마스터 복사, 개요 복사 후 업데이트 **/
    public int insertOusdCooTssPlnMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs);
        
    /** 대외협력 완료 마스터, 개요 수정 **/
    public int updateOusdCooTssCmplMst(HashMap<String, Object> mstDs, HashMap<String, Object> smryDs, boolean upWbsCd);

    /** 대외협력 완료 필수값 체크*/
	public String retrieveOusdCooTssCmplCheck(HashMap<String, String> input);
}
