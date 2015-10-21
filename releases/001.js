(function () {
    'use strict';

    module.exports = {
        desc: "Add web schema, functions and users table to it.",
        version: "001",
        schemas: {
            web: {
                tables: "users",
                functions: [
                    "create_user",
                    "update_user",
                    "update_password",
                    "log_visit"
                ]
            }
        }

    };
})();