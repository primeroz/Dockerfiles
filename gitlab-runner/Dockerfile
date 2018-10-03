FROM gitlab/gitlab-runner:ubuntu-v11.3.1

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y build-essential git curl gnupg cpio python unzip bc && \
		apt-get clean all && \
		rm -rf /var/lib/apt/lists/*


