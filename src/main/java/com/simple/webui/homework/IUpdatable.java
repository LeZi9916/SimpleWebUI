package com.simple.webui.homework;

import java.sql.Connection;

public interface IUpdatable
{
    void update(Connection dbSession);
}
