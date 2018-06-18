import requests
from VSTSRequest import APIRequest

def get_versions(response_data):
    print(f'status code: {response_data.status_code}')
    for h in response_data.history:
        print(f'{h.url}: {h.status_code}')
    print(f'content:\n{str(response_data.content)}')

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
    parser.add_argument('-c', '--count', type=int, default=0)
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
