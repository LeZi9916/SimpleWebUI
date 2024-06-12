<%@ page import="com.simple.webui.homework.User" %>
<%@ page import="static com.simple.webui.homework.Methods.getErrMsg" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.simple.webui.homework.User" %>
<%@ page import="com.simple.webui.homework.LoginResult" %>
<%@ page import="com.simple.webui.homework.Info" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object _userId = session.getAttribute("userId");
    if (_userId != null) {
        long userId = (long) _userId;
        User user = (User) session.getAttribute("user");
        if (user != null)
            response.sendRedirect(request.getContextPath() + "/Admin/index.jsp");
    }
%>
<%
    try
    {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String _id = request.getParameter("userId");
        String pwd = request.getParameter("password");
        if(_id != null && pwd != null)
        {
            long id  = Long.parseLong(_id);
            String hash = User.getStrHash(pwd);
            Connection dbSession = (Connection) application.getAttribute("dbSession");
            if(dbSession == null)
            {
                dbSession = DriverManager.getConnection("jdbc:mysql://" + Info.SqlAddress + ":3306/" + Info.Db, Info.Username, Info.Password);
                application.setAttribute("dbSession",dbSession);
            }

            User user = User.deserialize(dbSession,id);
            if(user == null || !user.comparePassword(hash))
                request.setAttribute("loginResult", LoginResult.LOGIN_UNKNOWN_PASSWORD_OR_USERID);
            else
            {
                user.update(session);
                response.sendRedirect(request.getContextPath() + "/Admin/index.jsp");
            }
        }

    }
    catch(Exception e)
    {

        request.setAttribute("loginResult", LoginResult.UNKNOWN_ERROR);
        throw e;
    }
