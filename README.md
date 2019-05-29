# docker-wkhtmltopdf-webservice
Docker based webservice based on ubuntu and wkhtmltopdf

This image is based on the 
[docker-wkhtmltopdf-aas](https://github.com/openlabs/docker-wkhtmltopdf-aas).

## Running the service

Run the container with docker run and binding the ports to the host.
The web service is exposed on port 80 in the container.

```sh
docker build -t wkhtmltopdf-webservice/wkhtmltopdf .

docker run -d -P -t wkhtmltopdf-webservice/wkhtmltopdf
```

Find the port that the container is bound to:

```sh
docker ps
```

## Using the webservice

This is a convenient way to use the service from command line
utilities like curl.

```sh
curl -vv -F 'file=@path/to/local/file.html' http://<docker-host>:<port>/ -o path/to/output/file.pdf

EG: curl -vv -F file=@C:/<>/test.html http://<>:<> -o C:/<>/test.pdf
```

where:

* docker-host is the hostname or address of the docker host running the container
* port is the public port to which the container is bound to.
