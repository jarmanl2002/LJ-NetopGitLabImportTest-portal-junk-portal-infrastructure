'use strict';

[
  'NETOP_PORTAL_HOSTNAME'
  , 'NETOP_NAS_HOSTNAME'
  , 'NETOP_PORTAL_CM'
  , 'NETOP_PORTAL_CS'
  , 'NETOP_PORTAL_WCS'
  , 'NAS_SHARED_SECRET'
  , 'NAS_SESSION_SECRET'
  , 'EMAIL_SENDER'
].map(function fRequiredEnvVariables (envVariable) {
  if (!process.env.hasOwnProperty(envVariable)) {
    throw new Error(envVariable + ' not defined');
  }
});

var fs = require('fs');
var path = require('path');
var opsworks = null;
if (process.env.AWS) {
  if (fs.existsSync(path.join(__dirname, '../opsworks.js'))) {
    opsworks = require(path.join(__dirname, '../opsworks.js'));
  } else {
    opsworks = require(process.env.OPSWORKS_PATH);
  }
} else {
  [
    'DB_NAME'
    , 'DB_USER'
    , 'DB_PASS'
    , 'DB_HOST'
  ].map(function fRequiredEnvVariables (envVariable) {
    if (!process.env.hasOwnProperty(envVariable)) {
      throw new Error(envVariable + ' not defined');
    }
  });
  opsworks = {
    db : {
      database: process.env.DB_NAME,
      username: process.env.DB_USER,
      password: process.env.DB_PASS,
      host:     process.env.DB_HOST
    }
  }
}
var _cacheSessionLocations = {};
_cacheSessionLocations[process.env.REDIS_HOST + ':' + process.env.REDIS_PORT] = 1;

module.exports = {
  environment:    process.NODE_ENV || 'production',
  database:       {
    engine:   'sequelize',
    database: opsworks.db.database,
    username: opsworks.db.username,
    password: opsworks.db.password,
    options:  {
      logging:  false,
      dialect:  'mysql',
      port:     3306,
      username: opsworks.db.username,
      host:     opsworks.db.host,
      pool:     {
        maxConnections: 20,
        maxIdleTime:    30000
      }
    }
  },
  cache:          {
    engine: 'redis',
    params: {
      host:    process.env.REDIS_HOST,
      port:    process.env.REDIS_PORT,
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
  session:        {
    engine: 'redis',
    params: {
      locations: _cacheSessionLocations,
      options: {
        remove:         false,
        keyCompression: false,
        maxExpiration:  864000,
        prefix:         'SessionID:'
      }
    }
  },
  authentication: {
    defaultAlgorithm: 'netop-v1.0.0',
    configuration:    {
      'netop-v1.0.0': {
        algorithm:  'netop',
        encoding:   'base64',
        iterations: 2500,
        keylength:  240,
        saltlength: 240
      }
    }
  },
  server:         {
    EXPRESS_SESSION_SECRET: process.env.NAS_SESSION_SECRET || 'a534k2jb3rkjnclk2j34kj4j2k3nbcf42jk13dkj234bj4h12b3jkd423bcjbksadjfksbhd pqox,pwmx,pqowksmxqpwcnqjibdvue87dasiu987',
    SESSION_COOKIE_DOMAIN:  'netop.com',
    SESSION_COOKIE_PATH:    '/',
    SESSION_COOKIE_MAXAGE:  86400000,
    SESSION_COOKIE_NAME:    'SESSIONID',
    SESSION_HTTP_ONLY:      true,
    SESSION_SECURE:         process.env.hasOwnProperty('SESSION_SECURE') ? (process.env.SESSION_SECURE === 'true') : true,
    SESSION_PROXY:          true,
    NAS_SHARED_SECRET:      process.env.NAS_SHARED_SECRET || 'ZOkB4O8OWLuitEM9yQLX9vQDT09ZsWuk7VpdwmI63RYvafiuYxkw6hm88Ndh6zgeDTH8FbZevNEhE4cSpIT3ZA53k813eMqjmZ8mVdEQWq1syaxsGIWwo4vd'
  },
  env: require('./env-config.js')
  // env:            path.join(__dirname, './env-config.json')
};
