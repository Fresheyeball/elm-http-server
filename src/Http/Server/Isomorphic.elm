module Http.Server.Isomorphic where

import Html exposing (Html)
import List exposing (concat, intersperse)

type alias CompiledJSUrl = String
type alias ModuleName = List String
type alias View = (ModuleName, CompiledJSUrl)

embed : (ModuleName, CompiledJSUrl) -> String -> String
embed (mn, url) html = """
  <!DOCTYPE HTML>
  <html>
    <head>
      <meta charset="UTF-8">
      <title>Line</title>
      <style>
        html, head, body { padding:0; margin:0; }
        body { font-family: calibri, helvetica, arial, sans-serif; }
        a:link { text-decoration: none; color: rgb(15,102,230); }
        a:visited { text-decoration: none; }
        a:active { text-decoration: none; }
        a:hover { text-decoration: underline; color: rgb(234,21,122); }
        html,body { height: 100%; margin: 0px; }
      </style>
    </head><body>
      """ ++ html ++ """
      <script src='""" ++ url  ++ """' ></script>
      <script>var runningElmModule =
        Elm.fullscreen(""" ++ concat (intersperse "." mn) ++ """);
      </script>
    </body>
  </html>"""
