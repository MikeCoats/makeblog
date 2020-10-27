# `make caddy-serve` will build a fresh copy of the site and then statically
# serve it using caddy.

.PHONY: caddy-serve
caddy-serve: clean all
	caddy file-server --listen 0.0.0.0:8998 --browse --root site/
