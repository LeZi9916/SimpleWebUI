package com.simple.webui.homework;

public class ShopCart
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
    public void setItems(long[] items) { this.items = items; }
    public void addItem(long itemId)
    {
        long[] newItems = new long[items.length + 1];
        System.arraycopy(items, 0, newItems, 0, items.length);
        newItems[items.length] = itemId;
        items = newItems;
    }
}
