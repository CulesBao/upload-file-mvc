package com.upload_file_mvc.controller;

import com.upload_file_mvc.dao.UserDAO;
import com.upload_file_mvc.model.User;
import com.upload_file_mvc.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/home", "/profile", "/users", "/user/edit", "/user/delete"})
public class UserController extends HttpServlet {
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
            case "/home":
                showHomePage(request, response);
                break;
            case "/profile":
                showProfile(request, response);
                break;
            case "/users":
                listUsers(request, response);
                break;
            case "/user/delete":
                deleteUser(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        switch (path) {
            case "/user/edit":
                updateUser(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    private void showHomePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = SessionUtil.getUser(request);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = SessionUtil.getUser(request);
        
        if (user != null) {
            User latestUser = userDAO.findById(user.getId());
            if (latestUser != null) {
                latestUser.setPassword(null); 
                request.setAttribute("user", latestUser);
            }
        }
        
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<User> users = userDAO.getAllUsers();
        
        // Don't expose passwords
        for (User user : users) {
            user.setPassword(null);
        }
        
        request.setAttribute("users", users);
        request.getRequestDispatcher("/users.jsp").forward(request, response);
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User currentUser = SessionUtil.getUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String fullName = request.getParameter("fullName");
        
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all required fields!");
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }
        
        User user = new User();
        user.setId(currentUser.getId());
        user.setFullName(fullName);
        user.setEmail(currentUser.getEmail());
        
        boolean success = userDAO.updateUser(user);
        
        if (success) {
            currentUser.setFullName(fullName);
            currentUser.setEmail(currentUser.getEmail());
            SessionUtil.setUser(request, currentUser);
            
            request.setAttribute("success", "Profile updated successfully!");
        } else {
            request.setAttribute("error", "An error occurred! Please try again.");
        }
        
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User currentUser = SessionUtil.getUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String userIdStr = request.getParameter("id");
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/users");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            
            if (userId != currentUser.getId()) {
                request.setAttribute("error", "You do not have permission to delete this user!");
                listUsers(request, response);
                return;
            }
            
            boolean success = userDAO.deleteUser(userId);
            
            if (success) {
                if (userId == currentUser.getId()) {
                    SessionUtil.logout(request);
                    response.sendRedirect(request.getContextPath() + "/login?message=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/users?success=deleted");
                }
            } else {
                request.setAttribute("error", "An error occurred while deleting the user!");
                listUsers(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/users");
        }
    }
}
