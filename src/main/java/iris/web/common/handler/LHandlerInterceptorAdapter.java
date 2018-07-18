package iris.web.common.handler;

import java.util.List;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import devonframe.exception.BaseException;
import devonframe.util.PatternUtil;

/**
 * <pre>
 * skipUrl, applyUrl 설정을 통해서 특정 url 요청일 경우 interceptor가 적용되지 않도록
 * 예외를 설정할 수 있는 기능을 가지는 확장 클래스
 * </pre>
 *
 * @author XXX팀 OOO
 */
public abstract class LHandlerInterceptorAdapter extends HandlerInterceptorAdapter {

	private Pattern[] skipUrlPatterns;
	private Pattern[] applyUrlPatterns;

	public void setSkipUrls(List<String> skipUrls) {
		this.skipUrlPatterns = PatternUtil.compileWildcardPattern(skipUrls);
	}

	public void setApplyUrls(List<String> applyUrls) {
		this.applyUrlPatterns = PatternUtil.compileWildcardPattern(applyUrls);
	}

	/**
	 * 요청url이 skipUrl 또는 applyUrl과 매칭될 때, Interceptor적용여부를 판별한다.
	 *
	 * @param request
	 * @param response
	 * @param handler
	 */
	public final boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		if (skipUrlPatterns != null && applyUrlPatterns != null) {
			throw new BaseException("skipUrl and applyUrl in interceptor property cannot be used at the same time");
		} else if ((skipUrlPatterns != null && PatternUtil.matches(skipUrlPatterns, request.getServletPath()))
				||(applyUrlPatterns != null && !PatternUtil.matches(applyUrlPatterns, request.getServletPath()))) {
			return true;
		}
		return checkHandle(request, response, handler);
	}

	public abstract boolean checkHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception;
}
