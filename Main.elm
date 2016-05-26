import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Html exposing (Html)
import Html.App as Html
import Mouse


type alias Model =
  { position : Mouse.Position
  }


type Msg
  = MoveMouse Mouse.Position


model : Model
model =
  { position =
    { x = 0
    , y = 0
    }
  }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MoveMouse newPosition ->
      { model | position = newPosition } ! []


view : Model -> Html Msg
view model =
  shapes (model.position.x, model.position.y)
    |> Element.toHtml


main : Program Never
main =
  Html.program
    { init = (model, Cmd.none)
    , update = update
    , view = view
    , subscriptions = subscriptions
    }


subscriptions : Model -> Sub Msg
subscriptions model =
  Mouse.moves MoveMouse


shapes : (Int, Int) -> Element
shapes (x, y) =
  let
    theGroup =
      group
        [ move (   0, -55) blueSquare
        , move (   0,  55) redSquare
        , move (-110, -55) blueCircle
        , move (-110,  55) redCircle
        , move ( 110, -55) blueHexagon
        , move ( 110,  55) redPentagon
        ]

    originGroup =
      move (-400, 400) theGroup

    movedGroup =
        move (toFloat(x), toFloat(-1 * y)) originGroup
  in
    collage 800 800 [ movedGroup ]


blueHexagon : Form
blueHexagon =
  filled blue (ngon 6 50)


redPentagon : Form
redPentagon =
  filled red (ngon 5 50)


blueSquare : Form
blueSquare =
  outlined (dashed blue) square


redSquare : Form
redSquare =
  outlined (solid red) square


square : Shape
square =
  Collage.square 100


blueCircle : Form
blueCircle =
  filled blue circle


redCircle : Form
redCircle =
  filled red circle


circle : Shape
circle =
  Collage.circle 50
