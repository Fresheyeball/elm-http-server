if [ -e example/main.js ]
then
  rm example/main.js
fi

elm make example/simple/Server.elm --output=example/simple/server.js
# elm make example/simple/Main.elm --output=example/simple/main.js
echo "Elm.worker(Elm.Server);" >> example/simple/server.js
node example/simple/server.js
