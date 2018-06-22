import requests
from VSTSRequest import APIRequest

def get_builds(response):
    print('status code: {r.status_code}'.format(r=response))
    return [str(build['id']) for build in response.json()['value']]

def main(
        account,
        project,
        definition,
        branch,
        buildstatus,
        count,
        version,
        user,
        token,
        *args,
        **kwargs):
    import os

    req = APIRequest(version, account, project, definition, branch, buildstatus, count, user, token)
    response = requests.get(req.url, params=req.params, headers=req.headers)

    verbose = kwargs.get('verbose', False)

    if verbose:
        print(
            'Request URL:\n{r.url}\nRequest Headers:\n{r.headers}\nRequest Parameters:\n{r.params}'.format(
                r = req))


    if verbose:
        print('Response content: {}'.format(response.content.decode()))

    env_val = get_builds(response)
    env_val = ' '.join(env_val)
    env_var = kwargs.get('environmentOutput', 'GET_VERSION_OUT')

    if kwargs.get('vsts', False):
        print('creating vsts variable')
        print(
            '##vso[task.setvariable variable={var_name};isOutput=true]{var_val}'.format(
                var_name = env_var, var_val = env_val))
    else:
        os.environ['{}'.format(env_var)] = env_val

def get_args():
    import argparse
    import sys

    parser = argparse.ArgumentParser(sys.argv[0])
    parser.add_argument('-a', '--account', required=True)
    parser.add_argument('-b', '--branch', default='refs/heads/master')
    parser.add_argument('-c', '--count', type=int, default=0)
    parser.add_argument('-d', '--definition', type=int, required=True)
    parser.add_argument('-e', '--environmentOutput')
    parser.add_argument('-p', '--project', required=True)
    parser.add_argument('-s', '--buildstatus')
    parser.add_argument('-t', '--token', default=None)
    parser.add_argument('-u', '--user', default=None)
    parser.add_argument('-v', '--version', type=float, default=4.1)
    parser.add_argument('-V', '--verbose', action='store_true')

    parser.add_argument('--vsts', action='store_true')

    args = parser.parse_args()

    return args.__dict__


if __name__ == '__main__':
    main(**get_args())
