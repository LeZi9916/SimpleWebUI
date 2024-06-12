<%@ page import="com.simple.webui.homework.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object _userId = session.getAttribute("userId");
    if (_userId != null)
    {
        String userId = ((Long) _userId).toString();
        String sessionId = (String) application.getAttribute(userId);
        if (sessionId != null && sessionId.equals(session.getId()))
            ((User)session.getAttribute("user")).logout(session,application);
    }
    response.sendRedirect(request.getContextPath() + "/Admin/login.jsp");
%>
