FROM python:3.6.12-buster

RUN pip install tqdm
RUN pip install wget
RUN pip install --upgrade firebase-admin

RUN mkdir /callsigns
RUN useradd -m callsigns

RUN chown 1000:1000 /callsigns
USER callsigns
WORKDIR /callsigns

COPY callsigns.py .

CMD ["python", "callsigns.py"]
