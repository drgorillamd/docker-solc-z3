# Use Arch Linux as base image
FROM archlinux

# Set the path to include the foundry, z3 and solc binaries we are about to install
ENV PATH="/root/.foundry/bin:/usr/bin/:/usr/local/bin/:$PATH"

# Update and install required packages
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm base-devel wget git cmake boost ninja cvc4 python && \
    pacman -Scc --noconfirm

# Build and install Z3
RUN git clone --recursive https://github.com/Z3Prover/z3.git
WORKDIR /z3/
RUN git checkout 8e6f17ebd011a352b3e67fcec03dcd4378a1472c
RUN python scripts/mk_make.py
WORKDIR /z3/build/
RUN make
RUN make install
WORKDIR /

# Create symbolic links for libz3
RUN ln -s /usr/lib/libz3.so /usr/lib/libz3.so.4
RUN ln -s /usr/lib/libz3.so /usr/lib/libz3.so.4.11

# Build and install solc
RUN git clone --recursive https://github.com/ethereum/solidity.git
WORKDIR /solidity/
RUN git checkout 7dd6d404815651b2341ecae220709a88aaed4038
RUN ./scripts/build.sh

# Install Foundry
RUN curl -L https://foundry.paradigm.xyz | bash && \
    ~/.foundry/bin/foundryup

# Set the working directory
WORKDIR /project-src

# Set the default command to run when the container starts
CMD ["bash"]
