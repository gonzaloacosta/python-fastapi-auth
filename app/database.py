from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base


# db_path = os.getenv('DB_PATH')
db_file = "/apikeys.db"
db_url = "sqlite://" + db_file

# Create a sqlite engine instance
engine = create_engine(db_url)

# Create a declarative meta instance
Base = declarative_base()
