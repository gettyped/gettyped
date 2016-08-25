package gettyped

sealed abstract class Maybe[A] {
  def fold[B](nothing: => B, just: A => B): B = this match {
    case Nothing() => nothing
    case Just(a)   => just(a)
  }
}

private final case class Nothing[A]() extends Maybe[A] {}

private final case class Just[A](a: A) extends Maybe[A] {}

object Maybe {
  def nothing[A]: Maybe[A] = Nothing()

  def just[A](a: A): Maybe[A] = Just(a)
}

object ScalaJSExample extends js.JSApp {
  def main(): Unit = {
    println("Compile success")
  }
}
