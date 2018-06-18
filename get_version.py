import requests
import base64

class APIRequest(object):
    def __init__(
            self,
            version,
            account,
            project,
            definition,
            status,
            total,
            user = None,
            auth = None
        ):
        self._ver  = version
        self._acc  = account
        self._proj = project
        self._def  = definition
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
            self._url = f'https://{self._acc}.visualstudio.com/{self._proj}/_apis/build/builds'
        return self._url

    @property
    def params(self):
        if self._params is None:
            self._params = {
                    'api-version'  : self._ver,
                    'definitions'  : self._def,
                    'resultFilter' : self._stat,
                    '$top'         : self._top,
                }

            if self._top is None or self._top == 0:
                del self._params['$top']

        return self._params

    @property
    def headers(self):
        if self._headers is None:
            self._headers = {
                    'Accept' : 'application/json'
                }

            if self._user is not None and self._auth is not None:
                auth = base64.b64encode(f'{self._user}:{self._auth}'.encode())
                self._headers['Authorization'] = f'Basic {auth.decode("UTF-8")}'

        return self._headers


def get_versions(response_data):
    print(response_data)
    print(str(response_data.content))

def main(account, project, definition, status, total, version, user, token):
    req = APIRequest(version, account, project, definition, status, total, user, auth=token)

    print(f'Sending request to: {req.url}')
    print(f'Request Headers: {req.headers}')
    print(f'Request Parameters: {req.params}')

    response = requests.get(req.url, params=req.params, headers=req.headers)

    versions = get_versions(response)

def get_args():
    import argparse
    import sys

    parser = argparse.ArgumentParser(sys.argv[0])
    parser.add_argument('-v', '--version', type=float, default=4.1)
    parser.add_argument('-c', '--count', type=int, default=1)
    parser.add_argument('-d', '--definition', type=int)
    parser.add_argument('-t', '--token', default=None)
    parser.add_argument('-u', '--user', default=None)
    parser.add_argument('-a', '--account')
    parser.add_argument('-s', '--buildstatus')
    parser.add_argument('-p', '--project')

    args = parser.parse_args()

    return [
            args.account,
            args.project,
            str(args.definition),
            args.buildstatus,
            str(args.count),
            str(args.version),
            args.user,
            args.token
        ]


if __name__ == '__main__':
    main(*get_args())
