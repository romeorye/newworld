package iris.web.common.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;


// Filter 클래스가 어노테이션을 쓸수없는 클래스이다. 버전 문제가 아닐지?
public class XSSFilter implements Filter {
	//@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		System.out.println("XSSFilter: init()");
	}

	//@Override
	public void destroy() {
		System.out.println("XSSFilter: destroy()");
	}

	//@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		XSSRequestWrapper wrapper = new XSSRequestWrapper((HttpServletRequest)request);
		chain.doFilter(wrapper, response);
	}

}