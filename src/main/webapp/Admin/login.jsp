<%@ page import="com.simple.webui.homework.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object _userId = session.getAttribute("userId");
    if(_userId != null)
    {
        long userId = (long) _userId;
        User user = (User) session.getAttribute("user");
        if(user != null)
            response.sendRedirect(request.getContextPath() + "/Admin/index.jsp");
    }
%>
<html>
<head>
    <title>Neko* WebUI - Login</title>
</head>
<style>
    #login {
        font: 14px / 1.4 "Helvetica Neue", "HelveticaNeue", Helvetica, Arial, sans-serif;
        position: absolute;
        background: rgba(255, 255, 255, .45);
        border-radius: 6px;
        top: 50%;
        left: 50%;
        width: 350px;
        padding: 0px !important;
        margin: -235px 0 0 -175px !important;
        background-position: center 48%;
    }
</style>
<body>
    <div id="login">
        <h1>Login</h1>
        <form action="tryLogin.jsp">

        </form>
    </div>
</body>
</html>
