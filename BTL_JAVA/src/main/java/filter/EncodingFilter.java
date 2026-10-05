package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter("/*")
public class EncodingFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");

        String uri = req.getRequestURI();
        if (!uri.endsWith(".css") && !uri.endsWith(".js") && !uri.endsWith(".png") &&
            !uri.endsWith(".jpg") && !uri.endsWith(".jpeg") && !uri.endsWith(".ico") &&
            !uri.endsWith(".svg") && !uri.endsWith(".woff") && !uri.endsWith(".woff2")) {
            res.setContentType("text/html; charset=UTF-8");
        }

        chain.doFilter(request, response);
    }
}
