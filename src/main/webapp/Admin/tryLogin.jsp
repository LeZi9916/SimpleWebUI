<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.simple.webui.homework.User" %>
<%@ page import="com.simple.webui.homework.LoginResult" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    try
    {
        long id = Long.parseLong(request.getParameter("id"));
        String pwd = request.getParameter("pwd");
        String hash = User.getStrHash(pwd);
        Connection dbSession = (Connection) application.getAttribute("dbSession");
        if(dbSession == null)
            dbSession = DriverManager.getConnection("jdbc:mysql://localhost:3306/NekoWebUI", "root", "password");

        User user = User.deserialize(dbSession,id);
        if(user == null || !user.comparePassword(hash))
        {
            request.setAttribute("loginResult", LoginResult.UNKNOWN_PASSWORD_OR_USERID);
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
        else
        {
            user.update(session);
            response.sendRedirect(request.getContextPath() + "/Admin/index.jsp");
        }

    }
    catch(Exception e)
    {

    }
%>
