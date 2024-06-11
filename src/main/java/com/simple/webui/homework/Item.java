package com.simple.webui.homework;

public class Item
{
    long id;
    String itemName;
    long picId;
    long parentId;

    public Item(long id,String itemName,long picId,long parentId)
    {
        this.id = id;
        this.itemName = itemName;
        this.picId = picId;
        this.parentId = parentId;
    }
    public long getId() { return id; }
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public long getPicId() { return picId; }
    public void setPicId(long picId) { this.picId = picId; }
    public long getParentId() { return parentId; }
    public void setParentId(long parentId) { this.parentId = parentId; }
}