%>
<!DOCTYPE html>
<html dir="ltr" lang="zh-CN">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login - Neko WebUI</title>
    <style>.login-action-lostpassword #login_error {
        display: none
    }</style>
    <meta name="robots" content="max-image-preview:large, noindex, noarchive">
    <link rel="dns-prefetch" href="https://use.fontawesome.com/">
    <link rel="stylesheet" id="wpacu-combined-css-head-1"
          href="./login_files/head-bcde979f757fb544bf2abf7ac72fc14e6ac6a269.css" type="text/css" media="all">
    <style type="text/css" data-wpacu-inline-css-file="1">/*! This file is auto-generated */
    body.rtl, body.rtl .press-this a.wp-switch-editor {
        font-family: Tahoma, Arial, sans-serif
    }

    .rtl h1, .rtl h2, .rtl h3, .rtl h4, .rtl h5, .rtl h6 {
        font-family: Arial, sans-serif;
        font-weight: 600
    }

    body.locale-he-il, body.locale-he-il .press-this a.wp-switch-editor {
        font-family: Arial, sans-serif
    }

    .locale-he-il em {
        font-style: normal;
        font-weight: 600
    }

    .locale-zh-cn #local-time, .locale-zh-cn #utc-time, .locale-zh-cn .form-wrap p, .locale-zh-cn .howto, .locale-zh-cn .inline-edit-row fieldset span.checkbox-title, .locale-zh-cn .inline-edit-row fieldset span.title, .locale-zh-cn .js .input-with-default-title, .locale-zh-cn .link-to-original, .locale-zh-cn .tablenav .displaying-num, .locale-zh-cn p.description, .locale-zh-cn p.help, .locale-zh-cn p.install-help, .locale-zh-cn span.description {
        font-style: normal
    }

    .locale-zh-cn .hdnle a {
        font-size: 12px
    }

    .locale-zh-cn form.upgrade .hint {
        font-style: normal;
        font-size: 100%
    }

    .locale-zh-cn #sort-buttons {
        font-size: 1em !important
    }

    .locale-de-de #customize-header-actions .button, .locale-de-de-formal #customize-header-actions .button {
        padding: 0 5px 1px
    }

    .locale-de-de #customize-header-actions .spinner, .locale-de-de-formal #customize-header-actions .spinner {
        margin: 16px 3px 0
    }

    .locale-ru-ru #adminmenu {
        width: inherit
    }

    .locale-ru-ru #adminmenu, .locale-ru-ru #wpbody {
        margin-left: 0
    }

    .locale-ru-ru .inline-edit-row fieldset label span.title, .locale-ru-ru .inline-edit-row fieldset.inline-edit-date legend {
        width: 8em
    }

    .locale-ru-ru .inline-edit-row fieldset .timestamp-wrap, .locale-ru-ru .inline-edit-row fieldset label span.input-text-wrap {
        margin-left: 8em
    }

    .locale-ru-ru.post-new-php .tagsdiv .newtag, .locale-ru-ru.post-php .tagsdiv .newtag {
        width: 165px
    }

    .locale-ru-ru.press-this .posting {
        margin-right: 277px
    }

    .locale-ru-ru .press-this-sidebar {
        width: 265px
    }

    .locale-ru-ru #customize-header-actions .button {
        padding: 0 5px 1px
    }

    .locale-ru-ru #customize-header-actions .spinner {
        margin: 16px 3px 0
    }

    .locale-lt-lt .inline-edit-row fieldset label span.title, .locale-lt-lt .inline-edit-row fieldset.inline-edit-date legend {
        width: 8em
    }

    .locale-lt-lt .inline-edit-row fieldset .timestamp-wrap, .locale-lt-lt .inline-edit-row fieldset label span.input-text-wrap {
        margin-left: 8em
    }

    @media screen and (max-width: 782px) {
        .locale-lt-lt .inline-edit-row fieldset .timestamp-wrap, .locale-lt-lt .inline-edit-row fieldset label span.input-text-wrap, .locale-ru-ru .inline-edit-row fieldset .timestamp-wrap, .locale-ru-ru .inline-edit-row fieldset label span.input-text-wrap {
            margin-left: 0
        }
    }</style>
    <link data-wpacu-to-be-preloaded-basic="1" rel="stylesheet" id="font-awesome-official-css"
          href="./login_files/all.css" type="text/css" media="all"
          integrity="sha384-blOohCVdhjmtROpu8+CfTnUWham9nkX7P7OZQMst+RUnhtoY/9qemFAkIKOYxDI3" crossorigin="anonymous">
    <link data-wpacu-to-be-preloaded-basic="1" rel="stylesheet" id="font-awesome-official-v4shim-css"
          href="./login_files/v4-shims.css" type="text/css" media="all"
          integrity="sha384-IqMDcR2qh8kGcGdRrxwop5R2GiUY5h8aDR/LhYxPYiXh3sAAGGDkFvFqWgFvTsTd" crossorigin="anonymous">
    <script type="text/javascript" src="./login_files/jquery.min.js.下载"></script>
    <link href="https://fonts.lug.ustc.edu.cn/css?family=Noto+Serif+SC&amp;display=swap" rel="stylesheet">
    <style>body {
        font-family: "Noto Serif SC", "Source Han Serif SC", "Source Han Serif", "source-han-serif-sc", "PT Serif", "SongTi SC", "MicroSoft Yahei", Georgia, serif !important
    }</style>
    <meta name="referrer" content="strict-origin-when-cross-origin">
    <meta name="viewport" content="width=device-width">
    <link rel="icon"
          href="https://leziblog.com/wp-content/uploads/2023/01/cropped-1674400634-QQ%E5%9B%BE%E7%89%8720230122231613-32x32.jpg"
          sizes="32x32">
    <link rel="icon"
          href="https://leziblog.com/wp-content/uploads/2023/01/cropped-1674400634-QQ%E5%9B%BE%E7%89%8720230122231613-192x192.jpg"
          sizes="192x192">
    <link rel="apple-touch-icon"
          href="https://leziblog.com/wp-content/uploads/2023/01/cropped-1674400634-QQ%E5%9B%BE%E7%89%8720230122231613-180x180.jpg">
    <meta name="msapplication-TileImage"
          content="https://leziblog.com/wp-content/uploads/2023/01/cropped-1674400634-QQ图片20230122231613-270x270.jpg">
    <link rel="stylesheet" href="chrome-extension://mbklgpngoohbbagagdfoccaclpdhgihd/css/index.css">
    <style>.one-pan-tip {
        cursor: pointer;
    }

    .one-pan-tip::before {
        background-position: center;
        background-size: 100% 100%;
        background-repeat: no-repeat;
        box-sizing: border-box;
        width: 1em;
        height: 1em;
        margin: 0 1px .15em 1px;
        vertical-align: middle;
        display: inline-block;
    }

    .one-pan-tip-success::before {
        content: '';
        background-image: url(data:image/png;base64,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)
    }

    .one-pan-tip-error {
        text-decoration: line-through;
    }

    .one-pan-tip-error::before {
        content: '';
        background-image: url(data:image/png;base64,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)
    }

    .one-pan-tip-other::before {
        content: '';
        background-image: url(data:image/png;base64,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)
    }

    .one-pan-tip-lock::before {
        content: '';
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAAK/0lEQVR4Xu1de4wddRX+ztztvX3C7gylZduyO1cIhIAJxhoNSuSVECkgCpQ/ECFCg41NRF47d8FcsXunLSSiiAjxDRoBQQ1Ew6NgKBpREhWUSrrO7NJSEPbOpbTQ7muOmaWt2+59zMydKTPM2X/v+b5zft/59tyZuTO/IchfphWgTK9eFg8xQMZNIAYQA2RcgYwvXyaAGCDjCmR8+TIBxAAZVyDjy5cJIAbIuAIZX75MADFAxhXI+PJlAogBMq5AxpcvEyBmA6hq+bDJeRMLFZpczDloCrCQgEVM2ENMIwz39XF0DO+0Xx4EHpyMuZwZ9GKAiBWf13v94gLNWgHi0wk4E6CFflIwMAbmzSD8GcwbJ8Znb3x7W9nxg20nRgzQjnr7satmdRXVi4mVLwA4iwhKu7TMcInwNFzcV30n/yu8Wd7VLmc9vBigHVW7y3O1/OiVIOoD4ah2qJpjeSeAu0bfxW27XjffjDKPGCCkmmpv30oiuh1Ei0NSBIcx9jBwhzOaL2N7+d3gBDMRYoCAKmpL+5cgzz8FcEZAaHThzNsnWVn91tDAb9slFQMEUFAr9p3JrNxPBDUALLZQl/m7NbtwLVAeC5tEDOBTOVUvXQvwrUSUNM2ep/GJ80e2btjucykHhCVtMWHWEDumSy+tVQj9sScKnYDf4EnlAmd44E9BKcQALRTr0o0BhagUVNhDHc/ABNg9x7HXPR4ktxigiVpar/FFKPSTIIK+r7HM78DNLa8Or93stw4xQAOlOntKpykKP0FEOb9iJiGOga3jo3zyzlfNqp96xAB1VJr/oeuOzLv5zZEe7TPvZoJFTIMM3rI3bReIVDCWALw8sgNM5j9U7cIZQNltZQIxQJ1rI2rR2ESgU1qJ1+pzZrzA4EeJlUecoYHnAHAjzOE9N+m5nHsZGFcQoacVd6vPmXmtY5s3t4oTAxykkKb3fQWk3NFKuEafMzMD9DAm+evOK+ZLIXhI6zXOZwW3EOikEPgpCDNPEuPE6pD572YcYoBp6izoLh+Rnz1mA5gfRnhmPDMOZdVOe+3LYfAHYzp7+8/Pkfs9EHWH4WPwHx3L/KQYwKd6ql66mwirfIYfGMb886pduBwoT4TCNwDN00uLCsDjRPhwGF5m92LHXvdgI6xMgL3KqN39y1Bw7TBH/QyUHavyjTAN8oXxfnUsjP0ShHN9xU8LYvBLjmWe2Oj4QwywzwC6cQ8RXRVC4Nsdy7wmKC5w/DFrCpq7wLvS95GgWGasdOzKA/VwYgBPlUXXzdPm5kdAmB1EXO8737G3nH6obuU6YtkN3W5Hx4vBT0/5qapl1v31UgwAQC0aVxDoR0GaD/Cb42OF4w/FbVvT69KKJa+RTwapderMZGzyaOfVDdsOxokBPAPoJe8g66wgorrg1TXLvCsIJqpYtVh6mIALgvC5Lt9YGzI3iAFmqFbu0IqjuwAq+BeUB6vW4PGHavQfXFdnb1+vQjQY5ICVGY85duVsMcBBCnTpxqcUomf8Nx9g173EGVp3fxBM1LFq4INWHq1ahfkHn6Zm/iugq2j0KSDTb4O827edsd2d2Pat3X4xccQd3tN3ekdO2RiEewK0fIc18Px0TOYNoOnGz0Dk3c7t64/Bv3Ms8xxfwbEGXZRTi8c6BBzmN80k82Vv2ea9YoBpCmi68RcQLfcrouvSl2tDA9/3Gx9nnFos/ZiAy/3mcJkrNds84M6mzE8AVTdGiEjzKyLgfqxqrfur//j4Irv00vUKYcaRfaOMzHy/Y5uXyASYpoCqG26g3+HHaGl128Cr8bXVP3OXXrpUIRww0puhGfi9Y1U+IwbYp8DSa+Zo+Tm+H7DwLqg4tundIdTwd33/7Ws/MuhFoXq/Dmb7K2DpNXPU/Jwb/baCXeyuDVXW+42PO27qQVRl1tV+87DLr9WGzLtlAvhVLANx2Z4AGWhwqyWKAVop9AH/XAzwAW9wq+U1NcDcntJRsxX+GgG+L5S0SvhB/ZxB/53a3WOCHwt5M+j7Ik1DA2i6cRMINwX7lex9WUPykjLuq3L+KgyV9ySvuAMrqmsATS+tAeE7SS8+yfUx4wHHrqxMco1ebTMM4N12xLNylvznt986F3xuzTIfbZ8pPoYZBtB6SxUoMOJLmR1mZt7k2OapSV7xTAPoxtMg+nSSi05Lbd4j245VySfl0nE93WYYQNVL/wj7EEJaGnMo63Qx2Vmz1u84lDmD5JppgKLxQjvPpAVJnoVYMUAWutxkjWIAMYB8BWTZAzIBstx9AGKAiAzgnVIR+BkwNjJokInfJabjAHyCwGeDaF5EqSKlEQO0Kae3azYDd47v5m823Cj5vTt7rgbzzUTU1WbKSOFigDbkZPC46yoX+d0TVz3aOIE68DRAR7aRNlKoGCCknN4NmOQqn68OD/w6CIXWaxzPCj0X5IGJIPxBY8UAQRXbH88bqpbp+4bN6Wmm9tZR+DehU0cIFAOEEJMZjjOaX9bOnvhqsbSJgKYbJIUoLTBEDBBYsqktzn7o2OaVIaD7IapufImIftAORxRYMUAIFZvtaeOXTl1yw1IqdGz1Gx9XnBgglLKRPH9Hqm5MBnrsK1StzUFigBCiuuM4qba18s8Q0AMgWrHkvWwp1KaP7ebehxcDhFDSZTqvZg88EgK6H7JgiaHlCzTSDkcUWDFACBVdxg01u3JrCOh+SJitX9rJ1wgrBgihKjP+7tiVk0NA90M0vXQnCKvb4YgCKwYIqaLLfGrNNjeFgneX56qzR7cT6PBQ+AhBYoCQYjJjM3bkP+445beDUmh66V4QLg2KiyNeDNCGqsz8pJPbtQKDd4z6pQm665df3rBxYoCwyu3FMfhFhruiZq1/pSnVMWsKqrvgIQISsIPX/ysVA7RpAA/OjGHHrvQ2o3rviaaOROzdM71OMUAEBvA2Zq5aZtPf+MUA4YROyXMBYoBw7W2NEgO01qitCPkKaEu+fWCZAJHIWIdEJkBcyu7llQkQicAyASKRUSZAXDI25pUJEInmMgEikVEmQFwyygSIWVmZAHEJLGcBcSkrZwFRKisTIEo1p3PJBIhLWZkA0SnLwIhjVRY2Y9SW9i9Bnme8GTO6KsIxyWlgON1moFoJ2dlTOi2Xw1MRpYuMplXdkSUKSZSSrwDvHS10oWMNPNRonapeuoUIN4fUITaYGCAiaZl5yBnfc0K9FzZ26v09ObibQTQnonSR0YgBIpNy6tagv41TbuXb1tot+2g79f5TFeJfELAkylRRcYkBolJyL4+3ZQyIt4HxGgE9IFoccYpI6cQAkcqZPjIxQPp6FmnFYoBI5UwfmRggfT2LtGIxQKRypo8sdQbQiiXvzdgfTZ/Uyay4ao3kgXvGk1ldnXcGqbrxIBFdmNSC01UXv1G1zEVJrnnmK2OKxucAanjJNcmLSVptDHzbsSpfTVpd0+up+9o4tWg8S6BTklx40mtjxltjythxu/5z2xtJrrWuAbqKNx5NyD1LwLIkF5/Y2hh7GDjPsStPJLbGvYU1fHPo/MXGwsIcKgP8WRB1J30hSahvan9j4BGedEvOK+v/lYSaWtXg6+XR3pO3E7ncsYC3PvlrpABzx/CO4bV2mhSShqapWzHUKgaIQdQ0UYoB0tStGGoVA8QgapooxQBp6lYMtYoBYhA1TZRigDR1K4ZaxQAxiJomSjFAmroVQ61igBhETROlGCBN3YqhVjFADKKmiVIMkKZuxVCrGCAGUdNEKQZIU7diqFUMEIOoaaIUA6SpWzHU+j/g27C9M416QQAAAABJRU5ErkJggg==)
    }</style>
    <meta name="ljjc::status" content="on">
