# Compiler
CC = gcc
CFLAGS = -Wall -Wextra -I.

# Target executables
TARGET_NORMAL = program_normal
TARGET_DUMMY = program_dummy

# Source files
SRC_NORMAL = main.c hw/hw.c
SRC_DUMMY = main.c hw_dummy/hw.c

# Object files
OBJ_NORMAL = $(SRC_NORMAL:.c=.o)
OBJ_DUMMY = $(SRC_DUMMY:.c=.o)

# Default target
all: normal dummy

# Normal mode
normal: $(TARGET_NORMAL)

$(TARGET_NORMAL): $(OBJ_NORMAL)
	$(CC) $(CFLAGS) -o $@ $^

# Dummy mode
dummy: $(TARGET_DUMMY)

$(TARGET_DUMMY): $(OBJ_DUMMY)
	$(CC) $(CFLAGS) -o $@ $^

# Pattern rule for object files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Generate compile_commands.json
compiledb:
	bear -- make clean all

# Or using compiledb tool (alternative)
# compiledb:
#	compiledb make clean all

# Clean
clean:
	rm -f $(OBJ_NORMAL) $(OBJ_DUMMY) $(TARGET_NORMAL) $(TARGET_DUMMY)

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
