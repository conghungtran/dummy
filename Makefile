# Compiler và flags
CC = gcc
CFLAGS = -Wall -Wextra -I.

# Tên file thực thi
TARGET_NORMAL = build_normal
TARGET_DUMMY = build_dummy

# File object
OBJ_NORMAL = main.o hw.o
OBJ_DUMMY = main.o hw_dummy.o

# Mặc định build cả 2 chế độ
all: normal dummy

# Build chế độ bình thường
normal: $(TARGET_NORMAL)

$(TARGET_NORMAL): $(OBJ_NORMAL)
	$(CC) $(CFLAGS) -o $@ $^

main.o: main.c hw.h
	$(CC) $(CFLAGS) -c $< -o $@

hw.o: hw.c hw.h
	$(CC) $(CFLAGS) -c $< -o $@

# Build chế độ dummy
dummy: $(TARGET_DUMMY)

$(TARGET_DUMMY): $(OBJ_DUMMY)
	$(CC) $(CFLAGS) -o $@ $^

hw_dummy.o: hw_dummy.c hw.h
	$(CC) $(CFLAGS) -c $< -o $@

# Clean file object và executable
clean:
	rm -f *.o $(TARGET_NORMAL) $(TARGET_DUMMY)

# Chạy chương trình ở cả 2 chế độ
run: normal dummy
	@echo "=== Chay che do binh thuong ==="
	./$(TARGET_NORMAL)
	@echo ""
	@echo "=== Chay che do dummy ==="
	./$(TARGET_DUMMY)

# Phony targets
.PHONY: all normal dummy clean run
