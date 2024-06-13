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

    public static<TElement> Counting<TElement>[] Count(TElement[] array)
    {
        Map<TElement, Long> counted = new HashMap<>();
        for (TElement element:array)
        {
            if(counted.containsKey(element))
                counted.put(element, 1L);
            else
            {
                long count = counted.get(element);
                counted.replace(element, ++count);
            }
        }
        List<Counting<TElement>> result = new ArrayList<>();
        counted.forEach((k,v) -> result.add(new Counting<TElement>(k,v)));
        return (Counting<TElement>[]) result.toArray();
    }
}
