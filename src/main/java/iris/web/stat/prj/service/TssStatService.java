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

public interface TssStatService {

    List<Map<String, Object>> retrieveGenTssStatList(HashMap<String, Object> input);

    List<Map<String, Object>> retrieveTechTeamTssStatList(HashMap<String, Object> input);

    List<Map<String, Object>> retrieveOusdTssStatList(HashMap<String, Object> input);

    List<Map<String, Object>> retrieveNatTssStatList(HashMap<String, Object> input);

    List<Map<String, Object>> retrieveGenTssStatDtlPopList(HashMap<String, Object> input);

    List<Map<String, Object>> retrieveTechTeamTssStatDtlPopList(HashMap<String, Object> input);
}