import os
from flask import Flask, jsonify, request
from PIL import Image
import torchvision.transforms.functional as TF
import CNN
import numpy as np
import torch
import pandas as pd

model = CNN.CNN(39)
model.load_state_dict(torch.load("plant_disease_model_1_latest.pt"))
model.eval()


disease_info = pd.read_csv('disease_info.csv', encoding='cp1252')
supplement_info = pd.read_csv('supplement_info.csv', encoding='cp1252')


app = Flask(__name__)


@app.route('/')
def welcome():
    return "Hello world"


@app.route('/detect', methods=['GET', 'POST'])
def prediction():
    imagee = request.files['image']
    filename = imagee.filename
    filepath = os.path.join("uploadedimg", filename)
    imagee.save(filepath)
    image = Image.open(filepath)
    image = image.resize((224, 224))
    input_data = TF.to_tensor(image)
    input_data = input_data.view((-1, 3, 224, 224))
    output = model(input_data)
    output = output.detach().numpy()
    pred = np.argmax(output)
    title = disease_info['disease_name'][pred]
    description = disease_info['description'][pred]
    prevent = disease_info['Possible Steps'][pred]
    image_url = disease_info['image_url'][pred]
    supplement_name = supplement_info['supplement name'][pred]
    supplement_image_url = supplement_info['supplement image'][pred]
    supplement_buy_link = supplement_info['buy link'][pred]
    return jsonify({'title': title,
                    'desc': description,
                    'prevent': prevent,
                    'image_url': image_url,
                    'pred': str(pred),
                    'sname': supplement_name,
                    'simage': supplement_image_url,
                    'buy_link': supplement_buy_link
                    })


if __name__ == '__main__':
    # app.run(host="192.168.1.6", port=5000)
    app.run()
