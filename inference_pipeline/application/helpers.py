import re
import os

import boto3
from keras.utils import pad_sequences


def get_all_s3_buckets():
    s3 = boto3.client('s3')
    response = s3.list_buckets()
    return [bucket['Name'] for bucket in response['Buckets']]


def download_model_artifacts_from_s3():
    # Load the Machine Learning model from S3
    if not os.path.exists("./downloads"):
        os.mkdir("./downloads")

    s3 = boto3.client('s3')
    bucket_name = 'text-classifier-on-aws'
    s3.download_file(bucket_name, 'disaster_tweets/disaster-tweet-model.h5', "./downloads/model.h5")
    s3.download_file(bucket_name, 'disaster_tweets/disaster-tweet-modelling-params.pkl', "./downloads/params.h5")
    s3.download_file(bucket_name, 'disaster_tweets/disaster-tweet-tokenizer.pkl', "./downloads/tokenizer.h5")


def preprocess_input_text(input_text):
    input_text = input_text.lower()  # convert to lowercase
    input_text = re.sub(r"http\S+", "", input_text)  # remove urls
    input_text = re.sub(r"@\w+", "", input_text)  # remove mentions
    input_text = re.sub(r"#\w+", "", input_text)  # remove hashtags
    input_text = re.sub(r'[^\w\s]', '', input_text)  # remove punctuation
    input_text = re.sub(r'\d+', '', input_text)  # remove numbers
    input_text = re.sub(r'\s+', ' ', input_text).strip()  # remove extra whitespace

    stopwords = {'ourselves', 'hers', 'between', 'yourself', 'but', 'again', 'there', 'about', 'once', 'during', 'out',
                 'very', 'having', 'with', 'they', 'own', 'an', 'be', 'some', 'for', 'do', 'its', 'yours', 'such',
                 'into', 'of', 'most', 'itself', 'other', 'off', 'is', 's', 'am', 'or', 'who', 'as', 'from', 'him',
                 'each', 'the', 'themselves', 'until', 'below', 'are', 'we', 'these', 'your', 'his', 'through', 'don',
                 'nor', 'me', 'were', 'her', 'more', 'himself', 'this', 'down', 'should', 'our', 'their', 'while',
                 'above', 'both', 'up', 'to', 'ours', 'had', 'she', 'all', 'no', 'when', 'at', 'any', 'before', 'them',
                 'same', 'and', 'been', 'have', 'in', 'will', 'on', 'does', 'yourselves', 'then', 'that', 'because',
                 'what', 'over', 'why', 'so', 'can', 'did', 'not', 'now', 'under', 'he', 'you', 'herself', 'has',
                 'just', 'where', 'too', 'only', 'myself', 'which', 'those', 'i', 'after', 'few', 'whom', 't', 'being',
                 'if', 'theirs', 'my', 'against', 'a', 'by', 'doing', 'it', 'how', 'further', 'was', 'here', 'than'}
    input_text = input_text.split()
    input_text = [i for i in input_text if i not in stopwords]

    return input_text


def make_prediction(input_text, model, tokenizer, params):
    input_text = preprocess_input_text(input_text)

    tokenized_text = tokenizer.texts_to_sequences([input_text])
    tokenized_text = pad_sequences(tokenized_text, maxlen=params['maxlen'], padding=params['padding_type'])
    return model.predict(tokenized_text)


def write_inference_result_to_database():
    # TODO: Write the inference result to the database
    return {
        "status": 200
    }
