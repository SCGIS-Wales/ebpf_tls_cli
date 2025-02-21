# Complete Makefile for building the eBPF program and user-space application

# Compiler and flags
CC = clang
CFLAGS = -O2 -target bpf -I./include  # Include the headers from the 'include' directory

# Paths
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
INCLUDE_DIR = include

# Sources and objects
BPF_PROGRAM = $(SRC_DIR)/bpf_program.c
USER_PROGRAM = $(SRC_DIR)/user_space.c
CLI_TOOL = $(SRC_DIR)/cli_tool.c
BPF_OBJECT = $(OBJ_DIR)/bpf_program.o
USER_OBJECT = $(OBJ_DIR)/user_space.o
CLI_OBJECT = $(OBJ_DIR)/cli_tool.o

# Output binaries
USER_BINARY = $(BIN_DIR)/user_space
CLI_BINARY = $(BIN_DIR)/cli_tool

# Create necessary directories
$(OBJ_DIR) $(BIN_DIR):
	@echo "Creating directories: $(OBJ_DIR) and $(BIN_DIR)"
	mkdir -p $(OBJ_DIR) $(BIN_DIR)

# Default target
all: $(OBJ_DIR) $(BIN_DIR) $(BPF_OBJECT) $(USER_BINARY) $(CLI_BINARY)

# Compile eBPF program
$(BPF_OBJECT): $(BPF_PROGRAM) | $(OBJ_DIR)
	@echo "Compiling eBPF program: $<"
	$(CC) $(CFLAGS) -c $< -o $@ || { echo "Error compiling $<"; exit 1; }

# Compile user-space program
$(USER_OBJECT): $(USER_PROGRAM) | $(OBJ_DIR)
	@echo "Compiling user-space program: $<"
	gcc -I$(INCLUDE_DIR) -c $< -o $@ || { echo "Error compiling $<"; exit 1; }

# Compile CLI tool
$(CLI_OBJECT): $(CLI_TOOL) | $(OBJ_DIR)
	@echo "Compiling CLI tool: $<"
	gcc -I$(INCLUDE_DIR) -c $< -o $@ || { echo "Error compiling $<"; exit 1; }

# Link user-space binary
$(USER_BINARY): $(USER_OBJECT) | $(BIN_DIR)
	@echo "Linking user-space binary: $@"
	gcc -o $@ $^ || { echo "Error linking $@"; exit 1; }

# Link CLI tool binary
$(CLI_BINARY): $(CLI_OBJECT) | $(BIN_DIR)
	@echo "Linking CLI tool binary: $@"
	gcc -o $@ $^ || { echo "Error linking $@"; exit 1; }

# Clean up build artifacts
clean:
	@echo "Cleaning up build artifacts..."
	rm -rf $(OBJ_DIR) $(BIN_DIR)
