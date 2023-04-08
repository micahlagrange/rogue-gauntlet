from flask import Flask, jsonify
import random

app = Flask(__name__)

@app.route('/')
def hello():    
    return jsonify({
        "target": [random.uniform(0,400),random.uniform(0,400)],
        "rotation_degrees": 92.0001,
        "attack": False
    })

if __name__ == '__main__':
    app.run(debug=True)
