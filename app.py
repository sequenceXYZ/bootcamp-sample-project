from flask import Flask
app = Flask(__name__)


@app.route('/')
def hello():
    return "Hello, this is a simple Python web application running on Docker!"
