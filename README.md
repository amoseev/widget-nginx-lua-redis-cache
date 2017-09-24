## Usage


1. Build and run container

    ```
    ./run.sh
    ```
2. Seed redis key
    ```
    $ redis-cli
    set path_/api/v1/cache/asdf_lang_ru-RU '{"body": "435","status": 200, "headers": {"Access-Control-Allow-Origin": [ "*" ], "content-type": [ "application/json" , "application/text"]}}'
    ```
3. Fetch response from redis cache

    http://localhost/api/v1/cache/asdf