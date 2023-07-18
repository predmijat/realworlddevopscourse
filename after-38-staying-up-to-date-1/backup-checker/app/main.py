import datetime
import logging
import os
import sys
from typing import Tuple

import apprise
from dotenv import load_dotenv
import mysql.connector
from tabulate import tabulate

load_dotenv()

today = datetime.datetime.now().date().isoformat()
db_host = f'{os.getenv("db_host")}'
db_username = f'{os.getenv("db_username")}'
db_password = f'{os.getenv("db_password")}'
database = f'{os.getenv("database")}'
db_table = f'{os.getenv("db_table")}'
zulip_bot_email = f'{os.getenv("zulip_bot_email")}'
zulip_bot_api_key = f'{os.getenv("zulip_bot_api_key")}'
zulip_organization = f'{os.getenv("zulip_organization")}'
zulip_stream = f'{os.getenv("zulip_stream")}'
zulip_topic = f'{os.getenv("zulip_topic")}'
message_success = "everything is a-ok"
message_fail = "something went wrong"


def configure_logging() -> None:
    log_formatter = logging.Formatter("%(asctime)s %(levelname)s %(message)s")
    root_logger = logging.getLogger()
    log_level = logging.getLevelName(os.getenv("LOG_LEVEL", "INFO"))
    root_logger.setLevel(log_level)

    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setFormatter(log_formatter)
    root_logger.addHandler(console_handler)


def get_backups_table() -> Tuple:
    try:
        connection = mysql.connector.connect(
            host=db_host, user=db_username, password=db_password, database=database
        )
    except mysql.connector.Error as e:
        logging.error(f"database connection error: {e}")
        raise

    logging.info("database connection successful")
    logging.info(
        f"db_host: {db_host},"
        f"db_username: {db_username},"
        f"db_password: *****,"
        f"database: {database}"
    )

    query = f'select * from {db_table} where date="{today}"'
    cursor = connection.cursor()
    logging.info(f"executing query: {query}")
    try:
        cursor.execute(query)
    except mysql.connector.Error as e:
        logging.error(f"query execution error: {e}")
        raise

    records = cursor.fetchall()
    column_names = [x[0] for x in cursor.description]
    return column_names, records


def get_expected_backups() -> list:
    with open("./expected-backups", "r") as f:
        expected_backups = [row.strip("\n") for row in f]

    return expected_backups


def compare(expected: list, done: list) -> bool:
    if expected != done:
        logging.info(f"backup list mismatch:")
        logging.info(f"expected: {expected}")
        logging.info(f"done: {done}")
        return False
    logging.info(f"all backups done!")
    return True


def send_notification(**kwargs) -> None:
    for k, v in kwargs.items():
        logging.info(f"{k} = {v}")
    logging.info("sending notification...")

    message = kwargs["message"]
    body = str(kwargs["body"])

    apobj = apprise.Apprise()
    apprise_string = f"zulip://{zulip_bot_email}@{zulip_organization}/{zulip_bot_api_key}/{zulip_stream}/"
    apobj.add(apprise_string)
    apobj.notify(
        body=f"```" f"\n" f"{message}" f"\n" f"{body}" f"\n" f"```",
        body_format=apprise.NotifyFormat.MARKDOWN,
        title=zulip_topic,
    )


def main() -> None:
    configure_logging()
    try:
        column_names, backups_table = get_backups_table()
        done_backups = [x[2] for x in backups_table if x[5] == "success"]
        done_backups = sorted(set(done_backups))
        expected_backups = get_expected_backups()
        expected_backups.sort()
        pretty_table = tabulate(backups_table, headers=column_names, tablefmt="pretty")

    except Exception as e:
        send_notification(message=message_fail, body=e)
        sys.exit(1)

    backups_ok = compare(expected_backups, done_backups)
    if not backups_ok:
        message = (
            f"{message_fail}\n"
            f"expected_backups and done_backups do not match:\n"
            f"expected backups: {expected_backups}\n"
            f"done backups: {done_backups}\n"
            f"diff: {list(set(expected_backups) ^ set(done_backups))}\n"
        )

        send_notification(message=message, body=pretty_table)
        sys.exit(1)

    send_notification(message=message_success, body=pretty_table)

    logging.info("done, exiting...")


if __name__ == "__main__":
    main()
