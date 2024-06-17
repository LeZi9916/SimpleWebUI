<%@ page import="java.sql.Connection" %>
<%@ page import="com.simple.webui.homework.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
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
    String _itemId = request.getParameter("itemId");
    String _count = request.getParameter("count");
    String originUrl = request.getParameter("originUrl");

    if(Methods.stringIsEmptyOrNull(_itemId) ||
        Methods.stringIsEmptyOrNull(_count) ||
        Methods.stringIsEmptyOrNull(originUrl))
    {
        response.sendRedirect(request.getContextPath() + "/Admin/userShopCart.jsp");
        return;
    }
    long itemId = Long.parseLong(_itemId);
    long count = Long.parseLong(_count);

    Connection dbSession = Methods.checkDbAlive(application);
    ShopCart shopCart = ShopCart.deserialize(dbSession, operator.getId());

    if(count <= 0)
    {
        session.setAttribute("itemId",itemId);
        session.setAttribute("originUrl",originUrl);
        response.sendRedirect(request.getContextPath() + "/Admin/delFromShopCart.jsp");
        return;
    }
    long diff = 0;
    Counting<Long>[] counted = CollectionHelper.Count(shopCart.getBoxedItems());
    for (Counting<Long> c: counted)
    {
        if(c.getKey() == itemId)
        {
            if(c.getCount() == count)
            {
                response.sendRedirect(request.getContextPath() + "/Admin/userShopCart.jsp");
                return;
            }
            else
                diff = c.getCount() - count;
        }
    }
    long[] items = shopCart.getItems();
    long[] newItems = new long[(int) (items.length - diff)];
    Map<Long,Integer> map = new HashMap<>();

    for (int i =0; i< newItems.length;i++)
    {
        long __itemId = itemId;
        if(i < items.length)
            __itemId = items[i];
        if(!map.containsKey(__itemId))
            map.put(__itemId,1);
        else
        {
            if(__itemId == itemId && map.get(__itemId) >= count)
                continue;
        }
        if(i >= items.length)
            newItems[i] = itemId;
        else
            newItems[i] = __itemId;
    }
    shopCart.setItems(newItems);
    shopCart.update(dbSession);
    response.sendRedirect(request.getContextPath() + "/Admin/userShopCart.jsp");
%>