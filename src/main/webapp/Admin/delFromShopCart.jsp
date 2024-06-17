<%@ page import="com.simple.webui.homework.User" %>
<%@ page import="com.simple.webui.homework.Methods" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session.getAttribute("originUrl") == null)
    {
        session.setAttribute("originUrl",request.getParameter("originUrl"));
        session.setAttribute("itemId",request.getParameter("itemId"));
    }
    User operator = null;
    User user = null;
    Object _userId = session.getAttribute("userId");
    if (_userId != null)
    {
        String userId = ((Long) _userId).toString();
        String sessionId = (String) application.getAttribute(userId);
        if (sessionId == null || !sessionId.equals(session.getId()))
        {
            response.sendRedirect(request.getContextPath() + "/Admin/login.jsp?originUrl=/Admin/delFromShopCart.jsp");
            return;
        }
        user = User.deserialize(Methods.checkDbAlive(application),Long.parseLong(userId));
        user.update(session,application);
        operator = user;
    }
    else
    {
        response.sendRedirect(request.getContextPath() + "/Admin/login.jsp?originUrl=/Admin/delFromShopCart.jsp");
        return;
    }
%>