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

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtil {
	
    /**
     * check date string validation with an user defined format.
     *
     * @param s
     *            date string you want to check.
     * @param format
     *            string representation of the date format. For example,
     *            "yyyy-MM-dd".
     * @return date java.util.Date
     */
    private static java.util.Date check(String s, String format)
            throws java.text.ParseException {
        if (s == null)
            throw new java.text.ParseException("date string to check is null",
                    0);
        if (format == null)
            throw new java.text.ParseException(
                    "format string to check date is null", 0);

        java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat(
                format, java.util.Locale.KOREA);
        java.util.Date date = null;
        try {
            date = formatter.parse(s);
        } catch (java.text.ParseException e) {
            /*
             * throw new java.text.ParseException( e.getMessage() + " with
             * format \"" + format + "\"", e.getErrorOffset() );
             */
            throw new java.text.ParseException(" wrong date:\"" + s
                    + "\" with format \"" + format + "\"", 0);
        }

        if (!formatter.format(date).equals(s))
            throw new java.text.ParseException("Out of bound date:\"" + s
                    + "\" with format \"" + format + "\"", 0);
        return date;
    }

	/**
	 * @return formatted string representation of current day with "yyyy-MM-dd".
	 */
	public static String getDateString() {
		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat(
				"yyyy-MM-dd", java.util.Locale.KOREA);
		return formatter.format(new java.util.Date());
	}

	/**
	 * @return formatted string representation of current day with "yyyy-MM-dd".
	 */
	public static String getDateString(String format) {
		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat(
				format, java.util.Locale.KOREA);
		return formatter.format(new java.util.Date());
	}
    
	/**
     * return add day to date strings with user defined format.
     *
     * @param String
     *            date string
     * @param String
     *            더할 일수
     * @param format
     *            string representation of the date format. For example,
     *            "yyyy-MM-dd".
     * @return int 날짜 형식이 맞고, 존재하는 날짜일 때 일수 더하기 형식이 잘못 되었거나 존재하지 않는 날짜:
     *         java.text.ParseException 발생
	 * @throws ParseException 
     * @exception LException
     */
    public static String addDays(String s, int day, String format) throws ParseException{

            java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat(
                    format, java.util.Locale.KOREA);
            java.util.Date date = check(s, format);

            date.setTime(date.getTime() + ((long) day * 1000 * 60 * 60 * 24));
            return formatter.format(date);
        
    }

	/**
	 * return add month to date strings with user defined format.
	 * 
	 * @param String
	 *            date string
	 * @param int
	 *            더할 월수
	 * @param format
	 *            string representation of the date format. For example,
	 *            "yyyy-MM-dd".
	 * @return int 날짜 형식이 맞고, 존재하는 날짜일 때 월수 더하기 형식이 잘못 되었거나 존재하지 않는 날짜:
	 *         java.text.ParseException 발생
	 */
	public static String addMonths(String s, int addMonth, String format)
			throws Exception {
		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat(
				format, java.util.Locale.KOREA);
		java.util.Date date = check(s, format);

		java.text.SimpleDateFormat yearFormat = new java.text.SimpleDateFormat(
				"yyyy", java.util.Locale.KOREA);
		java.text.SimpleDateFormat monthFormat = new java.text.SimpleDateFormat(
				"MM", java.util.Locale.KOREA);
		java.text.SimpleDateFormat dayFormat = new java.text.SimpleDateFormat(
				"dd", java.util.Locale.KOREA);
		int year = Integer.parseInt(yearFormat.format(date));
		int month = Integer.parseInt(monthFormat.format(date));
		int day = Integer.parseInt(dayFormat.format(date));

		month += addMonth;
		if (addMonth > 0) {
			while (month > 12) {
				month -= 12;
				year += 1;
			}
		} else {
			while (month <= 0) {
				month += 12;
				year -= 1;
			}
		}
		java.text.DecimalFormat fourDf = new java.text.DecimalFormat("0000");
		java.text.DecimalFormat twoDf = new java.text.DecimalFormat("00");
		String tempDate = String.valueOf(fourDf.format(year))
				+ String.valueOf(twoDf.format(month))
				+ String.valueOf(twoDf.format(day));
		java.util.Date targetDate = null;

		try {
			targetDate = check(tempDate, "yyyyMMdd");
		} catch (java.text.ParseException pe) {
			day = lastDay(year, month);
			tempDate = String.valueOf(fourDf.format(year))
					+ String.valueOf(twoDf.format(month))
					+ String.valueOf(twoDf.format(day));
			targetDate = check(tempDate, "yyyyMMdd");
		}

		return formatter.format(targetDate);
	}

	private static int lastDay(int year, int month)
			throws java.text.ParseException {
		int day = 0;
		switch (month) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			day = 31;
			break;
		case 2:
			if ((year % 4) == 0) {
				if ((year % 100) == 0 && (year % 400) != 0) {
					day = 28;
				} else {
					day = 29;
				}
			} else {
				day = 28;
			}
			break;
		default:
			day = 30;
		}
		return day;
	}
    
	public static long diffOfDate(String begin, String end)
	{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
		
		long diffDays = 0;
		
		Date beginDate;
		try {
			beginDate = formatter.parse(begin);
			Date endDate = formatter.parse(end);
			
			long diff = endDate.getTime() - beginDate.getTime();
			diffDays = diff / (24 * 60 * 60 * 1000);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return diffDays;
	}

	/**
	 * return days between two date strings with user defined format.
	 * 
	 * @param s
	 *            date string you want to check.
	 * @param format
	 *            string representation of the date format. For example,
	 *            "yyyy-MM-dd".
	 * @return int 날짜 형식이 맞고, 존재하는 날짜일 때 요일을 리턴 형식이 잘못 되었거나 존재하지 않는 날짜:
	 *         java.text.ParseException 발생 
	 *         0: 일요일 (java.util.Calendar.SUNDAY 와 비교)
	 *         1: 월요일 (java.util.Calendar.MONDAY 와 비교)
	 *         2: 화요일 (java.util.Calendar.TUESDAY 와 비교)
	 *         3: 수요일 (java.util.Calendar.WENDESDAY 와 비교)
	 *         4: 목요일 (java.util.Calendar.THURSDAY 와 비교)
	 *         5: 금요일 (java.util.Calendar.FRIDAY 와 비교)
	 *         6: 토요일 (java.util.Calendar.SATURDAY 와 비교)
	 *         예) String s = "2000-05-29";
	 *         int dayOfWeek = whichDay(s, "yyyy-MM-dd");
	 *         if (dayOfWeek == java.util.Calendar.MONDAY) System.out.println(" 월요일: " + dayOfWeek);
	 *         if (dayOfWeek == java.util.Calendar.TUESDAY) System.out.println(" 화요일: " + dayOfWeek);
	 */
	public static int whichDay(String s, String format)
			throws java.text.ParseException {
		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat(
				format, java.util.Locale.KOREA);
		java.util.Date date = check(s, format);

		java.util.Calendar calendar = formatter.getCalendar();
		calendar.setTime(date);
		return calendar.get(java.util.Calendar.DAY_OF_WEEK);
	}

	/**
	 * return days between two date strings with user defined format.
	 * 
	 * @param String
	 *            from date string
	 * @param String
	 *            to date string
	 * @return int 날짜 형식이 맞고, 존재하는 날짜일 때 2개 일자 사이의 일자 리턴 형식이 잘못 되었거나 존재하지 않는 날짜:
	 *         java.text.ParseException 발생
	 */
	public static int daysBetween(String from, String to, String format)
			throws java.text.ParseException {
		java.util.Date d1 = check(from, format);
		java.util.Date d2 = check(to, format);

		long duration = d2.getTime() - d1.getTime();

		return (int) (duration / (1000 * 60 * 60 * 24));
		// seconds in 1 day
	}
}//:~















