FROM python:3.10
WORKDIR /backup-checker
COPY ./app /backup-checker
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "main.py"]
