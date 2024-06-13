package com.simple.webui.homework;

public interface IMatcher<TInput,TOutput>
{
    TOutput Compare(TInput input);
}
