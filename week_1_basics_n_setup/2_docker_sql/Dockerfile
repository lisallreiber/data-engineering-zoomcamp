# # v0: basic version
# # -----------------------------------------------
# # specify image
# FROM python:3.9.1

# # bash code
# RUN pip install pandas

# ENTRYPOINT [ "bash" ]


#  v1.1: simple version
# -----------------------------------------------
FROM python:3.9.1

RUN pip install pandas 

WORKDIR /app
COPY pipeline.py pipeline.py

# here we define what docker is supposed to run in the container
ENTRYPOINT [ "python", "pipeline.py" ]

# #  v1.2: simple version
# # -----------------------------------------------
# RUN apt-get install wget
# RUN pip install pandas sqlalchemy psycopg2

# WORKDIR /app
# COPY ingest_data.py ingest_data.py 

# ENTRYPOINT [ "python", "ingest_data.py" ]