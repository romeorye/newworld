package iris.web.common.util;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.util.*;

public class TestConsole {

    static final Logger LOGGER = LogManager.getLogger(TestConsole.class);

    public static void isEmpty(String name, Object obj) {
        if (obj == null || obj.equals("")) {
            LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            LOGGER.debug(name + " is Empty " + obj);
            LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        }
    }

    public static void isEmptyMap(HashMap map) {
        Iterator<String> keys = map.keySet().iterator();
        LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        while (keys.hasNext()) {
            String key = keys.next();
            if (map.get(key) == null || map.get(key).equals("")) {
                LOGGER.debug(key + " is Empty " + map.get(key));
            }
        }
        LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    }

    public static void showMap(Map<String, Object> map) {
        showMap(map, "");
    }


    public static void showMap(Map<String, Object> map, String txt) {
        LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + txt);
        Iterator<String> keys = map.keySet().iterator();
        while (keys.hasNext()) {
            String key = keys.next();
            LOGGER.debug(key + " = " + map.get(key));
        }
        LOGGER.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + txt);
    }




}
