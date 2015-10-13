elm make example/simple/Server.elm --output=example/simple/server.js
echo "Elm.worker(Elm.Server);" >> example/simple/server.js
node example/simple/server.js
