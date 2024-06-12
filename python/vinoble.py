# -*- coding: utf-8 -*-
"""
위에 소스를 통해 utf-8을 통해 코딩을 하겠다라는 의미이다.

Author: Woody Jo
Description: VINOBLE MySQL python database와 CRUD
"""

# jsonify : json을 만들어주는
# request : http 신호 연결 해주는
# joblib : h5를 불러오기 위함
# pymysql : MySQL 불러오기
# flask의 jsonify는 ascii code이다
from flask import Flask, request #
# import json
import pymysql
import pandas as pd
from langchain_community.embeddings import HuggingFaceEmbeddings
import numpy as np
import joblib

app = Flask(__name__) # http://localhost:5000 까지 선언 됌
app.config['JSON_AS_ASCII'] = False # for utf8 

@app.route("/selectVinoble")
def select():
    # MySQL Connection이 필요하다.
    conn = pymysql.connect(
        host="192.168.10.15",
        user="vinoble",
        password="qwer1234",
        db="vinoble", # scheme name
        charset="utf8" # encoding
    )

    # startCount = int(request.args.get("startCount"))
    # lastCount = int(request.args.get("lastCount"))
    region = int(request.args.get("region"))
    wineType = int(request.args.get("wineType"))
    # userSearch = request.args.get("userSearch")

    # Connection으로부터 Cursor 생성
    curs = conn.cursor() # instance

    # SQL 문장
    sql = "select * from vinoble"

    # 실행하기
    curs.execute(sql)

    # select이기 때문에 fetchall()
    rows = curs.fetchall()

    conn.close()

    # print(rows)
    # # 데이터 컬럼들
    cols = ['index', 'wineImage', 'name', 'rating', 'winery', 'wineType', 'alcohol', 'year', 'price', 'bodyPercent', 'tanning', 'sugar', 'pH', 'region', 'grapeTypes', 'description', 'food1', 'food2', 'food3', 'food4', 'food5', 'foodname1', 'foodname2', 'foodname3', 'foodname4', 'foodname5']
    # # MySQL 데이터를 dict으로 만들기 위해 df 으로 만들기
    df = pd.DataFrame(
        rows,
        columns=cols
    )

    df.drop(['foodname1', 'foodname2', 'foodname3', 'foodname4', 'foodname5'],axis=1, inplace=True)

    match wineType:
        case 0:
            match region:
                case 0:
                    df = df[df['wineType'] == 'red']
                case 1:
                    df = df[(df['wineType'] == 'red') & (df['region'] == 'Bordeaux')]
                case 2:
                    df = df[(df['wineType'] == 'red') & (df['region'] == 'Bourgogne')]
                case 3:
                    df = df[(df['wineType'] == 'red') & (df['region'] == 'Rhone Valley')]
        
        case 1:
            match region:
                case 0:
                    df = df[df['wineType'] == 'white']
                case 1:
                    df = df[(df['wineType'] == 'white') & (df['region'] == 'Bordeaux')]
                case 2:
                    df = df[(df['wineType'] == 'white') & (df['region'] == 'Bourgogne')]
                case 3:
                    df = df[(df['wineType'] == 'white') & (df['region'] == 'Rhone Valley')]
        
    final_datas = []
    for i in range(len(df)):
            final_datas.append(df.iloc[i].to_dict())

    # return final_datas[0:lastCount]
    return final_datas

