elm make example/basic/Server.elm --output=example/basic/server.js
echo "Elm.worker(Elm.Server);" >> example/basic/server.js
node example/basic/server.js
