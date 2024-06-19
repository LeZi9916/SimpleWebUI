<%@ page import="com.simple.webui.homework.User" %>
<%@ page import="com.simple.webui.homework.Methods" %>
<%@ page import="com.simple.webui.homework.UserOrder" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.simple.webui.homework.OrderState" %>
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

    String _orderId = request.getParameter("orderId");
    String originUrl = request.getParameter("originUrl");

    if(Methods.stringIsEmptyOrNull(originUrl))
        originUrl = "";
    if(Methods.stringIsEmptyOrNull(_orderId))
    {
        response.sendRedirect(request.getContextPath() + originUrl);
        return;
    }
    long orderId = Long.parseLong(_orderId);
    Connection dbSession = Methods.checkDbAlive(application);
    UserOrder order = UserOrder.deserialize(dbSession,orderId);

    if(order == null || order.getState() >= OrderState.TRANSMITTING||
    order.getSource() != user.getId())
    {
        response.sendRedirect(request.getContextPath() + originUrl);
        return;
    }
    else
    {
        order.setState(OrderState.CANCELED);
        order.update(dbSession);
    }
    response.sendRedirect(request.getContextPath() + originUrl);
%>

