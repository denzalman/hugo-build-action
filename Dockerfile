FROM alpine:latest
LABEL maintainer="Den Zalman <den.devops@gmail.com>"

LABEL "com.github.actions.name"="Hugo to Github Pages"
LABEL "com.github.actions.description"="Build and deploy a hugo static site to GitHub Pages"
LABEL "com.github.actions.icon"="target"
LABEL "com.github.actions.color"="black"

RUN	apk add --no-cache \
	bash \
	ca-certificates \
	curl \
	git

COPY action.sh /usr/bin/action.sh
RUN chmod +x /usr/bin/action.sh

ENTRYPOINT ["./usr/bin/action.sh"]