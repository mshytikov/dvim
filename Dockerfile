FROM alpine

RUN apk update && apk add --no-cache\
    git \
    tmux \
    ruby \
    python3 \
    py2-pip \
    ncurses-dev \
    shadow \
    build-base \
    ruby-dev

RUN gem install rake --no-ri --no-rdoc \
    && gem install rubocop --no-ri --no-rdoc \
    && pip install flake8 \
    && pip3 install flake8

RUN apk add --no-cache vim

RUN adduser --disabled-password --gecos "" -u 1001 rat

USER rat
WORKDIR /home/rat

RUN git clone --depth 1 --recursive \
    https://github.com/carlhuda/janus.git .vim \
    && cd .vim && rake && rm -rf .git/

RUN mkdir .janus && cd .janus && git clone https://github.com/benmills/vimux.git

RUN ln -s  /dotfiles/vim/.vimrc.after   /home/rat/.vimrc.after  && \
    ln -s  /dotfiles/vim/.vimrc.before  /home/rat/.vimrc.before && \
    ln -s  /dotfiles/ack/.ackrc         /home/rat/.ackrc

USER root

RUN apk del build-base \
    ncurses-dev \
    ruby-dev

CMD vim
