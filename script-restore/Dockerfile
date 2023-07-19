FROM mysql:8.0-debian

RUN apt-get update && \
    apt-get install -y curl gnupg2 && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update && \
    apt-get install -y google-cloud-sdk

RUN apt-get install -y zip

WORKDIR /scripts

COPY restore-mysqldb.sh .
RUN chmod +x restore-mysqldb.sh

ENV MYSQL_HOST="" \
    MYSQL_USER="" \
    MYSQL_PASSWORD="" \
    MYSQL_BUCKET_RESTORE_URI="" \
    RESTORE_FILE_NAME="" \
    RESTORE_FROM=""

CMD ["/scripts/restore-mysqldb.sh"]