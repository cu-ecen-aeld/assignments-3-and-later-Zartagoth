HEADERS =
OBJECTS = writer.o

default: writer

%.o: %.c $(HEADERS)
	$(CC) -c $< -o $@

writer: $(OBJECTS)
	$(CC) $(OBJECTS) -o $@

clean:
	-rm -f $(OBJECTS)
	-rm -f writer
