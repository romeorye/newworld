package iris.web.common.util;

import java.net.URLDecoder;
import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.TimeZone;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.lgcns.encypt.EncryptUtil;

public class CommonUtil {
    static final Logger LOGGER = LogManager.getLogger(CommonUtil.class);
    /**
     * null인지 체크하여 null이면 "" return
     */
    public static String nullToString(String str) {
        if (str == null) {
            return "";
        } else {
            return str;
        }
    }
    public static String nullToString(Object obj) {
        if (obj == null) {
            return "";
        } else {
            return String.valueOf(obj);
        }
    }

    /**
     * DB에 저장하기 위해 해당 문자열 중 특정 문자열을 치환한다.
     *
     * 사용예) replaceSecInput("&<>#\'" )
     * 결과) &amp;&lt;&gt;&#35;&quot;&#39;
     */
    public static String replaceSecInput(String str) {

        if (str == null || str.equals("")) return "";

        String result = str;
        result = replace(result, "&",  "&amp;");
        result = replace(result, "<",  "&lt;");
        result = replace(result, ">",  "&gt;");
        result = replace(result, "#",  "&#35;");
        result = replace(result, "\"", "&quot;");
        result = replace(result, "'",  "&#39;");
        result = replace(result, "(",  "&#40;");
        result = replace(result, ")",  "&#41;");
        result = replace(result, "/",  "&#47;");
        result = replace(result, "\\", "&#92;");
        result = replace(result, ":",  "&#59;");
        result = replace(result, "\n", "<br>");
        result = replace(result, "•", "&#8226;");


        return result;
    }

    /**
     * DB에 저장된 해당 문자열 중 특정 문자열로 치환한다.
     *
     * 사용예) replaceSecOutput("&<>#\'" )
     * 결과) &amp;&lt;&gt;&#35;&quot;&#39;
     */
    public static String replaceSecOutput(String str) {

        if (str == null || str.equals("")) return "";

        String result = str;
        result = replace(result, "&amp;",  "&");
        result = replace(result, "&lt;",   "<");
        result = replace(result, "&gt;",   ">");
        result = replace(result, "&#35;",  "#");
        result = replace(result, "&quot;", "\"");
        result = replace(result, "&#39;",  "'");
        result = replace(result, "&#40;",  "(");
        result = replace(result, "&#41;",  ")");
        result = replace(result, "&#47;",  "/");
        result = replace(result, "&#92;",  "\\");
        result = replace(result, "&#59;",  ":");
        result = replace(result, "<br>",   "\r");
        result = replace(result, "{@",  "<");
        result = replace(result, "@}",  ">");
        result = replace(result, "&#8226;",  "•");

        return result;
    }

    /**
     * DB에 저장하기 위해 해당 문자열 중 특정 문자열을 치환한다.( br제외)
     *
     * 사용예) replaceSecInput("&<>#\'" )
     * 결과) &amp;&lt;&gt;&#35;&quot;&#39;
     */
    public static String replaceSecInput2(String str) {

        if (str == null || str.equals("")) return "";

        String result = str;
        result = replace(result, "&",  "&amp;");
        result = replace(result, "<",  "&lt;");
        result = replace(result, ">",  "&gt;");
        result = replace(result, "#",  "&#35;");
        result = replace(result, "\"", "&quot;");
        result = replace(result, "'",  "&#39;");
        result = replace(result, "(",  "&#40;");
        result = replace(result, ")",  "&#41;");
        result = replace(result, "/",  "&#47;");
        result = replace(result, "\\", "&#92;");
        result = replace(result, ":",  "&#59;");
        //result = replace(result, "\n", "<br>");
        result = replace(result, "•", "&#8226;");

        return result;
    }

