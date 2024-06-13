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
    public static<TIn,TOut> Grouping<TOut,TIn>[] GroupBy(TIn[] array,IMatcher<TIn,TOut> matcher)
    {
        Map<TOut, List<TIn>> result = new HashMap<>();
        for (TIn element: array)
        {
            List<TIn> grouped;
            if(result.containsKey(array))
            {
                grouped = result.get(matcher.Compare(element));

            }
            else
                grouped = new ArrayList<>();
            grouped.add(element);
            result.replace(matcher.Compare(element),grouped);
        }
        List<Grouping<TOut,TIn>> _result = new ArrayList<>();
        result.forEach((o,i) -> _result.add(new Grouping<>(o,(TIn[]) i.toArray())));
        return (Grouping<TOut, TIn>[]) _result.toArray();
    }

}
