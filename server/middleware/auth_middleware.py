from fastapi import HTTPException, Header
import jwt


def auth_middleware(x_auth_token = Header()):
    try:
    # get the user token from headers
        if not x_auth_token : 
            raise HTTPException(401, 'No auth token found, access denied!')
        
        #decode the token
        token = jwt.decode(x_auth_token, 'password_key',['HS256'])
        if not token : 
            raise HTTPException(401, 'Token verification failed, access denied!')
        #get the id from token -> retrieve data from postgres
        uid = token.get('id')
        return {'uid':uid, 'token': x_auth_token}
    except jwt.PyJWTError:
        raise HTTPException(401, 'Invalid token! Authorization failed')