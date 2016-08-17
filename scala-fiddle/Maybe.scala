sealed abstract class Maybe[A] {
  def fold[B](b: => B, f: A => B): B = Maybe.fold(b, f, this)
}

object Maybe {
  private final case class Nothing[A]() extends Maybe[A]

  private final case class Just[A](value: A) extends Maybe[A]

  def nothing[A]: Maybe[A] = Nothing()

  def just[A](a: A): Maybe[A] = Just(a)

  private def fold[A, B](b: => B, f: A => B, ma: Maybe[A]): B =
    ma match {
      case Nothing() => b
      case Just(a)   => f(a)
    }
}

object ScalaJSExample extends js.JSApp {
  def main(): Unit = {
    println("Compile success")
  }
}