@app.route("/searchProduct")
def searchProduct():
    # MySQL Connection이 필요하다.
    conn = pymysql.connect(
        host="192.168.10.15",
        user="vinoble",
        password="qwer1234",
        db="vinoble", # scheme name
        charset="utf8" # encoding
    )

    searchProduct = request.args.get("searchProduct")
    # startCount = int(request.args.get("startCount"))
    # lastCount = int(request.args.get("lastCount"))
    

    # Connection으로부터 Cursor 생성
    curs = conn.cursor() # instance

    # SQL 문장
    sql = "select * from vinoble"

    # 실행하기
    curs.execute(sql)

    # select이기 때문에 fetchall()
    rows = curs.fetchall()

    conn.close()

    # print(rows)
    # # 데이터 컬럼들
    cols = ['index', 'wineImage', 'name', 'rating', 'winery', 'wineType', 'alcohol', 'year', 'price', 'bodyPercent', 'tanning', 'sugar', 'pH', 'region', 'grapeTypes', 'description', 'food1', 'food2', 'food3', 'food4', 'food5', 'foodname1', 'foodname2', 'foodname3', 'foodname4', 'foodname5']
    # # MySQL 데이터를 dict으로 만들기 위해 df 으로 만들기
    df = pd.DataFrame(
        rows,
        columns=cols
    )
    df.drop(['foodname1', 'foodname2', 'foodname3', 'foodname4', 'foodname5'],axis=1, inplace=True)

    # index 추가하기 위해
    df.reset_index(inplace=True)
    
    final_datas = []
    for i in range(len(df)):
        if searchProduct.lower() in df.iloc[i]['name'].lower():
            final_datas.append(df.iloc[i].to_dict())

    # return final_datas[0:lastCount]
    return final_datas


@app.route("/topKeyowrds")
def topKeyWords():
    df = pd.read_csv("./df_description_word_tokens.csv")
    keyword_map = []
    # false 값과 함
    for i in df.Refind_Word.head(10):
        keyword_map.append({"keyword":i})
    keyword_map

    return keyword_map


@app.route("/recommend")
def recommend():
    # MySQL Connection이 필요하다.
    conn = pymysql.connect(
        host="192.168.10.15",
        user="vinoble",
        password="qwer1234",
        db="vinoble", # scheme name
        charset="utf8" # encoding
    )

    # Connection으로부터 Cursor 생성
    curs = conn.cursor() # instance

    # SQL 문장
    sql = "select * from vinoble"

    # 실행하기
    curs.execute(sql)

    # select이기 때문에 fetchall()
    rows = curs.fetchall()

    conn.close()

    # print(rows)
    # # 데이터 컬럼들
    cols = ['index', 'wineImage', 'name', 'rating', 'winery', 'wineType', 'alcohol', 'year', 'price', 'bodyPercent', 'tanning', 'sugar', 'pH', 'region', 'grapeTypes', 'description', 'food1', 'food2', 'food3', 'food4', 'food5', 'foodname1', 'foodname2', 'foodname3', 'foodname4', 'foodname5']

    # # MySQL 데이터를 dict으로 만들기 위해 df 으로 만들기
    df = pd.DataFrame(
        rows,
        columns=cols
    )

    df.drop(['foodname1', 'foodname2', 'foodname3', 'foodname4', 'foodname5'],axis=1, inplace=True)
    
    searchRecommend = request.args.get("searchRecommend")

    # 코사인 함수
    def cos_sim(a, b):
        dot = np.dot(a, b)
        norm_a = np.linalg.norm(a)
        norm_b = np.linalg.norm(b)
        return dot / (norm_a * norm_b)

    # 모델 만들기 for 아래 for문
    embeddings_model = HuggingFaceEmbeddings(
        model_name='jhgan/ko-sroberta-nli', # 모델 지정
        model_kwargs={'device':'cpu'}, # cpu or gpu 설정
        encode_kwargs={'normalize_embeddings':True}, # 임베딩 정규화 for 유사도 계산시 일관성을 높이기 위함
    )

    # 학습내용 불러오기
    embeddings = joblib.load('./huggingFaceEmbedding.h5')

    # user input
    embedded_query = embeddings_model.embed_query(searchRecommend)
    
    

    # 학습한 embeddings로 코사인 유사도 return
    result = [cos_sim(embedding, embedded_query) for embedding in embeddings]
    df['cosSim'] = result

    # return top 4
    df.sort_values(by='cosSim', ascending=False).head(4)

    final_datas = []
    for i in range(4):
        final_datas.append(df.sort_values(by='cosSim', ascending=False).iloc[i].to_dict())

    # return final_datas[0:lastCount]
    return final_datas



# 실행시키기 위해서 if문 필요
# 주로 port 5000번 사용, debug 사용해야 에러 확인 가능
# FAST API 8000번 사용
if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=True)