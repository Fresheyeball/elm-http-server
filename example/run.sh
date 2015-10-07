if [ -e example/main.js ]
then
  rm example/main.js
fi

elm make example/Server.elm --output=example/server.js
elm make example/Main.elm --output=example/main.js
echo "Elm.worker(Elm.Server);" >> example/server.js
node example/server.js
