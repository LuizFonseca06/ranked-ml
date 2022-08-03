# %%
import datetime


from sqlalchemy import create_engine
from tqdm import tqdm

from ranked_ml.settings import SQLITE_DB_URL


def import_query(path):
    with open(path, "r") as open_file:
        query = open_file.read()
    return query


def process_date(query, engine, data):
    query = query.format(date=data)

    delete_query = f"delete from tb_book_players where dtRef = '{data}'"

    engine.execute(delete_query)
    engine.execute(query)

    return True


def get_date_range_list(date_start: str, date_end: str) -> list:
    date_start = datetime.datetime.strptime(date_start, "%Y-%m-%d")
    date_end = datetime.datetime.strptime(date_end, "%Y-%m-%d")
    days = (date_end - date_start).days
    dates = [(date_start + datetime.timedelta(days=i)).strftime("%Y-%m-%d") for i in range(days + 1)]
    return dates


def backfill(query, engine, dt_start, dt_stop):
    dates = get_date_range_list(dt_start, dt_stop)
    for d in tqdm(dates):
        process_date(query, engine, d)


if __name__ == '__main__':
    engine = create_engine(SQLITE_DB_URL)
    # data = '2022-02-03'  #
    date_start = input("entre com uma data de inicio: ")
    date_end = input("entre com uma data de fim: ")
    print( get_date_range_list(date_start, date_end) )

    query = import_query('query_partidas.sql')
    backfill(query, engine, date_start, date_end)

    # print(query)
    # process_date(query, engine, data)