    /**
     * DB에 저장된 해당 문자열 중 특정 문자열로 치환한다. ( br제외)
     *
     * 사용예) replaceSecOutput("&<>#\'" )
     * 결과) &amp;&lt;&gt;&#35;&quot;&#39;
     */
    public static String replaceSecOutput2(String str) {

        if (str == null || str.equals("")) return "";

        String result = str;
        result = replace(result, "&amp;",  "&");
        result = replace(result, "&lt;",   "<");
        result = replace(result, "&gt;",   ">");
        result = replace(result, "&#35;",  "#");
        result = replace(result, "&quot;", "\"");
        result = replace(result, "&#39;",  "'");
        result = replace(result, "&#40;",  "(");
        result = replace(result, "&#41;",  ")");
        result = replace(result, "&#47;",  "/");
        result = replace(result, "&#92;",  "\\");
        result = replace(result, "&#59;",  ":");
        //result = replace(result, "<br>",   "\r");
        result = replace(result, "{@",  "<");
        result = replace(result, "@}",  ">");
        result = replace(result, "&#8226;",  "•");
        result = replace(result, "&#9656;", "▸");
        result = replace(result, "&#8228;", "․");
        result = replace(result, "&#37;",  "%");

        return result;
    }
    /**
     * DB에 저장하기 위해 해당 문자열 중 특정 문자열을 치환한다.
     *
     * 사용예) replaceSecInput("&<>#\'" )
     * 결과) &amp;&lt;&gt;&#35;&quot;&#39;
     */
    public static String replaceSecInput3(String str) {

        if (str == null || str.equals("")) return "";

        String result = str;

        result = replace(result, "•", "&#8226;");
        result = replace(result, "▸", "&#9656;");
        result = replace(result, "<",  "&lt;");
        result = replace(result, ">",  "&gt;");
        result = replace(result, "․",  "&#8228;");
        result = replace(result, "%",  "&#37;");

        return result;
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
     * System date를 YYYYMMDD 형태로 리턴
     */
    public static String getSystemDate() {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
        Date currentDate = new Date();
        String date = formatter.format(currentDate);
        return date;
    }

    /**
     * YYYYMMDDHHMMSS 형태로 리턴
     * 예) 20000427210948
     * @return
     */
    public static String getDateTimeSec() {
        GregorianCalendar cal = new GregorianCalendar();
        StringBuffer date = new StringBuffer();

        date.append(cal.get(1));
        if (cal.get(2) < 9) date.append("0");
        date.append(cal.get(2) + 1);
        if (cal.get(5) < 10) date.append("0");
        date.append(cal.get(5));
        if (cal.get(11) < 10) date.append("0");
        date.append(cal.get(11));
        if (cal.get(12) < 10) date.append("0");
        date.append(cal.get(12));
        if (cal.get(13) < 10) date.append("0");
        date.append(cal.get(13));

        return date.toString();
    }

    /**
     * 입력된 문자열을 지정된 문자를 삽입해 날짜 표현 형식으로 돌려준다.
     *
     * 사용예) getFormattedDate("20060310", "-")
     * 결과)  2006-03-10
     */
    public static String getFormattedDate(String sInDate, String sChar) {
        String sOutDate = "";

        if (sInDate == null || sInDate.equals("")) return sOutDate;
        if (sInDate.length() < 6) return sInDate;
        if (sInDate.length() > 8) sInDate = sInDate.substring(0,8);

        StringBuffer newDate = new StringBuffer(sInDate);
        if (sInDate.length() == 8) newDate.insert(6, sChar);
        newDate.insert(4, sChar);
        sOutDate = newDate.toString();

        return sOutDate;
    }

    /**
     * 입력된 문자열을 지정된 문자를 삽입해 날짜 표현 형식으로 돌려준다.
     *
     * 사용예) getFormattedDate("20070123140410", "-")
     * 결과)  2007-01-23 14:04:10
     */
    public static String getFormattedDateTime(String sInDate, String sChar) {
        String sOutDateTime = "";

        if (sInDate == null || sInDate.equals("")) return sOutDateTime;
        if (sInDate.length() < 14) return sInDate;

        StringBuffer newDate = new StringBuffer(sInDate.substring(0,8));
        newDate.insert(6, sChar);
        newDate.insert(4, sChar);
        sOutDateTime = newDate.toString();

        StringBuffer newTime = new StringBuffer(sInDate.substring(8));
        newTime.insert(4, ":");
        newTime.insert(2, ":");
        sOutDateTime = sOutDateTime + " " + newTime.toString();

        return sOutDateTime;
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
     * 문자열을 start부터 iLen만큼 잘라서 String으로 반환한다.
     * byte로 변환하여 한글이 잘리면 iLen-1로 하여 String로 반환한다.
     */
    public static String getSubString(String inStr, int start, int iLen) {
        String outStr = "";

        if (inStr == null ||
                inStr.trim().equals("") ||
                inStr.trim().equalsIgnoreCase("NULL")) {
            return outStr;
        }

        byte[] bStr = inStr.getBytes();
        if (bStr.length <= iLen) return inStr;
        if ((bStr.length - start) <= iLen) iLen = bStr.length - start;

        byte newbyte[] = new byte[iLen];

        int k = 0;
        for (int i = 0; i < iLen; i++) {
            if (bStr[i] < 0) k++;
        }
        if (k % 2 == 1) iLen--;

        System.arraycopy(bStr, start, newbyte, 0, iLen);

        outStr = new String(newbyte);

        return outStr;
    }

    /**
     * Clob를 String으로 변환하여 반환한다.
     *
     * @param clob
     * @return String
     */
    /*
    public static String getClobToString(Clob clob) {
        StringBuffer sb = new StringBuffer();

        if (clob == null) return "";

        try {
            Reader rd = clob.getCharacterStream();

            char[] buf = new char[1024];
            int readcnt;

            while ((readcnt = rd.read(buf, 0, 1024)) != -1) {
                sb.append(buf, 0, readcnt);
            }

            rd.close();

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return sb.toString();
    }
     */

    /**
     * 대상문자열(strTarget)에서 구분문자열(strDelim)을 기준으로 문자열을 분리하여
     * 각 분리된 문자열을 배열에 할당하여 반환한다.
     *
     * @param strTarget 분리 대상 문자열
     * @param strDelim 구분시킬 문자열로서 결과 문자열에는 포함되지 않는다.
     * @param bContainNull 구분되어진 문자열중 공백문자열의 포함여부.
     *                     true : 포함, false : 포함하지 않음.
     * @return 분리된 문자열을 순서대로 배열에 격납하여 반환한다.
     * @exception   LException
     */
    public static String[] split(String strTarget
            , String strDelim
            , boolean bContainNull) throws Exception {

        // StringTokenizer는 구분자가 연속으로 중첩되어 있을 경우 공백 문자열을 반환하지 않음.
        // 따라서 아래와 같이 작성함.
        int index = 0;
        String[] resultStrArray = null ;

        try {
            resultStrArray = new String[search(strTarget,strDelim)+1];
            String strCheck = new String(strTarget);

            while (strCheck.length() != 0) {
                int begin = strCheck.indexOf(strDelim);
                if (begin == -1) {
                    resultStrArray[index] = strCheck;
                    break;
                } else {
                    int end = begin + strDelim.length();
                    if (bContainNull) {
                        resultStrArray[index++] = strCheck.substring(0, begin);
                    }

                    strCheck = strCheck.substring(end);
                    if (strCheck.length() == 0 && bContainNull) {
                        resultStrArray[index] = strCheck;
                        break;
                    }
                }
            }
        } catch (Exception e) {
            throw new Exception("[CommonUtil.split()]" + e.getMessage(), e);
        }

        return resultStrArray;
    }

    /**
     * 대상문자열(strTarget)에서 지정문자열(strSearch)이 검색된 횟수를,
     * 지정문자열이 없으면 0 을 반환한다.
     *
     * @param strTarget 대상문자열
     * @param strSearch 검색할 문자열
     * @return 지정문자열이 검색되었으면 검색된 횟수를, 검색되지 않았으면 0 을 반환한다.
     * @exception   LException
     */
    public static int search(String strTarget, String strSearch) throws Exception {
        int result = 0;

        try {
            String strCheck = new String(strTarget);
            for (int i = 0; i < strTarget.length(); ) {
                int loc = strCheck.indexOf(strSearch);
                if (loc == -1) {
                    break;
                } else {
                    result++;
                    i = loc + strSearch.length();
                    strCheck = strCheck.substring(i);
                }
            }
        } catch (Exception e) {
            throw new Exception("[CommonUtil.search()]" + e.getMessage(), e);
        }

        return result;
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
     * ID encode(암호화)
     *
     * @param id
     * @param key
     * @return
     */
    public static String setEncodeID(String id, int encodedKey) {
        try {
            byte[] new_byte = id.getBytes("US-ASCII");
            String encodedId = "";

            for (int i = 0; i < id.length(); i++) {
                encodedId = (new_byte[i]-encodedKey) + encodedId;
            }

            return encodedId;
        } catch (Exception e) {
            return "error";
        }
    }

    /**
     * encoded ID 가져오기
     *
     * @param encodedId
     * @param key
     * @return
     */
    public static String getDecodeID(String encodedId, int encodedKey) {
        try {
            String conv_id = "";

            byte temp[] = new byte[encodedId.length()/2];

            int k = 0;

            for (int j = encodedId.length(); j > 0; j = j-2) {
                temp[k] = Byte.parseByte(Integer.toString(Integer.parseInt(encodedId.substring(j-2,j)) + encodedKey));
                k++;
            }

            conv_id = new String(temp);

            return conv_id;
        } catch (Exception e) {
            return "error";
        }
    }

    /**
     * 해당월로 부터 3개월 전
     *
     * @param date
     * @return
     */
    public static String  getMonthSerch(String date) {


        int year = Integer.parseInt(date.substring(0,4));
        int month = Integer.parseInt(date.substring(4,6));

        if( month==1 ){
            year = year - 1;
            month = 10;
            date = "" + year + "" + month;
        }else if( month==2 ){
            year = year - 1;
            month = 11;
            date = "" + year + "" + month;
        }else if( month==3 ){
            year = year - 1;
            month = 12;
            date = "" + year + "" + month;
        }else if( month==4 ){
            month = 1;
            date = "" + year + "0" + month;
        }else if( month==5 ){
            month = 2;
            date = "" + year + "0" + month;
        }else if( month==6 ){
            month = 3;
            date = "" + year + "0" + month;
        }else if( month==7 ){
            month = 4;
            date = "" + year + "0" + month;
        }else if( month==8 ){
            month = 5;
            date = "" + year + "0" + month;
        }else if( month==9 ){
            month = 6;
            date = "" + year + "0" + month;
        }else if( month==10 ){
            month = 7;
            date = "" + year + "0" + month;
        }else if( month==11 ){
            month = 8;
            date = "" + year + "0" + month;
        }else if( month==12 ){
            month = 9;
            date = "" + year + "0" + month;
        }

        return date;
    }

    /**
     * 해당월로 부터 1개월 전
     *
     * @param date
     * @return
     */
    public static String  getMonthSearch_1(String date) {


        int year = Integer.parseInt(date.substring(0,4));
        int month = Integer.parseInt(date.substring(4,6));

        if( month==1 ){
            year = year - 1;
            month = 12;
            date = "" + year + "" + month;
        }else if( month==2 ){
            month = 1;
            date = "" + year + "0" + month;
        }else if( month==3 ){
            month = 2;
            date = "" + year + "0" + month;
        }else if( month==4 ){
            month = 3;
            date = "" + year + "0" + month;
        }else if( month==5 ){
            month = 4;
            date = "" + year + "0" + month;
        }else if( month==6 ){
            month = 5;
            date = "" + year + "0" + month;
        }else if( month==7 ){
            month = 6;
            date = "" + year + "0" + month;
        }else if( month==8 ){
            month = 7;
            date = "" + year + "0" + month;
        }else if( month==9 ){
            month = 8;
            date = "" + year + "0" + month;
        }else if( month==10 ){
            month = 9;
            date = "" + year + "0" + month;
        }else if( month==11 ){
            month = 10;
            date = "" + year + "" + month;
        }else if( month==12 ){
            month = 11;
            date = "" + year + "" + month;
        }
        return date;
    }
    /**
     * 2008.11.07
     * 입력받은 String 을 len 만큼 분할하기.
     * 분할 위치에 2byte문자일 경우 -1 하여 처리.
     * @param str
     * @param len
     * @return
     */
    public static Vector divContent(String str, int len) {
        int slen = 0;
        int elen = 0;
        int blen = 0;
        int idx = 1;
        Vector v = new Vector();

        try {
            int tcnt = str.getBytes().length / len;
            if ((str.getBytes().length % len) > 0) tcnt++;
            if (str.getBytes().length < len) slen = str.length();
            if ((len % 2) == 0) len = len - 1;
            String tmp = "";
            char c;
            for (int j = 0; j < tcnt; j++) {
                if (slen == str.length() - 1) {
                    break;
                } else if (slen > str.length() - 1) {
                    tmp=str.substring(elen, str.length()-1);
                    //System.out.println(tmp.getBytes().length);
                    v.addElement(tmp);
                } else {
                    while (blen+1 < (len*idx)) {
                        if (blen+1 == str.getBytes().length) {
                            slen = str.length();
                            break;
                        }
                        c = str.charAt(slen);
                        blen++;
                        slen++;
                        if( c  > 127 ) blen++;  //2-byte character..
                    }
                    tmp=str.substring(elen,slen);
                    //System.out.println(tmp.getBytes().length);
                    v.addElement(tmp);
                }
                elen = slen;
                idx++;
            }
        } catch(Exception e) {}

        return v;
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
     * HTML Stripper
     *
     * @param html
     * @return
     */
    public static String stripHTML(String html) {
        String pattern = "<(?:.|\\s)*?>";
        return getRegexResult( html, pattern );
    }

    /**
     * 정규식표현 결과 리턴
     *
     * @param str
     * @param pattern
     * @return
     */
    public static String getRegexResult(String str, String pattern) {
        Pattern p = Pattern.compile(pattern);
        Matcher m = p.matcher(str);
        return m.replaceAll("");
    }

    /**
     * 확장자 체크
     *
     */
    public static Boolean getExtension(String fileNm) {
        String ext = fileNm.substring(fileNm.lastIndexOf(".") + 1, fileNm.length());
        boolean bln  = true;

        String [] etssArry = {"jpg","bmp","png","gif","tiff","tif","jpeg", "rle"};

        for(int i=0; i < etssArry.length; i++){
            if(etssArry[i].equals(ext.toLowerCase())){
                bln = false;
                break;
            }
        }
        return bln;
    }


    /**
     * 지재권(지적 재산권) 사번 인코딩
     *
     */
    public static String encode(byte[] raw) {
		  StringBuffer encoded = new StringBuffer();
		  for (int i = 0; i < raw.length; i += 3) {
		   encoded.append(encodeBlock(raw, i));
		  }
		  return encoded.toString();
		 }

	 protected static char[] encodeBlock(byte[] raw, int offset) {
		  int block = 0;
		  int slack = raw.length - offset - 1;
		  int end = (slack >= 2) ? 2 : slack;
		  for (int i = 0; i <= end; i++) {
		   byte b = raw[offset + i];
		   int neuter = (b < 0) ? b + 256 : b;
		   block += neuter << (8 * (2 - i));
		  }
		  char[] sec = new char[4];
		  for (int i = 0; i < 4; i++) {
		   int sixbit = (block >>> (6 * (3 - i))) & 0x3f;
		   sec[i] = getChar(sixbit);
		  }
		  if (slack < 1) sec[2] = '=';
		  if (slack < 2) sec[3] = '=';
		  return sec;
	 }

	 protected static char getChar(int sixBit) {
		  if (sixBit >= 0 && sixBit <= 25)
		   return (char)('A' + sixBit);
		  if (sixBit >= 26 && sixBit <= 51)
		   return (char)('a' + (sixBit - 26));
		  if (sixBit >= 52 && sixBit <= 61)
		   return (char)('0' + (sixBit - 52));
		  if (sixBit == 62) return '+';
		  if (sixBit == 63) return '/';
		   return '?';
	 }

    /**
     *  String Object 변환
      * @param map
     * @return
     */
    public static Map<String,Object> mapToObj(Map<String,String>map){
        Map<String, Object> result = new HashMap<>();

        Iterator<String> keys = map.keySet().iterator();
        while (keys.hasNext()) {
            String key = keys.next();
            result.put(key, map.get(key));
        }
        return result;
    }

    /**
     * Object String 변환
     * @param map
     * @return
     */
    public static HashMap<String,String> mapToString(Map<String,Object>map){
        HashMap<String, String> result = new HashMap<>();

        Iterator<String> keys = map.keySet().iterator();
        while (keys.hasNext()) {
            String key = keys.next();
            result.put(key, (String) map.get(key));
        }
        return result;
    }

    public static String getCookieSabun(String sabun) throws Exception  {
        
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        TimeZone jst = TimeZone.getTimeZone ("GMT+0");
        java.util.Calendar cal = java.util.Calendar.getInstance ( jst );
        sdf.setTimeZone(cal.getTimeZone());
        
        String str = sdf.format(cal.getTime());
		String encryptEmpNo = EncryptUtil.encryptText(str + "|" + "00203502"); 
		
		return encryptEmpNo;
	}
    
    public static String getCookieSsoUserId(HttpServletRequest req) throws Exception  {
	    Cookie[] cookies = req.getCookies();
		String descramblingKey = "amZrbGRzYWpmO2tk";
		
		String sabun ="";
		//G-Portal (Tip-Top 2.0)
		for(int i = 0 ; i < cookies.length ; i++) {
		  javax.servlet.http.Cookie cookie = cookies[i];
		  
		  if(cookie.getName().equals("URLENCODED_LG_GP_SI")) {
			   String encUid = URLDecoder.decode(cookie.getValue(), "UTF-8");
			   String plainUid = com.lgcns.encypt.EncryptUtil.decryptText(encUid, descramblingKey);
			   
			   sabun = plainUid ;
			   break;
		  }
		}
		return sabun;
    }
   
		  
}