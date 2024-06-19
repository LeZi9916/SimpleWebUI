<%@ page import="com.simple.webui.homework.User" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="java.util.List" %>
<%@ page import="java.io.File" %>
<%@ page import="com.simple.webui.homework.Item" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.simple.webui.homework.Methods" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.StandardCopyOption" %>
<%@ page import="java.nio.file.Path" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
    boolean isValidJPEG(File file)
    {
        try (InputStream input = new FileInputStream(file))
        {
            byte[] header = new byte[2];
            if (input.read(header) != 2) {
                return false;
            }
            int soi = ((header[0] & 0xFF) << 8) | (header[1] & 0xFF);
            return soi == 0xFFD8;
        }
        catch (Exception e)
        {
            return false;
        }
    }
%>
<%


    request.setCharacterEncoding("UTF-8");
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

    try
    {
        String _isCreate = null;
        String _itemId = null;
        String originUrl = "";
        String uploadType = null;
        String uploadPath = "";

        String name = null;
        String _price = null;
        String _count = null;
        String _enable = null;

        Connection dbSession = Methods.checkDbAlive(application);
        FileItem uploadItem = null;
        Item targetItem = null;
        if (ServletFileUpload.isMultipartContent(request))
        {
            try
            {
                DiskFileItemFactory factory = new DiskFileItemFactory();
                ServletFileUpload upload = new ServletFileUpload(factory);

                List<FileItem> formItems = upload.parseRequest(request);

                if (formItems != null && !formItems.isEmpty())
                {
                    for (FileItem item : formItems)
                    {
                        if (item.isFormField())
                        {
                            if( "isCreate".equals(item.getFieldName()))
                                _isCreate = item.getString();
                            else if("itemId".equals(item.getFieldName()))
                                _itemId = item.getString();
                            else if("originUrl".equals(item.getFieldName()))
                                originUrl = item.getString();
                            else if("uploadType".equals(item.getFieldName()))
                                uploadType = item.getString();
                            else if("name".equals(item.getFieldName()))
                                name = item.getString();
                            else if("price".equals(item.getFieldName()))
                                _price = item.getString();
                            else if("count".equals(item.getFieldName()))
                                _count = item.getString();
                            else if("enable".equals(item.getFieldName()))
                                _enable = item.getString();
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

        boolean isCreate = Boolean.parseBoolean(_isCreate);
        long itemId = Long.parseLong(_itemId);
        Double price = Methods.stringIsEmptyOrNull(_price) ? null: Double.parseDouble(_price);
        Integer count = Methods.stringIsEmptyOrNull(_count) ? null : Integer.parseInt(_count);
        Boolean enable = Methods.stringIsEmptyOrNull(_enable) ? null : Boolean.parseBoolean(_enable);

        if(isCreate)
            targetItem = new Item(itemId,name,count,price,0, operator.getId(),enable);
        else
            targetItem = Item.deserialize(dbSession,itemId);

        if(uploadItem != null)
        {
            uploadPath = application.getRealPath("") + File.separator + "pic" + File.separator + "item";
            String tempPath = uploadPath + File.separator + targetItem.getId() + "_temp.jpg";
            String filePath = uploadPath + File.separator + targetItem.getId() + ".jpg";
            File tempFile = new File(tempPath);
            if(tempFile.exists())
                tempFile.delete();
            uploadItem.write(tempFile);
            if(isValidJPEG(tempFile))
            {
                Files.copy(Paths.get(tempPath),Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
                targetItem.setPicId(targetItem.getId());
            }
        }
        if (!Methods.stringIsEmptyOrNull(name))
            targetItem.setItemName(name);
        if(price != null)
            targetItem.setPrice(price);
        if (count != null)
            targetItem.setCount(count);
        if (enable != null)
            targetItem.setEnable(enable);
        targetItem.update(dbSession);
        response.sendRedirect(request.getContextPath() + originUrl);
        return;
    }
    catch(Exception e )
    {
        e.toString();
        response.sendRedirect(request.getContextPath() + "/Admin/index.jsp");
        return;
    }



%>