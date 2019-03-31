import Browser
import Browser.Navigation exposing (Key(..))
import GraphicSVG exposing (..)
import GraphicSVG.App exposing (..)
import Url
import Html.Events exposing (onClick)
import Html.Events exposing (onInput)
import Html.Events exposing (..)
import Html exposing (..)
import Random

-- MESSAGES

type Msg
  = Roll
  | InitialRoll
  | NewFace Int 
  | LockMe Int 
  | Bet1 Int
  | Bet2 Int
  | Bet3 Int
  | OnHoverL
  | OffHoverL
  | OnHoverR
  | OffHoverR
  | OnHoverB1
  | OffHoverB1
  | OnHoverB2
  | OffHoverB2
  | OnHoverB3
  | OffHoverB3
  | OnHoverReset
  | OffHoverReset
  | ResetGame
  | MakeRequest Browser.UrlRequest
  | UrlChange Url.Url
  | Tick Float GetKeyState


-- GLOBAL VARS (for model)
   -- (easier for testing, set the credits/winValue via one variable)

credits = 1000
winValue = 2000


-- MODEL

type alias Model = {  dieFace : Int,
                      notif : String,
                      rollCount : Int,
                      lockIn : Int,
                      funds : Int,
                      betValue : Int,
                      time : Float,
                      hoverL : Bool,
                      hoverR : Bool,
                      hoverB1 : Bool,
                      hoverB2 : Bool,
                      hoverB3 : Bool,
                      hoverReset : Bool,
                      gameOver : Bool,
                      lockLockButton : Bool,
                      score: Int }


-- INIT

init : () -> Url.Url -> Key -> ( Model, Cmd Msg )
init flags url key = let 

                         model = { dieFace = 0, 
                                   notif = "Welcome to Craps!", 
                                   rollCount = 0, 
                                   lockIn = 0, 
                                   funds = credits, 
                                   betValue = 100,
                                   time = 0,
                                   hoverL = False,
                                   hoverR = False,
                                   hoverB1 = False,
                                   hoverB2 = False,
                                   hoverB3 = False,
                                   hoverReset = False,
                                   gameOver = False,
                                   lockLockButton = False,
                                   score = 0 }

                     in ( model  , Cmd.none ) -- add init model


-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of


-- TODO: Time based animations in the future? We'll see...

    Tick time _ -> 
        ({model | time = 0}, Cmd.none)

    MakeRequest req    -> 
        (model, Cmd.none)

    UrlChange url      -> 
        (model, Cmd.none)


