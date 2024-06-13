package com.simple.webui.homework;

import java.util.*;
public class Counting<T>
{
    T key;
    long count = 0;
    public Counting(T key,long count)
    {
        this.key = key;
        this.count = count;
    }
    public T getKey() { return key; }
    public long getCount() { return count; }
}
