TARGET = writer
SRC := writer.c 
OBJECTS := $(SRC:.c=.o)

CROSS_COMPILE :=
CC := $(CROSS_COMPILE)gcc

default: $(TARGET)

$(TARGET) : $(OBJECTS)
	$(CC) $(CFLAGS) $(INCLUDES) $(OBJECTS) -o $(TARGET) $(LDFLAGS)

clean:
	-rm -f *.o $(TARGET) *.elf *.map