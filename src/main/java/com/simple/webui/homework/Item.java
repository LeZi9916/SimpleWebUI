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
    long picId = 0;
    // 表示商品的Owner（店铺）
    long parentId;

    public Item(long id,String itemName,int count ,long picId,long parentId)
    {
        this.id = id;
        this.itemName = itemName;
        this.picId = picId;
        this.count = count;
        this.parentId = parentId;
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
    public Item clone(int count)
    {
        return new Item(this.id,this.itemName,count,this.picId,this.parentId);
    }
    public Item clone()
    {
        return clone(1);
    }
    public void update(Connection dbSession)
    {
        try
        {
            ResultSet result = dbSession.prepareStatement("SELECT * FROM ShopCart WHERE id=" + this.id)
                                        .executeQuery();
            String sql = "";
            if(result.isBeforeFirst())
            {
                sql = "UPDATE ShopCart SET itemName = ?, picId = ?,count = ? WHERE id = " + this.id;
                PreparedStatement statement = dbSession.prepareStatement(sql);
                statement.setString(1,this.itemName);
                statement.setLong(2,this.picId);
                statement.setInt(3,this.count);
                int updated = statement.executeUpdate();
                if(updated <= 0)
                    System.out.println("Cannot update row into database");
            }
            else
            {
                sql = "INSERT INTO ShopCart (id,itemName,count,picId,parentId) VALUES (?, ?, ?, ?)";
                PreparedStatement statement = dbSession.prepareStatement(sql);
                statement.setLong(1,this.id);
                statement.setString(2,this.itemName);
                statement.setInt(3,this.count);
                statement.setLong(4,this.picId);
                statement.setLong(5,this.parentId);
                int inserted = statement.executeUpdate();
                if(inserted <= 0)
                    System.out.println("Cannot insert row into database");
            }
        }
        catch(Exception e) {}
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
                            result.getLong("picId"),
                            result.getLong("parentId"));
        }
        catch (Exception e) { }
        return null;
    }
}
