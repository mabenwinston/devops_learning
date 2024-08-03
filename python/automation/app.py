from flask import Flask, jsonify
import subprocess
import configparser
import psycopg2

app = Flask(__name__)

def parse_data():
    try:
        result = subprocess.run(['sh', '-c', 'df -h | tail -n +2'], capture_output=True, text=True)
        space_data = result.stdout
        lines = space_data.strip().split("\n")
        parsed_data = []
        for line in lines:
            parts = line.split()
            filesystem = parts[0]
            size = parts[1]
            used = parts[2]
            available = parts[3]
            use_percentage = parts[4]
            mounted_on = parts[5]
            parsed_data.append((filesystem, size, used, available, use_percentage, mounted_on))    
        return parsed_data
    except Exception as e:
        print(f"Data parsing failed: {e}")

def db_operation(section='POSTGRES'):
    parsed_data = parse_data()
    config = configparser.ConfigParser()
    config.read('db.properties')
    if not config.has_section(section):
        raise Exception(f"Section {section} not found in the configuration file")
    global db_params 
    db_params = {}
    for key, value in config.items(section):
        db_params[key] = value

    try:
        connection = psycopg2.connect(**db_params)
        cursor = connection.cursor()
        drop_query = """
        DROP TABLE IF EXISTS FILESYSTEM CASCADE
        """
        create_query = """
        CREATE TABLE filesystem (
        filesystem VARCHAR(255),
        size VARCHAR(50),
        used VARCHAR(50),
        available VARCHAR(50),
        use_percentage VARCHAR(10),
        mounted_on VARCHAR(255))
        """
        insert_query = """
        INSERT INTO FILESYSTEM (filesystem, size, used, available, use_percentage, mounted_on) VALUES (%s, %s, %s, %s, %s, %s)
        """
        cursor.execute(drop_query)
        cursor.execute(create_query)
        cursor.executemany(insert_query, parsed_data)
        connection.commit()
        cursor.close()
        connection.close()
    except Exception as e:
        print(f"Unable to establish connection or execute query: {e}")

@app.route('/filesystem', methods=['GET'])

def fetch_api():
    # try:
    #     update_db = db_operation()
    #     connection = psycopg2.connect(**db_params)
    #     cursor = connection.cursor()
    #     select_query = """
    #     select * from filesystem where filesystem = 'drivers' or filesystem like '%/dev%'  ;
    #     """
    #     cursor.execute(select_query)
    #     temp = cursor.fetchall()
    #     print(temp)
    #     cursor.close()
    #     connection.close()
    # except Exception as e:
    #     return jsonify({"error": str(e)}), 500

    try:
        update_db = db_operation()
        connection = psycopg2.connect(**db_params)
        cursor = connection.cursor()
        select_query = """
        select * from filesystem where filesystem = 'drivers' or filesystem like '%/dev%'  ;
        """
        cursor.execute(select_query)
        rows = cursor.fetchall()
        columns = [desc[0] for desc in cursor.description]
        # for desc in cursor.description:
        #    columns.append(desc[0])
        cursor.close()
        connection.close()
        data = [dict(zip(columns, row)) for row in rows]
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':

    app.run(debug=True)