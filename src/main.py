from google.cloud import storage, bigquery
import pandas as pd
import io

def etl_handler(request):
    # GCSからCSVを読み込み
    storage_client = storage.Client()
    bucket = storage_client.bucket('dev-karasuit-etl-data')
    blob = bucket.blob('raw/iris_blank.csv')
    content = blob.download_as_bytes()

    # pandasでETL処理
    df = pd.read_csv(io.BytesIO(content))
    df.fillna({
        'sepal_length': df['sepal_length'].mean(),
        'sepal_width': df['sepal_width'].std(),
        'petal_length': df['petal_length'].mean(),
        'petal_width': df['petal_width'].var(),
        'species': df['species'].mode()[0]
    }, inplace=True)
    # BigQueryへロード
    bq_client = bigquery.Client()
    table_id = '<Project ID>.cleaned_iris_table'
    job = bq_client.load_table_from_dataframe(df, table_id)
    job.result()

    return 'ETL complete and table created', 200
