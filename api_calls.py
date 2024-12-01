import requests
from data_validation import validate_user_data


USER_URL = "https://reqres.in/api/users/"
REGISTER_URL = "https://reqres.in/api/register"
LOGIN_URL = "https://reqres.in/api/login"

def register_user(email, password):
    payload = {
        "email": email,
        "password": password
    }
    response = requests.post(REGISTER_URL, json=payload)
    data = check_status_code(response, 200)
    assert "token" in data, "Token is missing in response"
    return data

def fetch_user_data(id):
    url = f"{USER_URL}{id}"
    response = requests.get(url)
    data = check_status_code(response, 200)
    validate_user_data(data)
    return data

def update_user_data(id):
    url = f"{USER_URL}{id}"
    response = requests.patch(url)
    data = check_status_code(response, 200)
    assert "updatedAt" in data, f"updatedAt is missing. {data}"
    return data

def delete_user(id):
    url = f"{USER_URL}{id}"
    response = requests.delete(url)
    assert response.status_code == 204, f"Expected status code: 204, Received {response.status_code}"
    return response

def get_user_list(page, per_page):
    params = {
        "page": page,
        "per_page": per_page
    }
    response = requests.get(USER_URL, params=params)
    data = check_status_code(response, 200)
    return data

def login_with_invalid_email(email):
    payload = {
        "email": email,
        "password": "password"
    }
    response = requests.post(LOGIN_URL, json=payload)
    data = check_status_code(response, 400)
    assert data["error"] == "user not found", "User found and it shouldn't"
    return data

def check_status_code(response, code):
    assert response.status_code == code, f"Expected status code: {code}, Received {response.status_code}"
    data = response.json()
    return data