</head>

<body class="login js login-action-login wp-core-ui  locale-zh-cn" style="zoom: 1;">
<div class="loading" style="display: none;">
    <img src="./login_files/login_loading.gif" width="58" height="10">
</div>
<script type="text/javascript">/* <![CDATA[ */
document.body.className = document.body.className.replace('no-js', 'js');
/* ]]> */
</script>
<div id="login">
    <div style="height:50px"></div>
    <%
        Object _loginResult = request.getAttribute("loginResult");
        if(_loginResult != null)
        {
    %>
    <div id="login_error" class="notice notice-error"><%=getErrMsg((int)_loginResult)%></div>
    <%
        }
    %>
    <h1>
        Login
    </h1>
    <form name="loginform" id="loginform" action="login.jsp" method="post">
        <p>
            <label for="user_login">用户ID</label>
            <input type="text" name="userId" id="user_login" class="input" value="" size="20" autocapitalize="off"
                   autocomplete="username" required="required">
        </p>
        <div class="user-pass-wrap">
            <label for="user_pass">密码</label>
            <div class="wp-pwd">
                <input type="password" name="password" id="user_pass" class="input password-input" value="" size="20"
                       autocomplete="current-password" spellcheck="false" required="required">
                <button type="button" class="button button-secondary wp-hide-pw hide-if-no-js" data-toggle="0"
                        aria-label="显示密码">
                    <span class="dashicons dashicons-visibility" aria-hidden="true"></span>
                </button>
            </div>
        </div>
        <p>
        </p>
        <p>
        </p>
        <p class="submit">
            <input type="submit" name="wp-submit" id="wp-submit" class="button button-primary button-large"
                   value="登录">
        </p>
    </form>
    <p id="nav">
        <a class="wp-login-lost-password" href="register.jsp">没有账号？</a>
    </p>

    <script type="text/javascript">/* <![CDATA[ */
    function wp_attempt_focus() {
        setTimeout(function () {
                try {
                    d = document.getElementById("user_login");
                    d.focus();
                    d.select();
                } catch (er) {
                }
            },
            200);
    }

    wp_attempt_focus();
    if (typeof wpOnload === 'function') {
        wpOnload()
    }
    /* ]]> */
    </script>
    <p id="backtoblog">
        <a href="https://leziblog.com/" one-link-mark="yes">← 返回到 LeZi的猫窝</a></p>
