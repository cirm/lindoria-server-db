BEGIN;

DROP TABLE IF EXISTS users;
DROP SCHEMA IF EXISTS web CASCADE;

CREATE SCHEMA web
  AUTHORIZATION geegomoonshine;

CREATE TABLE web.users (
  display   VARCHAR(25),
  username  VARCHAR(10) NOT NULL UNIQUE,
  salt      VARCHAR(29),
  hpassword VARCHAR(60),
  roles     TEXT [],
  created   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  visited   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION web.create_user(
  IN i_display   VARCHAR(25),
  IN i_username  VARCHAR(10),
  IN i_salt      VARCHAR(29),
  IN i_hpassword VARCHAR(60),
  IN i_roles     TEXT []
)
  RETURNS JSON AS
/*
    % SELECT web.insert_user(
        i_username  := 'theory',
        i_display := 'Big Dude Eleven',
        i_salt := '***',
        i_hpassword     := '******',
        i_roles = ['admin', 'player', 'dm']
    );
     insert_user
    ─────────────
         t
Inserts a new user into the database. The other parameters are:
i_display
: The full display name of the user.
i_username
: The username of the user for login.
i_salt
: Random salt used to hash password.
i_hpassword
: Hashed Password for the user login.
i_roles
: List of active roles for the user.
*/

$BODY$
BEGIN
  INSERT INTO web.users (
    display,
    username,
    salt,
    hpassword,
    roles
  ) VALUES (
    i_display,
    i_username,
    i_salt,
    i_hpassword,
    i_roles);
  RETURN (SELECT
            row_to_json(t)
          FROM (
                 SELECT
                   username,
                   display
                 FROM
                   web.users
                 WHERE
                   username = i_username) t);
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION web.update_password(
  i_username   VARCHAR(10),
  i_salt       VARCHAR(29),
  i_hpassword VARCHAR(60)
)
  RETURNS BOOLEAN AS $BODY$
BEGIN
  UPDATE
    web.users
  SET
    salt     = i_salt,
    hpassword  = i_hpassword,
    updated = NOW()
  WHERE
    users.username = i_username;
  RETURN FOUND;
END;
$BODY$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION web.update_user(
  i_username    VARCHAR(10),
  i_usr_display VARCHAR(25)
)
  RETURNS JSON AS $BODY$
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
 via `update_password`. Returns true if the user was updated, and false if not.
*/
BEGIN
  UPDATE
    web.users wu
  SET
    display = COALESCE(i_usr_display, users.display),
    updated    = NOW()
  WHERE
    users.username = i_username;
  RETURN (SELECT
            row_to_json(t)
          FROM (
                 SELECT
                   username,
                   display
                 FROM
                   web.users
                 WHERE
                   username = i_username) t);
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION web.log_visit(
  i_username VARCHAR(10)
)
  RETURNS BOOLEAN AS $BODY$
/*
    % SELECT log_visit('theory');
     log_visit
    ───────────
     t
Log the visit for the specified username. At this point, that just means that
`web.users.visited_at` gets set to the current time.
*/
BEGIN
  UPDATE
    web.users
  SET
    visited = NOW()
  WHERE
    users.username = i_username;
  RETURN FOUND;
END;
$BODY$
LANGUAGE plpgsql;

COMMIT;