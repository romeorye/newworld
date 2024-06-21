/*
 * @(#) CodeService.java
 *
 * Copyright 2012 by LG CNS, Inc.,
 * All rights reserved.
 *
 * Do Not Erase This Comment!!! (이 주석문을 지우지 말것)
 *
 * 본 클래스를 실제 프로젝트에 사용하는 경우 XXXX 프로젝트 담당자에게
 * 프로젝트 정식명칭, 담당자 연락처(Email)등을 mail로 알려야 한다.
 *
 * 소스를 변경하여 사용하는 경우 XXXX 프로젝트 담당자에게
 * 변경된 소스 전체와 변경된 사항을 알려야 한다.
 * 저작자는 제공된 소스가 유용하다고 판단되는 경우 해당 사항을 반영할 수 있다.
 *
 * (주의!) 원저자의 허락없이 재배포 할 수 없으며
 * LG CNS 외부로의 유출을 하여서는 안 된다.
 */
package iris.web.common.code.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * <pre>
 * 본 클래스는 코드 정보에 대한 CRUD를 담당하는 Service 인터페이스입니다.
 * </pre>
 *
 * @author XXX팀 OOO
 */

public interface CodeService {

    public List<Map<String, Object>> retrieveCodeValueList(String string);

    public List<Map<String, Object>> retrieveCodeValueAllList(HashMap<String, String> input);

}
