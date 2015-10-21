BEGIN;
CREATE OR REPLACE FUNCTION web.create_user(
  IN i_usr_display VARCHAR(25),
  IN i_username    VARCHAR(10),
  IN i_salt        VARCHAR(29),
  IN i_hashed_pwd  VARCHAR(60),
  IN i_roles       TEXT []
)
  RETURNS JSON AS
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
  RETURN (SELECT row_to_json(t)
          FROM (
                 SELECT
                   username,
                   usr_display
                 FROM web.users
                 WHERE username = i_username) t);
END;
$BODY$
LANGUAGE plpgsql;

COMMIT;