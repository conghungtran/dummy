# Compiler
CC = gcc
CFLAGS = -Wall -Wextra -I.

# Directories
OBJ_DIR = obj
BIN_DIR = bin

# Target executables (with path)
TARGET_NORMAL = $(BIN_DIR)/program_normal
TARGET_DUMMY = $(BIN_DIR)/program_dummy

# Source files
SRC_NORMAL = main.c hw/hw.c
SRC_DUMMY = main.c hw_dummy/hw.c

# Object files (keep directory structure)
OBJ_NORMAL = $(SRC_NORMAL:%.c=$(OBJ_DIR)/%.o)
OBJ_DUMMY = $(SRC_DUMMY:%.c=$(OBJ_DIR)/%.o)

# Default target
all: $(BIN_DIR) $(OBJ_DIR) normal dummy

# Create directories if they don't exist
$(BIN_DIR) $(OBJ_DIR):
	mkdir -p $@

# Create subdirectories for object files
$(OBJ_DIR)/hw $(OBJ_DIR)/hw_dummy:
	mkdir -p $@

# Normal mode
normal: $(TARGET_NORMAL)

$(TARGET_NORMAL): $(OBJ_NORMAL) | $(BIN_DIR)
	$(CC) $(CFLAGS) -o $@ $^

# Dummy mode
dummy: $(TARGET_DUMMY)

$(TARGET_DUMMY): $(OBJ_DUMMY) | $(BIN_DIR)
	$(CC) $(CFLAGS) -o $@ $^

# Pattern rule for object files
$(OBJ_DIR)/%.o: %.c | $(OBJ_DIR)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# Generate compile_commands.json
compiledb:
	bear -- make clean all

# Or using compiledb tool (alternative)
# compiledb:
#	compiledb make clean all

# Clean
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

# Run
run-normal: normal
	./$(TARGET_NORMAL)

run-dummy: dummy
	./$(TARGET_DUMMY)

run: normal dummy
	@echo "=== Normal version ==="
	./$(TARGET_NORMAL)
	@echo "\n=== Dummy version ==="
	./$(TARGET_DUMMY)

.PHONY: all normal dummy clean run-normal run-dummy run compiledb