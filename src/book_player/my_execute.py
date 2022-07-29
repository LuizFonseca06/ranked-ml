# %%

import sqlalchemy
import os

from sqlalchemy import create_engine

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


if __name__ == '__main__':
    engine = create_engine(SQLITE_DB_URL)
    data = '2022-02-03'  # input("entre com uma data: ")
    query = import_query('query_partidas.sql')
    print(query)

    process_date(query, engine, data)
