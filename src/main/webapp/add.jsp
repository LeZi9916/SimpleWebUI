<%@ page import="com.simple.webui.homework.User" %>
<%@ page import="com.simple.webui.homework.Methods" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.simple.webui.homework.Item" %>
<%@ page import="com.simple.webui.homework.ShopCart" %>
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
            response.sendRedirect(request.getContextPath() + "/Admin/login.jsp?originUrl=/add.jsp");
            return;
        }
        user = User.deserialize(Methods.checkDbAlive(application),Long.parseLong(userId));
        user.update(session,application);
        operator = user;
    }
    else
    {
        response.sendRedirect(request.getContextPath() + "/Admin/login.jsp?originUrl=/add.jsp");
        return;
    }
    String _itemId = request.getParameter("itemId");
    String originUrl = request.getParameter("originUrl");
    String _count = request.getParameter("count");
    long count = Long.parseLong(_count);

    if(_itemId == null)
        _itemId = (String) session.getAttribute("itemId");
    if(originUrl == null)
        originUrl = (String) session.getAttribute("originUrl");
    if(_itemId == null)
    {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    if(count > 0)
    {
        Connection dbSession = Methods.checkDbAlive(application);
        ShopCart shopCart = ShopCart.deserialize(dbSession, operator.getId());
        Item item = Item.deserialize(dbSession,Long.parseLong(_itemId));
        count = Math.min(count,item.getCount());
        for(int i =0;i <count ; i++)
            shopCart.addItem(item.getId());
        shopCart.update(dbSession);
    }

    if(originUrl == null)
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    else
        response.sendRedirect(request.getContextPath() + originUrl);
    return;
%>