HEADERS =
OBJECTS = writer.o

default: writer

%.o: %.c $(HEADERS)
	gcc -c $< -o $@

writer: $(OBJECTS)
	gcc $(OBJECTS) -o $@

clean:
	-rm -f $(OBJECTS)
	-rm -f writer