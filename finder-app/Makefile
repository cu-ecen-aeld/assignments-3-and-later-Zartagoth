TARGET = writer
OBJECTS = writer.o

CROSS_COMPILE :=
CC := $(CROSS_COMPILE)gcc

default: $(TARGET)

%.o: %.c $(HEADERS)
	$(CC) -c $< -o $@

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -o $@

clean:
	-rm -f $(OBJECTS) $(TARGET)
