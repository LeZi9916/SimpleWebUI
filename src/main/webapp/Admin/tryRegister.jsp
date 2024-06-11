<%@ page import="com.simple.webui.homework.User" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="com.simple.webui.homework.LoginResult" %>
<%@ page import="java.util.Random" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
    long generateUserId(Connection dbSession)
    {
        Random rd = new Random();
        while(true)
        {
            long id = rd.nextLong();
            try
            {
                ResultSet result = dbSession.prepareStatement("SELECT * FROM User WHERE id=" + id)
                                            .executeQuery();
                if(!result.isBeforeFirst())
                    return id;
            }
            catch (Exception ignored) {   }
        }
    }
%>
<%

    try
    {
        String username = request.getParameter("username");
        String pwd = request.getParameter("password");
        String rePwd = request.getParameter("rePassword");

        if(pwd.length() < 6 || pwd.length() > 20 || !pwd.equals(rePwd))
        {
            request.setAttribute("isRegister",true);
            if(!pwd.equals(rePwd))
                request.setAttribute("loginResult", LoginResult.REGISTER_PASSWORD_NOT_MATCH);
            else
                request.setAttribute("loginResult", LoginResult.REGISTER_PASSWORD_TOO_SHORT_OR_LONG);
            %>
                <jsp:include page="login.jsp"></jsp:include>
            <%
            return;
        }

        Connection dbSession = (Connection) application.getAttribute("dbSession");
        if(dbSession == null)
            dbSession = DriverManager.getConnection("jdbc:mysql://localhost:3306/NekoWebUI", "root", "password");
        long id = generateUserId(dbSession);
        String hash = User.getStrHash(pwd);
        User newUser = new User(id,username,username,hash,0,0);
    }
    catch(Exception e)
    {
        request.setAttribute("isRegister",true);
        request.setAttribute("loginResult", LoginResult.UNKNOWN_ERROR);
        %>
            <jsp:include page="login.jsp"></jsp:include>
        <%
        return;
    }
%>
