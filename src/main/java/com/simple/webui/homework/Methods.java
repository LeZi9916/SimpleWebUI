package com.simple.webui.homework;

import javax.servlet.ServletContext;
import java.sql.*;
import java.util.Random;

public final class Methods
{
    public static String getErrMsg(int loginResult)
    {
        String errMsg = "";

        if(loginResult == LoginResult.LOGIN_UNKNOWN_PASSWORD_OR_USERID)
            errMsg = "Invalid UserID or Password.";
        else if(loginResult == LoginResult.REGISTER_PASSWORD_TOO_SHORT_OR_LONG)
            errMsg = "The password length does not meet the requirement: it should be between 6 and 20 characters";
        else if(loginResult == LoginResult.REGISTER_PASSWORD_NOT_MATCH)
            errMsg = "ReInput password do not match";
        else if(loginResult == LoginResult.UNKNOWN_ERROR)
            errMsg = "Internal error";
        return errMsg;
    }
    public static long generateUserId(Connection dbSession)
    {
        Random rd = new Random();
        while(true)
        {
            long id = rd.nextInt();
            if(id < 0)
                continue;
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
    public static  String getUserGroup(int userType)
    {
        switch (userType)
        {
            case 0:
                return "User";
            case 1:
                return "Merchant";
            case 2:
                return "Admin";
            case 3:
                return "Root";
            default:
                return "Unknown";
        }
    }
    public static Connection ConnectDb() throws SQLException, ClassNotFoundException
    {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection("jdbc:mysql://" + Info.SqlAddress + ":3306/" + Info.Db, Info.Username, Info.Password);
    }
    public static Connection checkDbAlive(ServletContext application)
    {
        try
        {
            Connection dbSession = (Connection) application.getAttribute("dbSession");
            if(dbSession == null)
            {
                dbSession = DriverManager.getConnection("jdbc:mysql://" + Info.SqlAddress + ":3306/" + Info.Db, Info.Username, Info.Password);
                application.setAttribute("dbSession",dbSession);
            }
            return dbSession;
        }
        catch (Exception ignored)
        {
            return null;
        }
    }
    public static boolean stringIsEmptyOrNull(String s)
    {
        return s == null || s.isEmpty();
    }
    public static <T extends IUpdatable>void update(T obj,Connection dbSession)
    {
        obj.update(dbSession);
    }
}
