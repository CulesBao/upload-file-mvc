package com.upload_file_mvc.controller;

import com.upload_file_mvc.dao.UserDAO;
import com.upload_file_mvc.model.User;
import com.upload_file_mvc.util.SessionUtil;
import com.upload_file_mvc.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/register", "/logout"})
public class AuthController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        switch (path) {
            case "/login":
                showLoginPage(request, response);
                break;
            case "/register":
                showRegisterPage(request, response);
                break;
            case "/logout":
                handleLogout(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        switch (path) {
            case "/login":
                handleLogin(request, response);
                break;
            case "/register":
                handleRegister(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    private void showLoginPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    private void showRegisterPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please enter both email and password!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        User user = userDAO.authenticate(email, password);
        
        if (user != null) {
            SessionUtil.setUser(request, user);
            
            String redirectUrl = request.getParameter("redirect");
            if (redirectUrl != null && !redirectUrl.isEmpty()) {
                response.sendRedirect(redirectUrl);
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.setAttribute("error", "Invalid email or password!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        
        if (password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all required fields!");
            setRegisterFormData(request, email, fullName);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Validate password
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            setRegisterFormData(request, email, fullName);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        

        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already in use!");
            setRegisterFormData(request, email, fullName);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        User user = new User(email, password, fullName);
        boolean success = userDAO.createUser(user);
        
        if (success) {
            request.setAttribute("success", "Registration successful! Please log in.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "An error occurred! Please try again.");
            setRegisterFormData(request, email, fullName);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
    
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        SessionUtil.logout(request);
        response.sendRedirect(request.getContextPath() + "/login?message=logout");
    }
    

    private void setRegisterFormData(HttpServletRequest request, String email, String fullName) {
        request.setAttribute("email", email);
        request.setAttribute("fullName", fullName);
    }
}
