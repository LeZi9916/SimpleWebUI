package com.simple.webui.homework;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Grouping<TKey, TElement>
{
    TKey key;
    TElement[] items;
    public Grouping(TKey key, TElement[] items)
    {
        this.key = key;
        this.items = items;
    }
    public TKey getKey() { return key; }
    public TElement[] getItems() { return items; }

}
