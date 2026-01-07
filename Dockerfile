FROM rust:latest

RUN mkdir /src
RUN useradd -m -s /bin/bash -U coder
RUN chgrp coder /src
RUN chmod 775 /src
USER coder
WORKDIR /src
RUN git clone https://github.com/helix-editor/helix
WORKDIR /src/helix
RUN cargo install --path helix-term --locked
ENV PATH=/src/helix/target/release:$PATH
RUN hx --grammar fetch
RUN hx --grammar build
ENV HELIX_RUNTIME=/src/helix/runtime
ENV TERM=xterm-256color
ENV COLORTERM=truecolor
RUN rustup component add rust-analyzer

COPY ./languages.toml /home/coder/.config/helix/
COPY ./config.toml /home/coder/.config/helix/

VOLUME /code
WORKDIR /code

CMD rustup component add rust-analyzer && hx
