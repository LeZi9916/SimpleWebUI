<%@ page import="com.simple.webui.homework.User" %>
<%@ page import="java.io.File" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="java.util.List" %>
<%@ page import="com.simple.webui.homework.Methods" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.simple.webui.homework.UserType" %>
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
            response.sendRedirect(request.getContextPath() + "/Admin/login.jsp");
        user = (User) session.getAttribute("user");
        operator = user;
    }
    else
        response.sendRedirect(request.getContextPath() + "/Admin/login.jsp");

    String uploadType = null;
    String origin = "";
    String id = null;
    String uploadPath = "";
    String newUsername = null;
    String newName = null;
    String userType = null;

    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists())
        uploadDir.mkdir();
    FileItem uploadItem = null;
    if (ServletFileUpload.isMultipartContent(request))
    {
        try
        {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);

            List<FileItem> formItems = upload.parseRequest(request);

            if (formItems != null && !formItems.isEmpty()) {

                for (FileItem item : formItems)
                {
                    if (item.isFormField())
                    {
                        if( "uploadType".equals(item.getFieldName()))
                            uploadType = item.getString();
                        else if("originUrl".equals(item.getFieldName()))
                            origin = item.getString();
                        else if("username".equals(item.getFieldName()))
                            newUsername = item.getString();
                        else if("name".equals(item.getFieldName()))
                            newName = item.getString();
                        else if("id".equals(item.getFieldName()))
                            id = item.getString();
                        else if("userType".equals(item.getFieldName()))
                            userType = item.getString();
                    }
                    else
                    {
                        if(uploadItem == null)
                            uploadItem = item;
                    }
                }
            }
        }
        catch (Exception ignored) { }
    }

    Connection dbSession = Methods.checkDbAlive(application);
    if(Methods.stringIsEmptyOrNull(id))
    {
        response.sendRedirect(request.getContextPath() + origin);
        return;
    }

    long userId = Long.parseLong(id);
    if(userId != operator.getId())
    {
        user = User.deserialize(dbSession,userId);
        if(user == null || !operator.checkPermission(UserType.ADMIN))
        {
            response.sendRedirect(request.getContextPath() + origin);
            return;
        }
    }

    if(uploadItem != null)
    {
        if(uploadType == null)
        {
            response.sendRedirect(request.getContextPath() + origin);
            return;
        }
        else if(uploadType.equals("user"))
            uploadPath = application.getRealPath("") + File.separator + "pic";
        else if(uploadType.equals("item"))
            uploadPath = application.getRealPath("") + File.separator + "pic" + File.separator + "item";
        else
        {
            response.sendRedirect(request.getContextPath() + origin);
            return;
        }
        String filePath = uploadPath + File.separator + id + ".jpg";
        File storeFile = new File(filePath);
        if(storeFile.exists())
            storeFile.delete();
        uploadItem.write(storeFile);
        if(uploadType.equals("user"))
            user.setPicId(user.getId());
    }

    if(!Methods.stringIsEmptyOrNull(newName))
        user.setName(newName);
    if(!Methods.stringIsEmptyOrNull(newUsername))
        user.setUsername(newUsername);
    if(!Methods.stringIsEmptyOrNull(userType))
    {
        int _userType = Integer.parseInt(userType);
        if ((_userType < UserType.ADMIN ||
                operator.checkPermission(UserType.ROOT)) &&
                _userType <= UserType.ROOT)
        {
            user.setUserType(_userType);
        }
    }
    user.update(session,application);
    user.update(dbSession);
    response.sendRedirect(request.getContextPath() + origin);
%>