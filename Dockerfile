FROM debian:jessie

################
# dependencies #
################
RUN apt-get update && \
    apt-get install -y moreutils && \
    apt-get install -y git && \
    apt-get install -y python-pip && \
    apt-get install -y libffi-dev libssl-dev && \
    apt-get install -y python-gevent python-simplejson && \
    apt-get install -y xfonts-base xfonts-75dpi libjpeg62-turbo && \
    apt-get install -y python-dev build-essential libxml2-dev libxslt1-dev && \
    apt-get install -y libjpeg62-turbo-dev zlib1g-dev && \
    apt-get install -y adduser node-less node-clean-css python python-dateutil python-decorator python-docutils python-feedparser python-imaging python-jinja2 python-ldap python-libxslt1 python-lxml python-mako python-mock python-openid python-passlib python-psutil python-psycopg2 python-pybabel python-pychart python-pydot python-pyparsing python-pypdf python-reportlab python-requests python-suds python-tz python-vatnumber python-vobject python-werkzeug python-xlwt python-yaml && \
    apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            node-less \
            node-clean-css \
            python-pyinotify \
            python-renderpm \
            python-support && \
    # postgresql-client-9.5
    curl --silent https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' >> /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    apt-get install -y postgresql-client-9.5 && \
    # wkhtmltopdf
    curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb && \
    dpkg --force-depends -i wkhtmltox.deb && \
    apt-get -y install -f --no-install-recommends && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm && \
    rm -rf /var/lib/apt/lists/* wkhtmltox.deb && \
    # pip dependencies
    pip install pip --upgrade && \
    pip install pillow psycogreen && \
    pip install Boto && \
    pip install FileChunkIO && \
    pip install pysftp && \
    pip install rotate-backups && \
    pip install oauthlib && \
	pip install ptvsd==3.0.0rc1 && \
    pip install requests --upgrade && \
    # check that pip is not broken after requests --upgrade
    pip --version


########################
# docker configuration #
########################
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
EXPOSE 8069 8072 8080
USER odoo
VOLUME ["/mnt/odoo-source/", \
       "/mnt/addons/extra"]
# /mnt/addons/extra is used for manually added addons.
# Expected structure is:
# /mnt/addons/extra/REPO_OR_GROUP_NAME/MODULE/__openerp__.py
#
# we don't add /mnt/odoo-source, /mnt/addons, /mnt/config to VOLUME in order to allow modify theirs content in inherited dockers

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/mnt/odoo-source/openerp-server"]
