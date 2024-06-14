package com.simple.webui.homework;

public interface IMatcher<TIn,TOut>
{
    TOut Compare(TIn input);
}
