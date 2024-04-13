from flask import Flask, request, render_template
from application.helpers import download_model_artifacts_from_s3, make_prediction

from keras.models import load_model
import pickle

app = Flask("INFERENCE-APP")

download_model_artifacts_from_s3()

model = load_model("./downloads/model.h5")
with open('./downloads/params.h5', 'rb') as handle:
    params = pickle.load(handle)
with open('./downloads/tokenizer.h5', 'rb') as handle:
    tokenizer = pickle.load(handle)


@app.route('/', methods=['GET'])
def index():
    return render_template("homepage.html")


@app.route('/inference', methods=['GET'])
def inference():
    return render_template("disaster_inference.html", )


@app.route('/inference', methods=['POST'])
def inference_post():
    input_text = request.form['text']
    prob = make_prediction(input_text, model, tokenizer, params)
    return render_template(
        'disaster_inference.html',
        text=input_text,
        prob=prob[0][0]
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
