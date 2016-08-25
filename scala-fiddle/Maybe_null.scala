// See https://gettyped.github.io/type/Maybe.html
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
  final case class Name(first: String, last: String)
  
  val absent: String = "Nobody"
  
  def present(n: Name): String = s"${n.first} ${n.last}"

  def describe(n: Name): String =
    if (n == null) absent else present(n)

  def describeT(n: Name): String =
    if (n == null) present(n) else absent

  val names: List[Name] =
    List(
      Name("Jane", "Doe"),
      null,
      Name("John", "Doe"))

  def main(): Unit = {
    println("describe")
    names.foreach { n => println(describe(n)) }
    println("........")
    println("describeT")
    names.foreach { n => println(describeT(n)) }
  }
}
