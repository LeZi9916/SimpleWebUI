<%@ page import="java.sql.Connection" %>
<%@ page import="com.simple.webui.homework.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
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
        user = (User) session.getAttribute("user");
    }
    else
    {
        response.sendRedirect(request.getContextPath() + "/Admin/login.jsp");
        return;
    }

    String _rdNum = request.getParameter("rdNum");
    String address = request.getParameter("address");
    String originUrl = request.getParameter("originUrl");

    if(Methods.stringIsEmptyOrNull(originUrl))
        originUrl = "/Admin/userShopCart.jsp";

    if(Methods.stringIsEmptyOrNull(_rdNum) ||
        Methods.stringIsEmptyOrNull(address)||
        session.getAttribute("rdNum") == null)
    {
        response.sendRedirect(request.getContextPath() + originUrl);
        return;
    }
    Long rdNum = (Long) session.getAttribute("rdNum");
    if(rdNum != Long.parseLong(_rdNum) || session.getAttribute("pendingOrders") == null)
    {
        response.sendRedirect(request.getContextPath() + originUrl);
        return;
    }

    Connection dbSession = Methods.checkDbAlive(application);
    UserOrder[] pendingOrders = (UserOrder[])session.getAttribute("pendingOrders");
    ShopCart shopCart = ShopCart.deserialize(dbSession,user.getId());
    for(UserOrder order :pendingOrders)
    {
        long itemId = order.getItemId();
        Item target = Item.deserialize(dbSession,itemId);
        if(target.getCount() == 0)
            continue;
        order.setUserAddress(address);
        order.setCount(Math.min(order.getCount(), target.getCount()));
        target.setCount(target.getCount() - order.getCount());
        target.update(dbSession);
        order.update(dbSession);
        shopCart.setItems(CollectionHelper.Where(shopCart.getBoxedItems(),i -> i != itemId,new Long[0]));
        shopCart.update(dbSession);
    }
    session.setAttribute("rdNum",null);
    session.setAttribute("pendingOrders",null);
    response.sendRedirect(request.getContextPath() + originUrl);
%>

