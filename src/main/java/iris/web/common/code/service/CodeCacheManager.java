/*------------------------------------------------------------------------------
 * NAME : CodeCacheManager
 * DESC : 코드 cache화 service
 * VER  : V1.0
 * PROJ :
 * Copyright 2016 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.08
 *------------------------------------------------------------------------------*/
package iris.web.common.code.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;


@Service("codeCacheManager")
public class CodeCacheManager {

    @Resource(name="commonDao")
    private CommonDao commonDao;

    @Resource(name="codeService")
    private CodeService codeService;

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    static final Logger LOGGER = LogManager.getLogger(CodeCacheManager.class);

    /**
     * Cache에서 코드목록정보를 조회한다.
     *
     * @param cache에서 조회할 그룹코드
     * @return 그룹코드로 조회된 하위코드정보목록
     */
    @Cacheable(value="codeListForCache")
    public List<Map<String, Object>> retrieveCodeValueListForCache(String input) {
        return codeService.retrieveCodeValueList(input);
    }

    @Cacheable(value="codeListForCache")
    public List<Map<String, Object>> retrieveCodeAllListForCache(String input) {
        // TODO Auto-generated method stub
        return codeService.retrieveCodeValueAllList(input);
    }

    @CacheEvict(value="codeListForCache") //해당 캐시 삭제
    public List<Map<String, Object>> refresh(String input) {
        return codeService.retrieveCodeValueAllList(input);
    }
}

