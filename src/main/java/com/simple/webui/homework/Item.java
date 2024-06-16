package com.simple.webui.homework;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class Item implements IUpdatable
{
    long id;
    String itemName;
    int count = 1;
    double price;
    long picId = 0;
    // 表示商品的Owner（店铺）
    long parentId;
    boolean enable = true;

    public Item(long id,String itemName,int count ,double price,long picId,long parentId,boolean isEnable)
    {
        this.id = id;
        this.itemName = itemName;
        this.price = price;
        this.picId = picId;
        this.count = count;
        this.parentId = parentId;
        this.enable = isEnable;
    }
    public long getId() { return id; }
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public long getPicId() { return picId; }
    public int getCount() { return count; }
    public void setCount(int count) { this.count = count; }
    public void setPicId(long picId) { this.picId = picId; }
    public long getParentId() { return parentId; }
    public void setParentId(long parentId) { this.parentId = parentId; }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public boolean isEnable()
    {
        return enable;

    }

    public void setEnable(boolean enable) {
        this.enable = enable;
    }

    public Item clone(int count)
    {
        return new Item(this.id,this.itemName,count,this.price,this.picId,this.parentId,true);
    }
    public Item clone()
    {
        return clone(1);
    }
    public void update(Connection dbSession)
    {
        try
        {
            ResultSet result = dbSession.prepareStatement("SELECT * FROM Item WHERE id=" + this.id)
                                        .executeQuery();
            String sql = "";
            if(result.isBeforeFirst())
            {
                sql = "UPDATE Item SET itemName = ?, picId = ?,count = ?,enable = ?, price = ? WHERE id = " + this.id;
                PreparedStatement statement = dbSession.prepareStatement(sql);
                statement.setString(1,this.itemName);
                statement.setLong(2,this.picId);
                statement.setInt(3,this.count);
                statement.setBoolean(4,this.enable);
                statement.setDouble(5,this.price);
                int updated = statement.executeUpdate();
                if(updated <= 0)
                    System.out.println("Cannot update row into database");
            }
            else
            {
                sql = "INSERT INTO Item (id,itemName,count,picId,parentId,price) VALUES (?, ?, ?, ?,?,?)";
                PreparedStatement statement = dbSession.prepareStatement(sql);
                statement.setLong(1,this.id);
                statement.setString(2,this.itemName);
                statement.setInt(3,this.count);
                statement.setLong(4,this.picId);
                statement.setLong(5,this.parentId);
                statement.setDouble(6,this.price);
                int inserted = statement.executeUpdate();
                if(inserted <= 0)
                    System.out.println("Cannot insert row into database");
            }
        }
        catch(Exception e)
        {
            return;
        }
    }
    public static Item deserialize(Connection dbSession, long targetId)
    {
        try
        {
            ResultSet result = dbSession.prepareStatement("SELECT * FROM Item WHERE id=" + targetId)
                                        .executeQuery();
            result.next();
            return new Item(targetId,
                            result.getString("itemName"),
                            result.getInt("count"),
                            result.getDouble("price"),
                            result.getLong("picId"),
                            result.getLong("parentId"),
                            result.getBoolean("enable"));
        }
        catch (Exception e) { }
        return null;
    }
    public static Item deserialize(ResultSet result)
    {
        try
        {
            return new Item(result.getLong("id"),
                            result.getString("itemName"),
                            result.getInt("count"),
                            result.getDouble("price"),
                            result.getLong("picId"),
                            result.getLong("parentId"),
                            result.getBoolean("enable"));
        }
        catch (Exception e) { }
        return null;
    }
}
