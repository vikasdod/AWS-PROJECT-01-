FROM python:3.10.1
WORKDIR ./

COPY app.py ./
ADD application application
ADD templates templates
ADD static static
COPY requirements.txt ./

#RUN sudo apt-get update
#RUN sudo apt-get install python

RUN pip install --upgrade pip -r requirements.txt

EXPOSE 5000

CMD [ "python", "app.py" ]