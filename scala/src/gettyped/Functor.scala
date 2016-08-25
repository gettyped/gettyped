package gettyped

trait Functor[F[_]] {
  def map[A, B](f: A => B)(fa: F[A]): F[B]
  
  def <%>[A, B](f: A => B)(fa: F[A]): F[B] = map(f)(fa)

  def mapUnit[A](fa: F[A]): F[Unit] =
    map((_: A) => ())(fa)
}
