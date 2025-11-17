package com.upload_file_mvc.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import com.upload_file_mvc.dto.User;

public class SessionUtil {
    
    private static final String USER_SESSION_KEY = "loggedInUser";
    private static final int SESSION_TIMEOUT = 60 * 60;

    public static void setUser(HttpServletRequest request, User user) {
        HttpSession session = request.getSession(true);
        session.setAttribute(USER_SESSION_KEY, user);
        session.setMaxInactiveInterval(SESSION_TIMEOUT);
    }

    public static User getUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute(USER_SESSION_KEY);
        }
        return null;
    }

    public static boolean isLoggedIn(HttpServletRequest request) {
        return getUser(request) != null;
    }

    public static void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(USER_SESSION_KEY);
            session.invalidate();
        }
    }

    public static String getEmail(HttpServletRequest request) {
        User user = getUser(request);
        return user != null ? user.getEmail() : null;
    }

    public static Integer getUserId(HttpServletRequest request) {
        User user = getUser(request);
        return user != null ? user.getId() : null;
    }
}
