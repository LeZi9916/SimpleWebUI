package com.simple.webui.homework;

import com.sun.media.sound.InvalidDataException;

public class User
{
    long id;
    String name;
    String username;
    int userType;

    public User()
    {

    }
    public long getId() { return id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public int getUserType() { return userType; }
    public void setUserType(int type) throws InvalidDataException
    {
        if(type > UserType.Root || type < UserType.User)
            throw new InvalidDataException("Unknown UserType:" + type);
        this.userType = type;
    }
    public boolean promote()
    {
        if(userType >= UserType.Root)
            return false;
        else
            userType++;
        return true;
    }
    public boolean demote()
    {
        if(userType <= UserType.User)
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
}
