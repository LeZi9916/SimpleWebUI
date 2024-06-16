package com.simple.webui.homework;

import javax.servlet.ServletContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
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
    public static long generateItemId(Connection dbSession)
    {
        Random rd = new Random();
        while(true)
        {
            long id = rd.nextInt();
            try
            {
                ResultSet result = dbSession.prepareStatement("SELECT * FROM Item WHERE id=" + id)
                        .executeQuery();
                if(!result.isBeforeFirst())
                    return id;
            }
            catch (Exception ignored) {   }
        }
    }
    public static  String getUserTypeStr(int userType)
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
            if(dbSession == null || dbSession.isClosed())
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
    public static User[] getAllUser(Connection dbSession)
    {
        try
        {
            List<User> result = new ArrayList<>();
            Statement statement = dbSession.createStatement();
            String sql = "SELECT * FROM User";
            ResultSet resultSet = statement.executeQuery(sql);
            while(resultSet.next())
                result.add(User.deserialize(resultSet));
            return result.toArray(new User[0]);
        }
        catch(Exception e){ return new User[0]; }
    }
    public static Item[] getAllItem(Connection dbSession,long parentId)
    {
        try
        {
            List<Item> result = new ArrayList<>();
            Statement statement = dbSession.createStatement();
            String sql = "SELECT * FROM Item WHERE parentId =" + parentId;
            ResultSet resultSet = statement.executeQuery(sql);
            while(resultSet.next())
                result.add(Item.deserialize(resultSet));
            return result.toArray(new Item[0]);
        }
        catch(Exception e) { return new Item[0]; }
    }
    public static Item[] getAllItem(Connection dbSession)
    {
        try
        {
            List<Item> result = new ArrayList<>();
            Statement statement = dbSession.createStatement();
            String sql = "SELECT * FROM Item";
            ResultSet resultSet = statement.executeQuery(sql);
            while(resultSet.next())
                result.add(Item.deserialize(resultSet));
            return result.toArray(new Item[0]);
        }
        catch(Exception e) { return new Item[0]; }
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
