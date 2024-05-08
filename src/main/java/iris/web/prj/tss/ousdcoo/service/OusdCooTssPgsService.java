package iris.web.prj.tss.ousdcoo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*********************************************************************************
 * NAME : OusdCooTssPgsService.java
 * DESC : 프로젝트 - 과제관리 - 대외협력과제 진행(PGS) service
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.19  IRIS04	최초생성
 *********************************************************************************/

public interface OusdCooTssPgsService {

    /** 변경이력 **/
    public List<Map<String, Object>> retrieveOusdCooTssPgsAltrHist(HashMap<String, String> input);

    public void deleteOusdTssOfTssCd(HashMap<String, String> input);

}
