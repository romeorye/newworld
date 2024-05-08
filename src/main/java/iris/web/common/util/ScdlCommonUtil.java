package iris.web.common.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class ScdlCommonUtil {
    /*
     * 문자열을 Date형으로 변환
     */
    public static Date strToDate(String str) {
        if(str.indexOf("-") > -1) {
            str = str.replaceAll("-", "");
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        Date d = new Date();
        try {
            d = sdf.parse(str);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return d;
    }
    
    
    /*
     * Date형을 문자열로 변환
     */
    public static String dateToStr(Date d) {
        String str = "";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        str = sdf.format(d);
        return str;
    }
    
    /*
     * 문자열을 연월일 문자열로 변환
     * ex) 20120123 -> 2012년 1월 23일
     */
    public static String strToDateStr(String str) {
        if(str.indexOf("-") > -1) {
            str = str.replaceAll("-", "");
        }
        String formattedStr = str;
        try {
            formattedStr = str.substring(0, 4) + "년 "
                        + Integer.valueOf(str.substring(4, 6)) + "월 "
                        + Integer.valueOf(str.substring(6, 8)) + "일";
        } catch (Exception e) {
            e.printStackTrace();
        }
        return formattedStr;
    }
    
    /*
     * 날짜 더하기
     */
    public static String addDate(String d, int days) {
        return dateToStr(addDate(strToDate(d), days));
    }

    /*
     * 날짜 더하기
     */
    public static Date addDate(Date d, int days) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(d);
        cal.add(Calendar.DATE, days);
        return cal.getTime();
    }
    
    /*
     * 오늘 날짜 구함
     * return Date
     */
    public static Date getToday() {
        Calendar cal = Calendar.getInstance();
        return cal.getTime();
    }
    
    /*
     * 오늘 날짜 구함
     * return String
     */
    public static String getTodayStr() {
        return dateToStr(getToday());
    }
    
    /*
     * 스케줄 등록 가능한 날짜인지 체크
     * return boolean
     */
    public static boolean canSetSchedule(String baseDate, int limitPeriod) {
        String limitDate = addDate(getTodayStr(), limitPeriod);
        baseDate = baseDate.replaceAll("-", "");
        return (baseDate.compareTo(limitDate) >= 0);
    }
    
    /*
     * 스케줄 등록 가능한 날짜인지 체크
     * return boolean
     */
    public static boolean canSetSchedule(Date baseDate, int limitPeriod) {
        String baseDateStr = dateToStr(baseDate);
        String limitDate = addDate(getTodayStr(), limitPeriod);
        return (baseDateStr.compareTo(limitDate) >= 0);
    }
}
