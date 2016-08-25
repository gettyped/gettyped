package gettyped

final class Valid[V[_], A] private(a: A) {
  val value: A = a
}

trait Validator[A] {
  type F[_]

  def validate(a: A): F[A]
}

object Valid {
  private def mkValid[V[A] <: Validator[A], A](a: A): Valid[V, A] =
    new Valid(a)

  def apply[V[A] <: Validator[A], A](a: A, v: V[A])
      (implicit F: Functor[v.F])
      : v.F[Valid[V, A]] =
    F.map(mkValid[V, A])(v.validate(a))
}
