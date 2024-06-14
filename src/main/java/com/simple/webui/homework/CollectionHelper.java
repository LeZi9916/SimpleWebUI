package com.simple.webui.homework;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class CollectionHelper
{
    public static<TIn,TOut> Grouping<TOut,TIn>[] GroupBy(TIn[] array,
                                                         IMatcher<TIn,TOut> matcher)
    {
        Map<TOut, List<TIn>> result = new HashMap<>();
        for (TIn element: array)
        {
            List<TIn> grouped;
            TOut key = matcher.Compare(element);
            if(result.containsKey(key))
                grouped = result.get(key);
            else
                grouped = new ArrayList<>();
            grouped.add(element);
            result.replace(key,grouped);
        }
        List<Grouping<TOut,TIn>> _result = new ArrayList<>();
        result.forEach((o,i) -> _result.add(new Grouping<>(o,(TIn[]) i.toArray())));
        return (Grouping<TOut, TIn>[]) _result.toArray(new Grouping[0]);
    }
    public static <TIn,TOut> Grouping<TOut,TIn>[] GroupBy(List<TIn> array,
                                                          IMatcher<TIn,TOut> matcher)
    {
        return GroupBy((TIn[])array.toArray(),matcher);
    }
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
        return (Counting<TElement>[]) result.toArray(new Counting[0]);
    }
    public static<TElement> Counting<TElement>[] Count(List<TElement> array)
    {
        return Count((TElement[])array.toArray());
    }
    public static<TElement> TElement[] Where(TElement[] array,
                                             IMatcher<TElement,Boolean> matcher)
    {
        List<TElement> result = new ArrayList<>();
        for (TElement element:array)
            if(matcher.Compare(element))
                result.add(element);
        return (TElement[]) result.toArray();
    }
    public static<TElement> TElement[] Where(List<TElement> array,
                                             IMatcher<TElement,Boolean> matcher)
    {
        return Where((TElement[])array.toArray(),matcher);
    }
    public static<TIn,TOut> TOut[] Select(TIn[] array,
                                          IMatcher<TIn,TOut> matcher)
    {
        List<TOut> result = new ArrayList<>();
        for (TIn element:array)
            result.add(matcher.Compare(element));

        return (TOut[]) result.toArray();
    }
    public static <TIn,TOut> TOut[] Select(List<TIn> array,
                                           IMatcher<TIn,TOut> matcher)
    {
        return  Select((TIn[]) array.toArray(),matcher);
    }
}
