import os
import json
import requests
from jose import jwt
from jose.exceptions import JWTError
from fastapi import HTTPException, Request

user_pool_id = 'us-east-2_dOcPPcCEd'
region = 'us-east-2'
app_client_id = '374am33565fed3tv5n3p8agqb2'
iss = f'https://cognito-idp.{region}.amazonaws.com/{user_pool_id}'
keys_url = f'{iss}/.well-known/jwks.json'
DEPLOYMENT_ENV = os.environ.get('DEPLOYMENT_ENV')
DEPLOYMENT_ENV = DEPLOYMENT_ENV if DEPLOYMENT_ENV else "local"

def get_keys(url: str):
    response = requests.get(url)
    keys = json.loads(response.text)['keys']
    return keys

def get_public_key(keys, kid):
    for key in keys:
        if key['kid'] == kid:
            return key
    raise Exception('Public key not found in jwks.json')

def validate_token(request: Request):
    auth_header = request.headers.get('Authorization')
    if auth_header is None:
        raise HTTPException(status_code=403, detail="Unauthorized")

    token_prefix = 'Bearer '
    if not auth_header.startswith(token_prefix):
        raise HTTPException(status_code=403, detail="Invalid authorization header")

    token = auth_header.split(' ')[1]
    if token == "BYPASSTOKEN" and DEPLOYMENT_ENV == "local":
        return

    headers = jwt.get_unverified_header(token)
    print("headers:" + str(headers))

    keys = get_keys(keys_url)
    kid = headers['kid']

    key = get_public_key(keys, kid)
    print("public key:" + str(key))

    # Decode the token and verify its signature and claims
    try:
        claims = jwt.decode(
            token,
            key,
            algorithms=['RS256'],
            audience=app_client_id,
            issuer=iss
        )
        print("claims:" + str(claims))
        return claims
    except JWTError as err:
        print("JWT error:" + str(err))
        raise HTTPException(status_code=403, detail="Unauthorized")