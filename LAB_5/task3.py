import pandas as pd
from sqlalchemy import Column, Date, Integer, String, Time, create_engine
from sqlalchemy.orm import DeclarativeBase
from config import adress, dbname


DATABASE_URL = f'mssql+pyodbc://@{adress}/{dbname}?driver=ODBC+Driver+17+for+SQL+Server&Trusted_Connection=yes&Encrypt=No&TrustServerCertificate=yes'

engines = []
for i in range(12):
    engine = create_engine(DATABASE_URL)
    engines.append(engine)

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
    df = pd.read_sql('SELECT USERNAME, USER_ACTION, ACTION_DATE, ACTION_TIME, ACTION_RESULT FROM USER_LOGS', engines[0])
    df.columns = ['username', 'user_action', 'action_date', 'action_time', 'action_result']
    df['shard'] = df.index % 12
    print('прочитано всего ' + str(len(df)) + ' записей')
    for i in range(12):
        shard_df = df[df['shard'] == i].drop(columns=['shard'])
        if not shard_df.empty:
            shard_df.to_sql('Logs', engines[i], if_exists='append', index=False, method='multi', chunksize=400)
            print('DataBase ' + str(i + 1) + ' (шард ' + str(i + 1) + '): ' + str(len(shard_df)) + ' записей')

if __name__ == '__main__':
    main()