</div>

<script>if (document.getElementById('login_error')) {
    document.getElementById('user_login').value = ''
}</script>
<script type="text/javascript">jQuery("body").prepend("<div class=\"loading\"><img src=\"https://cdn.jsdelivr.net/gh/moezx/cdn@3.1.9/img/Sakura/images/login_loading.gif\" width=\"58\" height=\"10\"></div><div id=\"bg\"><img /></div>");
jQuery('#bg').children('img').attr('src', 'https://cdn.jsdelivr.net/gh/mashirozx/Sakura@3.2.7/images/hd.png').load(function () {
    resizeImage('bg');
    jQuery(window).bind("resize",
        function () {
            resizeImage('bg')
        });
    jQuery('.loading').fadeOut()
})</script>
<script data-wpacu-to-be-preloaded-basic="1" type="text/javascript" id="wpacu-combined-js-body-group-1"
        src="./login_files/body-2a059815060ebadaf8ce1487a8574a3ebbd9473d.js.下载"></script>
<script type="text/javascript" id="zxcvbn-async-js-extra">/* <![CDATA[ */
var _zxcvbnSettings = {
    "src": "https:\/\/leziblog.com\/wp-includes\/js\/zxcvbn.min.js"
};
/* ]]> */
</script>
<script type="text/javascript" id="password-strength-meter-js-extra">/* <![CDATA[ */
var pwsL10n = {
    "unknown": "\u5bc6\u7801\u5f3a\u5ea6\u672a\u77e5",
    "short": "\u975e\u5e38\u5f31",
    "bad": "\u5f31",
    "good": "\u4e2d\u7b49",
    "strong": "\u5f3a",
    "mismatch": "\u4e0d\u5339\u914d"
};
/* ]]> */
</script>
<script type="text/javascript" id="password-strength-meter-js-translations">/* <![CDATA[ */
/* ]]> */
</script>
<script type="text/javascript" id="wp-util-js-extra">/* <![CDATA[ */
var _wpUtilSettings = {
    "ajax": {
        "url": "\/wp-admin\/admin-ajax.php"
    }
};
/* ]]> */
</script>
<script type="text/javascript" id="user-profile-js-extra">/* <![CDATA[ */
var userProfileL10n = {
    "user_id": "0",
    "nonce": "43f01cbb18"
};
/* ]]> */
</script>
<script type="text/javascript" id="user-profile-js-translations">/* <![CDATA[ */
/* ]]> */
</script>
<script data-wpacu-to-be-preloaded-basic="1" type="text/javascript" id="wpacu-combined-js-body-group-2"
        src="./login_files/body-2fcc547ebb1bdc80ae6f9e724e9e295d8c55cf71.js.下载"></script>
<input type="hidden" value="chrome_extension" data-id="abcdefghijk" name="chrome_extension"></body>

</html>