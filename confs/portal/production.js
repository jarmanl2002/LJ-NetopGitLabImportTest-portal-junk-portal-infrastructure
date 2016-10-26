var path = require('path');

module.exports = {
  environment: 'production',
  database: {
    engine:   'sequelize',
    database: 'portal',
    username: 'root',
    password: 'dev',
    options: {
      logging: console.log,
      logging: false,
      dialect: 'mysql',
      port: 3306,
      username: 'root',
      host: 'database',
      pool: {
        maxConnections: 20,
        maxIdleTime: 30000
      }
    }
  },
  cache: {
    engine: 'redis',
    params: {
      host: 'cache',
      port: 6379,
      options: {
        parser:                 'hiredis',
        'return_buffers':       false,
        'detect_buffers':       false,
        'socket_nodelay':       true,
        'socket_keepalive':     true,
        'no_ready_check':       false,
        'enable_offline_queue': true,
        'retry_max_delay':      true,
        'connect_timeout':      false,
        'max_attempts':         null,
        'auth_pass':            null
      }
    }
  },
  server: {
    locations: {'cache:6379' : 1},
    EXPRESS_SESSION_SECRET: 'a534k2jb3rkjnclk2j34kj4j2k3nbcf42jk13dkj234bj4h12b3jkd423bcjbksadjfksbhd pqox,pwmx,pqowksmxqpwcnqjibdvue87dasiu987',
    SESSION_COOKIE_DOMAIN:  'netop.com',
    SESSION_COOKIE_PATH:    '/',
    SESSION_COOKIE_MAXAGE:  1800000, //300000, //7200000,
    SESSION_COOKIE_NAME:    'PORTALID',
    NAS_COOKIE_NAME:        'SESSIONID',
    SESSION_HTTP_ONLY: true,
    SESSION_SECURE: true,
    SESSION_PROXY: true,
    NAS_SHARED_SECRET: 'ZOkB4O8OWLuitEM9yQLX9vQDT09ZsWuk7VpdwmI63RYvafiuYxkw6hm88Ndh6zgeDTH8FbZevNEhE4cSpIT3ZA53k813eMqjmZ8mVdEQWq1syaxsGIWwo4vd'
  },
  smtp: {
    server: {
      host: 'email-smtp.eu-west-1.amazonaws.com',
      port: 25,
      service: 'SAS',
      authMethod: 'PLAIN',
      auth: {
        user : 'AKIAJFBOXRCALLKPVICA',
        pass : 'AsFlrbFIBNeFiwdmjIpdCBTpI/dlLzsxpyHxe27xfLRj'
      }
    },
    sender: 'devteam_portal@netop.com'
  },
  forceHttps: false,
  env : path.join(__dirname, "./env-config.json"),
  portalAccess: '063947fdeb68fb5843238f24adbe94ae48200dc7',
  wcsCacheCounter: 'WCSCOUNTER',
  passwordResetCodeDuration: 86400,
  flashVars: {
    backUrl: 'login_back_url'
  },
  logging: {
    syslog: {
      level: 'error'
    },
  },
  wcsCacheCounter: 'WCSCOUNTER',
  emailValidation: {
    successUrl: "https://nas-local.netop.com/profile/email-validation",
    errorUrl:   "https://nas-local.netop.com/profile/email-validation"
  }
};
