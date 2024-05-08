package iris.web.space.batch.service;

import java.util.HashMap;
import java.util.List;

import iris.web.space.rqpr.vo.SpaceEvRnewMailInfo;

/*********************************************************************************
 * NAME : SpaceEvRnewMailService.java
 * DESC : 공간평가성적서 갱신대상 이메일 배치 Service
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2018.10.30  오정훈	최초생성
 *********************************************************************************/

public interface SpaceEvRnewMailService {

	/* 공간평가성적서 갱신대상 리스트 조회 */
	public List<SpaceEvRnewMailInfo> getSpaceEvRnewMailList();

	/* 공간평가성적서 갱신대상 이메일 발송 */
	public boolean sendSpaceEvRnewMail(SpaceEvRnewMailInfo spaceEvRnewMailInfo) throws Exception;

}