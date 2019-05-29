FROM ubuntu:18.04

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Download and install wkhtmltopdf
RUN DEBIAN_FRONTEND=noninteractive apt-get install lightdm -y build-essential xorg libssl-dev libxrender-dev wget gdebi
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb
RUN gdebi --n wkhtmltox_0.12.5-1.bionic_amd64.deb

# Install dependencies for running web service
RUN DEBIAN_FRONTEND=noninteractive apt-get install lightdm -y python-pip apt-utils
RUN pip install werkzeug executor gunicorn

RUN DEBIAN_FRONTEND=noninteractive apt-get install lightdm -y fonts-crosextra-caladea fonts-crosextra-carlito lmodern ttf-goudybookletter ttf-mplus fonts-wqy-zenhei ttf-ubuntu-font-family fonts-liberation fonts-thai-tlwg gsfonts ttf-dejavu ttf-dejavu-extra ttf-bitstream-vera ttf-adf-accanthis ttf-adf-baskervald ttf-adf-berenis ttf-adf-gillius ttf-adf-ikarius ttf-adf-irianis ttf-adf-libris ttf-adf-mekanus ttf-adf-oldania ttf-adf-romande ttf-adf-switzera ttf-adf-tribun ttf-adf-universalis ttf-adf-verana ttf-ancient-fonts ttf-anonymous-pro ttf-aenigma t1-xfree86-nonfree ttf-xfree86-nonfree ttf-xfree86-nonfree-syriac ttf-marvosym ttf-fifthhorseman-dkg-handwriting texlive-fonts-recommended ttf-sil-scheherazade ttf-wqy-microhei ttf-wqy-zenhei fonts-nanum fonts-nanum-extra

RUN apt-get update
RUN apt-get upgrade -y

ADD app.py /app.py
EXPOSE 80

#ENTRYPOINT ["usr/local/bin/gunicorn"]

# Show the extended help
#CMD ["-b", "0.0.0.0:80", "--log-file", "-", "app:application"]

CMD ["usr/local/bin/gunicorn", "-b", "0.0.0.0:80", "--log-file", "-", "app:application"]
