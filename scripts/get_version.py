import requests
from VSTSRequest import APIRequest

def get_builds(response):
    print('status code: {r.status_code}'.format(r=response))
    return [str(build['id']) for build in response.json()['value']]

def main(account, project, definition, branch, status, total, version, user, token, verbose=False):
    import os
    req = APIRequest(version, account, project, definition, branch, status, total, user, auth=token)

    if verbose:
        print(
            'Request URL:\n{r.url}\nRequest Headers:\n{r.headers}\nRequest Parameters:\n{r.params}'.format(
                r = req))

    response = requests.get(req.url, params=req.params, headers=req.headers)

    versions = get_builds(response)
    versions = ';'.join(versions)

    os.environ['MSFTKUBE_VERSIONS'] = versions

def get_args():
    import argparse
    import sys

    parser = argparse.ArgumentParser(sys.argv[0])
    parser.add_argument('-v', '--version', type=float, default=4.1)
    parser.add_argument('-b', '--branch', default='refs/head/master')
    parser.add_argument('-c', '--count', type=int, default=0)
    parser.add_argument('-d', '--definition', type=int)
    parser.add_argument('-V', '--verbose', action='store_true')
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
            args.branch,
            args.buildstatus,
            str(args.count),
            str(args.version),
            args.user,
            args.token,
            args.verbose,
        ]


if __name__ == '__main__':
    main(*get_args())
