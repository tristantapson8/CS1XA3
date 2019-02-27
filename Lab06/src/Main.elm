import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
  { string1 : String
  , string2 : String
  }


init : Model
init =
  Model "" ""



-- UPDATE


type Msg
  = String1 String
  | String2 String
 


update : Msg -> Model -> Model
update msg model =
  case msg of
    String1 string1 ->
      { model | string1 = string1 }

    String2 string2 ->
      { model | string2 = string2 }



-- VIEW


view : Model -> Html Msg
view model =
 div []
    [ input [ placeholder "String 1", value model.string1, onInput String1 ] []
    , input [ placeholder "String 2", value model.string2, onInput String2 ] []
    , div [] [ text ( model.string1 ++ " : " ++ model.string2 )]
    ]


