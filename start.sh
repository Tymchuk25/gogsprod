    #!/bin/bash

    #Download key=value from /opt/elasticbeanstalk/deployment/env
    #source /opt/elasticbeanstalk/deployment/env
    eval $(cat /opt/elasticbeanstalk/deployment/env | grep -v '^#')

    #Create folder if not have
    mkdir -p custom/conf

    #Create app.ini file

    cat > custom/conf/app.ini <<EOF
    BRAND_NAME = Gogs
    RUN_USER   = webapp
    RUN_MODE   = prod

    [database]
    TYPE     = mysql
    HOST     = ${DB_HOST}
    NAME     = gogs
    USER     = gogs
    PASSWORD = gogsgogs
    SSL_MODE = disable
    PATH     = /home/webapp/data/gogs.db
    SCHEMA   = public

    [repository]
    ROOT           = /home/webapp/gogs-repositories
    DEFAULT_BRANCH = master

    [server]
    DOMAIN           = gogs-service
    PROTOCOL         = http
    HTTP_ADDR        = 0.0.0.0
    HTTP_PORT        = 5000
    EXTERNAL_URL     = ${EXTERNAL_URL}
    DISABLE_SSH      = false
    SSH_PORT         = 22
    START_SSH_SERVER = false
    OFFLINE_MODE     = false

    [mailer]
    ENABLED = false

    [service]
    REGISTER_EMAIL_CONFIRM = false
    ENABLE_NOTIFY_MAIL     = false
    DISABLE_REGISTRATION   = true
    ENABLE_CAPTCHA         = false
    REQUIRE_SIGNIN_VIEW    = false

    [picture]
    DISABLE_GRAVATAR        = false
    ENABLE_FEDERATED_AVATAR = false

    [session]
    PROVIDER = file

    [log]
    MODE      = file
    LEVEL     = Info
    ROOT_PATH = /home/webapp/logs

    [email]
    ENABLED = false

    [auth]
    REQUIRE_EMAIL_CONFIRMATION  = false
    DISABLE_REGISTRATION        = true
    ENABLE_REGISTRATION_CAPTCHA = false
    REQUIRE_SIGNIN_VIEW         = false

    [user]
    ENABLE_EMAIL_NOTIFICATION = false

    [security]
    INSTALL_LOCK = true
    SECRET_KEY   = qmKG6pnP6QJXZFr
EOF

    #Start Gogs
    ./gogs web
