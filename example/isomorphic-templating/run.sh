if [ -e example/main.js ]
then
  rm example/main.js
fi

elm make example/isomorphic-templating/Server.elm --output=example/isomorphic-templating/server.js
elm make example/isomorphic-templating/Main.elm --output=example/isomorphic-templating/main.js
echo "Elm.worker(Elm.Server);" >> example/isomorphic-templating/server.js
node example/isomorphic-templating/server.js
