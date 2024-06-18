package com.simple.webui.homework;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserOrder
{
    long id;
    long source;
    long target;
    long itemId;
    int count;
    String userAddress;
    int state;
    public UserOrder(long id,long source,long target,long itemId,int count,String userAddress)
    {
        this.id = id;
        this.source = source;
        this.target = target;
        this.itemId = itemId;
        this.count = count;
        this.userAddress = userAddress;
        this.state = OrderState.NOT_SHIPPED;
    }
    public UserOrder(long id,long source,long target,long itemId,int count,String userAddress,int state)
    {
        this.id = id;
        this.source = source;
        this.target = target;
        this.itemId = itemId;
        this.count = count;
        this.userAddress = userAddress;
        this.state = state;
    }
    public long getId() { return  id; }
    public int getCount() {
        return count;
    }
    public int getState() {
        return state;
    }
    public long getItemId() {
        return itemId;
    }
    public long getSource() {
        return source;
    }
    public long getTarget() {
        return target;
    }
    public String getUserAddress() {
        return userAddress;
    }
    public void setState(int state) {
        this.state = state;
    }
    public void setUserAddress(String userAddress) {
        this.userAddress = userAddress;
    }
    public void update(Connection dbSession)
    {
        try
        {
            ResultSet result = dbSession.prepareStatement("SELECT * FROM UserOrder WHERE id=" + this.id)
                                        .executeQuery();
            String sql = "";
            if(result.isBeforeFirst()) // 已有记录
            {
                sql = "UPDATE UserOrder SET userAddress = ?, state = ? WHERE id = " + this.id;
                PreparedStatement statement = dbSession.prepareStatement(sql);
                statement.setString(1,this.userAddress);
                statement.setInt(2,this.state);
                int updated = statement.executeUpdate();
                if(updated <= 0)
                    System.out.println("Cannot update row into database");
            }
            else
            {
                sql = "INSERT INTO UserOrder (id,source,target,itemId,count,userAddress,state) VALUES (?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement statement = dbSession.prepareStatement(sql);
                statement.setLong(1,this.id);
                statement.setLong(2,this.source);
                statement.setLong(3,this.target);
                statement.setLong(4,this.itemId);
                statement.setInt(5,this.count);
                statement.setString(6,this.userAddress);
                statement.setInt(7,this.state);
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
    public static UserOrder[] getTargetOrders(Connection dbSession, long targetId)
    {
        try
        {
            List<UserOrder> orders = new ArrayList<>();
            ResultSet result = dbSession.prepareStatement("SELECT * FROM UserOrder WHERE target=" + targetId)
                                        .executeQuery();
            while(result.next())
                orders.add(UserOrder.deserialize(result));
            return orders.toArray(new UserOrder[0]);
        }
        catch (Exception e)
        {
            return null;
        }
    }
    public static UserOrder[] getSourceOrders(Connection dbSession, long sourceId)
    {
        try
        {
            List<UserOrder> orders = new ArrayList<>();
            ResultSet result = dbSession.prepareStatement("SELECT * FROM UserOrder WHERE source=" + sourceId)
                    .executeQuery();
            while(result.next())
                orders.add(UserOrder.deserialize(result));
            return orders.toArray(new UserOrder[0]);
        }
        catch (Exception e)
        {
            return null;
        }
    }
    public static UserOrder[] getItemOrders(Connection dbSession, long itemId)
    {
        try
        {
            List<UserOrder> orders = new ArrayList<>();
            ResultSet result = dbSession.prepareStatement("SELECT * FROM UserOrder WHERE itemId=" + itemId)
                    .executeQuery();
            while(result.next())
                orders.add(UserOrder.deserialize(result));
            return orders.toArray(new UserOrder[0]);
        }
        catch (Exception e)
        {
            return null;
        }
    }
    public static UserOrder[] getAllOrders(Connection dbSession)
    {
        try
        {
            List<UserOrder> orders = new ArrayList<>();
            ResultSet result = dbSession.prepareStatement("SELECT * FROM UserOrder")
                    .executeQuery();
            while(result.next())
                orders.add(UserOrder.deserialize(result));
            return orders.toArray(new UserOrder[0]);
        }
        catch (Exception e)
        {
            return null;
        }
    }
    public static UserOrder deserialize(Connection dbSession, long orderId)
    {
        try
        {
            ResultSet result = dbSession.prepareStatement("SELECT * FROM UserOrder WHERE id=" + orderId)
                                        .executeQuery();
            result.next();
            return deserialize(result);
        }
        catch (Exception e)
        {
            return null;
        }
    }
    public static UserOrder deserialize(ResultSet result)
    {
        try
        {
            return new UserOrder(result.getLong("id"),
                    result.getLong("source"),
                    result.getLong("target"),
                    result.getLong("itemId"),
                    result.getInt("count"),
                    result.getString("userAddress"),
                    result.getInt("state"));
        }
        catch (Exception e) {return  null;}
    }

}
