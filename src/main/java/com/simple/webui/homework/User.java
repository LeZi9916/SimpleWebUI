package com.simple.webui.homework;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.ZonedDateTime;
import java.util.Base64;

public class User implements IUpdatable
{
    long id;
    String name;
    String username;
    String password;
    long picId = 0;
    int userType = 0;
    String sessionId;

    public User(long id, String name, String username,String password, long picId, int userType)
    {
        this.id=id;
        this.name=name;
        this.username=username;
        this.password = password;
        this.picId=picId;
        this.userType=userType;
    }
    public long getId() { return id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public int getUserType() { return userType; }
    public void setUserType(int type) throws Exception
    {
        if(type > UserType.ROOT || type < UserType.USER)
            throw new Exception("Unknown UserType:" + type);
        this.userType = type;
    }
    public long getPicId() { return picId; }
    public void setPicId(long picId) { this.picId = picId; }
    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }
    public void setPassword(String newPwd) { password = newPwd; }
    public boolean comparePassword(String pwd) { return password.equals(pwd); }
    public boolean promote()
    {
        if(userType >= UserType.ROOT)
            return false;
        else
            userType++;
        return true;
    }
    public boolean demote()
    {
        if(userType <= UserType.USER)
            return false;
        else
            userType--;
        return false;
    }

    @Override
    public boolean equals(Object obj)
    {
        try
        {
            User user = (User)obj;
            return user.id == this.id;
        }
        catch(Exception e)
        {
            return false;
        }
    }
    public static User deserialize(Connection dbSession,long targetId)
    {
        try
        {
            ResultSet result = dbSession.prepareStatement("SELECT * FROM User WHERE id=" + targetId)
                                        .executeQuery();
            result.next();
            return new User(targetId,
                            result.getString("name"),
                            result.getString("username"),
                            result.getString("password"),
                            result.getLong("picId"),
                            result.getInt("userType"));
        }
        catch (Exception e)
        {
            return null;
        }
    }
    public static User deserialize(ResultSet result)
    {
        try
        {
            return new User(result.getLong("id"),
                    result.getString("name"),
                    result.getString("username"),
                    result.getString("password"),
                    result.getLong("picId"),
                    result.getInt("userType"));
        }
        catch (Exception e) {return  null;}
    }
    public void update(HttpSession session, ServletContext application)
    {
        sessionId = session.getId();
        String userId = ((Long)(this.id)).toString();
        String loginSessionId = (String) application.getAttribute(userId);

        application.setAttribute(userId,sessionId);
        session.setAttribute("user",this);
        session.setAttribute("userId",this.id);
    }
    public boolean checkPermission(int target) { return  this.userType >= target; }
    public void logout(HttpSession session, ServletContext application)
    {
        String userId = ((Long)(this.id)).toString();
        application.setAttribute(userId,null);
        session.setAttribute("user",null);
        session.setAttribute("userId",null);
    }
    public void update(Connection dbSession)
    {
        try
        {
            ResultSet result = dbSession.prepareStatement("SELECT * FROM User WHERE id=" + this.id)
                                        .executeQuery();
            String sql = "";
            if(result.isBeforeFirst()) // 已有记录
            {
                sql = "UPDATE User SET name = ?, username = ? ,password = ?,picId = ? ,userType = ? WHERE id = " + this.id;
                PreparedStatement statement = dbSession.prepareStatement(sql);
                statement.setString(1,this.name);
                statement.setString(2,this.username);
                statement.setString(3,this.password);
                statement.setLong(4,this.picId);
                statement.setInt(5,this.userType);
                int updated = statement.executeUpdate();
                if(updated <= 0)
                    System.out.println("Cannot update row into database");
            }
            else
            {
                sql = "INSERT INTO User (id,name,username,password,picId,userType) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement statement = dbSession.prepareStatement(sql);
                statement.setLong(1,this.id);
                statement.setString(2,this.name);
                statement.setString(3,this.username);
                statement.setString(4,this.password);
                statement.setLong(5,this.picId);
                statement.setInt(6,this.userType);
                int inserted = statement.executeUpdate();
                if(inserted <= 0)
                    System.out.println("Cannot insert row into database");
            }
        }
        catch (Exception e)
        {
            System.out.println(e);
        }
    }
    public static String getStrHash(String s)
    {
        try
        {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(s.getBytes());
            byte[] hash = md.digest();

            return Base64.getEncoder().encodeToString(hash);
        }
        catch(Exception e)
        {
            return null;
        }
    }
}
