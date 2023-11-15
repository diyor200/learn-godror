create or replace package pkg_users as
    procedure get_name(umail USERS.EMAIL%type);
    function totalUsers return number;
    function get_user_by_email(u_email users.email%type) return USERS%rowtype;
    function get_user_data_by_email(u_email users.email%type) return sys_refcursor;
end pkg_users;

    drop package pkg_users;

create or replace package body pkg_users as
    --     procedure get_name is begin

    procedure get_name(umail USERS.EMAIL%type) is
    begin
        DBMS_OUTPUT.PUT_LINE('email ' || umail);
    end get_name;
--         function totalUsers is begin
    function totalUsers return number is
        total_users number := 0;
    begin
        select count(*) into total_users from USERS;
        return total_users;
    end totalUsers;
--     function get_user_by_email is begin
    function get_user_by_email return USERS%rowtype is
        user USERS%rowtype;
    begin
        select * into user from USERS;
        return user;
    end get_user_by_email;
--     function
    function get_user_data_by_email( u_email USERS.EMAIL%TYPE) return sys_refcursor as
        v_cursor sys_refcursor;
    begin
        open v_cursor for
            select * from USERS where EMAIL=u_email;
        return v_cursor;
    end get_user_data_by_email;
end;


-- DECLARE
--     mail USERS.EMAIL%type;
--     c number;
--     u USERS%rowtype;
--     v_user_data SYS_REFCURSOR;
--     v_user_data_result USERS%rowtype;
-- begin
--     mail := 'shundey1@yandex.ru';
--     pkg_users.get_name(mail);
--     c := pkg_users.totalUsers();
--     DBMS_OUTPUT.PUT_LINE('total users = ' || c);
--     u := pkg_users.get_user_by_email(mail);
--     DBMS_OUTPUT.PUT_LINE(u.name);
--     v_user_data := pkg_users.get_user_data_by_email(mail);
--     loop
--         fetch v_user_data into v_user_data_result;
--         EXIT WHEN v_user_data%NOTFOUND;
--
--         DBMS_OUTPUT.PUT_LINE('name = ' || v_user_data_result.name);
--     end loop;
--     CLOSE v_user_data;
-- end;

select * from Users;

drop package body pkg_users;

-- user package returns record
CREATE OR REPLACE PACKAGE UserPackage AS
    -- Define a record type to represent user data
    TYPE UserRec IS RECORD (
                               ID       NUMBER,
                               Name     VARCHAR2(200),
                               Email    VARCHAR2(200),
                               Gender   VARCHAR2(30),
                               Password VARCHAR2(250)
                           );

    -- Function to retrieve user data by email
    FUNCTION GetUserByEmail(p_email IN VARCHAR2) RETURN UserRec;
END UserPackage;
/

-- Create or replace package body
CREATE OR REPLACE PACKAGE BODY UserPackage AS
    -- Function implementation to retrieve user data by email
    FUNCTION GetUserByEmail(p_email IN VARCHAR2) RETURN UserRec IS
        user_data UserRec;
    BEGIN
        -- Retrieve user data based on the provided email
        SELECT ID, Name, Email, Gender, Password
        INTO user_data
        FROM USERS
        WHERE Email = p_email;

        -- Return the user data
        RETURN user_data;
    EXCEPTION
        -- Handle the case when no data is found
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        -- Propagate other exceptions
        WHEN OTHERS THEN
            RAISE;
    END GetUserByEmail;
END UserPackage;

declare
    mail varchar2(200);
    begin
    DBMS_OUTPUT.PUT_LINE('test = ' || USERPACKAGE.GetUserByEmail(mail).EMAIL);
end;