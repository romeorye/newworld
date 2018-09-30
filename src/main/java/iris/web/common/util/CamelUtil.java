package iris.web.common.util;

import java.util.*;

public class CamelUtil {

	public static void main(String[] args) {
		//test
		System.out.println(toCamel("DTL_SBC_TITL_2"));
		System.out.println(toCamel("USE_YN"));
		System.out.println(toCamel("LAST_MDFY_DT"));
		System.out.println(toUnder("lastMdfyDt"));
		System.out.println(toUnder("frstRgstId"));
		System.out.println(toUnder("evSbcTxt"));
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

		String[] test = {
				"TSS_CD",
				"WBS_CD",
				"PK_WBS_CD",
				"PGS_STEP_CD",
				"TSS_ST",
				"TSS_SCN_CD",
				"GRS_YN",
				"TSS_NM",
				"PRJ_CD",
				"PRJ_NM",
				"BIZ_DPT_CD",
				"PROD_G",
				"SA_SABUN_CD",
				"SA_SABUN_NM",
				"TSS_STRT_DD",
				"TSS_FNH_DD",
				"CUST_SQLT",
				"TSS_SMRY_TXT",
				"TSS_ATTR_CD",
				"TSS_TYPE",
				"SMR_SMRY_TXT",
				"SMR_GOAL_TXT",
				"NPROD_SALS_PLN_Y",
				"CTY_OT_PLN_M"
			};
		System.out.println(insertToCamel(test));
		System.out.println(selectToCamel(test));
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		System.out.println(updateToCamel(test));
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	}

	public static String insertToCamel(String[] arr){

		StringBuffer result = new StringBuffer();
		result.append("(\n");
		for (int i = 0; i < arr.length; i++) {
			result.append(arr[i]);
			if(i!=arr.length-1){
				result.append(",\n");
			}else{
				result.append("\n");
			}
		}
		result.append(") VALUES (\n");
		for (int i = 0; i < arr.length; i++) {
			result.append("#{"+toCamel(arr[i])+"}");
			if(i!=arr.length-1){
				result.append(",\n");
			}else{
				result.append("\n");
			}
		}
		result.append(")\n");
		return result.toString();
	}

	public static String selectToCamel(String[] arr){
		StringBuffer result = new StringBuffer();
		for (int i = 0; i < arr.length; i++) {
			result.append(arr[i] + " AS " + toCamel(arr[i]));
			if(i!=arr.length-1){
				result.append(",\n");
			}else{
				result.append("\n");
			}
		}
		return result.toString();
	}

	public static String updateToCamel(String[] arr){
		StringBuffer result = new StringBuffer();
		for (int i = 0; i < arr.length; i++) {
			result.append(arr[i] + " = #{" + toCamel(arr[i])+"}");
			if(i!=arr.length-1){
				result.append(",\n");
			}else{
				result.append("\n");
			}
		}
		return result.toString();
	}

	public static Map<String, Object> mapToCamel(Map<String, Object> map) {
		Map<String, Object> newMap = new HashMap<String, Object>();
		Set set = map.keySet();
		Iterator iterator = set.iterator();
		while (iterator.hasNext()) {
			String key = (String) iterator.next();
			newMap.put(toCamel(key), map.get(key));
		}
		return newMap;
	}

	public static Map<String, Object> mapToUnder(Map<String, Object> map) {
		Map<String, Object> newMap = new HashMap<String, Object>();
		Set set = map.keySet();
		Iterator iterator = set.iterator();
		while (iterator.hasNext()) {
			String key = (String) iterator.next();
			newMap.put(toUnder(key), map.get(key));
		}
		return newMap;
	}

	public static String toCamel(String underScore) {
		if (underScore.indexOf('_') < 0 && Character.isLowerCase(underScore.charAt(0))) {
			return underScore;
		}
		StringBuilder result = new StringBuilder();
		boolean nextUpper = false;
		int len = underScore.length();

		for (int i = 0; i < len; i++) {
			char currentChar = underScore.charAt(i);
			if (currentChar == '_') {
				nextUpper = true;
			} else {
				if (nextUpper) {
					result.append(Character.toUpperCase(currentChar));
					nextUpper = false;
				} else {
					result.append(Character.toLowerCase(currentChar));
				}
			}
		}
		return result.toString();
	}

	public static String toUnder(String str) {
		String regex = "([a-z])([A-Z])";
		String replacement = "$1_$2";
		String value = "";
		value = str.replaceAll(regex, replacement).toUpperCase();
		return value;
	}
}
