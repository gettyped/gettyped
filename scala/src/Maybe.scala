package gettyped

sealed abstract class Maybe[A] {
  def fold[B](b: => B, f: A => B): B = this match {
    case Nothing() => b
    case Just(a)   => f(a)
  }
}

private final case class Nothing[A]() extends Maybe[A] {}

private final case class Just[A](a: A) extends Maybe[A] {}

object Maybe {
  def nothing[A]: Maybe[A] = Nothing()

  def just[A](a: A): Maybe[A] = Just(a)
}
