<%@ page import="java.sql.Connection" %>
<%@ page import="com.simple.webui.homework.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    String originUrl = (String) session.getAttribute("originUrl");
    String _itemId = (String) session.getAttribute("itemId");

    if(Methods.stringIsEmptyOrNull(originUrl))
        originUrl = request.getParameter("originUrl");
    if(Methods.stringIsEmptyOrNull(_itemId))
        _itemId = request.getParameter("itemId");


    if(Methods.stringIsEmptyOrNull(originUrl))
        originUrl = "/Admin/userShopCart.jsp";
    if (Methods.stringIsEmptyOrNull(_itemId))
    {
        response.sendRedirect(request.getContextPath() + originUrl);
        return;
    }
    long itemId = Long.parseLong(_itemId);
    Connection dbSession = Methods.checkDbAlive(application);
    ShopCart shopCart = ShopCart.deserialize(dbSession, operator.getId());
    Long[] items = shopCart.getBoxedItems();
    Long[] newItems = CollectionHelper.Where(items,i -> i != itemId,new Long[0]);
    shopCart.setItems(newItems);
    shopCart.update(dbSession);
    response.sendRedirect(request.getContextPath() + originUrl);
%>