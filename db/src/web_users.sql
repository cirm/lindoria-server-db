BEGIN;

DROP TABLE IF EXISTS users;
DROP SCHEMA IF EXISTS web CASCADE;

CREATE SCHEMA web AUTHORIZATION geegomoonshine;

CREATE TABLE web.users (
    usr_display     varchar(25),
    username        varchar(10) NOT NULL UNIQUE,
    salt            varchar(29),
    hashed_pwd      varchar(60),
    roles           text[],
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    visited_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION web.create_user (
    IN i_usr_display varchar(25),
    IN i_username varchar(10),
    IN i_salt varchar(29),
    IN i_hashed_pwd varchar(60),
    IN i_roles text[]
) RETURNS json AS
/*
    % SELECT web.insert_user(
        i_username  := 'theory',
        i_usr_display := 'Big Dude Eleven',
        i_salt := '***',
        i_hashed_pwd     := '******',
        i_roles = ['admin', 'player', 'dm']
    );
     insert_user
    ─────────────
         t
Inserts a new user into the database. The other parameters are:
i_usr_display
: The full display name of the user.
i_username
: The username of the user for login.
i_salt
: Random salt used to hash password.
i_hashed_pwd
: Hashed Password for the user login.
i_roles
: List of active roles for the user.
*/

$BODY$
BEGIN
INSERT INTO web.users (
    usr_display,
    username,
    salt,
    hashed_pwd,
    roles
) VALUES (
    i_usr_display,
    i_username,
    i_salt,
    i_hashed_pwd,
    i_roles);
RETURN ( SELECT row_to_json(t) FROM (
    SELECT username, usr_display FROM web.users where username=i_username) t);
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION web.update_password(
    i_username      varchar(10),
    i_salt          varchar(29),
    i_hashed_pwd    varchar(60)
) RETURNS BOOLEAN AS $BODY$
BEGIN
    UPDATE web.users
       SET salt         = update_password.i_salt,
           hashed_pwd   = update_password.i_hashed_pwd,
           updated_at   = NOW()
     WHERE users.username = update_user.i_username;
    RETURN FOUND;
END;
$BODY$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION web.update_user(
    i_username      varchar(10),
    i_usr_display   varchar(25)
) RETURNS BOOLEAN AS $BODY$
/*
    % SELECT web.update_user(
        i_usr_display := 'Big Dude Ten',
        i_salt := '***',
        i_hashed_pwd := '******'
    );
     update_user
    ─────────────
     t
Update the specified username. The user must be active. The username cannot be changed. The password can only be changed
 via `change_password()` or `reset_password()`. Returns true if the user was updated, and false if not.
*/
BEGIN
    UPDATE web.users
       SET usr_display          = COALESCE(update_user.i_usr_display, users.usr_display),
           updated_at           = NOW()
     WHERE users.username   = update_user.i_username;
    RETURN FOUND;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION web.log_visit(
    i_username  varchar(10)
) RETURNS BOOLEAN AS $BODY$
/*
    % SELECT log_visit('theory');
     log_visit
    ───────────
     t
Log the visit for the specified username. At this point, that just means that
`web.users.visited_at` gets set to the current time.
*/
BEGIN
    UPDATE web.users
       SET visited_at     = NOW()
     WHERE users.username = log_visit.i_username;
    RETURN FOUND;
END;
$BODY$
LANGUAGE plpgsql;

COMMIT;