module Stamps exposing (..)


import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Html exposing (..)
import Html.App as Html
import Mouse
import Keyboard


type Shape
  = Pentagon
  | Circle


type alias Stamp =
  { position : (Int, Int)
  , shape : Shape
  }


type alias Position =
  (Int, Int)


type alias Model =
  { stamps : List Stamp
  , shift : Bool
  }


type Msg
  = AddClick Position
  | HandleShift Bool
  | NoOp


model : Model
model =
  { stamps = []
  , shift = False
  }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    AddClick pos ->
      let
        newStamp =
          if model.shift then
            Stamp pos Pentagon
          else
            Stamp pos Circle
      in
        { model | stamps = newStamp :: model.stamps } ! []

    HandleShift pressed ->
      { model | shift = pressed } ! []

    NoOp ->
      model ! []


drawStamp : Stamp -> Form
drawStamp stamp =
  let
    -- We'll extract x and y
    (x, y) = stamp.position
    -- and we'll make a different shape based on the stamp's shape
    shape = case stamp.shape of
      Pentagon -> ngon 5 50
      Circle -> circle 50
  in
    shape
    |> filled red
    |> move (toFloat(x), toFloat(-y))


view : Model -> Html Msg
view model =
  let
    theGroup =
      -- Map a list of positions through our drawstamp function to get a list
      -- of forms, and put them in a group
      group (List.map drawStamp model.stamps)

    -- We'll move the group to the origin like we did in the previous examples
    originGroup =
      move (-400, 400) theGroup
  in
    -- Now make a collage containing the group
    collage 800 800
      [ originGroup ]
      |> Element.toHtml


main : Program Never
main =
  Html.program
    { init = (model, Cmd.none)
    , update = update
    , view = view
    , subscriptions = subscriptions
    }


mapKeyDown : Int -> Msg
mapKeyDown keyCode =
  case Debug.log "mapKeyDown" keyCode of
    16 -> HandleShift True
    _  -> NoOp

mapKeyUp : Int -> Msg
mapKeyUp keyCode =
  case Debug.log "mapKeyUp" keyCode of
    16 -> HandleShift False
    _  -> NoOp


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Mouse.clicks (\{x, y} -> AddClick (x, y))
    , Keyboard.downs mapKeyDown
    , Keyboard.ups mapKeyUp
    ]
