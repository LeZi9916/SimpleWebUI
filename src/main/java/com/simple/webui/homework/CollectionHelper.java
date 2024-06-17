package com.simple.webui.homework;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class CollectionHelper
{
    public static<TIn,TOut> Grouping<TOut,TIn>[] GroupBy(TIn[] array,
                                                         IMatcher<TIn,TOut> matcher,
                                                         TIn[] tempArray)
    {
        Map<TOut, List<TIn>> result = new HashMap<>();
        for (TIn element: array)
        {
            List<TIn> grouped;
            TOut key = matcher.Compare(element);
            if(result.containsKey(key))
                grouped = result.get(key);
            else
            {
                grouped = new ArrayList<>();
                result.put(key,grouped);
            }
            grouped.add(element);
            result.replace(key,grouped);
        }
        List<Grouping<TOut,TIn>> _result = new ArrayList<>();
        result.forEach((o,i) -> _result.add(new Grouping<>(o,i.toArray(tempArray))));
        return _result.toArray(new Grouping[0]);
    }
    public static<TElement> Counting<TElement>[] Count(TElement[] array)
    {
        Map<TElement, Long> counted = new HashMap<>();
        for (TElement element:array)
        {
            if(!counted.containsKey(element))
                counted.put(element, 1L);
            else
            {
                long count = counted.get(element);
                counted.replace(element, ++count);
            }
        }
        List<Counting<TElement>> result = new ArrayList<>();
        counted.forEach((k,v) -> result.add(new Counting<TElement>(k,v)));
        return (Counting<TElement>[]) result.toArray(new Counting[0]);
    }
    public static<TElement> TElement[] Where(TElement[] array,
                                             IMatcher<TElement,Boolean> matcher,
                                             TElement[] tempArray)
    {
        List<TElement> result = new ArrayList<>();
        for (TElement element:array)
            if(matcher.Compare(element))
                result.add(element);
        return result.toArray(tempArray);
    }
    public static<TElement> TElement[] Where(List<TElement> array,
                                             IMatcher<TElement,Boolean> matcher,
                                             TElement[] tempArray)
    {
        return Where(array.toArray(tempArray),matcher,tempArray);
    }
    public static<TIn,TOut> TOut[] Select(TIn[] array,
                                          IMatcher<TIn,TOut> matcher,
                                          TOut[] tempArray)
    {
        List<TOut> result = new ArrayList<>();
        for (TIn element:array)
            result.add(matcher.Compare(element));

        return result.toArray(tempArray);
    }
}
