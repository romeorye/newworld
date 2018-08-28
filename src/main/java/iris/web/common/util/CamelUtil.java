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
				"PRJ_CD",
				"TSS_CD",
				"PGS_STEP_CD",
				"TSS_SCN_CD",
				"WBS_CD",
				"PK_WBS_CD",
				"dept_code",
				"PPSL_MBD_CD",
				"BIZ_DPT_CD",
				"TSS_NM",
				"sa_sabun_new",
				"TSS_ATTR_CD",
				"TSS_STRT_DD",
				"TSS_FNH_DD",
				"ALTR_B_STRT_DD",
				"ALTR_B_FNH_DD",
				"ALTR_NX_STRT_DD",
				"ALTR_NX_FNH_DD",
				"CMPL_B_STRT_DD",
				"CMPL_B_FNH_DD",
				"CMPL_NX_STRT_DD",
				"CMPL_NX_FNH_DD",
				"DCAC_B_STRT_DD",
				"DCAC_B_FNH_DD",
				"DCAC_NX_STRT_DD",
				"DCAC_NX_FNH_DD",
				"COO_INST_CD",
				"SUPV_OPS_NM",
				"EXRS_INST_NM",
				"BIZ_NM",
				"TSS_ST",
				"TSS_NOS_ST",
				"TSS_ST_TXT",
				"FRST_RGST_DT",
				"FRST_RGST_ID",
				"LAST_MDFY_DT",
				"LAST_MDFY_ID",
				"DEL_YN",
				"PROD_G",
				"RSST_SPHE",
				"TSS_TYPE",
				"sa_sabun_name",
				"dept_name",
				"PRJ_NM"
			};
		System.out.println(selectToCamel(test));
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		System.out.println(updateToCamel(test));
		System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
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
