package com.simple.webui.homework;

import com.sun.media.sound.InvalidDataException;

import javax.servlet.http.HttpSession;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.ResultSet;
import java.time.ZonedDateTime;
import java.util.Base64;

public class User
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
    public void setUserType(int type) throws InvalidDataException
    {
        if(type > UserType.ROOT || type < UserType.USER)
            throw new InvalidDataException("Unknown UserType:" + type);
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
            return new User(targetId,
                            result.getString("name"),
                            result.getString("username"),
                            result.getString("password"),
                            result.getLong("picId"),
                            result.getInt("userType"));
        }
        catch (Exception e) { }
        return null;
    }
    public void update(HttpSession session)
    {
        sessionId = session.getId();
        session.setAttribute("user",this);
    }
    public void update(Connection dbSession)
    {

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
