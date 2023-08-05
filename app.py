from flask import Flask
app = Flask(__name__)


@app.route('/')
def hello():
    return "Hello, this is a simple Python web application running on Docker!"

# python -m flask run (in terminal)
# access app http://127.0.0.1:5000
