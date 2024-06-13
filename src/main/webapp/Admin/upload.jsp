<%@ page import="com.simple.webui.homework.User" %>
<%@ page import="java.io.File" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = null;
    Object _userId = session.getAttribute("userId");
    if (_userId != null)
    {
        String userId = ((Long) _userId).toString();
        String sessionId = (String) application.getAttribute(userId);
        if (sessionId == null || !sessionId.equals(session.getId()))
            response.sendRedirect(request.getContextPath() + "/Admin/login.jsp");
        user = (User) session.getAttribute("user");
    }
    else
        response.sendRedirect(request.getContextPath() + "/Admin/login.jsp");

    String uploadType = request.getParameter("uploadType");
    String origin = request.getParameter("originUrl");
    String id = request.getParameter("id");
    String uploadPath = "";
    if(origin == null)
        origin = "";
    if(uploadType == null)
        response.sendRedirect(request.getContextPath() + origin);
    else if(uploadType == "userPic")
        uploadPath = application.getRealPath("") + File.separator + "pic";
    else if(uploadType == "itemPic")
        uploadPath = application.getRealPath("") + File.separator + "pic" + File.separator + "item";
    else
        response.sendRedirect(request.getContextPath() + origin);


    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists())
        uploadDir.mkdir();

    // 检查是否是多部分内容
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
                    if (!item.isFormField())
                    {
                        String filePath = uploadPath + File.separator + id;
                        File storeFile = new File(filePath);
                        item.write(storeFile);
                    }
                }
            }
        }
        catch (Exception ignored) { }
    }
%>