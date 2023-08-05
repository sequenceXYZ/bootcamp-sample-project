from flask import Flask
app = Flask(__name__)


@app.route('/')
def hello():
    return "Hello, this is a simple Python web application running on Docker in EC2 instance!"


if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=5000)
