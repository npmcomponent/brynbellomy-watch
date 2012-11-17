
index.js: src/index.coffee
	@coffee -c -o ./ src/index.coffee

build: components index.js
	@component build --dev

components: component.json
	@component install --dev

clean:
	rm -rf build components template.js index.js

.PHONY: clean
