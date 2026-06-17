import pandas as pd
from sqlalchemy import Column, Date, Integer, String, Time, create_engine
from sqlalchemy.orm import DeclarativeBase
from config import adress, dbname


source_url = f'mssql+pyodbc://@{adress}/{dbname}?driver=ODBC+Driver+17+for+SQL+Server&Trusted_Connection=yes&Encrypt=No&TrustServerCertificate=yes'
source_engine = create_engine(source_url)

engines = []
for i in range(1, 13):
    shard_db_name = f"{dbname}_{i}" 
    shard_url = f'mssql+pyodbc://@{adress}/{shard_db_name}?driver=ODBC+Driver+17+for+SQL+Server&Trusted_Connection=yes&Encrypt=No&TrustServerCertificate=yes'
    engines.append(create_engine(shard_url))

class Base(DeclarativeBase):
    pass

class Logs(Base):
    __tablename__ = 'User_Logs'
    id = Column(Integer, primary_key=True)
    username = Column(String, nullable=False)
    user_action = Column(String, nullable=False)
    action_date = Column(Date, nullable=False)
    action_time = Column(Time, nullable=False)
    action_result = Column(String, nullable=False)

for engine in engines:
    Logs.__table__.create(bind=engine, checkfirst=True)

def main():
    print('START')
    df = pd.read_sql('SELECT USERNAME, USER_ACTION, ACTION_DATE, ACTION_TIME, ACTION_RESULT FROM USER_LOGS', source_engine)
    df.columns = ['username', 'user_action', 'action_date', 'action_time', 'action_result']
    df['shard'] = df.index % 12
    print(f'Прочитано из основной БД: {len(df)} записей')
    for i in range(12):
        shard_df = df[df['shard'] == i].drop(columns=['shard'])
        if not shard_df.empty:
            shard_df.to_sql('User_Logs', engines[i], if_exists='append', index=False, method='multi', chunksize=400)
            print(f'Узел {i + 1} (БД {dbname}_{i+1}): записано {len(shard_df)} записей')

if __name__ == '__main__':
    main()
