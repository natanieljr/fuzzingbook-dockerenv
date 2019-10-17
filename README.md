# Docker environment for the Generating Software Tests Lecture (a.k.a. fuzzinbook)

This docker image is used to run the fuzzingbook server for the lecture.

The fuzzingbook uses a docker spawner to start an independent docker image for each student. The spawner executes the script `start-singleuser-custom.sh` upon start.

All changes are stored on the server's disk (docker volumes), even if the image is changed the student's data should be preserved there.

## Building (for the fuzzingbook)

Run:

```
docker build -t jupyterhub-user .
```

