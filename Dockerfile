FROM ubuntu:xenial

RUN apt-get update && apt-get install -y \
    git \
    ruby \
    ack-grep \
    tmux \
    build-essential \
    libncurses5-dev \
    ruby-dev \
    python-dev \
    python3-dev \
    python-pip \
    python3-pip

RUN gem install rake \
    && gem install rubocop \
    && pip install flake8 \
    && pip3 install flake8

RUN git clone --depth 1 https://github.com/vim/vim.git \
 && cd vim && ./configure \
   --with-features=huge \
   --enable-rubyinterp \
   --enable-pythoninterp \
   --enable-python3interp \
   --enable-perlinterp \
   --enable-luainterp\
   make VIMRUNTIMEDIR=/usr/share/vim/vim74 && \
   make install \
 && cd .. && rm -rf vim

RUN adduser --disabled-password --gecos "" -uid 1001 rat

USER rat
WORKDIR /home/rat

RUN git clone --depth 1 --recursive \
    https://github.com/carlhuda/janus.git .vim \
    && cd .vim && rake

RUN mkdir .janus && cd .janus && git clone https://github.com/benmills/vimux.git

RUN ln -s  /dotfiles/vim/.vimrc.after   /home/rat/.vimrc.after  && \
    ln -s  /dotfiles/vim/.vimrc.before  /home/rat/.vimrc.before && \
    ln -s  /dotfiles/ack/.ackrc         /home/rat/.ackrc

USER root
RUN apt-get remove -y \
    build-essential \
    libncurses5-dev \
    ruby-dev \
    python-dev \
    python3-dev \
    && apt-get autoremove -y

CMD vim
