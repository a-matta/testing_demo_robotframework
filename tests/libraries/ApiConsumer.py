import requests
from robot.api import logger


class ApiConsumer:
    def set_api_url(self, api_base_url: str):
        """Set the base api url path for example http://localhost:8080/api"""
        self.api_base_url = api_base_url

    def get_auth_token(self, username: str, password: str):
        """Fetch authorisation token GET /api/auth/token and returns the JSON response"""
        url = f"{self.api_base_url}/auth/token"
        response = requests.get(url, auth=(username, password), headers={"content-type": "application/json"}).json()
        logger.info(response)
        return response

    def create_user(self, username: str, password: str, firstname: str, lastname: str, phone: str):
        """Create a user POST /api/users and returns the JSON response"""
        url = f"{self.api_base_url}/users"
        response = requests.post(
            url,
            json={
                "username": username,
                "password": password,
                "firstname": firstname,
                "lastname": lastname,
                "phone": phone,
            },
            headers={"content-type": "application/json"},
        ).json()
        logger.info(response)
        return response

    def get_user(self, token: str, username: str):
        """Get user details GET /api/users/{username} and returns the JSON response"""
        url = f"{self.api_base_url}/users/{username}"
        response = requests.get(url, headers={"Token": token}).json()
        logger.info(response)
        return response

    def update_user(self, token: str, username: str, **data):
        """Update the user details PUT /api/users/{username} and returns the JSON response"""
        url = f"{self.api_base_url}/users/{username}"
        response = requests.put(url, headers={"Token": token, "content-type": "application/json"}, json=data).json()
        logger.info(response)
        return response

    def get_all_users(self, token: str):
        """Get users list GET /api/users and returns the JSON response"""
        url = f"{self.api_base_url}/users"
        response = requests.get(url, headers={"Token": token}).json()
        logger.info(response)
        return response

    def assert_success(self, response):
        """Validate response contains status=SUCCESS"""
        status = response["status"]
        if status != "SUCCESS":
            raise AssertionError(f"Expected %s but was %s" % ("SUCCESS", status))

    def assert_failure(self, response):
        """Validate response contains status=FAILURE"""
        status = response["status"]
        if status != "FAILURE":
            raise AssertionError("Expected %s but was %s" % ("FAILURE", status))
