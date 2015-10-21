BEGIN;

CREATE TABLE web.users (
  usr_display VARCHAR(25),
  username    VARCHAR(10) NOT NULL UNIQUE,
  salt        VARCHAR(29),
  hashed_pwd  VARCHAR(60),
  roles       TEXT [],
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  visited_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMIT;