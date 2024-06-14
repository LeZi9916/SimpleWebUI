package com.simple.webui.homework;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ShopCart implements IUpdatable
{
    // Same of user id
    long id;
    long[] items = {};

    public ShopCart(long id, long[] items)
    {
        this.id = id;
        this.items = items;
    }
    public long getId() { return id; }
    public long[] getItems() { return items; }
    public Long[] getBoxedItems()
    {
        Long[] result = new Long[items.length];
        for (int i = 0; i < result.length; i++)
            result[i] = items[i];
        return result;
    }
    public void setItems(long[] items) { this.items = items; }
    public void addItem(long itemId)
    {
        long[] newItems = new long[items.length + 1];
        System.arraycopy(items, 0, newItems, 0, items.length);
        newItems[items.length] = itemId;
        items = newItems;
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
                sql = "UPDATE ShopCart SET items = ? WHERE id = " + this.id;
                PreparedStatement statement = dbSession.prepareStatement(sql);
                statement.setString(1,new ObjectMapper().writeValueAsString(items));
                int updated = statement.executeUpdate();
                if(updated <= 0)
                    System.out.println("Cannot update row into database");
            }
            else
            {
                sql = "INSERT INTO ShopCart (id,items) VALUES (?, ?)";
                PreparedStatement statement = dbSession.prepareStatement(sql);
                statement.setLong(1,this.id);
                statement.setString(2,new ObjectMapper().writeValueAsString(items));
                int inserted = statement.executeUpdate();
                if(inserted <= 0)
                    System.out.println("Cannot insert row into database");
            }
        }
        catch(Exception e) {}
    }
    public static ShopCart deserialize(Connection dbSession,long targetId)
    {
        try
        {
            ResultSet result = dbSession.prepareStatement("SELECT * FROM ShopCart WHERE id=" + targetId)
                                        .executeQuery();
            result.next();
            return new ShopCart(targetId, new ObjectMapper().readValue(result.getString("items"), long[].class));
        }
        catch (Exception e) { }
        return new ShopCart(targetId,new long[] {});
    }
}
