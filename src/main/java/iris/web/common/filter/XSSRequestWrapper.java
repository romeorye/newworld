package iris.web.common.filter;

import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

public class XSSRequestWrapper extends HttpServletRequestWrapper {

	private Map<String, String[]> sanitizedQueryString;			//XSS를 제거한 문자열 변수
	
	//치환대상 패턴
	private static Pattern[] verifyPatterns = new Pattern[] {
			Pattern.compile("<script>(.*?)</script>", Pattern.CASE_INSENSITIVE),
			Pattern.compile("</script>", Pattern.CASE_INSENSITIVE), 
			Pattern.compile("<script(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
			Pattern.compile("<javascript>(.*?)</javascript>", Pattern.CASE_INSENSITIVE),
			Pattern.compile("</javascript>", Pattern.CASE_INSENSITIVE), 
			Pattern.compile("<javascript(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
			Pattern.compile("<vbscript>(.*?)</vbscript>", Pattern.CASE_INSENSITIVE),
			Pattern.compile("</vbscript>", Pattern.CASE_INSENSITIVE), 
			Pattern.compile("<vbscript(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL)
	};

	//삭제대상 패턴
	private static Pattern[] clearPatterns = new Pattern[] {
		//Pattern.compile("src[\r\n]*=[\r\n]*\\\'(.*?)\\\'", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
		//Pattern.compile("src[\r\n]*=[\r\n]*\\\"(.*?)\\\"", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
		Pattern.compile("eval\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
		Pattern.compile("expression\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL),
		Pattern.compile("javascript:", Pattern.CASE_INSENSITIVE),
		Pattern.compile("vbscript:", Pattern.CASE_INSENSITIVE),
		Pattern.compile("onload(.*?)=", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL)
	};

	public XSSRequestWrapper(HttpServletRequest servletRequest) {
		super(servletRequest);
	}

	@Override
	public String getParameter(String name) {
		
		//System.out.println("getParameter : " + name);
		
		String parameter = null;
		String[] vals = getParameterMap().get(name); 
		
		if (vals != null && vals.length > 0) {
			parameter = vals[0];
		}
		
		return parameter;
	}

	@Override
	public String[] getParameterValues(String name) {
		
		//System.out.println("getParameterValues : " + name);
		
		return getParameterMap().get(name);
	}
	
	@Override
	public Enumeration<String> getParameterNames() {
		return Collections.enumeration(getParameterMap().keySet());
	}

	
	/**
	 * getParameter, getParameterValues, getParameterMap 모두 여기를 타도록 수정
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String,String[]> getParameterMap() {
		if(sanitizedQueryString == null) {
			Map<String, String[]> res = new HashMap<String, String[]>();
			Map<String, String[]> originalQueryString = super.getParameterMap();
			if(originalQueryString!=null) {
				for (String key : (Set<String>) originalQueryString.keySet()) {
					String[] rawVals = originalQueryString.get(key);
					String[] snzVals = new String[rawVals.length];
					for (int i=0; i < rawVals.length; i++) {
						snzVals[i] = stripXSS(rawVals[i]);
						//System.out.println("Sanitized [info] : from(" + rawVals[i] + ") , to(" + snzVals[i] + ")");
					}
					res.put(stripXSS(key), snzVals);
				}
			}
			sanitizedQueryString = res;
		}
		return sanitizedQueryString;
	}
	
	@Override
	public String getHeader(String name) {

		//System.out.println("getHeader : " + name);
		String value = super.getHeader(name);

		return stripXSS(value);
	}

	private String stripXSS(String value) {
		//System.out.println("stripXSS: value= "+value);
		if (value != null) {

			value = value.replaceAll("\0", "");

			for (Pattern scriptPattern : verifyPatterns) {
				if ( scriptPattern.matcher(value).find() ) {
					System.out.println("verify pattern match.....");
					value=value.replaceAll("<", "&lt;").replaceAll(">", "&gt;");		
				}
			}
			for (Pattern scriptPattern : clearPatterns) {
				if ( scriptPattern.matcher(value).find() ) {
					System.out.println("clear pattern match.....");
					value=scriptPattern.matcher(value).replaceAll("");		
				}
			}
		}
		//System.out.println("result: "+value);
		return value;
	}

}