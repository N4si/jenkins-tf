import json
import boto3
import psycopg2
from botocore.exceptions import ClientError
import os

def get_secret(secret_name):
    """Retrieve the secret value from AWS Secrets Manager."""
    session = boto3.session.Session()
    client = session.client(service_name='secretsmanager')
    
    try:
        # Retrieve the secret value
        get_secret_value_response = client.get_secret_value(SecretId=secret_name)
    except ClientError as e:
        # Handle exceptions
        raise e
    
    # Decrypt the secret if it's in SecretString format
    if 'SecretString' in get_secret_value_response:
        return json.loads(get_secret_value_response['SecretString'])
    else:
        return base64.b64decode(get_secret_value_response['SecretBinary'])

def lambda_handler(event, context):
    """Lambda function handler to connect to RDS and execute a query."""
    secret_name = "your-secret-name"  # Replace with your secret name in Secrets Manager
    secret = get_secret(secret_name)
    
    # RDS database credentials from the secret
    db_host = secret['host']
    db_name = secret['dbname']
    db_user = secret['username']
    db_password = secret['password']
    
    # Create a connection to the PostgreSQL RDS instance
    try:
        connection = psycopg2.connect(
            host=db_host,
            dbname=db_name,
            user=db_user,
            password=db_password
        )
        cursor = connection.cursor()
        
        # Example query: Replace with your actual SQL query
        query = "SELECT * FROM your_table_name LIMIT 10;"
        cursor.execute(query)
        
        # Fetch query results
        results = cursor.fetchall()
        
        # Close the cursor and connection
        cursor.close()
        connection.close()

        # Returning the query results as a JSON response
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Query executed successfully',
                'results': results
            })
        }
    
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Failed to execute query',
                'error': str(e)
            })
        }
