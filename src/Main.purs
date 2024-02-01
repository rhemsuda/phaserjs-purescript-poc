module Main
  ( RGB
  , drawColoredRect
  , main
  , mainScene
  )
  where

import Prelude

import Data.Int (hexadecimal, floor)
import Data.Int as Int
import Data.Monoid (power)
import Data.Number (sin, pi)
import Data.String as String
import Effect (Effect)
import Graphics.Phaser as Phaser
import Graphics.Phaser.ForeignTypes (PhaserClock, PhaserGame, PhaserGraphic, PhaserScene)
import Graphics.Phaser.Graphics as Graphics
import Graphics.Phaser.Scene as Scene
import Graphics.Phaser.Time (now, time)

type RGB = { r :: Int, g :: Int, b :: Int }

main :: Effect PhaserGame
main = do
  scene <- mainScene'
  let
    config =
      (Phaser.config.width 800.0)
        <> (Phaser.config.height 600.0)
        <> (Phaser.config.scene [ scene ])
  Phaser.createWithConfig config

mainScene' :: Effect PhaserScene
mainScene' = do
  scene <- Scene.newScene "main"

  -- Set up scene creation
  let createScene = flip Scene.create
  void $ createScene scene \currentScene -> do
    clock <- time currentScene
    graphic <- Graphics.create currentScene
    void $ drawColoredRect clock graphic

  -- Set up update loop
  let updateScene = flip Scene.update
  void $ updateScene scene \currentScene -> do
    clock <- time currentScene
    graphic <- Graphics.create currentScene
    void $ drawColoredRect clock graphic

  pure scene

mainScene :: Effect PhaserScene
mainScene = do
  Scene.newScene "main"
    >>= Scene.create
        ( \scene ->
            void do
              clock <- time scene
              Graphics.create scene >>= drawColoredRect clock
        )

drawColoredRect :: PhaserClock -> PhaserGraphic -> Effect PhaserGraphic
drawColoredRect clock graphic = do
  rgb <- currentRgb
  let color = rgbToHex rgb
  void $ Graphics.fillStyle color 1.0 graphic
  void $ Graphics.fillRect { x: 300.0, y: 200.0 } { width: 200.0, height: 200.0 } graphic
  pure graphic
  where
    currentRgb :: Effect RGB
    currentRgb = do
      time <- now clock
      let t = time / 1000.0
          r = floor $ (sin (t) + 1.0) * 127.5
          g = floor $ (sin (t + 2.0 * pi / 3.0) + 1.0) * 127.5
          b = floor $ (sin (t + 4.0 * pi / 3.0) + 1.0) * 127.5
      pure { r: r, g: g, b: b }
    rgbToHex :: RGB -> String
    rgbToHex { r, g, b } =
      "0x" <> toHexString r <> toHexString g <> toHexString b
      where
        toHexString n = do
          let width = 2
          let hs = Int.toStringAs hexadecimal n
          power "0" (width - String.length hs) <> hs