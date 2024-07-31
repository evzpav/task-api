# TASK API

It is a Node CRUD boilerplate using Postgres with frontend in React.

## Requirements
    Node v20.16.0 
    Docker
    Make

## Install dependencies
```
    make install
```

## Run Postgres DB
```bash
   make run-postgres
```

<!-- ## Run migrations
```bash
   make sql-scripts
``` -->

## Running
### Local development

#### Run front (dev server)
```bash
    make run-front

    #Frontend will be running on localhost:3000
```

#### Run backend locally on port 7777
```bash
    make run

    #Backend endpoints will be running on localhost:7777/v1
```
### Pre production
#### Run backend on docker - backend serves frontend build folder
```bash
    make run-docker

    #Frontend will be running on localhost:8888
    #Backend endpoints will be running on localhost:8888/v1
```


