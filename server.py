from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

@app.route('/execute', methods=['POST'])
def execute_command():
    command = request.json.get('command')
    if not command:
        return jsonify({'error': 'No command provided'}), 400

    try:
        output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
        return jsonify({'output': output.decode('utf-8')}), 200
    except subprocess.CalledProcessError as e:
        return jsonify({'error': e.output.decode('utf-8')}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)