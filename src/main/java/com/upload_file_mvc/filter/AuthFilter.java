package com.upload_file_mvc.filter;

import com.upload_file_mvc.util.SessionUtil;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter(urlPatterns = {"/home", "/profile", "/users", "/user/*", "/upload-async", "/tasks", "/files"})
public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        if (!SessionUtil.isLoggedIn(httpRequest)) {
            String requestUrl = httpRequest.getRequestURL().toString();
            String queryString = httpRequest.getQueryString();
            
            String redirectUrl = requestUrl;
            if (queryString != null) {
                redirectUrl += "?" + queryString;
            }
            
            httpResponse.sendRedirect(httpRequest.getContextPath() + 
                "/login?redirect=" + redirectUrl);
            return;
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
