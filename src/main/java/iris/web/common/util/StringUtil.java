package iris.web.common.util;

/******************************************************************************
 *	Program Name	: StringUtil.java
 *	Description		: String Util Class
 *   원본일치 ( lghausys.twms.esti.util )
 *******************************************************************************
 *                                MODIFICATION LOG
 *
 *		DATE		AUTHORS		DESCRIPTION
 *   -----------		--------    ----------------------------------
 *	2009/11/02		최주영		Initial Release
 *	2009/12/16		ZhangJun	Add numberFormat
 ********************************************************************************/

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.DecimalFormat;
import java.text.MessageFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class StringUtil {


    /**
     * Null check.
     * @param sTarget
     * @param isHtmlView
     * @return
     */

    public static String isNullGetEmpty(String sTarget, boolean isHtmlView) {

        String returnStr = "";

        if(sTarget != null && sTarget.trim().length() > 0) {
            returnStr = sTarget;
        } else {
            if(isHtmlView) {
                returnStr = "&nbsp;";
            }
        }
        return returnStr;
    }

    /**
     * 주어진 . String 이  . Null || "" 일경우 . returnValue 반환.
     * @param sTarget
     * @param sInputValue
     * @return
     */
    public static String isNullGetInput(String sTarget, String sInputValue) {

        String returnStr = "";

        if(sTarget != null && sTarget.trim().length() > 0) {
            returnStr = sTarget;
        } else {
            returnStr = sInputValue;
        }
        return returnStr;
    }

    /**
     * null check. return boolean (null : true, not null : false)
     * @param sTarget
     * @return
     */
    public static boolean isNullString(String sTarget) {

        boolean isNull = false;

        if(sTarget == null || "".equals(sTarget) || sTarget.trim().length() < 1) {
            isNull = true;
        }
        return isNull;
    }


    /**
     * 대상문자열이. Null 이거나, 주어진값과 . 동일한지여부를. 반환합니다.
     * @param sTarget
     * @param sInputValue
     * @return
     */
    public static boolean isNullOrInputValue(String sTarget, String sInputValue) {
        if(sTarget == null || "".equals(sTarget) || (sInputValue).equals(sTarget)) {
            return true;
        }
        return false;
    }


    /**
     * 현재시간(YYYYMMDDHH24MISS)을. 반환합니다.
     * @return
     */
    public static String getCurrentYYYYMMDDhhmiss() {

        Calendar cal = Calendar.getInstance();
        String returnStr = "";

        DecimalFormat df4 = new DecimalFormat("0000");
        DecimalFormat df2 = new DecimalFormat("00");

        returnStr = df4.format(cal.get(Calendar.YEAR))
                + df2.format(cal.get(Calendar.MONTH) + 1)
                + df2.format(cal.get(Calendar.DATE))
                + df2.format(cal.get(Calendar.HOUR_OF_DAY))
                + df2.format(cal.get(Calendar.MINUTE))
                + df2.format(cal.get(Calendar.SECOND));

        return returnStr;
    }


    /**
     * 프로젝트 . 표준. 날짜 형식을. 반환합니다.
     * @param yyyymmdd
     * @param isHtmlView
     * @return
     */
    public static String getStandardDateFormat(String yyyymmdd, boolean isHtmlView) {

        String formatStr = "";

        if(yyyymmdd != null && yyyymmdd.length() == 8) {
            formatStr = yyyymmdd.substring(0, 4) + "-" + yyyymmdd.substring(4, 6) + "-" + yyyymmdd.substring(6);
        } else if (yyyymmdd != null && yyyymmdd.length() == 6) {
            formatStr = yyyymmdd.substring(0, 4) + "/" + yyyymmdd.substring(4);
        }else {
            if(isHtmlView) {
                formatStr = "&nbsp;";
            } else {
                formatStr = "";
            }
        }
        return formatStr;
    }


    /**
     * 주어진 인자를. 숫자형으로. 포맷후 . 반환합니다. (기본값 : 0)
     * @param number
     * @param isHtmlView
     * @return
     */
    public static String numberFormat(String number, boolean isHtmlView) {
        double dn = 0;

        if(number == null || "".equals(number)) {
            return isNullGetInput(number, "0");
        }
        else {
            try {
                dn = Double.parseDouble(number);
                return java.text.NumberFormat.getInstance().format(dn);
            }
            catch(NumberFormatException e) {
                return isNullGetEmpty(number,isHtmlView);
            }
        }
    }


    /**
     * 정의된 . 소수점포맷. 데이터를 . 반환합니다.
     * @param parseData
     * @return
     */
    public double parseDoubleFormatJustPoint(double parseData) {
        return Double.parseDouble(String.format("%.3f", parseData));
    }


    /**
     * 특정 스트링내의 일정한 pattern subString을 replace 문자열로 대치한다.
     *
     * 사용예) replace("2002-02-10", "-", "/")
     * 결과)  "2002/02/10"
     */
    public static String replace(String str, String pattern, String replace) {

        int s = 0, e = 0;

        if (str == null || str.equals("")) return "";

        StringBuffer result = new StringBuffer();

        while ((e = str.indexOf(pattern, s)) >= 0) {
            result.append(str.substring(s, e));
            result.append(replace);
            s = e + pattern.length();
        }

        result.append(str.substring(s));
        return result.toString();
    }


    /**
     * 숫자 스트링을 iLen 만큼 앞에 '0'(zero)로 채워 돌려준다.
     * 소수점 이하는 모두 절사함.
     *
     * 사용예) getZeroAddition("123456", 10)
     * 결과)  0000123456
     */
    public static String getZeroAddition(String inStr, int iLen) {

        String outStr = "";

        if (inStr.equals("")) return outStr;

        int pts = inStr.indexOf(".");
        if (pts > 0) {
            inStr = inStr.substring(0, pts);
        }

        if (Long.parseLong(inStr) >= 0) {
            for (int i = 0; i < iLen - inStr.length(); i++) {
                outStr += "0";
            }

            outStr += inStr;
        } else {
            outStr += "-";
            for (int i = 0; i < iLen - inStr.length(); i++) {
                outStr += "0";
            }

            outStr += replace(inStr,"-","");
        }

        return outStr;
    }


    /**
     * 전달받은 문자열을 금전형식으로 돌려준다.
     * 숫자가 아닌 값이 들어오면 입력값을 그대로 돌려준다.
     *
     * 사용예) getFormattedDollar(200102042.345)
     * 결과)  200,102,042.35
     *
     * @param dInstr double
     * @return String
     */
    public static String getFormattedDollar(double dInstr, String sFormat) {

        String rStr = "" + Double.parseDouble("" + Math.round(dInstr*100))/100;

        try {
            Object[] testArgs = {new Double(rStr)};
            //MessageFormat form = new MessageFormat("{0,number,###,###,###,##0.00}");
            MessageFormat form = new MessageFormat(sFormat);
            rStr = form.format(testArgs);
        } catch (Exception e) {}

        return rStr;
    }


    /**
     * 전달받은 문자열을 금전형식으로 돌려준다.
     * 숫자가 아닌 값이 들어오면 입력값을 그대로 돌려준다.
     *
     * 사용예) getFormattedMoney("200102042.345")
     * 결과)  200,102,042.35
     *
     * @param sInstr String
     * @return String
     */
    public static String getFormattedDollar(String sInstr, String sFormat) {

        if (sInstr == null || sInstr.equals("")) return "";

        String rStr = getFormattedDollar(Double.parseDouble(sInstr), sFormat);

        return rStr;
    }


    /**
     * List에서 특정 code의 value 가져오기
     * @param LMultiData lmData
     * @param String code
     * @return
     */
    public static String getLMultiDataCodeNm(List<Map<String,Object>>  lmData, String code) {
        String strValue = "";

        for(int i = 0; i < lmData.size(); i++) {
            if(code.equals( lmData.get(i).get("code").toString() )) {
                strValue = lmData.get(i).get("value").toString();
                break;
            }
        }

        return strValue;
    }


    /**
     * UTF-8로 String Decoding (파라메타용)
     * @param HashMap
     * @return HashMap
     * @throws UnsupportedEncodingException
     */
    public static HashMap toUtf8(HashMap data) {
        //--------------------------------------------- EUC-KR Decoding START
        Iterator iter = data.entrySet().iterator();
        while (iter.hasNext()) {
            Map.Entry entry = (Map.Entry) iter.next();

            String strKey  =  entry.getKey().toString();
            String strValue = entry.getValue().toString();

            if(strValue == null || strValue.equals("")) {
                data.put(entry.getKey(), "");
            } else {
                try{
                    data.put(entry.getKey(), CommonUtil.replaceSecOutput(URLDecoder.decode(strValue, "UTF-8")));
                }
                catch (Exception e) {
                }
            }
        }

        Iterator iter2 = data.entrySet().iterator();
        while (iter2.hasNext()) {
            Map.Entry entry = (Map.Entry) iter2.next();

            String strKey  =  (String) entry.getKey();
            String strValue = (String) entry.getValue();

            if(strValue == null || strValue.equals("")) {
                data.put(entry.getKey(), "");
            } else {
                try {
                    data.put(entry.getKey(), CommonUtil.replaceSecOutput(URLDecoder.decode(strValue, "UTF-8")));
                } catch (UnsupportedEncodingException e) {
                }
            }
        }

        return data;
        //--------------------------------------------- EUC-KR Decoding END
    }


    /**
     * UTF-8로 String Decoding (파라메타용)
     * @param HashMap
     * @return HashMap
     * @throws UnsupportedEncodingException
     */
    public static HashMap toUtf8Output(HashMap data) {
        //--------------------------------------------- EUC-KR Decoding START
        if(data == null || data.isEmpty() || data.size() <= 0) return data;

        Iterator iter = data.entrySet().iterator();
        while (iter.hasNext()) {
            Map.Entry entry = (Map.Entry) iter.next();

            String strKey  =  entry.getKey().toString();
            String strValue = entry.getValue().toString();

            if(strValue == null || strValue.equals("")) {
                data.put(entry.getKey(), "");
            } else {
                try{
                    data.put(entry.getKey(), CommonUtil.replaceSecOutput2(strValue));
                }catch (Exception e){
                }
            }
        }

        Iterator iter2 = data.entrySet().iterator();
        while (iter2.hasNext()) {
            Map.Entry entry = (Map.Entry) iter2.next();

            String strKey  =  (String) entry.getKey();
            String strValue = (String) entry.getValue();

            if(strValue == null || strValue.equals("")) {
                data.put(entry.getKey(), "");
            } else {
                try{
                    data.put(entry.getKey(), CommonUtil.replaceSecOutput2(URLDecoder.decode(strValue, "UTF-8")));
                }catch (Exception e){

                }
            }
        }

        return data;
        //--------------------------------------------- EUC-KR Decoding END
    }


    /**
     * UTF-8로 String Decoding (파라메타용)
     * @param HashMap
     * @return HashMap
     * @throws UnsupportedEncodingException
     */
    public static HashMap toUtf8Input(HashMap data) {
        //--------------------------------------------- EUC-KR Decoding START
        if(data == null || data.isEmpty() || data.size() <= 0) return data;

        Iterator iter = data.entrySet().iterator();
        while (iter.hasNext()) {
            Map.Entry entry = (Map.Entry) iter.next();

            String strKey  =  (String) entry.getKey();
            String strValue = (String) entry.getValue();

            if(strValue == null || strValue.equals("")) {
                data.put(entry.getKey(), "");
            } else {
                try{
                    data.put(entry.getKey(), CommonUtil.replaceSecInput3(strValue));
                }catch (Exception e){

                }
            }
        }

        Iterator iter2 = data.entrySet().iterator();
        while (iter2.hasNext()) {
            Map.Entry entry = (Map.Entry) iter2.next();

            String strKey  =  (String) entry.getKey();
            String strValue = (String) entry.getValue();

            if(strValue == null || strValue.equals("")) {
                data.put(entry.getKey(), "");
            } else {
                try{
                    data.put(entry.getKey(), CommonUtil.replaceSecInput3(URLDecoder.decode(strValue, "UTF-8")));
                }catch (Exception e){

                }

            }
        }

        return data;
        //--------------------------------------------- EUC-KR Decoding END
    }


    /**
     * UTF-8로 String Decoding (그리드 데이타셋용)
     * @param HashMap
     * @return HashMap
     * @throws UnsupportedEncodingException
     */
    public static HashMap toGridUtf8(HashMap data) {
        //--------------------------------------------- EUC-KR Decoding START
        Iterator iter = data.entrySet().iterator();
        while (iter.hasNext()) {
            Map.Entry entry = (Map.Entry) iter.next();

            String strKey  =  (String) entry.getKey();
            String strValue = (String) entry.getValue();

            if(strValue == null || strValue.equals("")) {
                data.put(entry.getKey(), "");
            } else {
                try{
                    data.put(entry.getKey(), new String(strValue.getBytes("EUC-KR"), "UTF-8") );
                }catch (Exception e){

                }
            }
        }

        Iterator iter2 = data.entrySet().iterator();
        while (iter2.hasNext()) {
            Map.Entry entry = (Map.Entry) iter2.next();

            String strKey  =  (String) entry.getKey();
            String strValue = (String) entry.getValue();

            if(strValue == null || strValue.equals("")) {
                data.put(entry.getKey(), "");
            } else {
                try{
                    data.put(entry.getKey(), new String(strValue.getBytes("EUC-KR"), "UTF-8") );
                }catch (Exception e){

                }
            }
        }

        return data;
        //--------------------------------------------- EUC-KR Decoding END
    }


    /**
     * UTF-8로 String Decoding (String용)
     * @param HashMap
     * @return HashMap
     * @throws UnsupportedEncodingException
     */
    public static String toStringUtf8(String data) {
        String returnData = "";
        try {
            returnData = new String(data.getBytes("EUC-KR"), "UTF-8");
        } catch(Exception e){}

        return returnData;
        //--------------------------------------------- EUC-KR Decoding END
    }

    /**
     * UTF-8로 String Decoding (파라메타용)
     * @param HashMap
     * @return HashMap
     * @throws UnsupportedEncodingException
     */
    public static HashMap toEUC_KR(HashMap data) {
        //--------------------------------------------- EUC-KR Decoding START
        Iterator iter = data.entrySet().iterator();
        while (iter.hasNext()) {
            Map.Entry entry = (Map.Entry) iter.next();

            String strKey  =  (String) entry.getKey();
            String strValue = (String) entry.getValue();

            if(strValue == null || strValue.equals("")) {
                data.put(entry.getKey(), "");
            } else {
                try{
                    /*
                    if(LSecurityUtils.verifyXSS(CommonUtil.replaceSecOutput(URLDecoder.decode(strValue, "UTF-8")), "", "*")){
                        //LLog.debug.println("Key:"+(String) entry.getKey()+", Value(이상없음):"+CommonUtil.replaceSecOutput(URLDecoder.decode(strValue, "UTF-8")));
                        data.put((String) entry.getKey(), CommonUtil.replaceSecOutput(URLDecoder.decode(strValue, "UTF-8")));
                    }else{
                        //LLog.debug.println("Key:"+(String) entry.getKey()+", Value(이상):"+CommonUtil.replaceSecOutput(URLDecoder.decode(strValue, "UTF-8")));
                        data.setString((String) entry.getKey(), LSecurityUtils.clearXSS(CommonUtil.replaceSecOutput(URLDecoder.decode(strValue, "UTF-8")), "", "*"));
                    }
                     */
                    data.put(entry.getKey(), CommonUtil.replaceSecOutput(URLDecoder.decode(strValue, "EUC-KR")));
                }catch (Exception e){

                }
                //                try {
                //                    data.setString(strKey, URLDecoder.decode(strValue, "UTF-8"));
                //                } catch (UnsupportedEncodingException e) {
                //                    e.printStackTrace();
                //                }
            }
        }

        Iterator iter2 = data.entrySet().iterator();
        while (iter2.hasNext()) {
            Map.Entry entry = (Map.Entry) iter2.next();

            String strKey  =  (String) entry.getKey();
            String strValue = (String) entry.getValue();

            if(strValue == null || strValue.equals("")) {
                data.put(entry.getKey(), "");
            } else {
                try{
                    /*
                    if(LSecurityUtils.verifyXSS(CommonUtil.replaceSecOutput(URLDecoder.decode(strValue, "UTF-8")), "", "*")){
                        //LLog.debug.println("Key:"+(String) entry.getKey()+", Value(이상없음):"+CommonUtil.replaceSecOutput(URLDecoder.decode(strValue, "UTF-8")));
                        data.put((String) entry.getKey(), CommonUtil.replaceSecOutput(URLDecoder.decode(strValue, "UTF-8")));
                    }else{
                        //LLog.debug.println("Key:"+(String) entry.getKey()+", Value(이상):"+CommonUtil.replaceSecOutput(URLDecoder.decode(strValue, "UTF-8")));
                        data.setString((String) entry.getKey(), LSecurityUtils.clearXSS(CommonUtil.replaceSecOutput(URLDecoder.decode(strValue, "UTF-8")), "", "*"));
                    }
                     */
                    data.put(entry.getKey(), CommonUtil.replaceSecOutput(URLDecoder.decode(strValue, "EUC-KR")));
                }catch (Exception e){

                }
                //                try {
                //                    data.setString(strKey, URLDecoder.decode(strValue, "UTF-8"));
                //                } catch (UnsupportedEncodingException e) {
                //                    e.printStackTrace();
                //                }
            }
        }

        return data;
        //--------------------------------------------- EUC-KR Decoding END
    }


    /**
     * HashMap의 데이타를 String 형태로 변경한다. ( 예: BigDecimal을 String 으로 변경 )
     * @param HashMap
     * @return HashMap<String,String>
     */
    public static HashMap convertStingHashMap(HashMap dataMap) {
        try {
            Iterator iterbatchSet = dataMap.entrySet().iterator();
            while (iterbatchSet.hasNext()) {
                Map.Entry entry = (Map.Entry) iterbatchSet.next();
                dataMap.put( String.valueOf( entry.getKey()), String.valueOf( entry.getValue() ) );
            }
        } catch(Exception e){}

        return dataMap;
    }

    
}

