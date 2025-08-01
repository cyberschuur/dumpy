FROM almalinux:9 AS builder
RUN dnf -y install dnf-plugins-core
RUN dnf config-manager --set-enabled crb
RUN dnf -y install gcc libpcap-devel
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH=/root/.cargo/bin:$PATH
WORKDIR /src
COPY . .
RUN cargo build --release

FROM almalinux/9-minimal
RUN microdnf -y install libpcap
COPY --from=builder /src/target/release/dumpy /bin/dumpy
WORKDIR /config
VOLUME /config
ENTRYPOINT ["/bin/dumpy"]
