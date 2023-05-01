FROM ubuntu:20.04

RUN apt update

RUN apt install python3-pip -y

RUN pip install flask

RUN apt install python3.8-venv

RUN python3 -m venv venv

RUN apt update 

RUN /bin/bash venv/bin/activate

RUN pip install --upgrade pip

WORKDIR /COPY

COPY . .

RUN pip install -r requirements.txt

RUN export FLASK_APP=crudapp.py

#RUN rm -r migrations/

RUN flask db init

RUN flask db migrate -m "entries table"

RUN flask db upgrade

CMD ["flask", "RUN","--host=0.0.0.0"]