// See https://gettyped.github.io/type/Maybe.html
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
  import Maybe._

  final case class Name(first: String, last: String)
  
  val absent: String = "Nobody"
  
  def present(n: Name): String = s"${n.first} ${n.last}"

  def describe(n: Maybe[Name]): String =
    n.fold(absent, present)

  /// Uncomment `describeT` and this file will fail to compile.
  // def describeT(n: Maybe[Name]): String =
  //   n.fold(present, absent)

  val names: List[Maybe[Name]] =
    List(
      just(Name("Jane", "Doe")),
      nothing,
      just(Name("John", "Doe")))

  def main(): Unit = {
    println("describe")
    names.foreach { n => println(describe(n)) }
  }
}
