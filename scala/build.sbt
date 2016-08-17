addSbtPlugin("org.scala-js" % "sbt-scalajs" % "0.6.11")
enablePlugins(ScalaJSPlugin)

name := "Get Typed (Scala)"

scalaVersion := "2.11.8"

scalaSource in Compile := baseDirectory.value / "src"
scalaSource in Test := baseDirectory.value / "test"
