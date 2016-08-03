module GetTyped.Valid
  ( class Validator
  , validator
  , Valid
  , validate
  )
where

import Prelude (<$>)
import Type.Proxy (Proxy(..))

newtype Valid v a = MkValid a

class Validator v f a where
  validator :: Proxy v -> a -> f a

validate :: ∀ v f a. (Validator v f a, Functor f) => a -> f (Valid v a)
validate a = MkValid <$> validator (Proxy :: Proxy v) a
