from jsonschema import validate, ValidationError
import json

def validate_user_data(json_data):
    assert json_data["data"]["id"] == 4
    assert json_data["data"]["email"] == "eve.holt@reqres.in"
    assert json_data["data"]["first_name"] == "Eve"
    assert json_data["data"]["last_name"] == "Holt"
    assert json_data["data"]["avatar"] == "https://reqres.in/img/faces/4-image.jpg"

def validate_user_list_schema(data):
    file_name = 'user_list_schema.json'
    with open(file_name, 'r') as file:
        schema = json.load(file)
    try:
        validate(instance=data, schema=schema)
        print("JSON is valid")
    except ValidationError as e:
        raise ValidationError(f"JSON validation error: {e.message}")