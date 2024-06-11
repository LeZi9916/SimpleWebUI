<%@ page import="com.simple.webui.homework.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null)
        response.sendRedirect(request.getContextPath() + "/Admin/login.jsp");
%>
<html>
<head>
    <title>
        Neko* WebUI - <%=((User)session.getAttribute("user")).getName()%>
    </title>
</head>
<body>

</body>
</html>
