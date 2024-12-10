FROM registry.access.redhat.com/ubi9/nginx-124:1-25.1729775649

COPY ./dist/spd-application .
COPY ./nginx-ubi9.conf "${NGINX_CONF_PATH}"

ENV ANGULAR__BASE_HREF=/
ENV SAC_IDENTITIES="[]"

USER root

RUN chmod -R a+rwx ${APP_ROOT} && \
    rpm-file-permissions

USER 1001

CMD ["/bin/sh", "-c", "mv index.html index.template.html && envsubst < index.template.html > index.html && envsubst < /opt/app-root/src/assets/js/env.template.js > /opt/app-root/src/assets/js/env.js && exec nginx -g 'daemon off;'"]

HEALTHCHECK \
  CMD curl --fail http://localhost/health || exit 1
