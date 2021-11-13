#!/usr/bin/python3
# Pre-requisites 
# 1. $ sudo pip install mysql-connector-python
# 2. $ curl -L -s http://deepyeti.ucsd.edu/jianmo/amazon/categoryFilesSmall/Appliances_5.json.gz | gunzip > /tmp/Appliances_5.json
# 3. $ mysql cookbook < reviews.sql
# 4. $ ./python_json_load.py /tmp/Appliances_5.json

import mysql.connector
import os
import sys

filepath = sys.argv[1]
if not os.path.isfile(filepath):
    print("File path {} does not exist. Exiting...".format(filepath))
    sys.exit(1)

db = mysql.connector.connect(host='localhost',
                             database='cookbook',
                             user='cbuser',
                             password='cbpass',auth_plugin='mysql_native_password')

cur = db.cursor(prepared=True)
sql = "INSERT INTO reviews(id, appliences_review) VALUES (0,%s)"

with open(filepath) as file:
    line = file.readline()
    while line:
        cur.execute(sql, (line,))
        db.commit()
        line = file.readline()

sys.exit(0)
