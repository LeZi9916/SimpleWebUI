<%@ page import="com.simple.webui.homework.User" %>
<%@ page import="com.simple.webui.homework.Methods" %>
<%@ page import="com.simple.webui.homework.UserType" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="com.simple.webui.homework.Item" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
    boolean delUser(Connection dbSession,long userId)
    {
        try
        {
            PreparedStatement state = dbSession.prepareStatement("DELETE FROM User WHERE id = ?");
            state.setLong(1,userId);

            return state.executeUpdate() > 0;
        }
        catch(Exception e)
        {
            return false;
        }
    }
    boolean delItem(Connection dbSession,long itemId)
    {
        try
        {
            PreparedStatement state = dbSession.prepareStatement("DELETE FROM Item WHERE id = ?");
            state.setLong(1,itemId);

            return state.executeUpdate() > 0;
        }
        catch(Exception e)
        {
            return false;
        }
    }
%>
<%
    User operator = null;
    User user = null;
    Object _userId = session.getAttribute("userId");
    if (_userId != null)
    {
        String userId = ((Long) _userId).toString();
        String sessionId = (String) application.getAttribute(userId);
        if (sessionId == null || !sessionId.equals(session.getId()))
        {
            response.sendRedirect(request.getContextPath() + "/Admin/login.jsp");
            return;
        }
        user = User.deserialize(Methods.checkDbAlive(application),Long.parseLong(userId));
        user.update(session,application);
        operator = user;
    }
    else
    {
        response.sendRedirect(request.getContextPath() + "/Admin/login.jsp");
        return;
    }
    String originUrl = "/Admin/index.jsp";
    String type = request.getParameter("type");
    String _id = request.getParameter("id");
    Connection dbSession = Methods.checkDbAlive(application);
    try
    {
        if(!Methods.stringIsEmptyOrNull(request.getParameter("originUrl")))
            originUrl = request.getParameter("originUrl");
        if(!Methods.stringIsEmptyOrNull(type))
        {
            if(type.equals("user"))
            {
                if(!Methods.stringIsEmptyOrNull(_id))
                {
                    long id = Long.parseLong(_id);
                    if(id != operator.getId() && !operator.checkPermission(UserType.ADMIN))
                    {
                        response.sendRedirect(request.getContextPath() + originUrl);
                        return;
                    }
                    if(delUser(dbSession,id))
                    {
                        response.sendRedirect(request.getContextPath() + "/Admin/logout.jsp");
                        return;
                    }
                }
            }
            else
            {
                if(!Methods.stringIsEmptyOrNull(_id))
                {
                    long id = Long.parseLong(_id);
                    Item item = Item.deserialize(dbSession,id);
                    if(item.getParentId() != operator.getId() && !operator.checkPermission(UserType.ADMIN))
                    {
                        response.sendRedirect(request.getContextPath() + originUrl);
                        return;
                    }
                    delItem(dbSession,id);
                }
            }
        }
    }
    catch(Exception e) {}
    response.sendRedirect(request.getContextPath() + originUrl);
    return;
%>