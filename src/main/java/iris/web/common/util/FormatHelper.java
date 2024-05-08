package iris.web.common.util;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class FormatHelper {
    private static NumberFormat nf = NumberFormat.getInstance(Locale.KOREAN);
    private static final int MAX_SCALE = 4;

    public static String strNum(double number) {
        nf.setMaximumFractionDigits(MAX_SCALE);
        return nf.format(number);
    }

    public static String strNum(double str, String format) throws Exception {
        NumberFormat df = new java.text.DecimalFormat(format);
        return df.format(str);
    }

    public static String strNum(float number) {
        nf.setMaximumFractionDigits(MAX_SCALE);
        return nf.format(number);
    }

    public static String strNum(float str, String format) throws Exception {
        return strNum(String.valueOf(str), format);
    }

    public static String strNum(int number) {
        nf.setMaximumFractionDigits(MAX_SCALE);
        return nf.format(number);
    }

    public static String strNum(int str, String format) throws Exception {
        return strNum(String.valueOf(str), format);
    }

    public static String strNum(long number) {
        nf.setMaximumFractionDigits(MAX_SCALE);
        return nf.format(number);
    }

    public static String strNum(long str, String format) throws Exception {
        return strNum(String.valueOf(str), format);
    }

    public static String strNum(String number) {
        if (number == null || number.trim().equals("")) {
            return "0";
        }
        nf.setMaximumFractionDigits(MAX_SCALE);
        return nf.format(Double.parseDouble(number));
    }

    public static String strNum(String str, String format) throws Exception {
        try {
            if (str == null || str.trim().equals("")) {
                str = "0";
            }
            return strNum(new java.math.BigDecimal(str).doubleValue(), format);
        } catch (Exception e) {
            throw e;
        }
    }

    public static String strDate(int iyyyymmdd, String separator) {
        String yyyymmdd = String.valueOf(iyyyymmdd);

        if (yyyymmdd.length() == 6) {
            return yyyymmdd.substring(0, 4) + separator + yyyymmdd.substring(4, 6);
        } else if (yyyymmdd.length() == 8) {
            return yyyymmdd.substring(0, 4) + separator + yyyymmdd.substring(4, 6) + separator + yyyymmdd.substring(6, 8);
        } else {
            return yyyymmdd;
        }
    }

    public static String strDate(long lyyyymmdd, String separator) {
        String yyyymmdd = String.valueOf(lyyyymmdd);
        if (yyyymmdd.length() == 6) {
            return yyyymmdd.substring(0, 4) + separator + yyyymmdd.substring(4, 6);
        } else if (yyyymmdd.length() == 8) {
            return yyyymmdd.substring(0, 4) + separator + yyyymmdd.substring(4, 6) + separator + yyyymmdd.substring(6, 8);
        } else {
            return yyyymmdd;
        }
    }

    public static String strDate(Date dyyyymmdd, String separator) {
        String yyyymmdd = String.valueOf(dyyyymmdd);

        if (yyyymmdd.length() == 10) {
            return yyyymmdd.substring(0, 4) + separator + yyyymmdd.substring(5, 7) + separator + yyyymmdd.substring(8, 10);
        } else {
            return yyyymmdd;
        }
    }

    public static String strDate(String sdate) {
        return getStrDate(sdate, "yyyy-MM-dd");
    }

    public static String strDate(String year, String month, String day) {
        Calendar date = Calendar.getInstance();
        date.set(new Integer(year).intValue(), new Integer(month).intValue() - 1, new Integer(day).intValue());
        SimpleDateFormat simpleDate = new SimpleDateFormat("yyyy-MM-dd");
        return simpleDate.format(date.getTime());
    }

    public static String strDate(String sdate, String separator) {
        return getStrDate(sdate, "yyyy" + separator + "MM" + separator + "dd");
    }

    public static String strYear(String sdate) {
        return getStrDate(sdate, "yyyy");
    }

    public static String strMonth(String sdate) {
        return getStrDate(sdate, "MM");
    }

    public static String strDay(String sdate) {
        return getStrDate(sdate, "dd");
    }

    public static String strDayW(String sdate) {
        return getStrDate(sdate, "E");
    }

    public static String strHour(String sdate) {
        return getStrDate(sdate, "HH");
    }

    public static String strMinute(String sdate) {
        return getStrDate(sdate, "mm");
    }

    public static String strDateTime(String sdate) {
        return getStrDate(sdate, "yyyy-MM-dd HH:mm");
    }

    public static String strTime(String sdate) {
        return getStrDate(sdate, "HH:mm");
    }

    public static String curDate() {
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat simpleDate = new SimpleDateFormat("yyyy-MM-dd");
        return simpleDate.format(cal.getTime());
    }

    public static String curDateAnotherFormat() {
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat simpleDate = new SimpleDateFormat("yyyyMMddHHmmss");
        return simpleDate.format(cal.getTime());
    }
    
    public static String lstDate() {
        String curDate = curDate();
        return calDate(strYear(curDate), 0, strMonth(curDate), 1, "01", -1);
    }

    public static String curTime() {
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat simpleDate = new SimpleDateFormat("HH:mm:ss");
        return simpleDate.format(cal.getTime());
    }

    public static String curDateTime() {
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat simpleDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return simpleDate.format(cal.getTime());
    }

    public static String fDayW(String sdate) {
        Calendar cal = Calendar.getInstance();
        cal.set(Integer.parseInt(strYear(sdate)), Integer.parseInt(strMonth(sdate)) - 1, Integer.parseInt(strDay(sdate)));
        return calDate(sdate, "d", cal.get(Calendar.DAY_OF_WEEK) * -1 + 2);
    }

    public static String lDayW(String sdate) {
        Calendar cal = Calendar.getInstance();
        cal.set(Integer.parseInt(strYear(sdate)), Integer.parseInt(strMonth(sdate)) - 1, Integer.parseInt(strDay(sdate)));
        return calDate(sdate, "d", 7 - cal.get(Calendar.DAY_OF_WEEK) + 1);
    }

    public static String calDate(String sdate, String filter, int val) {
        int y = Integer.parseInt(strYear(sdate));
        int m = Integer.parseInt(strMonth(sdate));
        int d = Integer.parseInt(strDay(sdate));

        if (filter.equals("Y") || filter.equals("y")) {
            y = y + val;
        } else if (filter.equals("M") || filter.equals("m")) {
            m = m + val;
        } else if (filter.equals("D") || filter.equals("d")) {
            d = d + val;
        }

        Calendar date = Calendar.getInstance();
        date.set(y, m - 1, d);
        SimpleDateFormat simpleDate = new SimpleDateFormat("yyyy-MM-dd");
        return simpleDate.format(date.getTime());
    }

    public static String calDate(String year, int y, String month, int m, String day, int d) {
        Calendar date = Calendar.getInstance();
        date.set(Integer.parseInt(year) + y, Integer.parseInt(month) + m - 1, Integer.parseInt(day) + d);
        SimpleDateFormat simpleDate = new SimpleDateFormat("yyyy-MM-dd");
        return simpleDate.format(date.getTime());
    }

    public static String getStrDate(long ldate, String format) {
        Date date = new Date(ldate);
        SimpleDateFormat simpleDate = new SimpleDateFormat(format);
        return simpleDate.format(date);
    }

    public static String getStrDate(String sdate, String format) {
        int yy = 0, mm = 0, dd = 0, hh = 0, mi = 0, si = 0;
        try {
            sdate = StringUtil.replace(sdate, "-", "");
            sdate = StringUtil.replace(sdate, "/", "");
            sdate = StringUtil.replace(sdate, ":", "");
            sdate = StringUtil.replace(sdate, " ", "");
            sdate = sdate.trim();
            if (sdate.length() == 6) {
                return toMask(sdate, "9999-99");
            } else if (sdate.length() >= 8) {
                yy = Integer.parseInt(sdate.substring(0, 4));
                mm = Integer.parseInt(sdate.substring(4, 6)) - 1;
                dd = Integer.parseInt(sdate.substring(6, 8));
                if (sdate.length() > 8) {
                    hh = Integer.parseInt(sdate.substring(8, 10));
                }
                if (sdate.length() > 10) {
                    mi = Integer.parseInt(sdate.substring(10, 12));
                }
                if (sdate.length() > 12) {
                    si = Integer.parseInt(sdate.substring(12, 14));
                }
            } else {
                return sdate;
            }
        } catch (Exception e) {
            return sdate;
        }
        Calendar date = Calendar.getInstance();
        date.set(yy, mm, dd, hh, mi, si);
        SimpleDateFormat simpleDate = new SimpleDateFormat(format);
        return simpleDate.format(date.getTime());
    }

    public static String toJumin(String value) {
        value = StringUtil.replace(value, "-", "");

        if (value.length() == 10) {
            return value.substring(0, 3) + "-" + value.substring(3, 5) + "-" + value.substring(5, 10);
        } else if (value.length() == 13) {
            return value.substring(0, 6) + "-" + value.substring(6, 13);
        } else {
            return value;
        }
    }

    public static String toJumin2(String value) {
        value = StringUtil.replace(value, "-", "");

        if (value.length() == 10) {
            return value.substring(0, 3) + "-" + value.substring(3, 5) + "-" + value.substring(5, 10);
        } else if (value.length() == 13) {
            return value.substring(0, 6) + "-" + value.substring(6, 7) + "******";
        } else {
            return value;
        }
    }

    public static String toTel(String str) {
        if (str == null || str.trim().equals("")) {
            return "";
        }
        if (str.length() < 3) {
            return str;
        }

        StringBuffer sb = new StringBuffer();
        String mask = "";
        int j = 0;

        str = StringUtil.replace(str, " ", "");
        str = StringUtil.replace(str, "-", "");
        str = StringUtil.replace(str, "(", "");
        str = StringUtil.replace(str, ")", "");

        if (str.substring(0, 2).equals("02")) {
            mask = (str.length() == 9) ? "99-999-9999" : "99-9999-9999";
        } else {
            mask = (str.length() == 10) ? "999-999-9999" : "999-9999-9999";
        }

        for (int i = 0; i < str.length(); i++) {
            sb.append(str.charAt(i));
            j++;
            if (j < mask.length() && "()-".indexOf(mask.charAt(j)) != -1) {
                sb.append(mask.charAt(j++));
            }
        }
        return sb.toString();
    }

    public static String toMask(String str, String mask) {
        if (str == null) {
            return "";
        }

        StringBuffer sb = new StringBuffer();
        int j = 0;

        str = StringUtil.replace(str, " ", "");
        str = StringUtil.replace(str, "-", "");
        str = StringUtil.replace(str, "(", "");
        str = StringUtil.replace(str, ")", "");
        str = StringUtil.replace(str, "/", "");
        str = StringUtil.replace(str, "_", "");
        str = StringUtil.replace(str, ":", "");

        if (str.equals("")) {
            return "";
        }

        for (int i = 0; i < str.length(); i++) {
            sb.append(str.charAt(i));
            j++;
            if (j < mask.length() && ":()-/_ ".indexOf(mask.charAt(j)) != -1) {
                sb.append(mask.charAt(j++));
            }
        }
        return sb.toString();
    }

}