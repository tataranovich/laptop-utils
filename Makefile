.PHONY: install uninstall

install:
	install -d $(DESTDIR)/etc/pm/sleep.d $(DESTDIR)/etc/default $(DESTDIR)/usr/bin $(DESTDIR)/etc/xdg/autostart
	install -m 0755 src/rtchibernate $(DESTDIR)/etc/pm/sleep.d/00rtchibernate
	install -m 0644 src/laptop-utils $(DESTDIR)/etc/default/laptop-utils
	install -m 0755 src/laptop-utils.sh $(DESTDIR)/usr/bin/laptop-utils.sh
	install -m 0644 src/laptop-utils.desktop $(DESTDIR)/etc/xdg/autostart/laptop-utils.desktop

uninstall:
	rm $(DESTDIR)/etc/pm/sleep.d/00rtchibernate
	rm $(DESTDIR)/etc/default/laptop-utils
	rm $(DESTDIR)/usr/bin/laptop-utils.sh
	rm $(DESTDIR)/etc/xdg/autostart/laptop-utils.desktop
