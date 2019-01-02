FROM gitlab/gitlab-runner:ubuntu-v11.6.0

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y build-essential git curl gnupg cpio python unzip bc ncurses-dev && \
		apt-get clean all && \
		rm -rf /var/lib/apt/lists/*

RUN groupadd -g 2000 privoxy
    #useradd -g privoxy -M -N --shell /usr/sbin/nologin -u 2000 privoxy
