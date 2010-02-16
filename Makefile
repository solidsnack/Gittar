
T=/usr/local/bin/gittar

install:
	install -o root -g root -m 775 ./bin/gittar.sh $T

uninstall:
	rm $T

