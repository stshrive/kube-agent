import base64

class APIRequest(object):
    def __init__(
            self,
            version,
            account,
            project,
            definition,
            branch,
            status,
            total,
            user = None,
            auth = None
        ):
        self._ver  = version
        self._acc  = account
        self._proj = project
        self._def  = definition
        self._bran = branch
        self._stat = status
        self._top  = total
        self._user = user
        self._auth = auth

        self._url     = None
        self._params  = None
        self._headers = None

    @property
    def url(self):
        if self._url is None:
            self._url = 'https://{s._acc}.visualstudio.com/{s._proj}/_apis/build/builds'.format(s = self)
        return self._url

    @property
    def params(self):
        if self._params is None:
            self._params = {
                    'api-version'  : self._ver,
                    'definitions'  : self._def,
                    'resultFilter' : self._stat,
                    '$top'         : self._top,
                    'branchName'   : self._bran,
                }

            if self._top is None or int(self._top) == 0:
                del self._params['$top']

        return self._params

    @property
    def headers(self):
        if self._headers is None:
            self._headers = {
                    'Accept' : 'application/json'
                }

            auth_header = None
            if self._user is not None and self._auth is not None:
                auth = base64.b64encode('{s._user}:{s._auth}'.format(s = self).encode())
                auth_header = 'Basic {}'.format(auth.decode("UTF-8"))

            if self._user is None and self._auth is not None:
                auth_header = 'Bearer {}'.format(self._auth)

            if auth_header is not None:
                self._headers['Authorization'] = auth_header

        return self._headers
