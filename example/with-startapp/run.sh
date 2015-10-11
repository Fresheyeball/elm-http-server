if [ -e example/main.js ]
then
  rm example/main.js
fi

elm make example/with-startapp/Server.elm --output=example/with-startapp/server.js
elm make example/with-startapp/Main.elm --output=example/with-startapp/main.js
echo "Elm.worker(Elm.Server);" >> example/with-startapp/server.js
node example/with-startapp/server.js
