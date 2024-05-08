package iris.web.stat.prj.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*********************************************************************************
 * NAME : TssStatService.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016.08.08
 *********************************************************************************/

public interface PtfloService {

    List<Map<String, Object>> retrievePtfloFunding_a(HashMap<String, Object> input);
    List<Map<String, Object>> retrievePtfloFunding_p(HashMap<String, Object> input);

    List<Map<String, Object>> retrievePtfloTrm_a(HashMap<String, Object> input);
    List<Map<String, Object>> retrievePtfloTrm_p(HashMap<String, Object> input);

    List<Map<String, Object>> retrievePtfloAttr_a(HashMap<String, Object> input);
    List<Map<String, Object>> retrievePtfloAttr_p(HashMap<String, Object> input);

    List<Map<String, Object>> retrievePtfloSphe_a(HashMap<String, Object> input);
    List<Map<String, Object>> retrievePtfloSphe_p(HashMap<String, Object> input);

    List<Map<String, Object>> retrievePtfloType_a(HashMap<String, Object> input);
    List<Map<String, Object>> retrievePtfloType_p(HashMap<String, Object> input);

}