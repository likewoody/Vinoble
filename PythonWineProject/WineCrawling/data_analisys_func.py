# key를 dic의 key로 사용하여 valueList의 value값을 list로 넣는 함수
def df_dictionary_column(self, df, key, valueList):
    
    info = {}

    for i in range(len(df)):
        valueData = df[valueList].iloc[i]
        keyData = df[key].iloc[i]
        if not(keyData in info):
            info[keyData] = []
            
        info[keyData].append(valueData)

    return info