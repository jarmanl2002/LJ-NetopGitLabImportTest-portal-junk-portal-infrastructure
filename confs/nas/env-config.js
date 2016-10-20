'use strict';

var _portalDefinition = {
  protocol: process.env.NETOP_PORTAL_PROTOCOL || 'https',
  hostname: process.env.NETOP_PORTAL_HOSTNAME, // ex: 'portal-delta.netop.com',
  port:     process.env.NETOP_PORTAL_PORT || 443

};
var _nasDefinition = {
  protocol: process.env.NETOP_NAS_PROTOCOL || 'https',
  hostname: process.env.NETOP_NAS_HOSTNAME, // ex: 'nas-delta.netop.com',
  port:     process.env.NETOP_NAS_PORT || 443

};


module.exports = {
  cm:            process.env.NETOP_PORTAL_CM.split(','),
  cs:            process.env.NETOP_PORTAL_CS.split(','),
  wcs:           process.env.NETOP_PORTAL_WCS.split(','),
  currentServer: {
    protocol: _nasDefinition.protocol,
    hostname: [_nasDefinition.hostname],
    port:     _nasDefinition.port
  },
  auth: {
    server: {
      protocol: _nasDefinition.protocol,
      hostname: [_nasDefinition.hostname],
      port:     _nasDefinition.port
    },
    service: {
      login: {
        path:   '/auth/v1/login',
        method: 'POST'
      },
      logout: {
        path:   '/auth/v1/logout',
        method: 'GET'
      },
      checkSession: {
        path:   '/auth/v1/checkSession',
        method: 'GET'
      }
    },
    rest: {
      user: '/api/user'
    },
    apikey: {
      user:        '/api/key/user',
      'user-v1.1': '/api/v1.1/key/user'
    }
  },
  rest: {
    server: {
      protocol: _portalDefinition.protocol,
      hostname: [_portalDefinition.hostname],
      port:     _portalDefinition.port
    },
    website: {
      keepalive: '/api/v1/utils/keepalive',
      whoami:    '/api/v1/utils/check'
    },
    service: {
      auth: {
        path:   '/',
        method: 'GET'
      },
      user:                   '/api/v1/rest/user',
      resetPassword:          '/profile/reset/',
      clearPasswordResetCode: '/profile/invalid/',
      login:                  '/profile/login'
    }
  },
  adminApiKey: {
    server: {
      protocol: _nasDefinition.protocol,
      hostname: [_nasDefinition.hostname],
      port:     _nasDefinition.port
    },
    service: {
      userGetByEmail: {
        path:   '/api/key/user/email',
        method: 'POST'
      },
      resetPassword: {
        path:   '/api/key/user/resetPassword',
        method: 'POST'
      }
    }
  }
};