-- INITIAL LOCK IN --

    -- generating a random double dice roll sum (2-12)

    InitialRoll ->
      ( model
      , Random.generate LockMe (Random.int 2 12) 
      )

    LockMe newFace ->

      -- win condition met

      if (model.funds >= winValue && model.gameOver == False) then

         ( { model | dieFace = 0, 
             notif = "WINNER ??!! SCORE: " ++ String.fromInt model.score, 
             rollCount = 0, 
             lockIn = 0, 
             gameOver = True }, 
             Cmd.none
        ) 

       -- first roll is craps win

      else if ((newFace == 7 || newFace == 11) && model.rollCount == 0 && model.gameOver == False)  then

        ( { model | dieFace = newFace, 
            notif = "Won on first roll!", 
            rollCount = 0, 
            lockIn = 0,
            funds = model.funds + model.betValue,
            score = model.score + (1 * (model.betValue // 100)) }, 
            Cmd.none
        )

      -- bankrupt on lock in roll 

      else if ((newFace == 2 || newFace == 3 || newFace == 12) && model.rollCount /= 1 && model.funds <= 0
                && model.gameOver == False && model.lockLockButton == False) then

        ( { model | dieFace = 0, 
            notif = "BANKRUPT !! SCORE: " ++ String.fromInt model.score,  
            rollCount = 0, 
            lockIn = 0,
            gameOver = True,
            lockLockButton = True }, 
            Cmd.none
        )

      -- first roll is not craps win 

      else if ((newFace == 2 || newFace == 3 || newFace == 12) && model.rollCount /= 1 && model.funds > 0
                   && model.gameOver == False && model.lockLockButton == False) then

        ( { model | dieFace = newFace, 
            --notif = "Locking in, but you lost on first roll!", 
            notif = "Lost on first roll!", 
            rollCount = 0, 
            lockIn = 0,
            funds = model.funds - model.betValue,
            lockLockButton = False }, 
            Cmd.none
        )


      {- NOTE1: weird bug where if conditions for lock button doesnt work properly if the user doesnt hover off of
                it after losing; convoluted if statements here to fix that, dont want to break code since the fix 
                works... -}

      {- NOTE2: after testing all if conditions, there is still a slight bug that will sometimes randomly decide if
                   you can continue playing even after reaching 0 or less credits, not sure why? -}

      else if (model.funds <= 0 && model.gameOver == False && (model.hoverL == True || model.hoverR == False)) then

         ( { model | dieFace = 0, 
            notif = "BANKRUPT !! SCORE: " ++ String.fromInt model.score, 
            rollCount = 0, 
            lockIn = 0, 
            gameOver = True }, 
            Cmd.none
        ) 

      -- lock in the target roll 

      else if (model.gameOver == False && model.lockLockButton == False && (model.hoverL == True || model.hoverR == False)) then

        ( { model | dieFace = newFace, 
            notif = "Locking in!", 
            rollCount = 1, 
            lockIn = newFace,
            lockLockButton = True }, 
            Cmd.none
        )

      else if (model.gameOver == True && model.lockLockButton == False && model.funds <= 0 
               && (model.hoverL == True || model.hoverR == False)) then

        ( { model | dieFace = 0, 
            notif = "BANKRUPT !! SCORE: " ++ String.fromInt model.score, 
            rollCount = 0, 
            lockIn = 0, 
            gameOver = True }, 
            Cmd.none
        ) 

       else 
        (  model , 
            Cmd.none
        )


-- ROLLING FOR CRAPS --

  -- generating a random double dice roll sum (2-12)

    Roll ->
      ( model
      , Random.generate NewFace (Random.int 2 12)
      )

    NewFace newFace  ->

    -- roll is craps loss ( 7 or 11 on second or higher roll), and 0 credits left 

      if ((newFace == 7 || newFace == 11) && model.rollCount /= 0 && model.gameOver == False && model.funds <= 0)  then

        ( { model | dieFace = newFace, 
             notif = "You Lose!", 
             rollCount = 0, 
             lockIn = 0, 
             funds = model.funds - model.betValue,
             gameOver = True }, 
             Cmd.none
        )

    -- roll is craps loss ( 7 or 11 on second or higher roll) but not game over 

      else if ((newFace == 7 || newFace == 11) && model.rollCount /= 0 && model.gameOver == False)  then
        ( { model | dieFace = newFace, 
             notif = "You Lose!", 
             rollCount = 0, 
             lockIn = 0, 
             funds = model.funds - model.betValue,
             lockLockButton = False }, 
             Cmd.none
        )


      -- roll is target (craps win)

      else if (model.lockIn == newFace  && model.gameOver == False ) then
        ( { model | dieFace = model.lockIn, 
            notif = "You Win!", 
            rollCount = 0, 
            lockIn = 0, 
            funds = model.funds + model.betValue,
            lockLockButton = False,
            score = model.score + (1 * (model.betValue // 100)) }, 
            Cmd.none
        )

      -- roll is bankrupt (game over)  

      else if ((newFace == 7 || newFace == 11) && (model.rollCount /= 0) && ( model.funds <= 0) && model.gameOver == False) then

         ( { model | dieFace = 0, 
            notif = "BANKRUPT!", 
            rollCount = 0, 
            lockIn = 0, 
            funds = 0 ,
            gameOver = True }, 
            Cmd.none
        ) 

      -- just another roll --

      else if (model.gameOver == False && model.lockLockButton == True && model.rollCount /= 0) then

        ( { model | dieFace = newFace, 
            notif = "Keep Rolling...", 
            rollCount = 1,
            lockLockButton = True }, 
            Cmd.none
        )

      else  
        ( model, 
          Cmd.none
        )


    -- BETTING CONDITIONS --

    Bet1 val ->
      ({ model | betValue = 100 }, Cmd.none)

    Bet2 val ->
      ({ model | betValue = 200 }, Cmd.none)

    Bet3 val ->
      ({ model | betValue = 300 }, Cmd.none)


    -- BUTTON HOVERS --
      -- (for highlight animations on mouse over)

    OnHoverL ->
      ({ model | hoverL = True }, Cmd.none)

    OffHoverL ->
      ({ model | hoverL = False }, Cmd.none)

    OnHoverR ->
      ({ model | hoverR = True }, Cmd.none)

    OffHoverR ->
      ({ model | hoverR = False }, Cmd.none)

    OnHoverB1 ->
      ({ model | hoverB1 = True }, Cmd.none)

    OffHoverB1 ->
      ({ model | hoverB1 = False }, Cmd.none)

    OnHoverB2 ->
      ({ model | hoverB2 = True }, Cmd.none)

    OffHoverB2 ->
      ({ model | hoverB2 = False }, Cmd.none)

    OnHoverB3 ->
      ({ model | hoverB3 = True }, Cmd.none)

    OffHoverB3 ->
      ({ model | hoverB3 = False }, Cmd.none)

    OnHoverReset ->
      ({ model | hoverReset = True }, Cmd.none)

    OffHoverReset ->
      ({ model | hoverReset = False }, Cmd.none)


    -- GAMEOVER --

    ResetGame ->
      ({ model | dieFace = 0, notif = "Welcome to Craps!", betValue = 100, lockIn = 0, funds = credits, gameOver = False,
         lockLockButton = False, score = 0 }, Cmd.none)



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- GLOBAL VARS (for view)
   -- just simple rgb color value vars for GraphicSVG, easier to refer to than color code

myLightGreen = (rgb 208 232 129)
myDarkGrey = (rgb 56 54 44)
myLightBrown = (rgb 150 145 120)
myDarkGreen = (rgb 73 68 34)



-- VIEW

view : Model -> { title : String,  body : Collage Msg }
view model = let  title = "Craps Game"
                
                  body = collage 500 500 shapes
                  shapes = [ arcadeCabinet
                             |> move (0, 0)
                           ]

                   -- group all the graphics together 
                  arcadeCabinet = group [ 

                                          -- CABINET GRAPHICS (so many lol...)
                                         
                                          side1, side2,
                                          triT3, triT4,
                                          cPanel,
                                          sideR1, sideR2, sideR3, sideR4,
                                          sideT1, sideT2,
                                          triT1, triT2,
                                          skewR1, skewR2,
                                          skewSide1, skewSide2,
                                          skewRT1, skewRT2,
                                          flat1, flat2, flat3,
                                          tri1, tri2,
                                          topBar1, topBar2, midBar,
                                          botRect1, botRect2, botRect3, botRect4,
                                          botPoly1, botPoly2, botPoly3, botPoly4,
                                          botRect5, botRect6,
                                          reset1, reset2,
                                          d1, d2,
                                          line1, line2, line3, line4, line5, line6,
                                          triFix1, triFix2,
                                          bottomDrop,
                                           

                                          -- BUTTON GRAPHICS

                                          lbU2, lbU1, lb,
                                          rbU2, rbU1, rb,
                                          b1U2, b1U1, b1,
                                          b2U2, b2U1, b2,
                                          b3U2, b3U1, b3, 


                                          -- SCREEN GRAPHICS
                                           
                                          screenbg, screen,
                                          tenGon, fiveGon,
                                          
                                          
                                          -- MODEL TEXT

                                          intro, 
                                          roll, 
                                          notif,
                                          lockIn,
                                          funds,
                                          bet

                                        ]

                  
                  -- graphic attributes

                  bottomDrop = rect 255 9
                               |> filled white
                               |> move (0, -197.5)
   
                  topBar1 = rect 200 1.5
                            |> filled myLightBrown
                            |> move (0, 222.3)

                  topBar2 = rect 200 1.5
                            |> filled myDarkGrey
                            |> move (0, 176)

                  midBar = rect 198 1.5
                           |> filled myLightBrown
                           |> move (0, -17) 
                  
                  line1 = rect 210 0.5
                          |> filled myDarkGrey
                          |> move (0, -33)

                  line2 = rect 210 0.5
                          |> filled myDarkGrey
                          |> move (0, -38)

                  line3 = rect 210 0.5
                          |> filled myDarkGrey
                          |> move (0, -43)

                  line4 = rect 210 0.5
                          |> filled myDarkGrey
                          |> move (0, -48)

                  line5 = rect 210 0.5
                          |> filled myDarkGrey
                          |> move (0, -53)

                  line6 = rect 210 0.5
                          |> filled myDarkGrey
                          |> move (0, -58)

                  botRect1 = roundedRect 80 70 7
                             |> filled myDarkGreen
                             |> move (0, -130)
                             |> addOutline (solid 1) myDarkGrey

                  botRect2 = rect 68 60
                             |> filled myLightBrown
                             |> addOutline (solid 2) myDarkGrey
                             |> move (0, -130)
                 
                  botRect3 = rect 18 15
                             |> filled white
                             |> addOutline (solid 1.3) myDarkGrey
                             |> move (-15, -145)

                  botRect4 = rect 18 15
                             |> filled white
                             |> addOutline (solid 1.3) myDarkGrey
                             |> move (15, -145)

                  botPoly1 = polygon[(0,0), (4.5, 8), (13.5, 8), (18,0)]
                             |> filled charcoal
                             |> move (6, -152)

                  botPoly2 = polygon[(0,0), (4.5, 8), (13.5, 8), (18,0)]
                             |> filled charcoal
                             |> move (-24, -152)

                  botPoly3 = polygon[(0.5,2), (4.5, 8), (13.5, 8), (17.5,2)]
                             |> filled (rgb 193 191 186)
                             |> rotate (degrees 180)
                             |> move (-6, -136)

                  botPoly4 = polygon[(0.5,2), (4.5, 8), (13.5, 8), (17.5,2)]
                             |> filled (rgb 193 191 186)
                             |> rotate (degrees 180)
                             |> move (24, -136)

                  botRect5 = rect 10 1
                             |> filled black
                             |> move (15, -139.5)

                  botRect6 = rect 10 1
                             |> filled black
                             |> move (-15, -139.5)

                  {- on/off hover button conditionals
                     each button uses notifyEnter/notifyLeave to determine if a mouse is ontop of them,
                     and each have a notifyTap assigned to determine which button is pressed -}

                  -- RESET GAME BUTTONS 

                  reset1 = if (model.hoverReset == False) then 
                            roundedRect 20 20 4
                            |> filled orange
                            |> addOutline (solid 1.3) (rgb 201 84 38)
                            |> move (-15, -120)
                            |> notifyEnter OnHoverReset
                            |> notifyTap ResetGame

                          else
                           roundedRect 20 20 4
                           |> filled (rgb 163 59 17)
                           |> addOutline (solid 1.3) (rgb 201 84 38)
                           |> move (-15, -120)
                           |> notifyLeave OffHoverReset
                           |> notifyTap ResetGame

                  reset2 = if (model.hoverReset == False) then 
                            roundedRect 20 20 4
                            |> filled orange
                            |> addOutline (solid 1.3) (rgb 201 84 38)
                            |> move (15, -120)
                            |> notifyEnter OnHoverReset
                            |> notifyTap ResetGame

                          else
                           roundedRect 20 20 4
                           |> filled (rgb 163 59 17)
                           |> addOutline (solid 1.3) (rgb 201 84 38)
                           |> move (15, -120)
                           |> notifyLeave OffHoverReset
                           |> notifyTap ResetGame
                 
                  -- more graphic attributes...

                  d1 = GraphicSVG.text "¢"
                      |> bold
                      |> sansserif
                      |> size 16
                      |> fixedwidth
                      |> centered
                      |> filled (rgb 201 84 38)
                      |> move (15, -125)

                  d2 = GraphicSVG.text "¢"
                      |> bold
                      |> sansserif
                      |> size 16
                      |> fixedwidth
                      |> centered
                      |> filled (rgb 201 84 38)
                      |> move (-15, -125)

                  cPanel = rect 215 420
                           |> filled myDarkGreen
                           |> move (0, 13)

                  sideR1 = rect 35 160
                           |> filled myDarkGrey
                           |> move (95, 85)
 
                  sideR2 = rect 35 160
                           |> filled myDarkGrey
                           |> move (-95, 85)

                  sideR3 = rect 20 285
                           |> filled myDarkGrey
                           |> move (-109, -58)

                  sideR4 = rect 20 285
                           |> filled myDarkGrey
                           |> move (109, -58)

                  sideT1 = rect 10 60
                           |> filled myDarkGrey
                           |> move (-104, 193.5)

                  sideT2 = rect 10 60
                           |> filled myDarkGrey
                           |> move (104, 193.5)

                  triT1 = rightTriangle 25 15
                          |> filled myDarkGrey
                          |> move (-100, 162)
                          |> rotate (degrees 180)
                          |> mirrorY

                  triT2 = rightTriangle 25 15
                          |> filled myDarkGrey
                          |> move (-100, 162)
                          |> rotate (degrees 180)
                          |> mirrorY
                          |> mirrorX

                  triFix1 = polygon[(0,0), (18, 30.2), (35, 30.2)]
                            |> filled  myDarkGreen
                            |> move (-98, -15)

                  triFix2 = polygon[(0,0), (18, 30.2), (35, 30.2)]
                            |> filled  myDarkGreen
                            |> move (-98, -15)
                            |> mirrorX

                  skewRT1 = rect 7 15
                          |> filled myLightBrown
                          |> move (-230.36, 230.8)
                          |> skewX -0.50

                  triT3 = isosceles 26.5 14.5
                          |> filled myDarkGrey
                          |> move (-96.85, 223)
                          |> rotate (degrees 180)
                          |> mirrorY
                          |> mirrorX
                  
                  skewRT2 = rect 7 15
                            |> filled myLightBrown
                            |> move (230.36, 230.8)
                            |> skewX 0.50
                  
                  triT4 = isosceles 26.5 14.5
                          |> filled myDarkGrey
                          |> move (96.85, 223)
                          |> rotate (degrees 180)
                          |> mirrorY
                          |> mirrorX

                  skewR1 = rect 7 255
                           |> filled myDarkGreen
                           |> move (120, 96)
                           |> skewX 0.05

                  skewR2 = rect 7 255
                           |> filled myDarkGreen
                           |> move (-120, 96)
                           |> skewX -0.05
                  
                  skewSide1 = rect 7 170
                              |> filled myDarkGreen
                              |> move (-121.6, -116.2)

                  skewSide2 = rect 7 170
                              |> filled myDarkGreen
                              |> move (121.6, -116.2)
                          
                  screen = rect 140 130
                           |> filled (rgb 120 167 188)
                           |> addOutline (solid 2) grey
                           |> move (0, 90)

                  screenbg = rect 160 150
                           |> filled charcoal
                           |> move (0, 90)

                  tri1  = rightTriangle 45 45
                          |> filled myDarkGrey
                          |> move (-112.5, -15)
                          |> rotate (degrees 180)
                          |> mirrorX

                  tri2  = rightTriangle 45 45
                          |> filled myDarkGrey
                          |> move (-112.5, -15)
                          |> rotate (degrees 180)
                          
                  flat1 = rect 200 35
                          |> filled myLightGreen
                          |> move (0, 200)
                          |> addOutline (solid 0.5) black

                  flat2 = rect 215 35
                          |> filled myLightGreen
                          |> move (0, -46)
                          |> addOutline (solid 0.5) black

                  flat3 = rect 215 130
                          |> filled myLightGreen
                          |> move (0, -135)
                          |> addOutline (solid 0.5) black

                  side1 = rect 25 195
                          |> filled myDarkGrey
                          |> move (100, -103)

                  side2 = rect 25 195
                          |> filled myDarkGrey
                          |> move (-100, -103)

                  -- SCREEN ASSETS AND BUTTON ATTRIBUTES -- 

                  tenGon = ngon 10 30
                           |> outlined (solid 2.2) black
                           |> scale 1
                           |> move (0, 113)
                           |> makeTransparent 0.66

                  fiveGon = ngon 5 30
                            |> outlined (solid 2.9) black
                            |> scale 0.75
                            |> rotate 60
                            |> move (0, 113)
                            |> makeTransparent 0.66

                  intro = GraphicSVG.text "Craps Simulator™"
                          |> bold
                          |> sansserif
                          |> size 20
                          |> fixedwidth
                          |> centered
                          |> filled black
                          |> move (0, 193)

                  roll =  GraphicSVG.text (String.fromInt model.dieFace) 
                          |> bold
                          |> size 20
                          |> fixedwidth
                          |> centered
                          |> filled black
                          |> move (0,107)
                          |> makeTransparent 0.66

                  notif = GraphicSVG.text (model.notif) 
                          |> bold
                          |> size 9
                          |> fixedwidth
                          |> centered
                          |> filled black
                          |> move (0, 71)
                          |> makeTransparent 0.66

                  lockIn = GraphicSVG.text ("Lock in Roll: " ++ String.fromInt model.lockIn) 
                           |> bold
                           |> size 9
                           |> fixedwidth
                           |> centered
                           |> filled black
                           |> move (0, 59)
                           |> makeTransparent 0.66

                  funds = GraphicSVG.text ("Credits: " ++ String.fromInt model.funds) 
                          |> bold
                          |> size 9
                          |> fixedwidth
                          |> centered
                          |> filled black
                          |> move (0, 47)
                          |> makeTransparent 0.66

                  bet = GraphicSVG.text ("Bet: " ++ String.fromInt model.betValue) 
                        |> bold
                        |> size 9
                        |> fixedwidth
                        |> centered
                        |> filled black
                        |> move (0, 35)
                        |> makeTransparent 0.66

                  {- on/off hover button conditionals
                     each button uses notifyEnter/notifyLeave to determine if a mouse is ontop of them,
                     and each have a notifyTap assigned to determine which button is pressed -}

                  -- LOCK BUTTON

                  lb = if (model.hoverL == False) then 
                        oval 21 11
                        |> filled (rgb 234 206 133)
                        |> move (-60, 0)
                        |> notifyTap InitialRoll
                        |> notifyEnter OnHoverL
                        |> addOutline (solid 1.1) white

                      else 
                       oval 21 11
                       |> filled (rgb 214 166 47)
                       |> move (-60, 0)
                       |> notifyTap InitialRoll
                       |> notifyLeave OffHoverL
                       |> addOutline (solid 1.1) white

                  lbU1 = oval 23 11
                         |> filled (rgb 234 206 133)
                         |> move (-60, -3)
                         |> addOutline (solid 0.9) black

                  lbU2 = oval 28 11
                         |> filled (rgb 234 206 133)
                         |> move (-60, -5)
                  
                  -- ROLL BUTTON

                  rb = if (model.hoverR == False) then 
                        oval 21 11 
                        |> filled (rgb 163 161 155)
                        |> move (-30, 0)
                        |> notifyTap Roll
                        |> notifyEnter OnHoverR
                        |> addOutline (solid 1.1) white

                       else
                        oval 21 11
                        |> filled charcoal
                        |> move (-30, 0)
                        |> notifyTap Roll
                        |> notifyLeave OffHoverR
                        |> addOutline (solid 1.1) white

                  rbU1 = oval 23 11
                         |> filled (rgb 163 161 155)
                         |> move (-30, -3)
                         |> addOutline (solid 0.9) black

                  rbU2 = oval 28 11
                         |> filled white
                         |> move (-30, -5)

                  -- BET 100 BUTTON

                  b1 = if (model.hoverB1 == False) then 
                        oval 21 11
                        |> filled (rgb 126 155 79)
                        |> move (0, 0)
                        |> notifyTap (Bet1 model.betValue)
                        |> notifyEnter OnHoverB1
                        |> addOutline (solid 1.1) (rgb 208 232 129)

                       else
                        oval 21 11
                        |> filled (rgb 67 114 95)
                        |> move (0, 0)
                        |> notifyTap (Bet1 model.betValue)
                        |> notifyLeave OffHoverB1
                        |> addOutline (solid 1.1) (rgb 208 232 129)

                  b1U1 = oval 23 11
                         |> filled (rgb 126 155 79)
                         |> move (0, -3)
                         |> addOutline (solid 0.9) black

                  b1U2 = oval 28 11
                         |> filled (rgb 208 232 129)
                         |> move (0, -5)

                  -- BET 200 BUTTON

                  b2 = if (model.hoverB2 == False) then 
                        oval 21 11
                         |> filled (rgb 35 105 132)
                         |> move (30, 0)
                         |> notifyTap (Bet2 model.betValue)
                         |> notifyEnter OnHoverB2
                         |> addOutline (solid 1.1) (rgb 190 231 247)

                       else
                        oval 21 11
                        |> filled (rgb 20 58 112)
                        |> move (30, 0)
                        |> notifyTap (Bet2 model.betValue)
                        |> notifyLeave OffHoverB2
                        |> addOutline (solid 1.1) (rgb 190 231 247)

                  b2U1 = oval 23 11
                         |> filled (rgb 35 105 132)
                         |> move (30, -3)
                         |> addOutline (solid 0.9) black

                  b2U2 =  oval 28 11
                          |> filled (rgb 190 231 247)
                          |> move (30, -5)

                  -- BET 300 BUTTON

                  b3 = if (model.hoverB3 == False) then
                        oval 21 11
                         |> filled (rgb 216 91 122)
                         |> move (60, 0)
                         |> notifyTap (Bet3 model.betValue)
                         |> notifyEnter OnHoverB3
                         |> addOutline (solid 1.1) (rgb 226 138 160)

                       else
                        oval 21 11
                        |> filled darkRed
                        |> move (60, 0)
                        |> notifyTap (Bet3 model.betValue)
                        |> notifyLeave OffHoverB3
                        |> addOutline (solid 1.1) (rgb 226 138 160)

                  b3U1 = oval 23 11
                         |> filled (rgb 216 91 122)
                         |> move (60, -3)
                         |> addOutline (solid 0.9) black

                  b3U2 = oval 28 11
                         |> filled (rgb 226 138 160)
                         |> move (60, -5)

             in { title = title , body = body }


-- MAIN

main : AppWithTick () Model Msg
main = appWithTick Tick
       { init = init
       , update = update
       , view = view
       , subscriptions = subscriptions
       , onUrlRequest = MakeRequest
       , onUrlChange = UrlChange
       }  
