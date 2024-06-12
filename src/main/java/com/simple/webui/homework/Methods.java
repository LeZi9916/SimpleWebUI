package com.simple.webui.homework;

import java.sql.Connection;
import java.sql.ResultSet;
import java.util.Random;

public final class Methods
{
    public static String getErrMsg(int loginResult)
    {
        String errMsg = "";

        if(loginResult == LoginResult.LOGIN_UNKNOWN_PASSWORD_OR_USERID)
            errMsg = "Invalid UserID oe Password.";
        else if(loginResult == LoginResult.REGISTER_PASSWORD_TOO_SHORT_OR_LONG)
            errMsg = "The password length does not meet the requirement: it should be between 6 and 20 characters";
        else if(loginResult == LoginResult.REGISTER_PASSWORD_NOT_MATCH)
            errMsg = "ReInput password do not match";
        else if(loginResult == LoginResult.UNKNOWN_ERROR)
            errMsg = "Internal error";
        return errMsg;
    }
    public static long generateUserId(Connection dbSession)
    {
        Random rd = new Random();
        while(true)
        {
            long id = rd.nextLong();
            try
            {
                ResultSet result = dbSession.prepareStatement("SELECT * FROM User WHERE id=" + id)
                        .executeQuery();
                if(!result.isBeforeFirst())
                    return id;
            }
            catch (Exception ignored) {   }
        }
    }
}
