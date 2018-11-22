package iris.web.rlab.tmgt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface RlabTeamGateService {

	/* Team Gate 리스트 조회 */
	List<Map<String, Object>> rlabTeamGateList(HashMap<String, Object> input);

	/* Team Gate 상세조회 */
	HashMap<String, Object> rlabTeamGateDtl(HashMap<String, Object> input);

	/* Team Gate 결과상세조회 */
	HashMap<String, Object> rlabTeamGateCmplDtl(HashMap<String, Object> input);

	/* Team Gate 등록  */
	void saveRlabTeamGate(HashMap<String, Object> input);

	/* Team Gate 임시저장  */
	void saveTempRlabTeamGateEv(HashMap<String, Object> input);

	/* Team Gate 평가  */
	void saveRlabTeamGateEv(HashMap<String, Object> input);

	/* Team Gate 투표완료  */
	void saveRlabTeamGateEvCmpl(HashMap<String, Object> input);

	/* Team Gate 투표수정  */
	void saveRlabTeamGateEvReg(HashMap<String, Object> input);

	/* Team Gate 삭제  */
	void delRlabTeamGateEvReg(HashMap<String, Object> input);

}
